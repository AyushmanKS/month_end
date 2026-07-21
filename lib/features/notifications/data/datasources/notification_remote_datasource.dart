import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/entities/app_notification.dart';

class NotificationRemoteDataSource {
  NotificationRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'notifications';

  Stream<List<AppNotification>> watchForBucket(String bucketId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(AppNotification.fromJson).toList());
  }

  Future<void> markAllRead(String bucketId) async {
    try {
      await _client.rpc(
        'mark_notifications_read',
        params: {'p_bucket_id': bucketId},
      );
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }
}
