import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_skeletons.dart';
import '../../domain/entities/bucket_activity.dart';
import '../providers/bucket_activity_providers.dart';
import '../providers/bucket_providers.dart';

class BucketActivityScreen extends ConsumerStatefulWidget {
  const BucketActivityScreen({super.key});

  @override
  ConsumerState<BucketActivityScreen> createState() =>
      _BucketActivityScreenState();
}

class _BucketActivityScreenState extends ConsumerState<BucketActivityScreen> {
  bool _loadingMore = false;
  bool _reachedEnd = false;

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
        return AppAssets.swapHorizontal;
      case 'member_joined':
      case 'join_requested':
        return AppAssets.personAdd;
      case 'member_left':
      case 'member_removed':
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

  Future<void> _loadMore(String bucketId, BucketActivity? oldest) async {
    if (_loadingMore || _reachedEnd) return;
    setState(() => _loadingMore = true);
    final count = await loadOlderActivity(ref, bucketId, oldest);
    if (!mounted) return;
    setState(() {
      _loadingMore = false;
      if (count == 0) _reachedEnd = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bucketId = ref.watch(activeBucketIdProvider);
    if (bucketId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Activity history')),
        body: const AppEmptyState(
          title: 'No bucket selected',
          subtitle: 'Open a bucket to see its history.',
          icon: AppAssets.history,
        ),
      );
    }
    final activityAsync = ref.watch(bucketActivityProvider(bucketId));

    return Scaffold(
      appBar: AppBar(title: const Text('Activity history')),
      body: SafeArea(
        child: activityAsync.when(
          loading: () => const NotificationsSkeleton(),
          error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
          data: (items) {
            if (items.isEmpty) {
              return const AppEmptyState(
                title: 'No activity yet',
                subtitle:
                    'Expenses, members and changes to this bucket appear here.',
                icon: AppAssets.history,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                120,
              ),
              itemCount: items.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  if (_reachedEnd) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Center(
                      child: _loadingMore
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : TextButton(
                              onPressed: () => _loadMore(bucketId, items.last),
                              child: const Text('Load older'),
                            ),
                    ),
                  );
                }
                return _ActivityTile(
                  activity: items[index],
                  icon: _iconFor(items[index].type),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity, required this.icon});

  final BucketActivity activity;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: AppIcon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.createdAt != null
                        ? AppDateUtils.dayYear(activity.createdAt!)
                        : '',
                    style: TextStyle(
                      color: context.brand.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
