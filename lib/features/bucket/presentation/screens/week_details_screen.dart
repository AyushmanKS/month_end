import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/analytics/chart_type_provider.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../domain/entities/weekly_bucket.dart';
import '../providers/bucket_providers.dart';
import '../widgets/member_contribution_chart.dart';

class WeekDetailsScreen extends ConsumerWidget {
  const WeekDetailsScreen({super.key, required this.week});

  final WeeklyBucket week;

  Future<void> _enterManualTotal(BuildContext context, WidgetRef ref) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => _ManualTotalDialog(initial: week.spentAmount),
    );
    if (amount == null || !context.mounted) return;
    final ok = await ref
        .read(bucketControllerProvider.notifier)
        .setWeekManualTotal(weekId: week.id, amount: amount);
    showAppSnack(
      ok ? 'Week total saved.' : 'Could not save the week total.',
      success: ok,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(chartTypeProvider);
    final expenses = ref.watch(weekExpensesProvider(week.id));
    final members = ref.watch(bucketMembersProvider).valueOrNull ?? const [];
    final busy = ref.watch(bucketControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text('Week ${week.weekIndex + 1}')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            120,
          ),
          children: [
            _SummaryCard(week: week),
            const SizedBox(height: AppSpacing.lg),
            if (week.isHistorical) ...[
              _HistoricalCard(
                week: week,
                busy: busy,
                onEnter: () => _enterManualTotal(context, ref),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              'Member contributions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ChartSwitcher(
              selected: type,
              onSelected: (t) => ref.read(chartTypeProvider.notifier).set(t),
            ),
            const SizedBox(height: AppSpacing.md),
            MemberContributionChart(
              week: week,
              expenses: expenses,
              members: members,
              type: type,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Daily breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            _DailyBreakdown(week: week, expenses: expenses),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.week});

  final WeeklyBucket week;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppDateUtils.day(week.startDate)} – ${AppDateUtils.day(week.endDate)}',
              style: TextStyle(color: brand.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _Metric(
                  label: week.isHistorical ? 'Manual total' : 'Allocated',
                  value: week.isHistorical
                      ? CurrencyFormatter.format(week.spentAmount)
                      : CurrencyFormatter.format(week.allocatedAmount),
                ),
                _Metric(
                  label: 'Spent',
                  value: CurrencyFormatter.format(week.spentAmount),
                ),
                if (!week.isHistorical)
                  _Metric(
                    label: 'Left',
                    value: CurrencyFormatter.format(week.remainingAmount),
                    color: week.isOverBudget ? brand.danger : brand.success,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: color),
          ),
          Text(
            label,
            style: TextStyle(color: context.brand.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _HistoricalCard extends StatelessWidget {
  const _HistoricalCard({
    required this.week,
    required this.busy,
    required this.onEnter,
  });

  final WeeklyBucket week;
  final bool busy;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: brand.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Before this bucket started',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'This week ended before the bucket was created, so day-wise '
              'expenses are not tracked. Enter the total you spent that week '
              'to keep your budget accurate.',
              style: TextStyle(color: brand.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: week.needsManualTotal
                  ? 'Enter total spent'
                  : 'Edit total spent',
              variant: AppButtonVariant.secondary,
              icon: Icons.edit_outlined,
              isLoading: busy,
              onPressed: busy ? null : onEnter,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartSwitcher extends StatelessWidget {
  const _ChartSwitcher({required this.selected, required this.onSelected});

  final AppChartType selected;
  final ValueChanged<AppChartType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      children: [
        for (final type in AppChartType.values)
          ChoiceChip(
            label: Text(type.label),
            selected: selected == type,
            onSelected: (_) => onSelected(type),
          ),
      ],
    );
  }
}

class _DailyBreakdown extends StatelessWidget {
  const _DailyBreakdown({required this.week, required this.expenses});

  final WeeklyBucket week;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final days = <DateTime>[];
    var cursor = DateTime(
      week.startDate.year,
      week.startDate.month,
      week.startDate.day,
    );
    final end = DateTime(
      week.endDate.year,
      week.endDate.month,
      week.endDate.day,
    );
    while (!cursor.isAfter(end)) {
      days.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }

    final effective = DateTime(
      week.effectiveStartDate.year,
      week.effectiveStartDate.month,
      week.effectiveStartDate.day,
    );

    final totals = <DateTime, double>{for (final d in days) d: 0};
    for (final e in expenses) {
      final day = DateTime(
        e.createdAt.year,
        e.createdAt.month,
        e.createdAt.day,
      );
      if (totals.containsKey(day)) {
        totals[day] = (totals[day] ?? 0) + e.amount;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          children: [
            for (final day in days)
              _DailyRow(
                day: day,
                total: totals[day] ?? 0,
                inactive: day.isBefore(effective),
                brand: brand,
              ),
          ],
        ),
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  const _DailyRow({
    required this.day,
    required this.total,
    required this.inactive,
    required this.brand,
  });

  final DateTime day;
  final double total;
  final bool inactive;
  final AppBrandColors brand;

  @override
  Widget build(BuildContext context) {
    final color = inactive ? brand.textSecondary : null;
    return Opacity(
      opacity: inactive ? 0.5 : 1,
      child: ListTile(
        dense: true,
        title: Text(AppDateUtils.dayYear(day), style: TextStyle(color: color)),
        subtitle: inactive
            ? Text(
                'Inactive · before bucket start',
                style: TextStyle(color: brand.textSecondary, fontSize: 11),
              )
            : null,
        trailing: Text(
          inactive ? '—' : CurrencyFormatter.format(total),
          style: TextStyle(fontWeight: FontWeight.w700, color: color),
        ),
      ),
    );
  }
}

class _ManualTotalDialog extends StatefulWidget {
  const _ManualTotalDialog({required this.initial});

  final double initial;

  @override
  State<_ManualTotalDialog> createState() => _ManualTotalDialogState();
}

class _ManualTotalDialogState extends State<_ManualTotalDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initial > 0 ? widget.initial.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = double.tryParse(_controller.text.trim());
    if (value == null || value < 0) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Total spent this week'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        decoration: const InputDecoration(prefixText: '₹ ', hintText: '0'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
