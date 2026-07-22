import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/expense.dart';

class ExpenseLocalDataSource {
  ExpenseLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<Expense>> watchExpenses(String bucketId) {
    final query = _db.select(_db.expenses)
      ..where((t) => t.bucketId.equals(bucketId) & t.deletedLocal.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<Expense?> getById(String id) async {
    final row = await (_db.select(
      _db.expenses,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> upsertLocal(Expense expense, {required String syncState}) async {
    await _db
        .into(_db.expenses)
        .insertOnConflictUpdate(_toCompanion(expense, syncState: syncState));
  }

  Future<void> markDeleted(String id) async {
    await (_db.update(_db.expenses)..where((t) => t.id.equals(id))).write(
      const ExpensesCompanion(
        deletedLocal: Value(true),
        syncState: Value('pending'),
      ),
    );
  }

  Future<void> reconcile({
    required String bucketId,
    required List<Expense> server,
    required Set<String> pendingIds,
  }) async {
    final serverIds = server.map((e) => e.id).toSet();
    final localRows = await (_db.select(
      _db.expenses,
    )..where((t) => t.bucketId.equals(bucketId))).get();

    for (final expense in server) {
      if (pendingIds.contains(expense.id)) continue;
      await _db
          .into(_db.expenses)
          .insertOnConflictUpdate(_toCompanion(expense, syncState: 'synced'));
    }

    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(_db.expenses)..where((t) => t.id.equals(row.id))).go();
    }
  }

  ExpensesCompanion _toCompanion(Expense e, {required String syncState}) {
    return ExpensesCompanion.insert(
      id: e.id,
      bucketId: e.bucketId,
      weekId: Value(e.weekId),
      addedByUid: Value(e.addedByUid),
      amount: Value(e.amount),
      categoryId: Value(e.categoryId),
      note: Value(e.note),
      receiptImageUrl: Value(e.receiptImageUrl),
      createdAt: e.createdAt,
      editedByUid: Value(e.editedByUid),
      syncState: Value(syncState),
    );
  }

  Expense _toDomain(ExpenseRow r) {
    return Expense(
      id: r.id,
      bucketId: r.bucketId,
      weekId: r.weekId,
      addedByUid: r.addedByUid,
      amount: r.amount,
      categoryId: r.categoryId,
      note: r.note,
      receiptImageUrl: r.receiptImageUrl,
      createdAt: r.createdAt,
      editedByUid: r.editedByUid,
    );
  }
}
