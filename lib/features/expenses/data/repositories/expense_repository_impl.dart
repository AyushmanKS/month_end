import '../../domain/entities/big_expense.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._remote);

  final ExpenseRemoteDataSource _remote;

  @override
  Stream<List<Expense>> watchExpenses(String bucketId) =>
      _remote.watchExpenses(bucketId);

  @override
  Future<List<Expense>> fetchExpenses(String bucketId) =>
      _remote.fetchExpenses(bucketId);

  @override
  Future<Expense> addExpense({
    required String bucketId,
    required double amount,
    required String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) =>
      _remote.addExpense(
        bucketId: bucketId,
        amount: amount,
        categoryId: categoryId,
        note: note,
        receiptImageUrl: receiptImageUrl,
      );

  @override
  Future<Expense> editExpense({
    required String expenseId,
    double? amount,
    String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) =>
      _remote.editExpense(
        expenseId: expenseId,
        amount: amount,
        categoryId: categoryId,
        note: note,
        receiptImageUrl: receiptImageUrl,
      );

  @override
  Future<void> deleteExpense(String expenseId) =>
      _remote.deleteExpense(expenseId);

  @override
  Future<BigExpense> addBigExpense({
    required String bucketId,
    required String title,
    required double amount,
  }) =>
      _remote.addBigExpense(bucketId: bucketId, title: title, amount: amount);
}
