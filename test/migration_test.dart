import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:month_end/core/db/app_database.dart';

import 'generated_migrations/schema.dart';

void main() {
  test('schemaVersion has a matching generated snapshot', () {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    expect(
      db.schemaVersion,
      GeneratedHelper.versions.last,
      reason:
          'schemaVersion was bumped without regenerating drift snapshots. Run: '
          'dart run drift_dev schema dump lib/core/db/app_database.dart drift_schemas/ '
          '&& dart run drift_dev schema generate drift_schemas/ test/generated_migrations/',
    );
  });

  test('migrating from v1 to latest matches the generated snapshot', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final connection = await verifier.startAt(1);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 3);
  });

  test('foreign keys are enabled on open', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.data.values.first, 1);
  });
}
