import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

mixin SyncColumns on Table {
  TextColumn get syncState => text().withDefault(const Constant('synced'))();
  BoolColumn get deletedLocal => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAtLocal => dateTime().nullable()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
}

@DataClassName('BucketRow')
class Buckets extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get ownerId => text()();
  TextColumn get joinCode => text().withDefault(const Constant(''))();
  RealColumn get monthlyBudget => real().withDefault(const Constant(0))();
  TextColumn get monthStartDate => text()();
  RealColumn get remainingMainBucket => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WeeklyBucketRows extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get bucketId => text()();
  IntColumn get weekIndex => integer().withDefault(const Constant(0))();
  TextColumn get startDate => text()();
  TextColumn get endDate => text()();
  TextColumn get effectiveStartDate => text().nullable()();
  TextColumn get kind => text().withDefault(const Constant('active'))();
  RealColumn get allocatedAmount => real().withDefault(const Constant(0))();
  RealColumn get spentAmount => real().withDefault(const Constant(0))();
  RealColumn get remainingAmount => real().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseRow')
class Expenses extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get bucketId => text()();
  TextColumn get weekId => text().nullable()();
  TextColumn get addedByUid => text().withDefault(const Constant(''))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get categoryId => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get receiptImageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get editedByUid => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BigExpenseRow')
class BigExpenses extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get bucketId => text()();
  TextColumn get addedByUid => text().withDefault(const Constant(''))();
  TextColumn get title => text().withDefault(const Constant(''))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BucketMemberRows extends Table with SyncColumns {
  TextColumn get bucketId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get joinedAt => dateTime().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get photoUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {bucketId, userId};
}

@DataClassName('CategoryRow')
class Categories extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().withDefault(const Constant('other'))();
  BoolColumn get isPreset => boolean().withDefault(const Constant(true))();
  TextColumn get ownerUid => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotificationRows extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get bucketId => text()();
  TextColumn get type => text().withDefault(const Constant('unknown'))();
  TextColumn get message => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get actorUid => text().nullable()();
  TextColumn get readBy => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Outbox extends Table {
  TextColumn get id => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get op => text()();
  TextColumn get payload => text().withDefault(const Constant('{}'))();
  IntColumn get baseVersion => integer().nullable()();
  TextColumn get actor => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncState => text().withDefault(const Constant('pending'))();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Buckets,
    WeeklyBucketRows,
    Expenses,
    BigExpenses,
    BucketMemberRows,
    Categories,
    NotificationRows,
    Outbox,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {},
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> clearAll() async {
    await batch((b) {
      b.deleteWhere(buckets, (_) => const Constant(true));
      b.deleteWhere(weeklyBucketRows, (_) => const Constant(true));
      b.deleteWhere(expenses, (_) => const Constant(true));
      b.deleteWhere(bigExpenses, (_) => const Constant(true));
      b.deleteWhere(bucketMemberRows, (_) => const Constant(true));
      b.deleteWhere(categories, (_) => const Constant(true));
      b.deleteWhere(notificationRows, (_) => const Constant(true));
      b.deleteWhere(outbox, (_) => const Constant(true));
    });
  }

  static QueryExecutor _open() {
    return driftDatabase(
      name: 'month_end',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
