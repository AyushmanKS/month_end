import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/entities/bucket_activity.dart';

class BucketActivityRemoteDataSource {
  BucketActivityRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'bucket_activity';

  Stream<List<BucketActivity>> watchActivity(String bucketId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('created_at', ascending: false)
        .limit(100)
        .map((rows) => rows.map(BucketActivity.fromJson).toList());
  }

  Future<List<BucketActivity>> loadOlder({
    required String bucketId,
    DateTime? beforeCreatedAt,
    String? beforeId,
    int limit = 30,
  }) async {
    try {
      final data = await _client.rpc(
        'get_bucket_activity',
        params: {
          'p_bucket_id': bucketId,
          'p_before_created_at': beforeCreatedAt?.toUtc().toIso8601String(),
          'p_before_id': beforeId,
          'p_limit': limit,
        },
      );
      final rows = (data as List).cast<Map<String, dynamic>>();
      return rows.map(BucketActivity.fromJson).toList();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }
}
