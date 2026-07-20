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

  Future<void> markRead({
    required String notificationId,
    required String userId,
    required List<String> currentReadBy,
  }) async {
    try {
      if (currentReadBy.contains(userId)) return;
      await _client.from(_table).update({
        'read_by': [...currentReadBy, userId],
      }).eq('id', notificationId);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }
}
