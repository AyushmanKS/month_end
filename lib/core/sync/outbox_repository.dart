import 'package:drift/drift.dart';
import '../db/app_database.dart';
import 'outbox_command.dart';

class OutboxRepository {
  OutboxRepository(this._db);

  final AppDatabase _db;

  Future<void> enqueue(OutboxCommand command, {String? actor}) async {
    await _db
        .into(_db.outbox)
        .insertOnConflictUpdate(
          OutboxCompanion.insert(
            id: command.id,
            entity: command.entity,
            entityId: command.entityId,
            op: command.op.wire,
            payload: Value(command.encodePayload()),
            baseVersion: Value(command.baseVersion),
            actor: Value(actor),
            createdAt: DateTime.now(),
            priority: Value(command.priority),
          ),
        );
  }

  Future<List<OutboxData>> pending() {
    return (_db.select(_db.outbox)
          ..where((t) => t.syncState.isNotValue('synced'))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.createdAt),
          ]))
        .get();
  }

  Future<int> pendingCount() async {
    final rows = await (_db.select(
      _db.outbox,
    )..where((t) => t.syncState.isNotValue('synced'))).get();
    return rows.length;
  }

  Future<Set<String>> pendingEntityIds(String entity) async {
    final rows =
        await (_db.select(_db.outbox)..where(
              (t) => t.entity.equals(entity) & t.syncState.isNotValue('synced'),
            ))
            .get();
    return rows.map((r) => r.entityId).toSet();
  }

  Future<void> markSyncing(String id) => _setState(id, 'syncing');

  Future<void> markSynced(String id) async {
    await (_db.delete(_db.outbox)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markFailed(String id, String error) async {
    await (_db.update(_db.outbox)..where((t) => t.id.equals(id))).write(
      OutboxCompanion(
        syncState: const Value('failed'),
        lastError: Value(error),
        attemptCount: Value.absent(),
      ),
    );
  }

  Future<void> reschedule(String id, {required String error}) async {
    final row = await (_db.select(
      _db.outbox,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    final attempts = (row?.attemptCount ?? 0) + 1;
    await (_db.update(_db.outbox)..where((t) => t.id.equals(id))).write(
      OutboxCompanion(
        syncState: const Value('pending'),
        attemptCount: Value(attempts),
        lastError: Value(error),
      ),
    );
  }

  Future<void> resetSyncingToPending() async {
    await (_db.update(_db.outbox)..where((t) => t.syncState.equals('syncing')))
        .write(const OutboxCompanion(syncState: Value('pending')));
  }

  Future<void> _setState(String id, String state) async {
    await (_db.update(_db.outbox)..where((t) => t.id.equals(id))).write(
      OutboxCompanion(syncState: Value(state)),
    );
  }
}
