import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/image_upload_service.dart';
import '../../../../core/sync/outbox_command.dart';
import '../../../../core/sync/outbox_repository.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../data/datasources/expense_local_datasource.dart';
import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

const _uuid = Uuid();

final expenseRemoteDataSourceProvider = Provider<ExpenseRemoteDataSource>((
  ref,
) {
  return ExpenseRemoteDataSource(ref.watch(supabaseClientProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseRemoteDataSourceProvider));
});

final expenseLocalDataSourceProvider = Provider<ExpenseLocalDataSource>((ref) {
  return ExpenseLocalDataSource(ref.watch(appDatabaseProvider));
});

final expenseHydratorProvider = Provider<void>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return;
  final local = ref.read(expenseLocalDataSourceProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  final sub = ref
      .read(expenseRepositoryProvider)
      .watchExpenses(bucketId)
      .listen((server) async {
        final pendingIds = await outbox.pendingEntityIds('expense');
        await local.reconcile(
          bucketId: bucketId,
          server: server,
          pendingIds: pendingIds,
        );
      }, onError: (_) {});
  ref.onDispose(sub.cancel);
});

final expensesProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return Stream.value(const []);
  ref.watch(expenseHydratorProvider);
  return ref.watch(expenseLocalDataSourceProvider).watchExpenses(bucketId);
});

class ExpenseController extends StateNotifier<AsyncValue<void>> {
  ExpenseController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  ExpenseLocalDataSource get _local =>
      _ref.read(expenseLocalDataSourceProvider);
  OutboxRepository get _outbox => _ref.read(outboxRepositoryProvider);

  Future<String?> uploadReceipt(String filePath) async {
    return _ref.read(imageUploadServiceProvider).uploadReceipt(filePath);
  }

  void _kickSync() => unawaited(_ref.read(syncEngineProvider).sync());

  String _localDate(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';

  Future<bool> addExpense({
    required String bucketId,
    required double amount,
    required String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      final uid = _ref.read(currentUserIdProvider) ?? '';
      final expense = Expense(
        id: id,
        bucketId: bucketId,
        weekId: null,
        addedByUid: uid,
        amount: amount,
        categoryId: categoryId,
        note: note,
        receiptImageUrl: receiptImageUrl,
        createdAt: now,
      );
      await _local.upsertLocal(expense, syncState: 'pending');
      await _outbox.enqueue(
        OutboxCommand(
          id: id,
          op: OutboxOp.expenseCreate,
          entity: 'expense',
          entityId: id,
          priority: 10,
          payload: {
            'bucketId': bucketId,
            'amount': amount,
            'categoryId': categoryId,
            'note': note,
            'receipt': receiptImageUrl,
            'occurredAt': now.toUtc().toIso8601String(),
            'localDate': _localDate(now),
          },
        ),
        actor: uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> editExpense({
    required String expenseId,
    double? amount,
    String? categoryId,
    String? note,
    String? receiptImageUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      final existing = await _local.getById(expenseId);
      if (existing == null) throw StateError('expense not found');
      final uid = _ref.read(currentUserIdProvider) ?? '';
      final updated = existing.copyWith(
        amount: amount,
        categoryId: categoryId,
        note: note,
        receiptImageUrl: receiptImageUrl,
        editedByUid: uid,
      );
      await _local.upsertLocal(updated, syncState: 'pending');
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.expenseEdit,
          entity: 'expense',
          entityId: expenseId,
          priority: 10,
          payload: {
            'amount': amount,
            'categoryId': categoryId,
            'note': note,
            'receipt': receiptImageUrl,
          },
        ),
        actor: uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    state = const AsyncValue.loading();
    try {
      final uid = _ref.read(currentUserIdProvider) ?? '';
      await _local.markDeleted(expenseId);
      await _outbox.enqueue(
        OutboxCommand(
          id: _uuid.v4(),
          op: OutboxOp.expenseDelete,
          entity: 'expense',
          entityId: expenseId,
          priority: 10,
          payload: const {},
        ),
        actor: uid,
      );
      _kickSync();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> addBigExpense({
    required String bucketId,
    required String title,
    required double amount,
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = _uuid.v4();
      final uid = _ref.read(currentUserIdProvider) ?? '';
      await _outbox.enqueue(
        OutboxCommand(
          id: id,
          op: OutboxOp.bigExpenseCreate,
          entity: 'big_expense',
          entityId: id,
          priority: 10,
          payload: {'bucketId': bucketId, 'title': title, 'amount': amount},
        ),
        actor: uid,
      );
      _kickSync();
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
