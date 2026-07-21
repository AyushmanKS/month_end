import '../entities/bucket.dart';
import '../entities/bucket_member.dart';
import '../entities/weekly_bucket.dart';

abstract class BucketRepository {
  Future<List<Bucket>> fetchMyBuckets();

  Future<Bucket?> fetchBucket(String bucketId);

  Stream<Bucket?> watchBucket(String bucketId);

  Future<Bucket> createBucket({
    required String name,
    required double monthlyBudget,
  });

  Future<Bucket> updateMonthlyBudget({
    required String bucketId,
    required double monthlyBudget,
  });

  Future<Bucket> joinBucketViaCode(String joinCode);

  Future<Bucket> transferOwnership({
    required String bucketId,
    required String newOwnerId,
  });

  Future<void> deleteBucket(String bucketId);

  Future<List<BucketMember>> fetchMembers(String bucketId);

  Future<void> inviteMemberByUsername({
    required String bucketId,
    required String username,
  });

  Future<List<WeeklyBucket>> fetchWeeklyBuckets(String bucketId);

  Stream<List<WeeklyBucket>> watchWeeklyBuckets(String bucketId);
}
