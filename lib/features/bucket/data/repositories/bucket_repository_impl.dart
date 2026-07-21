import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';
import '../../domain/repositories/bucket_repository.dart';
import '../datasources/bucket_remote_datasource.dart';

class BucketRepositoryImpl implements BucketRepository {
  BucketRepositoryImpl(this._remote);

  final BucketRemoteDataSource _remote;

  @override
  Future<List<Bucket>> fetchMyBuckets() => _remote.fetchMyBuckets();

  @override
  Future<Bucket?> fetchBucket(String bucketId) => _remote.fetchBucket(bucketId);

  @override
  Stream<Bucket?> watchBucket(String bucketId) => _remote.watchBucket(bucketId);

  @override
  Future<Bucket> createBucket({
    required String name,
    required double monthlyBudget,
  }) => _remote.createBucket(name: name, monthlyBudget: monthlyBudget);

  @override
  Future<Bucket> updateMonthlyBudget({
    required String bucketId,
    required double monthlyBudget,
  }) => _remote.updateMonthlyBudget(
    bucketId: bucketId,
    monthlyBudget: monthlyBudget,
  );

  @override
  Future<Bucket> joinBucketViaCode(String joinCode) =>
      _remote.joinBucketViaCode(joinCode);

  @override
  Future<Bucket> transferOwnership({
    required String bucketId,
    required String newOwnerId,
  }) => _remote.transferOwnership(bucketId: bucketId, newOwnerId: newOwnerId);

  @override
  Future<void> deleteBucket(String bucketId) => _remote.deleteBucket(bucketId);

  @override
  Future<List<BucketMember>> fetchMembers(String bucketId) =>
      _remote.fetchMembers(bucketId);

  @override
  Future<void> inviteMemberByUsername({
    required String bucketId,
    required String username,
  }) => _remote.inviteMemberByUsername(bucketId: bucketId, username: username);

  @override
  Future<List<WeeklyBucket>> fetchWeeklyBuckets(String bucketId) =>
      _remote.fetchWeeklyBuckets(bucketId);

  @override
  Stream<List<WeeklyBucket>> watchWeeklyBuckets(String bucketId) =>
      _remote.watchWeeklyBuckets(bucketId);
}
