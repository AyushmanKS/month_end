import 'package:supabase_flutter/supabase_flutter.dart'
    hide Bucket, AuthException;
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../bucket/domain/entities/bucket.dart';
import '../../../bucket/domain/entities/weekly_bucket.dart';
import '../../../bucket/domain/usecases/calculate_weekly_allocation.dart';
import '../../domain/entities/big_expense.dart';
import '../../domain/entities/expense.dart';

class ExpenseRemoteDataSource {
  ExpenseRemoteDataSource(this._client);

  final SupabaseClient _client;
  final CalculateWeeklyAllocation _allocator = const CalculateWeeklyAllocation();

  static const String _expenses = 'expenses';
  static const String _bigExpenses = 'big_expenses';
  static const String _weekly = 'weekly_buckets';
  static const String _buckets = 'buckets';
  static const String _notifications = 'notifications';

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const AuthException('You must be signed in.');
    return id;
  }

  Stream<List<Expense>> watchExpenses(String bucketId) {
    return _client
        .from(_expenses)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('created_at')
        .map((rows) => rows.map(Expense.fromJson).toList());
  }

  Future<List<Expense>> fetchExpenses(String bucketId) async {
    try {
      final rows = await _client
          .from(_expenses)
          .select('*, users(name)')
          .eq('bucket_id', bucketId)
          .order('created_at', ascending: false);
      return rows.map(Expense.fromJson).toList();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Expense> addExpense({
    required String bucketId,
    required double amount,
    required String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) async {
    try {
      final week = await _resolveActiveWeek(bucketId);
      final row = await _client
          .from(_expenses)
          .insert({
            'bucket_id': bucketId,
            'week_id': week?.id,
            'added_by_uid': _uid,
            'amount': amount,
            'category_id': categoryId,
            'note': note,
            'receipt_image_url': receiptImageUrl,
          })
          .select('*, users(name)')
          .single();

      if (week != null) {
        await _applyWeeklyDelta(week, amount);
      }
      await _applyBucketDelta(bucketId, -amount);
      await _insertNotification(
        bucketId: bucketId,
        type: 'expense_added',
        message: 'A new expense of ${amount.toStringAsFixed(0)} was added',
      );
      await _maybeThresholdNotification(bucketId, week?.id);
      AppLogger.instance.i('Expense added to bucket $bucketId');
      return Expense.fromJson(row);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<Expense> editExpense({
    required String expenseId,
    double? amount,
    String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) async {
    try {
      final existing = await _client
          .from(_expenses)
          .select()
          .eq('id', expenseId)
          .single();
      final previous = Expense.fromJson(existing);

      final payload = <String, dynamic>{
        'edited_by_uid': _uid,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (amount != null) payload['amount'] = amount;
      if (categoryId != null) payload['category_id'] = categoryId;
      if (note != null) payload['note'] = note;
      if (receiptImageUrl != null) {
        payload['receipt_image_url'] = receiptImageUrl;
      }

      final row = await _client
          .from(_expenses)
          .update(payload)
          .eq('id', expenseId)
          .select('*, users(name)')
          .single();
      final updated = Expense.fromJson(row);

      final delta = updated.amount - previous.amount;
      if (delta != 0) {
        if (previous.weekId != null) {
          final week = await _fetchWeek(previous.weekId!);
          if (week != null) await _applyWeeklyDelta(week, delta);
        }
        await _applyBucketDelta(previous.bucketId, -delta);
      }
      await _insertNotification(
        bucketId: previous.bucketId,
        type: 'expense_edited',
        message: 'An expense was edited',
      );
      return updated;
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      final existing = await _client
          .from(_expenses)
          .select()
          .eq('id', expenseId)
          .single();
      final expense = Expense.fromJson(existing);

      await _client.from(_expenses).delete().eq('id', expenseId);

      if (expense.weekId != null) {
        final week = await _fetchWeek(expense.weekId!);
        if (week != null) await _applyWeeklyDelta(week, -expense.amount);
      }
      await _applyBucketDelta(expense.bucketId, expense.amount);
      await _insertNotification(
        bucketId: expense.bucketId,
        type: 'expense_deleted',
        message: 'An expense was deleted',
      );
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<BigExpense> addBigExpense({
    required String bucketId,
    required String title,
    required double amount,
  }) async {
    try {
      final row = await _client
          .from(_bigExpenses)
          .insert({
            'bucket_id': bucketId,
            'added_by_uid': _uid,
            'title': title,
            'amount': amount,
          })
          .select()
          .single();

      final bucket = await _applyBucketDelta(bucketId, -amount);
      if (bucket != null) {
        await _rebalanceActiveWeeks(bucket);
      }
      await _insertNotification(
        bucketId: bucketId,
        type: 'big_expense_added',
        message: '$title (${amount.toStringAsFixed(0)}) added as a big expense',
      );
      AppLogger.instance.i('Big expense added; weeks rebalanced');
      return BigExpense.fromJson(row);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<WeeklyBucket?> _resolveActiveWeek(String bucketId) async {
    final today = DateTime.now();
    final rows = await _client
        .from(_weekly)
        .select()
        .eq('bucket_id', bucketId)
        .eq('status', 'active')
        .order('week_index');
    final weeks = rows.map(WeeklyBucket.fromJson).toList();
    if (weeks.isEmpty) return null;
    for (final week in weeks) {
      final start = DateTime(
          week.startDate.year, week.startDate.month, week.startDate.day);
      final end = DateTime(
          week.endDate.year, week.endDate.month, week.endDate.day, 23, 59, 59);
      if (!today.isBefore(start) && !today.isAfter(end)) return week;
    }
    return weeks.first;
  }

  Future<WeeklyBucket?> _fetchWeek(String weekId) async {
    final row =
        await _client.from(_weekly).select().eq('id', weekId).maybeSingle();
    return row == null ? null : WeeklyBucket.fromJson(row);
  }

  Future<void> _applyWeeklyDelta(WeeklyBucket week, double delta) async {
    final newSpent = week.spentAmount + delta;
    await _client.from(_weekly).update({
      'spent_amount': newSpent,
      'remaining_amount': week.allocatedAmount - newSpent,
    }).eq('id', week.id);
  }

  Future<Bucket?> _applyBucketDelta(String bucketId, double delta) async {
    final row =
        await _client.from(_buckets).select().eq('id', bucketId).maybeSingle();
    if (row == null) return null;
    final bucket = Bucket.fromJson(row);
    final updated = await _client
        .from(_buckets)
        .update({
          'remaining_main_bucket': bucket.remainingMainBucket + delta,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', bucketId)
        .select()
        .single();
    return Bucket.fromJson(updated);
  }

  Future<void> _rebalanceActiveWeeks(Bucket bucket) async {
    final rows = await _client
        .from(_weekly)
        .select()
        .eq('bucket_id', bucket.id)
        .order('week_index');
    final weeks = rows.map(WeeklyBucket.fromJson).toList();
    final rebalanced = _allocator(WeeklyAllocationInput(
      remainingMainBucket: bucket.remainingMainBucket,
      weeks: weeks,
    ));
    for (final week in rebalanced.where((w) => w.isActive)) {
      await _client.from(_weekly).update({
        'allocated_amount': week.allocatedAmount,
        'remaining_amount': week.remainingAmount,
      }).eq('id', week.id);
    }
  }

  Future<void> _maybeThresholdNotification(
      String bucketId, String? weekId) async {
    if (weekId == null) return;
    final week = await _fetchWeek(weekId);
    if (week == null) return;
    if (week.progress >= 0.8) {
      await _insertNotification(
        bucketId: bucketId,
        type: 'budget_threshold',
        message:
            'Week ${week.weekIndex + 1} is at ${(week.progress * 100).round()}% of its budget',
      );
    }
  }

  Future<void> _insertNotification({
    required String bucketId,
    required String type,
    required String message,
  }) async {
    try {
      await _client.from(_notifications).insert({
        'bucket_id': bucketId,
        'type': type,
        'actor_uid': _uid,
        'message': message,
      });
    } catch (e) {
      AppLogger.instance.w('Failed to insert notification', e);
    }
  }
}
