import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/bucket_activity.dart';

class BucketActivityLocalDataSource {
  BucketActivityLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<BucketActivity>> watchActivity(String bucketId) {
    final query = _db.select(_db.bucketActivityRows)
      ..where((t) => t.bucketId.equals(bucketId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> upsertMany(List<BucketActivity> items) async {
    await _db.batch((b) {
      for (final a in items) {
        b.insert(
          _db.bucketActivityRows,
          _companion(a),
          onConflict: DoUpdate((_) => _companion(a)),
        );
      }
    });
  }

  BucketActivityRowsCompanion _companion(BucketActivity a) {
    return BucketActivityRowsCompanion.insert(
      id: a.id,
      bucketId: a.bucketId,
      actorUid: Value(a.actorUid),
      type: Value(a.type),
      category: Value(a.category),
      summary: Value(a.summary),
      metadata: Value(jsonEncode(a.metadata)),
      correlationId: Value(a.correlationId),
      createdAt: Value(a.createdAt),
    );
  }

  BucketActivity _toDomain(BucketActivityRow row) {
    return BucketActivity(
      id: row.id,
      bucketId: row.bucketId,
      type: row.type,
      category: row.category,
      summary: row.summary,
      actorUid: row.actorUid,
      metadata: _decode(row.metadata),
      correlationId: row.correlationId,
      createdAt: row.createdAt,
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
