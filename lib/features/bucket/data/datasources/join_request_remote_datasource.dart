import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/entities/join_request.dart';

class JoinRequestRemoteDataSource {
  JoinRequestRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'join_requests';

  Future<JoinRequest> requestJoin({
    required String id,
    required String code,
  }) async {
    try {
      final data = await _client.rpc(
        'request_join',
        params: {'p_id': id, 'p_code': code.toUpperCase()},
      );
      return JoinRequest.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Stream<List<JoinRequest>> watchIncoming(String bucketId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('created_at')
        .map((rows) => rows.map(JoinRequest.fromJson).toList());
  }

  Stream<List<JoinRequest>> watchOutgoing(String uid) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('requester_uid', uid)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(JoinRequest.fromJson).toList());
  }
}
