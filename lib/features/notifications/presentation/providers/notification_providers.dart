import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/sync/outbox_command.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../../bucket/domain/entities/weekly_bucket.dart';
import '../../data/datasources/user_notification_local_datasource.dart';
import '../../data/datasources/user_notification_remote_datasource.dart';
import '../../domain/entities/user_notification.dart';
import '../../services/local_notification_service.dart';

const _uuid = Uuid();
const _inboxEntity = 'inbox';

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService(FlutterLocalNotificationsPlugin());
});

final userNotificationRemoteDataSourceProvider =
    Provider<UserNotificationRemoteDataSource>((ref) {
      return UserNotificationRemoteDataSource(
        ref.watch(supabaseClientProvider),
      );
    });

final userNotificationLocalDataSourceProvider =
    Provider<UserNotificationLocalDataSource>((ref) {
      return UserNotificationLocalDataSource(ref.watch(appDatabaseProvider));
    });

final inboxHydratorProvider = Provider<void>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return;
  final local = ref.read(userNotificationLocalDataSourceProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  final service = ref.read(localNotificationServiceProvider);
  final seen = <String>{};
  var first = true;
  final sub = ref
      .read(userNotificationRemoteDataSourceProvider)
      .watchInbox(uid)
      .listen((server) async {
        final pending = await outbox.pendingEntityIds(_inboxEntity);
        await local.reconcile(uid, server, pending);
        if (!first) {
          var bucketDeleted = false;
          for (final n in server) {
            if (seen.contains(n.id)) continue;
            if (!n.isUnread) continue;
            if (!n.type.startsWith('join_')) {
              unawaited(
                service.showThresholdAlert(
                  id: n.id.hashCode & 0x7fffffff,
                  title: n.title.isEmpty ? 'Notification' : n.title,
                  body: n.body,
                ),
              );
            }
            if (n.type == 'bucket_deleted' || n.type == 'removed_from_bucket') {
              bucketDeleted = true;
              final name = n.bucketName.isEmpty ? 'A bucket' : n.bucketName;
              showAppSnack('$name is no longer available. ${n.body}'.trim());
            }
          }
          if (bucketDeleted) {
            ref.invalidate(bucketListHydratorProvider);
          }
        }
        seen
          ..clear()
          ..addAll(server.map((n) => n.id));
        first = false;
      }, onError: (_) {});
  ref.onDispose(sub.cancel);
});

final inboxProvider = StreamProvider<List<UserNotification>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(const []);
  ref.watch(inboxHydratorProvider);
  return ref.watch(userNotificationLocalDataSourceProvider).watchInbox(uid);
});

final unreadInboxCountProvider = Provider<int>((ref) {
  final inbox = ref.watch(inboxProvider).value ?? const [];
  return inbox.where((n) => n.isUnread && n.type != 'join_requested').length;
});

Future<void> markInboxRead(WidgetRef ref, String id) async {
  try {
    await ref.read(userNotificationLocalDataSourceProvider).markReadLocal(id);
    await ref
        .read(outboxRepositoryProvider)
        .enqueue(
          OutboxCommand(
            id: _uuid.v4(),
            op: OutboxOp.inboxMarkRead,
            entity: _inboxEntity,
            entityId: id,
            payload: const {},
          ),
        );
    unawaited(ref.read(syncEngineProvider).sync());
  } catch (_) {}
}

Future<void> markAllInboxRead(WidgetRef ref) async {
  final uid = ref.read(currentUserIdProvider);
  if (uid == null) return;
  final unread = (ref.read(inboxProvider).value ?? const [])
      .where((n) => n.isUnread)
      .toList();
  if (unread.isEmpty) return;
  try {
    final local = ref.read(userNotificationLocalDataSourceProvider);
    final outbox = ref.read(outboxRepositoryProvider);
    await local.markAllReadLocal(uid);
    for (final n in unread) {
      await outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.inboxMarkRead,
          entity: _inboxEntity,
          entityId: n.id,
          payload: const {},
        ),
      );
    }
    unawaited(ref.read(syncEngineProvider).sync());
  } catch (_) {}
}

Future<void> archiveInboxNotification(WidgetRef ref, String id) async {
  try {
    await ref.read(userNotificationLocalDataSourceProvider).archiveLocal(id);
    await ref
        .read(outboxRepositoryProvider)
        .enqueue(
          OutboxCommand(
            id: _uuid.v4(),
            op: OutboxOp.inboxArchive,
            entity: _inboxEntity,
            entityId: id,
            payload: const {},
          ),
        );
    unawaited(ref.read(syncEngineProvider).sync());
  } catch (_) {}
}

final thresholdWatcherProvider = Provider<void>((ref) {
  final service = ref.read(localNotificationServiceProvider);
  final alerted = <String>{};
  ref.listen<AsyncValue<List<WeeklyBucket>>>(weeklyBucketsProvider, (_, next) {
    final weeks = next.value ?? const <WeeklyBucket>[];
    for (final week in weeks) {
      final key = '${week.bucketId}:${week.weekIndex}';
      if (week.isActive && week.isOverThreshold && !alerted.contains(key)) {
        alerted.add(key);
        service.showThresholdAlert(
          id: week.weekIndex,
          title: 'Weekly budget alert',
          body:
              'Week ${week.weekIndex + 1} is at ${(week.progress * 100).round()}% '
              'of its allocation.',
        );
      }
    }
  });
});
