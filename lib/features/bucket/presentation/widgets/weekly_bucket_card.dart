import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/animated_progress_bar.dart';
import '../../domain/entities/weekly_bucket.dart';

class WeeklyBucketCard extends StatelessWidget {
  const WeeklyBucketCard({
    super.key,
    required this.week,
    this.onTap,
    this.currencyCode = 'INR',
  });

  final WeeklyBucket week;
  final VoidCallback? onTap;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final isFuture = week.isFuture;
    final isCurrent = week.isCurrent;
    final tap = isFuture ? null : onTap;

    final card = Card(
      shape: isCurrent
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              side: const BorderSide(color: AppColors.primary, width: 1.5),
            )
          : null,
      child: InkWell(
        onTap: tap,
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
              if (week.isHistorical)
                _HistoricalFooter(
                  week: week,
                  brand: brand,
                  currencyCode: currencyCode,
                )
              else
                _ActiveFooter(
                  week: week,
                  brand: brand,
                  currencyCode: currencyCode,
                ),
            ],
          ),
        ),
      ),
    );

    return Opacity(
      opacity: isFuture
          ? 0.5
          : week.isHistorical
          ? 0.85
          : 1,
      child: card,
    );
  }
}

class _ActiveFooter extends StatelessWidget {
  const _ActiveFooter({
    required this.week,
    required this.brand,
    required this.currencyCode,
  });

  final WeeklyBucket week;
  final AppBrandColors brand;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedProgressBar(value: week.progress),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${CurrencyFormatter.format(week.spentAmount, code: currencyCode)} spent',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${CurrencyFormatter.format(week.remainingAmount, code: currencyCode)} left',
              style: TextStyle(
                color: week.isOverBudget ? brand.danger : brand.success,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoricalFooter extends StatelessWidget {
  const _HistoricalFooter({
    required this.week,
    required this.brand,
    required this.currencyCode,
  });

  final WeeklyBucket week;
  final AppBrandColors brand;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    if (week.needsManualTotal) {
      return Row(
        children: [
          AppIcon(AppAssets.editNote, size: 18, color: brand.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Tap to enter total spent',
              style: TextStyle(color: brand.textSecondary, fontSize: 13),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total spent', style: Theme.of(context).textTheme.bodySmall),
        Text(
          CurrencyFormatter.format(week.spentAmount, code: currencyCode),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.week});

  final WeeklyBucket week;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final (label, color) = week.isHistorical
        ? ('Past', brand.textSecondary)
        : week.isFuture
        ? ('Upcoming', brand.textSecondary)
        : week.isCurrent
        ? ('Active', AppColors.primary)
        : ('Passed', brand.textSecondary);
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
