import 'package:supabase_flutter/supabase_flutter.dart'
    hide Bucket, AuthException;
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';
import '../../domain/usecases/generate_join_code.dart';

class BucketRemoteDataSource {
  BucketRemoteDataSource(this._client, {GenerateJoinCode? codeGenerator})
      : _codeGenerator = codeGenerator ?? const GenerateJoinCode();

  final SupabaseClient _client;
  final GenerateJoinCode _codeGenerator;

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
      final now = DateTime.now();
      final monthStart = AppDateUtils.startOfMonth(now);
      final joinCode = _codeGenerator();

      final bucketRow = await _client
          .from(_buckets)
          .insert({
            'name': name,
            'owner_id': _uid,
            'join_code': joinCode,
            'monthly_budget': monthlyBudget,
            'month_start_date': _dateString(monthStart),
            'remaining_main_bucket': monthlyBudget,
          })
          .select()
          .single();

      final bucket = Bucket.fromJson(bucketRow);

      await _client.from(_members).insert({
        'bucket_id': bucket.id,
        'user_id': _uid,
      });

      await _seedWeeklyBuckets(bucket, now);
      return bucket;
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> _seedWeeklyBuckets(Bucket bucket, DateTime now) async {
    final windows = AppDateUtils.weekWindows(bucket.monthStartDate);
    final perWeek = windows.isEmpty ? 0.0 : bucket.monthlyBudget / windows.length;
    final rows = <Map<String, dynamic>>[];
    for (var i = 0; i < windows.length; i++) {
      rows.add({
        'bucket_id': bucket.id,
        'week_index': i,
        'start_date': _dateString(windows[i].start),
        'end_date': _dateString(windows[i].end),
        'allocated_amount': perWeek,
        'spent_amount': 0,
        'remaining_amount': perWeek,
        'status': 'active',
      });
    }
    if (rows.isNotEmpty) {
      await _client.from(_weekly).insert(rows);
    }
  }

  Future<Bucket> updateMonthlyBudget({
    required String bucketId,
    required double monthlyBudget,
  }) async {
    try {
      final current = await fetchBucket(bucketId);
      if (current == null) {
        throw const NotFoundException('Bucket not found.');
      }
      final spent = current.spentSoFar;
      final remaining = monthlyBudget - spent;
      final row = await _client
          .from(_buckets)
          .update({
            'monthly_budget': monthlyBudget,
            'remaining_main_bucket': remaining,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bucketId)
          .select()
          .single();
      return Bucket.fromJson(row);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Bucket> joinBucketViaCode(String joinCode) async {
    try {
      final row = await _client
          .from(_buckets)
          .select()
          .eq('join_code', joinCode.toUpperCase())
          .maybeSingle();
      if (row == null) {
        throw const NotFoundException('No bucket found for that code.');
      }
      final bucket = Bucket.fromJson(row);
      await _client.from(_members).upsert({
        'bucket_id': bucket.id,
        'user_id': _uid,
      });
      return bucket;
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

  Future<void> persistRebalance(List<WeeklyBucket> weeks) async {
    try {
      for (final week in weeks) {
        await _client.from(_weekly).update({
          'allocated_amount': week.allocatedAmount,
          'remaining_amount': week.remainingAmount,
        }).eq('id', week.id);
      }
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
