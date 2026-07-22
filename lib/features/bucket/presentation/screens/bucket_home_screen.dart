import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_skeletons.dart';
import '../providers/bucket_providers.dart';
import '../widgets/bucket_switcher.dart';
import '../widgets/monthly_overview_ring.dart';
import '../widgets/weekly_bucket_card.dart';

class BucketHomeScreen extends ConsumerWidget {
  const BucketHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucketsAsync = ref.watch(myBucketsProvider);

    return Scaffold(
      body: SafeArea(
        child: bucketsAsync.when(
          loading: () => const DashboardSkeleton(),
          error: (e, _) => AppErrorView(
            message: ErrorHandler.userMessage(e),
            onRetry: () => ref.invalidate(myBucketsProvider),
          ),
          data: (buckets) {
            if (buckets.isEmpty) return const _NoBucketView();
            return const _BucketDashboard();
          },
        ),
      ),
    );
  }
}

class _BucketDashboard extends ConsumerWidget {
  const _BucketDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucketAsync = ref.watch(activeBucketProvider);
    final weeksAsync = ref.watch(weeklyBucketsProvider);
    final currencyCode = ref.watch(activeCurrencyProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myBucketsProvider);
        ref.invalidate(bucketMembersProvider);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          120,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: BucketSwitcher()),
              IconButton(
                onPressed: () => context.push(RouteNames.inviteMember),
                icon: const AppIcon(AppAssets.personAdd),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          bucketAsync.when(
            loading: () => const MonthlyRingSkeleton(),
            error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
            data: (bucket) => bucket == null
                ? const SizedBox.shrink()
                : MonthlyOverviewRing(bucket: bucket),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly buckets',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.push(RouteNames.bigExpense),
                icon: const AppIcon(AppAssets.bolt, size: 18),
                label: const Text('Big expense'),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          weeksAsync.when(
            loading: () => const WeeklyCardsSkeleton(),
            error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
            data: (weeks) {
              if (weeks.isEmpty) {
                return const AppEmptyState(
                  title: 'No weeks yet',
                  subtitle: 'Weekly buckets appear once a budget is set.',
                );
              }
              final ordered = [...weeks]
                ..sort((a, b) {
                  if (a.isCurrent != b.isCurrent) return a.isCurrent ? -1 : 1;
                  return a.weekIndex.compareTo(b.weekIndex);
                });
              return Column(
                children: [
                  for (var i = 0; i < ordered.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child:
                          WeeklyBucketCard(
                                week: ordered[i],
                                currencyCode: currencyCode,
                                onTap: () => context.push(
                                  RouteNames.weekDetails,
                                  extra: ordered[i],
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: AppDurations.listStagger * i,
                                duration: AppDurations.medium,
                              )
                              .slideY(begin: 0.1, end: 0),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NoBucketView extends StatelessWidget {
  const _NoBucketView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              AppAssets.savings,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Start a shared bucket',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Create a household budget or join one with a code.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Create a bucket',
              icon: AppAssets.addHome,
              onPressed: () => context.push(RouteNames.createBucket),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Join with a code',
              icon: AppAssets.qrCodeScanner,
              variant: AppButtonVariant.ghost,
              onPressed: () => context.push(RouteNames.joinBucket),
            ),
          ],
        ),
      ),
    );
  }
}
