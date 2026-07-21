import '../entities/big_expense.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses(String bucketId);

  Future<Expense> addExpense({
    required String bucketId,
    required double amount,
    required String? categoryId,
    String? note,
    String? receiptImageUrl,
  });

  Future<Expense> editExpense({
    required String expenseId,
    double? amount,
    String? categoryId,
    String? note,
    String? receiptImageUrl,
  });

  Future<void> deleteExpense(String expenseId);

  Future<BigExpense> addBigExpense({
    required String bucketId,
    required String title,
    required double amount,
  });
}
