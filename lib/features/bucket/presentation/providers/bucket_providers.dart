import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/datasources/bucket_remote_datasource.dart';
import '../../data/repositories/bucket_repository_impl.dart';
import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';
import '../../domain/repositories/bucket_repository.dart';

final bucketRemoteDataSourceProvider =
    Provider<BucketRemoteDataSource>((ref) {
  return BucketRemoteDataSource(ref.watch(supabaseClientProvider));
});

final bucketRepositoryProvider = Provider<BucketRepository>((ref) {
  return BucketRepositoryImpl(ref.watch(bucketRemoteDataSourceProvider));
});

final myBucketsProvider = FutureProvider<List<Bucket>>((ref) async {
  ref.watch(authStateChangesProvider);
  return ref.watch(bucketRepositoryProvider).fetchMyBuckets();
});

final activeBucketIdProvider = StateProvider<String?>((ref) {
  final buckets = ref.watch(myBucketsProvider).valueOrNull;
  if (buckets == null || buckets.isEmpty) return null;
  return buckets.first.id;
});

final activeBucketProvider = StreamProvider<Bucket?>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(null);
  return ref.watch(bucketRepositoryProvider).watchBucket(id);
});

final weeklyBucketsProvider =
    StreamProvider<List<WeeklyBucket>>((ref) {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return Stream.value(const []);
  return ref.watch(bucketRepositoryProvider).watchWeeklyBuckets(id);
});

final bucketMembersProvider =
    FutureProvider<List<BucketMember>>((ref) async {
  final id = ref.watch(activeBucketIdProvider);
  if (id == null) return const [];
  return ref.watch(bucketRepositoryProvider).fetchMembers(id);
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
      final bucket =
          await _repo.createBucket(name: name, monthlyBudget: monthlyBudget);
      _ref.invalidate(myBucketsProvider);
      _ref.read(activeBucketIdProvider.notifier).state = bucket.id;
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
      _ref.read(activeBucketIdProvider.notifier).state = bucket.id;
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
}

final bucketControllerProvider =
    StateNotifierProvider<BucketController, AsyncValue<Bucket?>>((ref) {
  return BucketController(ref);
});
