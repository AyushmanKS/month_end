import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../core/logging/app_logger.dart';
import 'web_notifier.dart' as web_notifier;

class LocalNotificationService {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const String _channelId = 'budget_thresholds';
  static const String _channelName = 'Budget alerts';

  Future<void> init() async {
    if (kIsWeb) return;
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
    );
    _initialized = true;
    AppLogger.instance.i('Local notifications initialized');
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) {
      await web_notifier.requestWebNotificationPermission();
      return;
    }
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showThresholdAlert({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      await web_notifier.showWebNotification(title: title, body: body);
      AppLogger.instance.i('Threshold web notification fired: $title');
      return;
    }
    await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Weekly and monthly budget threshold alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
    AppLogger.instance.i('Threshold local notification fired: $title');
  }
}
