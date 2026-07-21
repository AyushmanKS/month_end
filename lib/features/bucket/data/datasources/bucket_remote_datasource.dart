import 'package:supabase_flutter/supabase_flutter.dart'
    hide Bucket, AuthException;
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';

class BucketRemoteDataSource {
  BucketRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _buckets = 'buckets';
  static const String _members = 'bucket_members';
  static const String _weekly = 'weekly_buckets';

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const AuthException('You must be signed in.');
    }
    return id;
  }

  Future<List<Bucket>> fetchMyBuckets() async {
    try {
      final memberRows = await _client
          .from(_members)
          .select('bucket_id')
          .eq('user_id', _uid);
      final ids = memberRows
          .map((r) => r['bucket_id'] as String)
          .toList(growable: false);
      if (ids.isEmpty) return [];
      final rows = await _client
          .from(_buckets)
          .select()
          .inFilter('id', ids)
          .order('created_at');
      return rows.map(Bucket.fromJson).toList();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Bucket?> fetchBucket(String bucketId) async {
    try {
      final row = await _client
          .from(_buckets)
          .select()
          .eq('id', bucketId)
          .maybeSingle();
      return row == null ? null : Bucket.fromJson(row);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Stream<Bucket?> watchBucket(String bucketId) {
    return _client
        .from(_buckets)
        .stream(primaryKey: ['id'])
        .eq('id', bucketId)
        .map((rows) => rows.isEmpty ? null : Bucket.fromJson(rows.first));
  }

  Future<Bucket> createBucket({
    required String name,
    required double monthlyBudget,
  }) async {
    try {
      final data = await _client.rpc(
        'create_bucket',
        params: {'p_name': name, 'p_budget': monthlyBudget},
      );
      return Bucket.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Bucket> updateMonthlyBudget({
    required String bucketId,
    required double monthlyBudget,
  }) async {
    try {
      final data = await _client.rpc(
        'update_monthly_budget',
        params: {'p_bucket_id': bucketId, 'p_budget': monthlyBudget},
      );
      return Bucket.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Bucket> joinBucketViaCode(String joinCode) async {
    try {
      final data = await _client.rpc(
        'join_bucket_with_code',
        params: {'p_code': joinCode.toUpperCase()},
      );
      if (data == null) {
        throw const NotFoundException('No bucket found for that code.');
      }
      return Bucket.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Bucket> transferOwnership({
    required String bucketId,
    required String newOwnerId,
  }) async {
    try {
      final data = await _client.rpc(
        'transfer_bucket_ownership',
        params: {'p_bucket_id': bucketId, 'p_new_owner': newOwnerId},
      );
      return Bucket.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> deleteBucket(String bucketId) async {
    try {
      await _client.rpc('delete_bucket', params: {'p_bucket_id': bucketId});
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<WeeklyBucket> setWeekManualTotal({
    required String weekId,
    required double amount,
  }) async {
    try {
      final data = await _client.rpc(
        'set_week_manual_total',
        params: {'p_week_id': weekId, 'p_amount': amount},
      );
      return WeeklyBucket.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<List<BucketMember>> fetchMembers(String bucketId) async {
    try {
      final rows = await _client
          .from(_members)
          .select('bucket_id, user_id, joined_at, users(name, photo_url)')
          .eq('bucket_id', bucketId);
      return rows.map(BucketMember.fromJson).toList();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> inviteMemberByUsername({
    required String bucketId,
    required String username,
  }) async {
    try {
      final user = await _client
          .from('users')
          .select('id')
          .eq('username', username)
          .maybeSingle();
      if (user == null) {
        throw const NotFoundException('No user found with that username.');
      }
      await _client.from(_members).upsert({
        'bucket_id': bucketId,
        'user_id': user['id'],
      });
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<List<WeeklyBucket>> fetchWeeklyBuckets(String bucketId) async {
    try {
      final rows = await _client
          .from(_weekly)
          .select()
          .eq('bucket_id', bucketId)
          .order('week_index');
      return rows.map(WeeklyBucket.fromJson).toList();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Stream<List<WeeklyBucket>> watchWeeklyBuckets(String bucketId) {
    return _client
        .from(_weekly)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('week_index')
        .map((rows) => rows.map(WeeklyBucket.fromJson).toList());
  }
}
