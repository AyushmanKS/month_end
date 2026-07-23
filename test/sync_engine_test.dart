import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:month_end/core/db/app_database.dart';
import 'package:month_end/core/sync/outbox_command.dart';
import 'package:month_end/core/sync/outbox_repository.dart';
import 'package:month_end/core/sync/sync_dispatcher.dart';
import 'package:month_end/core/sync/sync_engine.dart';
import 'package:month_end/core/sync/sync_status.dart';

class _FakeDispatcher implements SyncDispatcher {
  _FakeDispatcher({this.failFirst = 0, this.alwaysFail = false});

  int failFirst;
  final bool alwaysFail;
  final List<String> dispatched = [];
  int calls = 0;

  @override
  Future<void> dispatch(OutboxData row) async {
    calls++;
    if (alwaysFail) throw Exception('permanent');
    if (failFirst > 0) {
      failFirst--;
      throw Exception('transient');
    }
    dispatched.add(row.entityId);
  }
}

void main() {
  late AppDatabase db;
  late OutboxRepository outbox;
  late SyncStatusNotifier status;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    outbox = OutboxRepository(db);
    status = SyncStatusNotifier();
  });

  tearDown(() => db.close());

  OutboxCommand cmd(String id, {int priority = 0}) => OutboxCommand(
    id: id,
    op: OutboxOp.expenseCreate,
    entity: 'expense',
    entityId: id,
    payload: {'v': 1},
    priority: priority,
  );

  test('drains all pending commands and clears the queue', () async {
    final dispatcher = _FakeDispatcher();
    final engine = SyncEngine(outbox, status, dispatcher, () => true);
    await outbox.enqueue(cmd('a'));
    await outbox.enqueue(cmd('b'));

    await engine.sync();

    expect(dispatcher.dispatched.toSet(), {'a', 'b'});
    expect(await outbox.pendingCount(), 0);
  });

  test('does nothing when unauthenticated', () async {
    final dispatcher = _FakeDispatcher();
    final engine = SyncEngine(outbox, status, dispatcher, () => false);
    await outbox.enqueue(cmd('a'));

    await engine.sync();

    expect(dispatcher.calls, 0);
    expect(await outbox.pendingCount(), 1);
  });

  test('defers when the backend is unreachable', () async {
    final dispatcher = _FakeDispatcher();
    final engine = SyncEngine(
      outbox,
      status,
      dispatcher,
      () => true,
      () async => false,
    );
    await outbox.enqueue(cmd('a'));

    await engine.sync();

    expect(dispatcher.calls, 0);
    expect(await outbox.pendingCount(), 1);
  });

  test('dispatches higher priority first', () async {
    final dispatcher = _FakeDispatcher();
    final engine = SyncEngine(outbox, status, dispatcher, () => true);
    await outbox.enqueue(cmd('low', priority: 0));
    await outbox.enqueue(cmd('high', priority: 10));

    await engine.sync();

    expect(dispatcher.dispatched.first, 'high');
  });

  test('reschedules then recovers after transient failures', () async {
    final dispatcher = _FakeDispatcher(failFirst: 2);
    final engine = SyncEngine(outbox, status, dispatcher, () => true);
    await outbox.enqueue(cmd('a'));

    await engine.sync();
    expect(await outbox.pendingCount(), 1);

    await engine.sync();
    await engine.sync();
    expect(await outbox.pendingCount(), 0);
  });

  test('marks a command failed after the max attempts', () async {
    final dispatcher = _FakeDispatcher(alwaysFail: true);
    final engine = SyncEngine(outbox, status, dispatcher, () => true);
    await outbox.enqueue(cmd('a'));

    for (var i = 0; i < 8; i++) {
      await engine.sync();
    }

    final row = (await outbox.pending()).firstWhere((r) => r.id == 'a');
    expect(row.syncState, 'failed');
  });

  test('stress: 500 offline commands drain exactly once', () async {
    final dispatcher = _FakeDispatcher();
    final engine = SyncEngine(outbox, status, dispatcher, () => true);
    for (var i = 0; i < 500; i++) {
      await outbox.enqueue(cmd('e$i'));
    }
    expect(await outbox.pendingCount(), 500);

    await engine.sync();

    expect(await outbox.pendingCount(), 0);
    expect(dispatcher.dispatched.length, 500);
    expect(dispatcher.dispatched.toSet().length, 500);
  });

  test('recovers interrupted syncing rows after a restart', () async {
    for (var i = 0; i < 20; i++) {
      await outbox.enqueue(cmd('e$i'));
    }
    await outbox.markSyncing('e0');
    await outbox.markSyncing('e1');

    final dispatcher = _FakeDispatcher();
    final freshEngine = SyncEngine(outbox, status, dispatcher, () => true);
    await freshEngine.sync();

    expect(await outbox.pendingCount(), 0);
    expect(dispatcher.dispatched.length, 20);
    expect(dispatcher.dispatched.toSet().length, 20);
  });
}
