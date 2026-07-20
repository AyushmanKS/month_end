import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/animated_progress_bar.dart';
import '../../domain/entities/weekly_bucket.dart';

class WeeklyBucketCard extends StatelessWidget {
  const WeeklyBucketCard({super.key, required this.week, this.onTap});

  final WeeklyBucket week;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Week ${week.weekIndex + 1}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  _StatusChip(week: week),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${AppDateUtils.day(week.startDate)} – ${AppDateUtils.day(week.endDate)}',
                style: TextStyle(color: brand.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedProgressBar(value: week.progress),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${CurrencyFormatter.format(week.spentAmount)} spent',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${CurrencyFormatter.format(week.remainingAmount)} left',
                    style: TextStyle(
                      color: week.isOverBudget ? brand.danger : brand.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.week});

  final WeeklyBucket week;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final (label, color) = week.isActive
        ? ('Active', brand.success)
        : ('Closed', brand.textSecondary);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
