import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/expense_category.dart';

class CategoryLocalDataSource {
  CategoryLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<ExpenseCategory>> watchCategories() {
    final query = _db.select(_db.categories)
      ..where((t) => t.deletedLocal.equals(false))
      ..orderBy([
        (t) => OrderingTerm(expression: t.isPreset, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.name),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> upsertLocal(
    ExpenseCategory c, {
    required String syncState,
  }) async {
    await _db
        .into(_db.categories)
        .insertOnConflictUpdate(_companion(c, syncState));
  }

  Future<void> deleteLocal(String id) async {
    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();
  }

  Future<void> reconcile(
    List<ExpenseCategory> server,
    Set<String> pendingIds,
  ) async {
    final serverIds = server.map((c) => c.id).toSet();
    for (final category in server) {
      if (pendingIds.contains(category.id)) continue;
      await _db
          .into(_db.categories)
          .insertOnConflictUpdate(_companion(category, 'synced'));
    }
    final localRows = await _db.select(_db.categories).get();
    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(
        _db.categories,
      )..where((t) => t.id.equals(row.id))).go();
    }
  }

  CategoriesCompanion _companion(ExpenseCategory c, String syncState) {
    return CategoriesCompanion.insert(
      id: c.id,
      name: Value(c.name),
      iconKey: Value(c.iconKey),
      isPreset: Value(c.isPreset),
      syncState: Value(syncState),
    );
  }

  ExpenseCategory _toDomain(CategoryRow r) {
    return ExpenseCategory(
      id: r.id,
      name: r.name,
      iconKey: r.iconKey,
      isPreset: r.isPreset,
    );
  }
}
