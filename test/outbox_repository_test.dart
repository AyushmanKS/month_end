import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:month_end/core/db/app_database.dart';
import 'package:month_end/core/sync/outbox_command.dart';
import 'package:month_end/core/sync/outbox_repository.dart';

void main() {
  late AppDatabase db;
  late OutboxRepository outbox;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    outbox = OutboxRepository(db);
  });

  tearDown(() => db.close());

  OutboxCommand cmd(
    String id, {
    int priority = 0,
    OutboxOp op = OutboxOp.expenseCreate,
    String entity = 'expense',
  }) => OutboxCommand(
    id: id,
    op: op,
    entity: entity,
    entityId: id,
    payload: {'v': 1},
    priority: priority,
  );

  test('enqueue stores the command as pending with zero attempts', () async {
    await outbox.enqueue(cmd('a'));
    final pending = await outbox.pending();
    expect(pending, hasLength(1));
    expect(pending.single.id, 'a');
    expect(pending.single.syncState, 'pending');
    expect(pending.single.attemptCount, 0);
  });

  test('pending orders by priority descending', () async {
    await outbox.enqueue(cmd('low', priority: 0));
    await outbox.enqueue(cmd('high', priority: 5));
    final ids = (await outbox.pending()).map((r) => r.id).toList();
    expect(ids.first, 'high');
  });

  test('pendingCount counts only unsynced rows', () async {
    await outbox.enqueue(cmd('a'));
    await outbox.enqueue(cmd('b'));
    expect(await outbox.pendingCount(), 2);
    await outbox.markSynced('a');
    expect(await outbox.pendingCount(), 1);
  });

  test('markSynced removes the row', () async {
    await outbox.enqueue(cmd('a'));
    await outbox.markSynced('a');
    expect(await outbox.pending(), isEmpty);
  });

  test('reschedule increments attemptCount and records the error', () async {
    await outbox.enqueue(cmd('a'));
    await outbox.reschedule('a', error: 'net');
    final first = (await outbox.pending()).single;
    expect(first.attemptCount, 1);
    expect(first.syncState, 'pending');
    expect(first.lastError, 'net');

    await outbox.reschedule('a', error: 'net-again');
    expect((await outbox.pending()).single.attemptCount, 2);
  });

  test('markFailed sets the failed state', () async {
    await outbox.enqueue(cmd('a'));
    await outbox.markFailed('a', 'boom');
    final row = (await outbox.pending()).single;
    expect(row.syncState, 'failed');
    expect(row.lastError, 'boom');
  });

  test('resetSyncingToPending flips syncing rows back to pending', () async {
    await outbox.enqueue(cmd('a'));
    await outbox.markSyncing('a');
    expect((await outbox.pending()).single.syncState, 'syncing');
    await outbox.resetSyncingToPending();
    expect((await outbox.pending()).single.syncState, 'pending');
  });

  test('pendingEntityIds filters by entity', () async {
    await outbox.enqueue(cmd('a', entity: 'expense'));
    await outbox.enqueue(cmd('b', entity: 'bucket', op: OutboxOp.bucketCreate));
    expect(await outbox.pendingEntityIds('expense'), {'a'});
    expect(await outbox.pendingEntityIds('bucket'), {'b'});
  });
}
