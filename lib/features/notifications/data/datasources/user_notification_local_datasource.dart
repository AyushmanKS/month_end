import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/user_notification.dart';

class UserNotificationLocalDataSource {
  UserNotificationLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<UserNotification>> watchInbox(String uid) {
    final query = _db.select(_db.userNotificationRows)
      ..where((t) => t.recipientUid.equals(uid))
      ..where((t) => t.archivedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> reconcile(
    String uid,
    List<UserNotification> server,
    Set<String> pendingIds,
  ) async {
    final serverIds = server.map((n) => n.id).toSet();
    for (final n in server) {
      if (pendingIds.contains(n.id)) continue;
      await _db
          .into(_db.userNotificationRows)
          .insertOnConflictUpdate(_companion(n, 'synced'));
    }
    final localRows = await (_db.select(
      _db.userNotificationRows,
    )..where((t) => t.recipientUid.equals(uid))).get();
    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(
        _db.userNotificationRows,
      )..where((t) => t.id.equals(row.id))).go();
    }
  }

  Future<void> markReadLocal(String id) async {
    await (_db.update(
      _db.userNotificationRows,
    )..where((t) => t.id.equals(id) & t.readAt.isNull())).write(
      UserNotificationRowsCompanion(
        readAt: Value(DateTime.now()),
        syncState: const Value('pending'),
      ),
    );
  }

  Future<void> markAllReadLocal(String uid) async {
    await (_db.update(
      _db.userNotificationRows,
    )..where((t) => t.recipientUid.equals(uid) & t.readAt.isNull())).write(
      UserNotificationRowsCompanion(
        readAt: Value(DateTime.now()),
        syncState: const Value('pending'),
      ),
    );
  }

  Future<void> archiveLocal(String id) async {
    final now = DateTime.now();
    await (_db.update(
      _db.userNotificationRows,
    )..where((t) => t.id.equals(id))).write(
      UserNotificationRowsCompanion(
        archivedAt: Value(now),
        readAt: Value(now),
        syncState: const Value('pending'),
      ),
    );
  }

  UserNotificationRowsCompanion _companion(UserNotification n, String state) {
    return UserNotificationRowsCompanion.insert(
      id: n.id,
      recipientUid: n.recipientUid,
      eventId: Value(n.eventId),
      type: Value(n.type),
      category: Value(UserNotification.categoryWire(n.category)),
      bucketId: Value(n.bucketId),
      bucketName: Value(n.bucketName),
      actorUid: Value(n.actorUid),
      title: Value(n.title),
      body: Value(n.body),
      metadata: Value(jsonEncode(n.metadata)),
      correlationId: Value(n.correlationId),
      createdAt: Value(n.createdAt),
      readAt: Value(n.readAt),
      archivedAt: Value(n.archivedAt),
      syncState: Value(state),
    );
  }

  UserNotification _toDomain(UserNotificationRow row) {
    return UserNotification(
      id: row.id,
      recipientUid: row.recipientUid,
      eventId: row.eventId,
      type: row.type,
      category: UserNotification.categoryFrom(row.category),
      title: row.title,
      body: row.body,
      bucketId: row.bucketId,
      bucketName: row.bucketName,
      actorUid: row.actorUid,
      metadata: _decode(row.metadata),
      correlationId: row.correlationId,
      createdAt: row.createdAt,
      readAt: row.readAt,
      archivedAt: row.archivedAt,
    );
  }

  Map<String, dynamic> _decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }
}
