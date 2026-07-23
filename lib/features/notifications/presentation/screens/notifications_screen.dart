import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
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
import '../../../bucket/domain/entities/join_request.dart';
import '../../../bucket/presentation/providers/join_request_providers.dart';
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

  String _iconFor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.expenseAdded:
        return AppAssets.addCircle;
      case AppNotificationType.expenseEdited:
        return AppAssets.edit;
      case AppNotificationType.expenseDeleted:
        return AppAssets.delete;
      case AppNotificationType.bigExpenseAdded:
        return AppAssets.bolt;
      case AppNotificationType.budgetThreshold:
        return AppAssets.warning;
      case AppNotificationType.ownershipTransferred:
        return AppAssets.swapHorizontal;
      case AppNotificationType.memberLeft:
        return AppAssets.personOff;
      case AppNotificationType.joinRequested:
        return AppAssets.personAdd;
      case AppNotificationType.memberJoined:
        return AppAssets.personAdd;
      case AppNotificationType.unknown:
        return AppAssets.notificationNone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final suggestions = ref.watch(suggestionsProvider).value ?? const [];
    final joinRequests =
        ref.watch(incomingJoinRequestsProvider).value ?? const [];
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: SafeArea(
        child: notificationsAsync.when(
          loading: () => const NotificationsSkeleton(),
          error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
          data: (notifications) {
            if (notifications.isEmpty &&
                suggestions.isEmpty &&
                joinRequests.isEmpty) {
              return const AppEmptyState(
                title: 'Nothing yet',
                subtitle:
                    'Expenses, big spends and budget alerts will show here.',
                icon: AppAssets.notificationNone,
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
                if (joinRequests.isNotEmpty) ...[
                  Text(
                    'Join requests',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  for (final request in joinRequests)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: _JoinRequestCard(request: request),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                ],
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

class _JoinRequestCard extends ConsumerStatefulWidget {
  const _JoinRequestCard({required this.request});

  final JoinRequest request;

  @override
  ConsumerState<_JoinRequestCard> createState() => _JoinRequestCardState();
}

class _JoinRequestCardState extends ConsumerState<_JoinRequestCard> {
  bool _busy = false;

  Future<void> _decide(bool accept) async {
    setState(() => _busy = true);
    await ref
        .read(joinRequestControllerProvider.notifier)
        .decide(requestId: widget.request.id, accept: accept);
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final name = request.requesterName ?? 'Someone';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  backgroundImage: request.requesterPhoto != null
                      ? NetworkImage(request.requesterPhoto!)
                      : null,
                  child: request.requesterPhoto == null
                      ? const AppIcon(
                          AppAssets.personAdd,
                          size: 20,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '$name wants to join',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : () => _decide(false),
                    icon: const AppIcon(AppAssets.close, size: 18),
                    label: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _busy ? null : () => _decide(true),
                    icon: const AppIcon(
                      AppAssets.checkCircle,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
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
  final String icon;
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
              child: AppIcon(icon, size: 20, color: AppColors.primary),
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
