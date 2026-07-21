import '../entities/weekly_bucket.dart';

class WeeklyAllocationInput {
  const WeeklyAllocationInput({
    required this.remainingMainBucket,
    required this.weeks,
  });

  final double remainingMainBucket;
  final List<WeeklyBucket> weeks;
}

class CalculateWeeklyAllocation {
  const CalculateWeeklyAllocation();

  List<WeeklyBucket> call(WeeklyAllocationInput input) {
    final activeWeeks = input.weeks
        .where((w) => w.isActive)
        .toList(growable: false);
    final closedWeeks = input.weeks
        .where((w) => !w.isActive)
        .toList(growable: false);

    if (activeWeeks.isEmpty) return input.weeks;

    final alreadySpentInActive = activeWeeks.fold<double>(
      0,
      (sum, w) => sum + w.spentAmount,
    );
    final distributable = input.remainingMainBucket + alreadySpentInActive;
    final perWeek = distributable / activeWeeks.length;

    final rebalanced = activeWeeks.map((week) {
      final allocated = perWeek < 0 ? 0.0 : perWeek;
      return week.copyWith(
        allocatedAmount: allocated,
        remainingAmount: allocated - week.spentAmount,
      );
    }).toList();

    final result = [...closedWeeks, ...rebalanced]
      ..sort((a, b) => a.weekIndex.compareTo(b.weekIndex));
    return result;
  }

  static double initialWeeklyAllocation({
    required double remainingMainBucket,
    required int remainingWeeksInMonth,
  }) {
    if (remainingWeeksInMonth <= 0) return remainingMainBucket;
    return remainingMainBucket / remainingWeeksInMonth;
  }
}
