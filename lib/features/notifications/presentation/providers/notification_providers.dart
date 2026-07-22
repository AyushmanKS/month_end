import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/sync/outbox_command.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../../bucket/domain/entities/weekly_bucket.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../domain/entities/app_notification.dart';
import '../../services/local_notification_service.dart';

const _uuid = Uuid();

final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  return LocalNotificationService(FlutterLocalNotificationsPlugin());
});

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSource(ref.watch(supabaseClientProvider));
    });

final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>((ref) {
      return NotificationLocalDataSource(ref.watch(appDatabaseProvider));
    });

final notificationHydratorProvider = Provider<void>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return;
  final local = ref.read(notificationLocalDataSourceProvider);
  final sub = ref
      .read(notificationRemoteDataSourceProvider)
      .watchForBucket(bucketId)
      .listen(
        (server) => unawaited(local.reconcile(bucketId, server)),
        onError: (_) {},
      );
  ref.onDispose(sub.cancel);
});

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return Stream.value(const []);
  ref.watch(notificationHydratorProvider);
  return ref
      .watch(notificationLocalDataSourceProvider)
      .watchForBucket(bucketId);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final notifications = ref.watch(notificationsProvider).value ?? const [];
  if (userId == null) return 0;
  return notifications.where((n) => !n.isReadBy(userId)).length;
});

Future<void> markNotificationsRead(WidgetRef ref) async {
  final bucketId = ref.read(activeBucketIdProvider);
  if (bucketId == null) return;
  final userId = ref.read(currentUserIdProvider);
  try {
    if (userId != null) {
      await ref
          .read(notificationLocalDataSourceProvider)
          .markAllReadLocal(bucketId, userId);
    }
    await ref
        .read(outboxRepositoryProvider)
        .enqueue(
          OutboxCommand(
            id: _uuid.v4(),
            op: OutboxOp.markNotificationsRead,
            entity: 'notifications',
            entityId: bucketId,
            payload: const {},
          ),
        );
    unawaited(ref.read(syncEngineProvider).sync());
  } catch (_) {}
}

final thresholdWatcherProvider = Provider<void>((ref) {
  final service = ref.read(localNotificationServiceProvider);
  final alerted = <String>{};
  ref.listen<AsyncValue<List<WeeklyBucket>>>(weeklyBucketsProvider, (_, next) {
    final weeks = next.value ?? const <WeeklyBucket>[];
    for (final week in weeks) {
      final key = '${week.bucketId}:${week.weekIndex}';
      if (week.isActive && week.isOverThreshold && !alerted.contains(key)) {
        alerted.add(key);
        service.showThresholdAlert(
          id: week.weekIndex,
          title: 'Weekly budget alert',
          body:
              'Week ${week.weekIndex + 1} is at ${(week.progress * 100).round()}% '
              'of its allocation.',
        );
      }
    }
  });
});
