import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/app_notification.dart';

class NotificationLocalDataSource {
  NotificationLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<AppNotification>> watchForBucket(String bucketId) {
    final query = _db.select(_db.notificationRows)
      ..where((t) => t.bucketId.equals(bucketId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> reconcile(String bucketId, List<AppNotification> server) async {
    final serverIds = server.map((n) => n.id).toSet();
    for (final n in server) {
      await _db
          .into(_db.notificationRows)
          .insertOnConflictUpdate(_companion(n));
    }
    final localRows = await (_db.select(
      _db.notificationRows,
    )..where((t) => t.bucketId.equals(bucketId))).get();
    for (final row in localRows) {
      if (!serverIds.contains(row.id)) {
        await (_db.delete(
          _db.notificationRows,
        )..where((t) => t.id.equals(row.id))).go();
      }
    }
  }

  Future<void> markAllReadLocal(String bucketId, String userId) async {
    final rows = await (_db.select(
      _db.notificationRows,
    )..where((t) => t.bucketId.equals(bucketId))).get();
    for (final row in rows) {
      final readBy = (jsonDecode(row.readBy) as List).cast<String>();
      if (!readBy.contains(userId)) {
        readBy.add(userId);
        await (_db.update(
          _db.notificationRows,
        )..where((t) => t.id.equals(row.id))).write(
          NotificationRowsCompanion(readBy: Value(jsonEncode(readBy))),
        );
      }
    }
  }

  NotificationRowsCompanion _companion(AppNotification n) {
    return NotificationRowsCompanion.insert(
      id: n.id,
      bucketId: n.bucketId,
      type: Value(n.type.name),
      message: Value(n.message),
      createdAt: Value(n.createdAt),
      actorUid: Value(n.actorUid),
      readBy: Value(jsonEncode(n.readBy)),
    );
  }

  AppNotification _toDomain(NotificationRow r) {
    return AppNotification(
      id: r.id,
      bucketId: r.bucketId,
      type: AppNotificationType.values.firstWhere(
        (t) => t.name == r.type,
        orElse: () => AppNotificationType.unknown,
      ),
      message: r.message,
      createdAt: r.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      actorUid: r.actorUid,
      readBy: (jsonDecode(r.readBy) as List).cast<String>(),
    );
  }
}
