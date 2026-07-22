import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../../domain/entities/bucket.dart';
import '../../domain/entities/bucket_member.dart';
import '../../domain/entities/weekly_bucket.dart';

class BucketLocalDataSource {
  BucketLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<Bucket>> watchMyBuckets() {
    final query = _db.select(_db.buckets)
      ..where((t) => t.deletedLocal.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);
    return query.watch().map((rows) => rows.map(_bucket).toList());
  }

  Stream<Bucket?> watchBucket(String id) {
    final query = _db.select(_db.buckets)
      ..where((t) => t.id.equals(id) & t.deletedLocal.equals(false));
    return query.watchSingleOrNull().map((r) => r == null ? null : _bucket(r));
  }

  Stream<List<WeeklyBucket>> watchWeeks(String bucketId) {
    final query = _db.select(_db.weeklyBucketRows)
      ..where((t) => t.bucketId.equals(bucketId) & t.deletedLocal.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.weekIndex)]);
    return query.watch().map((rows) => rows.map(_week).toList());
  }

  Future<Bucket?> getBucket(String id) async {
    final row = await (_db.select(
      _db.buckets,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _bucket(row);
  }

  Future<WeeklyBucket?> getWeek(String id) async {
    final row = await (_db.select(
      _db.weeklyBucketRows,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _week(row);
  }

  Future<void> upsertBucketLocal(Bucket b, {required String syncState}) async {
    await _db
        .into(_db.buckets)
        .insertOnConflictUpdate(_bucketCompanion(b, syncState));
  }

  Future<void> upsertWeekLocal(
    WeeklyBucket w, {
    required String syncState,
  }) async {
    await _db
        .into(_db.weeklyBucketRows)
        .insertOnConflictUpdate(_weekCompanion(w, syncState));
  }

  Stream<List<BucketMember>> watchMembers(String bucketId) {
    final query = _db.select(_db.bucketMemberRows)
      ..where((t) => t.bucketId.equals(bucketId));
    return query.watch().map((rows) => rows.map(_member).toList());
  }

  Future<void> reconcileMembers(
    String bucketId,
    List<BucketMember> server,
  ) async {
    final serverIds = server.map((m) => m.userId).toSet();
    for (final member in server) {
      await _db
          .into(_db.bucketMemberRows)
          .insertOnConflictUpdate(_memberCompanion(member));
    }
    final localRows = await (_db.select(
      _db.bucketMemberRows,
    )..where((t) => t.bucketId.equals(bucketId))).get();
    for (final row in localRows) {
      if (!serverIds.contains(row.userId)) {
        await (_db.delete(_db.bucketMemberRows)..where(
              (t) => t.bucketId.equals(bucketId) & t.userId.equals(row.userId),
            ))
            .go();
      }
    }
  }

  BucketMember _member(BucketMemberRow r) {
    return BucketMember(
      bucketId: r.bucketId,
      userId: r.userId,
      joinedAt: r.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      name: r.name,
      photoUrl: r.photoUrl,
    );
  }

  BucketMemberRowsCompanion _memberCompanion(BucketMember m) {
    return BucketMemberRowsCompanion.insert(
      bucketId: m.bucketId,
      userId: m.userId,
      joinedAt: Value(m.joinedAt),
      name: Value(m.name),
      photoUrl: Value(m.photoUrl),
    );
  }

  Future<void> markBucketDeleted(String id) async {
    await (_db.update(_db.buckets)..where((t) => t.id.equals(id))).write(
      const BucketsCompanion(
        deletedLocal: Value(true),
        syncState: Value('pending'),
      ),
    );
  }

  Future<void> reconcileBucketList(
    List<Bucket> server,
    Set<String> pendingIds,
  ) async {
    final serverIds = server.map((b) => b.id).toSet();
    final localRows = await _db.select(_db.buckets).get();
    for (final bucket in server) {
      if (pendingIds.contains(bucket.id)) continue;
      await _db
          .into(_db.buckets)
          .insertOnConflictUpdate(_bucketCompanion(bucket, 'synced'));
    }
    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(_db.buckets)..where((t) => t.id.equals(row.id))).go();
      await (_db.delete(
        _db.weeklyBucketRows,
      )..where((t) => t.bucketId.equals(row.id))).go();
    }
  }

  Future<void> reconcileBucket(Bucket server, Set<String> pendingIds) async {
    if (pendingIds.contains(server.id)) return;
    await _db
        .into(_db.buckets)
        .insertOnConflictUpdate(_bucketCompanion(server, 'synced'));
  }

  Future<void> reconcileWeeks(
    String bucketId,
    List<WeeklyBucket> server,
    Set<String> pendingIds,
  ) async {
    final serverIds = server.map((w) => w.id).toSet();
    final localRows = await (_db.select(
      _db.weeklyBucketRows,
    )..where((t) => t.bucketId.equals(bucketId))).get();
    for (final week in server) {
      if (pendingIds.contains(week.id)) continue;
      await _db
          .into(_db.weeklyBucketRows)
          .insertOnConflictUpdate(_weekCompanion(week, 'synced'));
    }
    for (final row in localRows) {
      if (serverIds.contains(row.id)) continue;
      if (pendingIds.contains(row.id)) continue;
      await (_db.delete(
        _db.weeklyBucketRows,
      )..where((t) => t.id.equals(row.id))).go();
    }
  }

  Bucket _bucket(BucketRow r) {
    return Bucket(
      id: r.id,
      name: r.name,
      ownerId: r.ownerId,
      joinCode: r.joinCode,
      monthlyBudget: r.monthlyBudget,
      monthStartDate: DateTime.parse(r.monthStartDate),
      remainingMainBucket: r.remainingMainBucket,
      createdAt: r.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      currency: r.currency,
    );
  }

  BucketsCompanion _bucketCompanion(Bucket b, String syncState) {
    return BucketsCompanion.insert(
      id: b.id,
      ownerId: b.ownerId,
      monthStartDate: b.monthStartDate.toIso8601String(),
      name: Value(b.name),
      joinCode: Value(b.joinCode),
      monthlyBudget: Value(b.monthlyBudget),
      remainingMainBucket: Value(b.remainingMainBucket),
      currency: Value(b.currency),
      createdAt: Value(b.createdAt),
      syncState: Value(syncState),
    );
  }

  WeeklyBucket _week(WeeklyBucketRow r) {
    return WeeklyBucket(
      id: r.id,
      bucketId: r.bucketId,
      weekIndex: r.weekIndex,
      startDate: DateTime.parse(r.startDate),
      endDate: DateTime.parse(r.endDate),
      effectiveStartDate: r.effectiveStartDate != null
          ? DateTime.parse(r.effectiveStartDate!)
          : DateTime.parse(r.startDate),
      kind: r.kind == 'historical'
          ? WeeklyBucketKind.historical
          : WeeklyBucketKind.active,
      allocatedAmount: r.allocatedAmount,
      spentAmount: r.spentAmount,
      remainingAmount: r.remainingAmount,
      status: r.status == 'closed'
          ? WeeklyBucketStatus.closed
          : WeeklyBucketStatus.active,
    );
  }

  WeeklyBucketRowsCompanion _weekCompanion(WeeklyBucket w, String syncState) {
    return WeeklyBucketRowsCompanion.insert(
      id: w.id,
      bucketId: w.bucketId,
      startDate: w.startDate.toIso8601String(),
      endDate: w.endDate.toIso8601String(),
      weekIndex: Value(w.weekIndex),
      effectiveStartDate: Value(w.effectiveStartDate.toIso8601String()),
      kind: Value(
        w.kind == WeeklyBucketKind.historical ? 'historical' : 'active',
      ),
      allocatedAmount: Value(w.allocatedAmount),
      spentAmount: Value(w.spentAmount),
      remainingAmount: Value(w.remainingAmount),
      status: Value(
        w.status == WeeklyBucketStatus.closed ? 'closed' : 'active',
      ),
      syncState: Value(syncState),
    );
  }
}
