import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_skeletons.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../domain/entities/app_notification.dart';
import '../providers/notification_providers.dart';
import '../../../suggestions/presentation/providers/suggestion_providers.dart';
import '../../../suggestions/presentation/widgets/suggestion_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => markNotificationsRead(ref),
    );
  }

  IconData _iconFor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.expenseAdded:
        return Icons.add_circle_outline;
      case AppNotificationType.expenseEdited:
        return Icons.edit_outlined;
      case AppNotificationType.expenseDeleted:
        return Icons.delete_outline;
      case AppNotificationType.bigExpenseAdded:
        return Icons.bolt_outlined;
      case AppNotificationType.budgetThreshold:
        return Icons.warning_amber_rounded;
      case AppNotificationType.ownershipTransferred:
        return Icons.swap_horiz_rounded;
      case AppNotificationType.memberLeft:
        return Icons.person_off_outlined;
      case AppNotificationType.unknown:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final suggestions = ref.watch(suggestionsProvider).value ?? const [];
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: SafeArea(
        child: notificationsAsync.when(
          loading: () => const NotificationsSkeleton(),
          error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
          data: (notifications) {
            if (notifications.isEmpty && suggestions.isEmpty) {
              return const AppEmptyState(
                title: 'Nothing yet',
                subtitle:
                    'Expenses, big spends and budget alerts will show here.',
                icon: Icons.notifications_none_rounded,
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                120,
              ),
              children: [
                if (suggestions.isNotEmpty) ...[
                  Text(
                    'Suggestions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  for (final suggestion in suggestions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: SuggestionCard(suggestion: suggestion),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                for (var i = 0; i < notifications.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child:
                        _NotificationTile(
                          notification: notifications[i],
                          icon: _iconFor(notifications[i].type),
                          unread:
                              userId != null &&
                              !notifications[i].isReadBy(userId),
                        ).animate().fadeIn(
                          delay: AppDurations.listStagger * (i % 8),
                          duration: AppDurations.fast,
                        ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.unread,
  });

  final AppNotification notification;
  final IconData icon;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppDateUtils.dayYear(notification.createdAt),
                    style: TextStyle(
                      color: context.brand.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (unread)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
