import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/datasources/bucket_remote_datasource.dart';
import '../../data/repositories/bucket_repository_impl.dart';
import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';
import '../../domain/repositories/bucket_repository.dart';

final bucketRemoteDataSourceProvider = Provider<BucketRemoteDataSource>((ref) {
  return BucketRemoteDataSource(ref.watch(supabaseClientProvider));
});

final bucketRepositoryProvider = Provider<BucketRepository>((ref) {
  return BucketRepositoryImpl(ref.watch(bucketRemoteDataSourceProvider));
});

final myBucketsProvider = FutureProvider<List<Bucket>>((ref) async {
  ref.watch(authStateChangesProvider);
  return ref.watch(bucketRepositoryProvider).fetchMyBuckets();
});

final selectedBucketIdProvider = StateProvider<String?>((ref) => null);

final activeBucketIdProvider = Provider<String?>((ref) {
  final selected = ref.watch(selectedBucketIdProvider);
  final buckets = ref.watch(myBucketsProvider).valueOrNull ?? const <Bucket>[];
  if (buckets.isEmpty) return null;
  if (selected != null && buckets.any((b) => b.id == selected)) return selected;
  return buckets.first.id;
});

final activeBucketProvider = StreamProvider<Bucket?>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(null);
  return ref.watch(bucketRepositoryProvider).watchBucket(id);
});

final weeklyBucketsProvider = StreamProvider<List<WeeklyBucket>>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(const []);
  return ref.watch(bucketRepositoryProvider).watchWeeklyBuckets(id);
});

final bucketMembersProvider = FutureProvider<List<BucketMember>>((ref) async {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return const [];
  return ref.watch(bucketRepositoryProvider).fetchMembers(id);
});

final ownedBucketsProvider = Provider<List<Bucket>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  final buckets = ref.watch(myBucketsProvider).valueOrNull ?? const <Bucket>[];
  if (uid == null) return const [];
  return buckets.where((b) => b.ownerId == uid).toList();
});

final bucketMembersFamilyProvider =
    FutureProvider.family<List<BucketMember>, String>((ref, bucketId) async {
      return ref.watch(bucketRepositoryProvider).fetchMembers(bucketId);
    });

class BucketController extends StateNotifier<AsyncValue<Bucket?>> {
  BucketController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  BucketRepository get _repo => _ref.read(bucketRepositoryProvider);

  Future<Bucket?> createBucket({
    required String name,
    required double monthlyBudget,
  }) async {
    state = const AsyncValue.loading();
    try {
      final bucket = await _repo.createBucket(
        name: name,
        monthlyBudget: monthlyBudget,
      );
      _ref.invalidate(myBucketsProvider);
      _ref.read(selectedBucketIdProvider.notifier).state = bucket.id;
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
      _ref.invalidate(myBucketsProvider);
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
    state = const AsyncValue.loading();
    try {
      final bucket = await _repo.updateMonthlyBudget(
        bucketId: bucketId,
        monthlyBudget: monthlyBudget,
      );
      state = AsyncValue.data(bucket);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> inviteByUsername({
    required String bucketId,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repo.inviteMemberByUsername(
        bucketId: bucketId,
        username: username,
      );
      _ref.invalidate(bucketMembersProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> transferOwnership({
    required String bucketId,
    required String newOwnerId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repo.transferOwnership(bucketId: bucketId, newOwnerId: newOwnerId);
      _ref.invalidate(myBucketsProvider);
      _ref.invalidate(bucketMembersProvider);
      _ref.invalidate(bucketMembersFamilyProvider(bucketId));
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
      await _repo.deleteBucket(bucketId);
      if (_ref.read(selectedBucketIdProvider) == bucketId) {
        _ref.read(selectedBucketIdProvider.notifier).state = null;
      }
      _ref.invalidate(myBucketsProvider);
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
