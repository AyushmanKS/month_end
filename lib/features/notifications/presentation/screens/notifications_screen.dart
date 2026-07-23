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
import '../../domain/entities/user_notification.dart';
import '../providers/notification_providers.dart';
import '../../../bucket/domain/entities/join_request.dart';
import '../../../bucket/presentation/providers/join_request_providers.dart';
import '../../../suggestions/presentation/providers/suggestion_providers.dart';
import '../../../suggestions/presentation/widgets/suggestion_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  String _iconFor(String type) {
    switch (type) {
      case 'expense_added':
        return AppAssets.addCircle;
      case 'expense_edited':
        return AppAssets.edit;
      case 'expense_deleted':
        return AppAssets.delete;
      case 'big_expense_added':
        return AppAssets.bolt;
      case 'budget_threshold':
        return AppAssets.warning;
      case 'budget_changed':
      case 'currency_changed':
      case 'week_total_edited':
        return AppAssets.payments;
      case 'ownership_transferred':
      case 'ownership_transferred_to_you':
      case 'ownership_transferred_away':
        return AppAssets.swapHorizontal;
      case 'member_joined':
      case 'join_requested':
      case 'join_accepted':
        return AppAssets.personAdd;
      case 'member_left':
      case 'member_removed':
      case 'removed_from_bucket':
      case 'join_rejected':
        return AppAssets.personOff;
      case 'bucket_deleted':
        return AppAssets.delete;
      case 'bucket_archived':
        return AppAssets.folder;
      case 'bucket_restored':
      case 'bucket_created':
        return AppAssets.savings;
      default:
        return AppAssets.notificationNone;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);
    final suggestions = ref.watch(suggestionsProvider).value ?? const [];
    final joinRequests =
        ref.watch(incomingJoinRequestsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          if ((inboxAsync.value ?? const []).any((n) => n.isUnread))
            TextButton(
              onPressed: () => markAllInboxRead(ref),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: SafeArea(
        child: inboxAsync.when(
          loading: () => const NotificationsSkeleton(),
          error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
          data: (inbox) {
            final notifications = inbox
                .where((n) => n.type != 'join_requested')
                .toList();
            if (notifications.isEmpty &&
                suggestions.isEmpty &&
                joinRequests.isEmpty) {
              return const AppEmptyState(
                title: 'Nothing yet',
                subtitle:
                    'Invites, membership changes and budget alerts show here.',
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
                        _InboxTile(
                          notification: notifications[i],
                          icon: _iconFor(notifications[i].type),
                          onTap: () => markInboxRead(ref, notifications[i].id),
                          onArchive: () => archiveInboxNotification(
                            ref,
                            notifications[i].id,
                          ),
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

class _InboxTile extends StatelessWidget {
  const _InboxTile({
    required this.notification,
    required this.icon,
    required this.onTap,
    required this.onArchive,
  });

  final UserNotification notification;
  final String icon;
  final VoidCallback onTap;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final unread = notification.isUnread;
    final title = notification.title.isEmpty
        ? notification.body
        : notification.title;
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onArchive(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        child: const AppIcon(AppAssets.inbox, color: AppColors.primary),
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: unread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      if (notification.body.isNotEmpty &&
                          notification.title.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          notification.body,
                          style: TextStyle(
                            color: context.brand.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Text(
                        notification.createdAt != null
                            ? AppDateUtils.dayYear(notification.createdAt!)
                            : '',
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
                    margin: const EdgeInsets.only(top: 4, left: AppSpacing.xs),
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
