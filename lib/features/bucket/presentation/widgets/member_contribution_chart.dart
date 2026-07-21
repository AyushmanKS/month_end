import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/analytics/chart_type_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';

class MemberContribution {
  const MemberContribution({
    required this.uid,
    required this.name,
    required this.color,
    required this.total,
  });

  final String uid;
  final String name;
  final Color color;
  final double total;
}

class MemberContributionChart extends StatelessWidget {
  const MemberContributionChart({
    super.key,
    required this.week,
    required this.expenses,
    required this.members,
    required this.type,
  });

  final WeeklyBucket week;
  final List<Expense> expenses;
  final List<BucketMember> members;
  final AppChartType type;

  Color _colorFor(String uid, int index) {
    if (uid.isEmpty) return const Color(0xFF8A9AA8);
    return AppColors.categorySwatch[index % AppColors.categorySwatch.length];
  }

  List<DateTime> get _days {
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
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final orderedUids = <String>[];
    for (final member in members) {
      if (!orderedUids.contains(member.userId)) orderedUids.add(member.userId);
    }
    for (final expense in expenses) {
      final uid = expense.addedByUid;
      if (!orderedUids.contains(uid)) orderedUids.add(uid);
    }

    final colorByUid = <String, Color>{};
    final nameByUid = <String, String>{};
    for (var i = 0; i < orderedUids.length; i++) {
      final uid = orderedUids[i];
      colorByUid[uid] = _colorFor(uid, i);
      nameByUid[uid] = _nameFor(uid);
    }

    final totalByUid = <String, double>{};
    for (final expense in expenses) {
      totalByUid[expense.addedByUid] =
          (totalByUid[expense.addedByUid] ?? 0) + expense.amount;
    }

    final contributions =
        totalByUid.entries
            .map(
              (e) => MemberContribution(
                uid: e.key,
                name: nameByUid[e.key] ?? _nameFor(e.key),
                color: colorByUid[e.key] ?? _colorFor(e.key, 0),
                total: e.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.total.compareTo(a.total));

    if (expenses.isEmpty) {
      return _EmptyChart(brand: context.brand);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 240,
          child: switch (type) {
            AppChartType.bar => _buildBars(context, colorByUid),
            AppChartType.line => _buildLines(context, colorByUid),
            AppChartType.pie => _buildPie(contributions, donut: false),
            AppChartType.donut => _buildPie(contributions, donut: true),
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _Legend(contributions: contributions),
      ],
    );
  }

  String _nameFor(String uid) {
    if (uid.isEmpty) return 'Deleted User';
    for (final member in members) {
      if (member.userId == uid) {
        return member.name ?? 'Member';
      }
    }
    return 'Deleted User';
  }

  Map<DateTime, Map<String, double>> _dailyTotals() {
    final result = <DateTime, Map<String, double>>{};
    for (final day in _days) {
      result[day] = <String, double>{};
    }
    for (final expense in expenses) {
      final day = DateTime(
        expense.createdAt.year,
        expense.createdAt.month,
        expense.createdAt.day,
      );
      final bucket = result[day];
      if (bucket == null) continue;
      bucket[expense.addedByUid] =
          (bucket[expense.addedByUid] ?? 0) + expense.amount;
    }
    return result;
  }

  Widget _buildBars(BuildContext context, Map<String, Color> colorByUid) {
    final days = _days;
    final daily = _dailyTotals();
    var maxY = 0.0;
    final groups = <BarChartGroupData>[];
    for (var i = 0; i < days.length; i++) {
      final perMember = daily[days[i]] ?? const {};
      var runningTop = 0.0;
      final stack = <BarChartRodStackItem>[];
      for (final entry in perMember.entries) {
        final from = runningTop;
        final to = runningTop + entry.value;
        stack.add(
          BarChartRodStackItem(
            from,
            to,
            colorByUid[entry.key] ?? const Color(0xFF8A9AA8),
          ),
        );
        runningTop = to;
      }
      if (runningTop > maxY) maxY = runningTop;
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: runningTop,
              rodStackItems: stack,
              width: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: maxY <= 0 ? 1 : maxY * 1.2,
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) =>
                  _dayLabel(context, days, value.toInt()),
            ),
          ),
        ),
        barGroups: groups,
      ),
    );
  }

  Widget _buildLines(BuildContext context, Map<String, Color> colorByUid) {
    final days = _days;
    final daily = _dailyTotals();
    final uids = colorByUid.keys.toList();
    var maxY = 0.0;
    final lines = <LineChartBarData>[];
    for (final uid in uids) {
      final spots = <FlSpot>[];
      for (var i = 0; i < days.length; i++) {
        final value = daily[days[i]]?[uid] ?? 0;
        if (value > maxY) maxY = value;
        spots.add(FlSpot(i.toDouble(), value));
      }
      if (spots.every((s) => s.y == 0)) continue;
      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 3,
          color: colorByUid[uid],
          dotData: const FlDotData(show: false),
        ),
      );
    }

    return LineChart(
      LineChartData(
        maxY: maxY <= 0 ? 1 : maxY * 1.2,
        minY: 0,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        lineTouchData: const LineTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) =>
                  _dayLabel(context, days, value.toInt()),
            ),
          ),
        ),
        lineBarsData: lines,
      ),
    );
  }

  Widget _buildPie(
    List<MemberContribution> contributions, {
    required bool donut,
  }) {
    final total = contributions.fold<double>(0, (sum, c) => sum + c.total);
    final sections = contributions.map((c) {
      final percent = total <= 0 ? 0 : (c.total / total) * 100;
      return PieChartSectionData(
        value: c.total,
        color: c.color,
        radius: donut ? 50 : 70,
        title: percent >= 8 ? '${percent.round()}%' : '',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: donut ? 48 : 0,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _dayLabel(BuildContext context, List<DateTime> days, int index) {
    if (index < 0 || index >= days.length) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        '${days[index].day}',
        style: TextStyle(color: context.brand.textSecondary, fontSize: 11),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.contributions});

  final List<MemberContribution> contributions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final c in contributions)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: c.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${c.name} · ${CurrencyFormatter.format(c.total)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.brand});

  final AppBrandColors brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_rounded, color: brand.textSecondary, size: 36),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No expenses in this week yet',
            style: TextStyle(color: brand.textSecondary),
          ),
        ],
      ),
    );
  }
}
