import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/sync/outbox_command.dart';
import '../../../../core/sync/outbox_repository.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/presentation/providers/expense_providers.dart';
import '../../data/datasources/bucket_local_datasource.dart';
import '../../data/datasources/bucket_remote_datasource.dart';
import '../../data/repositories/bucket_repository_impl.dart';
import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';
import '../../domain/repositories/bucket_repository.dart';

const _uuid = Uuid();

final bucketRemoteDataSourceProvider = Provider<BucketRemoteDataSource>((ref) {
  return BucketRemoteDataSource(ref.watch(supabaseClientProvider));
});

final bucketRepositoryProvider = Provider<BucketRepository>((ref) {
  return BucketRepositoryImpl(ref.watch(bucketRemoteDataSourceProvider));
});

final bucketLocalDataSourceProvider = Provider<BucketLocalDataSource>((ref) {
  return BucketLocalDataSource(ref.watch(appDatabaseProvider));
});

final bucketListHydratorProvider = Provider<void>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return;
  final local = ref.read(bucketLocalDataSourceProvider);
  final remote = ref.read(bucketRepositoryProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  Future<void> hydrate() async {
    try {
      final server = await remote.fetchMyBuckets();
      final pending = await outbox.pendingEntityIds('bucket');
      await local.reconcileBucketList(server, pending);
    } catch (_) {}
  }

  unawaited(hydrate());
  ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
    if (next.value == true) unawaited(hydrate());
  });
});

final myBucketsProvider = StreamProvider<List<Bucket>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(const []);
  ref.watch(bucketListHydratorProvider);
  return ref.watch(bucketLocalDataSourceProvider).watchMyBuckets();
});

final selectedBucketIdProvider = StateProvider<String?>((ref) => null);

final activeBucketIdProvider = Provider<String?>((ref) {
  final selected = ref.watch(selectedBucketIdProvider);
  final buckets = ref.watch(myBucketsProvider).value ?? const <Bucket>[];
  if (buckets.isEmpty) return null;
  if (selected != null && buckets.any((b) => b.id == selected)) return selected;
  return buckets.first.id;
});

final _activeBucketHydratorProvider = Provider<void>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return;
  final local = ref.read(bucketLocalDataSourceProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  final sub = ref.read(bucketRepositoryProvider).watchBucket(id).listen((
    bucket,
  ) async {
    if (bucket == null) return;
    final pending = await outbox.pendingEntityIds('bucket');
    await local.reconcileBucket(bucket, pending);
  }, onError: (_) {});
  ref.onDispose(sub.cancel);
});

final activeBucketProvider = StreamProvider<Bucket?>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(null);
  ref.watch(_activeBucketHydratorProvider);
  return ref.watch(bucketLocalDataSourceProvider).watchBucket(id);
});

final activeCurrencyProvider = Provider<String>((ref) {
  return ref.watch(activeBucketProvider).value?.currency ?? 'INR';
});

final _weeklyHydratorProvider = Provider<void>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return;
  final local = ref.read(bucketLocalDataSourceProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  final sub = ref.read(bucketRepositoryProvider).watchWeeklyBuckets(id).listen((
    weeks,
  ) async {
    final pending = await outbox.pendingEntityIds('week');
    await local.reconcileWeeks(id, weeks, pending);
  }, onError: (_) {});
  ref.onDispose(sub.cancel);
});

final weeklyBucketsProvider = StreamProvider<List<WeeklyBucket>>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(const []);
  ref.watch(_weeklyHydratorProvider);
  return ref.watch(bucketLocalDataSourceProvider).watchWeeks(id);
});

final bucketHydratorProvider = Provider<void>((ref) {
  ref.watch(bucketListHydratorProvider);
  ref.watch(_activeBucketHydratorProvider);
  ref.watch(_weeklyHydratorProvider);
  ref.watch(_memberHydratorProvider);
});

final _memberHydratorProvider = Provider<void>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return;
  final local = ref.read(bucketLocalDataSourceProvider);
  Future<void> hydrate() async {
    try {
      final members = await ref.read(bucketRepositoryProvider).fetchMembers(id);
      await local.reconcileMembers(id, members);
    } catch (_) {}
  }

  unawaited(hydrate());
  ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
    if (next.value == true) unawaited(hydrate());
  });
});

final bucketMembersProvider = StreamProvider<List<BucketMember>>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(const []);
  ref.watch(_memberHydratorProvider);
  return ref.watch(bucketLocalDataSourceProvider).watchMembers(id);
});

final ownedBucketsProvider = Provider<List<Bucket>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  final buckets = ref.watch(myBucketsProvider).value ?? const <Bucket>[];
  if (uid == null) return const [];
  return buckets.where((b) => b.ownerId == uid).toList();
});

final bucketMembersFamilyProvider =
    StreamProvider.family<List<BucketMember>, String>((ref, bucketId) {
      final local = ref.read(bucketLocalDataSourceProvider);
      Future<void> hydrate() async {
        try {
          final members = await ref
              .read(bucketRepositoryProvider)
              .fetchMembers(bucketId);
          await local.reconcileMembers(bucketId, members);
        } catch (_) {}
      }

      unawaited(hydrate());
      return local.watchMembers(bucketId);
    });

final weekExpensesProvider = Provider.family<List<Expense>, String>((
  ref,
  weekId,
) {
  final expenses = ref.watch(expensesProvider).value ?? const [];
  return expenses.where((e) => e.weekId == weekId).toList();
});

class BucketController extends StateNotifier<AsyncValue<Bucket?>> {
  BucketController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  BucketRepository get _repo => _ref.read(bucketRepositoryProvider);
  BucketLocalDataSource get _local => _ref.read(bucketLocalDataSourceProvider);
  OutboxRepository get _outbox => _ref.read(outboxRepositoryProvider);
  String get _uid => _ref.read(currentUserIdProvider) ?? '';

  void _kickSync() => unawaited(_ref.read(syncEngineProvider).sync());

  Future<Bucket?> createBucket({
    required String name,
    required double monthlyBudget,
    String currency = 'INR',
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      final bucket = Bucket(
        id: id,
        name: name,
        ownerId: _uid,
        joinCode: '',
        monthlyBudget: monthlyBudget,
        monthStartDate: DateTime(now.year, now.month, 1),
        remainingMainBucket: monthlyBudget,
        createdAt: now,
        currency: currency,
      );
      await _local.upsertBucketLocal(bucket, syncState: 'pending');
      await _outbox.enqueue(
        OutboxCommand(
          id: id,
          op: OutboxOp.bucketCreate,
          entity: 'bucket',
          entityId: id,
          priority: 20,
          payload: {
            'name': name,
            'budget': monthlyBudget,
            'currency': currency,
          },
        ),
        actor: _uid,
      );
      _ref.read(selectedBucketIdProvider.notifier).state = id;
      _kickSync();
      state = AsyncValue.data(bucket);
      return bucket;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return null;
    }
  }

  Future<Bucket?> joinViaCode(String code) async {
    state = const AsyncValue.loading();
    try {
      final bucket = await _repo.joinBucketViaCode(code);
      await _local.upsertBucketLocal(bucket, syncState: 'synced');
      _ref.read(selectedBucketIdProvider.notifier).state = bucket.id;
      state = AsyncValue.data(bucket);
      return bucket;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return null;
    }
  }

  Future<bool> updateBudget({
    required String bucketId,
    required double monthlyBudget,
  }) async {
    return _enqueueBucket(
      bucketId: bucketId,
      op: OutboxOp.bucketUpdateBudget,
      payload: {'budget': monthlyBudget},
      optimistic: (b) => b.copyWith(monthlyBudget: monthlyBudget),
    );
  }

  Future<bool> setBucketCurrency({
    required String bucketId,
    required String currency,
    double rate = 1,
  }) async {
    final existing = await _local.getBucket(bucketId);
    return _enqueueBucket(
      bucketId: bucketId,
      op: OutboxOp.bucketSetCurrency,
      payload: {
        'currency': currency,
        'rate': rate,
        'expected': existing?.currency,
      },
      optimistic: (b) => b.copyWith(currency: currency),
    );
  }

  Future<bool> transferOwnership({
    required String bucketId,
    required String newOwnerId,
  }) async {
    return _enqueueBucket(
      bucketId: bucketId,
      op: OutboxOp.bucketTransfer,
      payload: {'newOwner': newOwnerId},
      optimistic: (b) => b.copyWith(ownerId: newOwnerId),
    );
  }

  Future<bool> inviteByUsername({
    required String bucketId,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.inviteByUsername,
          entity: 'member',
          entityId: bucketId,
          payload: {'username': username},
        ),
        actor: _uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> setWeekManualTotal({
    required String weekId,
    required double amount,
  }) async {
    state = const AsyncValue.loading();
    try {
      final week = await _local.getWeek(weekId);
      if (week != null) {
        await _local.upsertWeekLocal(
          week.copyWith(spentAmount: amount),
          syncState: 'pending',
        );
      }
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.weekSetManualTotal,
          entity: 'week',
          entityId: weekId,
          priority: 10,
          payload: {'amount': amount},
        ),
        actor: _uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> deleteBucket(String bucketId) async {
    state = const AsyncValue.loading();
    try {
      await _local.markBucketDeleted(bucketId);
      if (_ref.read(selectedBucketIdProvider) == bucketId) {
        _ref.read(selectedBucketIdProvider.notifier).state = null;
      }
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.bucketDelete,
          entity: 'bucket',
          entityId: bucketId,
          priority: 20,
          payload: const {},
        ),
        actor: _uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> _enqueueBucket({
    required String bucketId,
    required OutboxOp op,
    required Map<String, dynamic> payload,
    Bucket Function(Bucket)? optimistic,
  }) async {
    state = const AsyncValue.loading();
    try {
      if (optimistic != null) {
        final existing = await _local.getBucket(bucketId);
        if (existing != null) {
          await _local.upsertBucketLocal(
            optimistic(existing),
            syncState: 'pending',
          );
        }
      }
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: op,
          entity: 'bucket',
          entityId: bucketId,
          priority: 20,
          payload: payload,
        ),
        actor: _uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }
}

final bucketControllerProvider =
    StateNotifierProvider<BucketController, AsyncValue<Bucket?>>((ref) {
      return BucketController(ref);
    });
