import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/big_expense.dart';
import '../../domain/entities/expense.dart';

class ExpenseRemoteDataSource {
  ExpenseRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _expenses = 'expenses';

  Stream<List<Expense>> watchExpenses(String bucketId) {
    return _client
        .from(_expenses)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('created_at')
        .map((rows) => rows.map(Expense.fromJson).toList());
  }

  Future<Expense> addExpense({
    required String bucketId,
    required double amount,
    required String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) async {
    try {
      final now = DateTime.now();
      final localDate =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
      final data = await _client.rpc(
        'add_expense',
        params: {
          'p_bucket_id': bucketId,
          'p_amount': amount,
          'p_category_id': categoryId,
          'p_note': note,
          'p_receipt': receiptImageUrl,
          'p_occurred_at': now.toUtc().toIso8601String(),
          'p_local_date': localDate,
        },
      );
      AppLogger.instance.i('Expense added to bucket $bucketId');
      return Expense.fromJson(Map<String, dynamic>.from(data as Map));
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
      final data = await _client.rpc(
        'edit_expense',
        params: {
          'p_expense_id': expenseId,
          'p_amount': amount,
          'p_category_id': categoryId,
          'p_note': note,
          'p_receipt': receiptImageUrl,
        },
      );
      return Expense.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _client.rpc('delete_expense', params: {'p_expense_id': expenseId});
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
      final data = await _client.rpc(
        'add_big_expense',
        params: {'p_bucket_id': bucketId, 'p_title': title, 'p_amount': amount},
      );
      AppLogger.instance.i('Big expense added; weeks rebalanced');
      return BigExpense.fromJson(Map<String, dynamic>.from(data as Map));
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }
}
