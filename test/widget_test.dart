import 'package:flutter_test/flutter_test.dart';
import 'package:month_end/features/bucket/domain/entities/weekly_bucket.dart';
import 'package:month_end/features/bucket/domain/usecases/calculate_weekly_allocation.dart';

void main() {
  WeeklyBucket week({
    required int index,
    required double allocated,
    required double spent,
    WeeklyBucketStatus status = WeeklyBucketStatus.active,
  }) {
    return WeeklyBucket(
      id: 'w$index',
      bucketId: 'b1',
      weekIndex: index,
      startDate: DateTime(2026, 7, 1 + index * 7),
      endDate: DateTime(2026, 7, 7 + index * 7),
      allocatedAmount: allocated,
      spentAmount: spent,
      remainingAmount: allocated - spent,
      status: status,
    );
  }

  group('CalculateWeeklyAllocation', () {
    const allocator = CalculateWeeklyAllocation();

    test('spreads remaining budget evenly across active weeks', () {
      final result = allocator(
        WeeklyAllocationInput(
          remainingMainBucket: 3000,
          weeks: [
            week(index: 0, allocated: 1000, spent: 0),
            week(index: 1, allocated: 1000, spent: 0),
            week(index: 2, allocated: 1000, spent: 0),
          ],
        ),
      );

      expect(result, hasLength(3));
      for (final w in result) {
        expect(w.allocatedAmount, closeTo(1000, 0.001));
      }
    });

    test('never rebalances closed weeks', () {
      final result = allocator(
        WeeklyAllocationInput(
          remainingMainBucket: 1000,
          weeks: [
            week(
              index: 0,
              allocated: 500,
              spent: 500,
              status: WeeklyBucketStatus.closed,
            ),
            week(index: 1, allocated: 500, spent: 0),
            week(index: 2, allocated: 500, spent: 0),
          ],
        ),
      );

      final closed = result.firstWhere((w) => w.weekIndex == 0);
      expect(closed.allocatedAmount, 500);

      final active = result.where((w) => w.isActive);
      for (final w in active) {
        expect(w.allocatedAmount, closeTo(500, 0.001));
      }
    });

    test('keeps already-spent amounts inside the rebalance', () {
      final result = allocator(
        WeeklyAllocationInput(
          remainingMainBucket: 900,
          weeks: [
            week(index: 0, allocated: 500, spent: 100),
            week(index: 1, allocated: 500, spent: 0),
          ],
        ),
      );

      final total = result.fold<double>(0, (sum, w) => sum + w.allocatedAmount);
      expect(total, closeTo(1000, 0.001));
    });
  });
}
