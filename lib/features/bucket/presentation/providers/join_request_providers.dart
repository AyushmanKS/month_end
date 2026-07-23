import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/sync/outbox_command.dart';
import '../../../../core/sync/outbox_repository.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../data/datasources/join_request_local_datasource.dart';
import '../../data/datasources/join_request_remote_datasource.dart';
import '../../domain/entities/join_request.dart';
import 'bucket_providers.dart';

const _uuid = Uuid();
const _joinRequestEntity = 'joinRequest';

enum JoinRequestOutcome { pending, alreadyMember, notFound, failed }

final joinRequestRemoteDataSourceProvider =
    Provider<JoinRequestRemoteDataSource>((ref) {
      return JoinRequestRemoteDataSource(ref.watch(supabaseClientProvider));
    });

final joinRequestLocalDataSourceProvider = Provider<JoinRequestLocalDataSource>(
  (ref) {
    return JoinRequestLocalDataSource(ref.watch(appDatabaseProvider));
  },
);

final _incomingJoinRequestHydratorProvider = Provider<void>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return;
  final local = ref.read(joinRequestLocalDataSourceProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  final service = ref.read(localNotificationServiceProvider);
  final seen = <String>{};
  var first = true;
  final sub = ref
      .read(joinRequestRemoteDataSourceProvider)
      .watchIncoming(bucketId)
      .listen((server) async {
        final pending = await outbox.pendingEntityIds(_joinRequestEntity);
        await local.reconcileIncoming(bucketId, server, pending);
        final active = server.where((r) => r.isPending).toList();
        if (!first) {
          for (final r in active) {
            if (seen.contains(r.id)) continue;
            unawaited(
              service.showThresholdAlert(
                id: r.id.hashCode & 0x7fffffff,
                title: 'New join request',
                body:
                    '${r.requesterName ?? 'Someone'} asked to join '
                    '${r.bucketName}',
              ),
            );
          }
        }
        seen
          ..clear()
          ..addAll(active.map((r) => r.id));
        first = false;
      }, onError: (_) {});
  ref.onDispose(sub.cancel);
});

final _outgoingJoinRequestHydratorProvider = Provider<void>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return;
  final local = ref.read(joinRequestLocalDataSourceProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  final service = ref.read(localNotificationServiceProvider);
  final lastStatus = <String, JoinRequestStatus>{};
  var first = true;
  final sub = ref
      .read(joinRequestRemoteDataSourceProvider)
      .watchOutgoing(uid)
      .listen((server) async {
        final pending = await outbox.pendingEntityIds(_joinRequestEntity);
        await local.reconcileOutgoing(uid, server, pending);
        if (!first) {
          for (final r in server) {
            final previous = lastStatus[r.id];
            if (previous == r.status) continue;
            if (r.status == JoinRequestStatus.accepted) {
              unawaited(
                service.showThresholdAlert(
                  id: r.id.hashCode & 0x7fffffff,
                  title: 'Request accepted',
                  body: 'You can now access ${r.bucketName}',
                ),
              );
            } else if (r.status == JoinRequestStatus.rejected) {
              unawaited(
                service.showThresholdAlert(
                  id: r.id.hashCode & 0x7fffffff,
                  title: 'Request declined',
                  body: 'Your request to join ${r.bucketName} was declined',
                ),
              );
            }
          }
        }
        lastStatus
          ..clear()
          ..addEntries(server.map((r) => MapEntry(r.id, r.status)));
        first = false;
      }, onError: (_) {});
  ref.onDispose(sub.cancel);
});

final joinRequestHydratorProvider = Provider<void>((ref) {
  ref.watch(_incomingJoinRequestHydratorProvider);
  ref.watch(_outgoingJoinRequestHydratorProvider);
});

final incomingJoinRequestsProvider = StreamProvider<List<JoinRequest>>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return Stream.value(const []);
  ref.watch(_incomingJoinRequestHydratorProvider);
  return ref
      .watch(joinRequestLocalDataSourceProvider)
      .watchIncomingPending(bucketId);
});

final outgoingJoinRequestsProvider = StreamProvider<List<JoinRequest>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(const []);
  ref.watch(_outgoingJoinRequestHydratorProvider);
  return ref.watch(joinRequestLocalDataSourceProvider).watchOutgoing(uid);
});

class JoinRequestController extends StateNotifier<AsyncValue<JoinRequest?>> {
  JoinRequestController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  JoinRequestRemoteDataSource get _remote =>
      _ref.read(joinRequestRemoteDataSourceProvider);
  JoinRequestLocalDataSource get _local =>
      _ref.read(joinRequestLocalDataSourceProvider);
  OutboxRepository get _outbox => _ref.read(outboxRepositoryProvider);
  String get _uid => _ref.read(currentUserIdProvider) ?? '';

  void _kickSync() => unawaited(_ref.read(syncEngineProvider).sync());

  Future<JoinRequestOutcome> requestJoin(String code) async {
    state = const AsyncValue.loading();
    try {
      final request = await _remote.requestJoin(id: _uuid.v4(), code: code);
      await _local.upsertLocal(request, syncState: 'synced');
      state = AsyncValue.data(request);
      return request.status == JoinRequestStatus.accepted
          ? JoinRequestOutcome.alreadyMember
          : JoinRequestOutcome.pending;
    } catch (e, s) {
      final mapped = ErrorHandler.map(e, s);
      state = AsyncValue.error(mapped, s);
      final message = mapped.message.toLowerCase();
      if (message.contains('already_member')) {
        return JoinRequestOutcome.alreadyMember;
      }
      if (message.contains('no bucket found')) {
        return JoinRequestOutcome.notFound;
      }
      return JoinRequestOutcome.failed;
    }
  }

  Future<bool> decide({required String requestId, required bool accept}) async {
    try {
      await _local.setStatusLocal(
        requestId,
        accept ? JoinRequestStatus.accepted : JoinRequestStatus.rejected,
      );
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.joinRequestDecide,
          entity: _joinRequestEntity,
          entityId: requestId,
          priority: 15,
          payload: {'accept': accept},
        ),
        actor: _uid,
      );
      _kickSync();
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> cancel(String requestId) async {
    try {
      await _local.setStatusLocal(requestId, JoinRequestStatus.cancelled);
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.joinRequestCancel,
          entity: _joinRequestEntity,
          entityId: requestId,
          priority: 15,
          payload: const {},
        ),
        actor: _uid,
      );
      _kickSync();
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }
}

final joinRequestControllerProvider =
    StateNotifierProvider<JoinRequestController, AsyncValue<JoinRequest?>>((
      ref,
    ) {
      return JoinRequestController(ref);
    });
