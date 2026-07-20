import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/image_upload_service.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

final expenseRemoteDataSourceProvider =
    Provider<ExpenseRemoteDataSource>((ref) {
  return ExpenseRemoteDataSource(ref.watch(supabaseClientProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseRemoteDataSourceProvider));
});

final expensesProvider = StreamProvider<List<Expense>>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return Stream.value(const []);
  return ref.watch(expenseRepositoryProvider).watchExpenses(bucketId);
});

class ExpenseController extends StateNotifier<AsyncValue<void>> {
  ExpenseController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  ExpenseRepository get _repo => _ref.read(expenseRepositoryProvider);

  Future<String?> uploadReceipt(String filePath) async {
    return _ref.read(imageUploadServiceProvider).uploadReceipt(filePath);
  }

  Future<bool> addExpense({
    required String bucketId,
    required double amount,
    required String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) =>
      _run(() => _repo.addExpense(
            bucketId: bucketId,
            amount: amount,
            categoryId: categoryId,
            note: note,
            receiptImageUrl: receiptImageUrl,
          ));

  Future<bool> editExpense({
    required String expenseId,
    double? amount,
    String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) =>
      _run(() => _repo.editExpense(
            expenseId: expenseId,
            amount: amount,
            categoryId: categoryId,
            note: note,
            receiptImageUrl: receiptImageUrl,
          ));

  Future<bool> deleteExpense(String expenseId) =>
      _run(() => _repo.deleteExpense(expenseId));

  Future<bool> addBigExpense({
    required String bucketId,
    required String title,
    required double amount,
  }) =>
      _run(() => _repo.addBigExpense(
            bucketId: bucketId,
            title: title,
            amount: amount,
          ));

  Future<bool> _run(Future<Object?> Function() action) async {
    state = const AsyncValue.loading();
    try {
      await action();
      _ref.invalidate(myBucketsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }
}

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, AsyncValue<void>>((ref) {
  return ExpenseController(ref);
});
