import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../../bucket/domain/entities/weekly_bucket.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../domain/entities/app_notification.dart';
import '../../services/local_notification_service.dart';

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService(FlutterLocalNotificationsPlugin());
});

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSource(ref.watch(supabaseClientProvider));
    });

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return Stream.value(const []);
  return ref
      .watch(notificationRemoteDataSourceProvider)
      .watchForBucket(bucketId);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final notifications =
      ref.watch(notificationsProvider).valueOrNull ?? const [];
  if (userId == null) return 0;
  return notifications.where((n) => !n.isReadBy(userId)).length;
});

Future<void> markNotificationsRead(WidgetRef ref) async {
  final bucketId = ref.read(activeBucketIdProvider);
  if (bucketId == null) return;
  await ref.read(notificationRemoteDataSourceProvider).markAllRead(bucketId);
}

final _thresholdAlertedProvider = StateProvider<Set<String>>((ref) => {});

final thresholdWatcherProvider = Provider<void>((ref) {
  final service = ref.read(localNotificationServiceProvider);
  ref.listen<AsyncValue<List<WeeklyBucket>>>(weeklyBucketsProvider, (_, next) {
    final weeks = next.valueOrNull ?? const <WeeklyBucket>[];
    final alerted = ref.read(_thresholdAlertedProvider);
    for (final week in weeks) {
      final key = '${week.bucketId}:${week.weekIndex}';
      if (week.isActive && week.isOverThreshold && !alerted.contains(key)) {
        service.showThresholdAlert(
          id: week.weekIndex,
          title: 'Weekly budget alert',
          body:
              'Week ${week.weekIndex + 1} is at ${(week.progress * 100).round()}% '
              'of its allocation.',
        );
        ref.read(_thresholdAlertedProvider.notifier).update((s) => {...s, key});
      }
    }
  });
});
