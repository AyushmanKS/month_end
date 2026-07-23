import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/join_request.dart';

class JoinRequestLocalDataSource {
  JoinRequestLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<JoinRequest>> watchIncomingPending(String bucketId) {
    final query = _db.select(_db.joinRequestRows)
      ..where((t) => t.bucketId.equals(bucketId))
      ..where((t) => t.status.equals('pending'))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<JoinRequest>> watchOutgoing(String uid) {
    final query = _db.select(_db.joinRequestRows)
      ..where((t) => t.requesterUid.equals(uid))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> upsertLocal(JoinRequest r, {required String syncState}) async {
    await _db
        .into(_db.joinRequestRows)
        .insertOnConflictUpdate(_companion(r, syncState));
  }

  Future<void> setStatusLocal(String id, JoinRequestStatus status) async {
    await (_db.update(
      _db.joinRequestRows,
    )..where((t) => t.id.equals(id))).write(
      JoinRequestRowsCompanion(
        status: Value(JoinRequest.statusToWire(status)),
        syncState: const Value('pending'),
      ),
    );
  }

  Future<void> reconcileIncoming(
    String bucketId,
    List<JoinRequest> server,
    Set<String> pendingIds,
  ) async {
    final serverIds = server.map((r) => r.id).toSet();
    for (final r in server) {
      if (pendingIds.contains(r.id)) continue;
      await _db
          .into(_db.joinRequestRows)
          .insertOnConflictUpdate(_companion(r, 'synced'));
    }
    final localRows = await (_db.select(
      _db.joinRequestRows,
    )..where((t) => t.bucketId.equals(bucketId))).get();
    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(
        _db.joinRequestRows,
      )..where((t) => t.id.equals(row.id))).go();
    }
  }

  Future<void> reconcileOutgoing(
    String uid,
    List<JoinRequest> server,
    Set<String> pendingIds,
  ) async {
    final serverIds = server.map((r) => r.id).toSet();
    for (final r in server) {
      if (pendingIds.contains(r.id)) continue;
      await _db
          .into(_db.joinRequestRows)
          .insertOnConflictUpdate(_companion(r, 'synced'));
    }
    final localRows = await (_db.select(
      _db.joinRequestRows,
    )..where((t) => t.requesterUid.equals(uid))).get();
    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(
        _db.joinRequestRows,
      )..where((t) => t.id.equals(row.id))).go();
    }
  }

  JoinRequestRowsCompanion _companion(JoinRequest r, String syncState) {
    return JoinRequestRowsCompanion.insert(
      id: r.id,
      bucketId: r.bucketId,
      bucketName: Value(r.bucketName),
      requesterUid: r.requesterUid,
      requesterName: Value(r.requesterName),
      requesterPhoto: Value(r.requesterPhoto),
      status: Value(JoinRequest.statusToWire(r.status)),
      createdAt: Value(r.createdAt),
      decidedAt: Value(r.decidedAt),
      syncState: Value(syncState),
    );
  }

  JoinRequest _toDomain(JoinRequestRow row) {
    return JoinRequest(
      id: row.id,
      bucketId: row.bucketId,
      bucketName: row.bucketName,
      requesterUid: row.requesterUid,
      status: JoinRequest.statusFromWire(row.status),
      requesterName: row.requesterName,
      requesterPhoto: row.requesterPhoto,
      createdAt: row.createdAt,
      decidedAt: row.decidedAt,
    );
  }
}
