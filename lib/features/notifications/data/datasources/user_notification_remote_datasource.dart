import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_notification.dart';

class UserNotificationRemoteDataSource {
  UserNotificationRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'user_notifications';

  Stream<List<UserNotification>> watchInbox(String uid) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('recipient_uid', uid)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(UserNotification.fromJson).toList());
  }
}
