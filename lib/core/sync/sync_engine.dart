import 'dart:async';
import '../logging/app_logger.dart';
import 'outbox_repository.dart';
import 'sync_dispatcher.dart';
import 'sync_status.dart';

class SyncEngine {
  SyncEngine(
    this._outbox,
    this._status,
    this._dispatcher,
    this._isAuthenticated, [
    this._isBackendReachable,
  ]);

  final OutboxRepository _outbox;
  final SyncStatusNotifier _status;
  final SyncDispatcher _dispatcher;
  final bool Function() _isAuthenticated;
  final Future<bool> Function()? _isBackendReachable;

  static const int _maxAttempts = 8;

  bool _running = false;
  bool _dirty = false;
  bool _recovered = false;

  Future<void> sync() async {
    if (!_isAuthenticated()) return;
    if (_running) {
      _dirty = true;
      return;
    }
    _running = true;
    try {
      final health = _isBackendReachable;
      if (health != null && !await health()) {
        AppLogger.instance.i('Sync deferred: backend not reachable');
        return;
      }
      if (!_recovered) {
        await _outbox.resetSyncingToPending();
        _recovered = true;
      }
      do {
        _dirty = false;
        await _drain();
      } while (_dirty);
    } finally {
      _running = false;
    }
  }

  Future<void> _drain() async {
    final pending = await _outbox.pending();
    if (pending.isEmpty) {
      _status.finish();
      return;
    }
    _status.begin(pending.length);
    for (final row in pending) {
      try {
        await _outbox.markSyncing(row.id);
        await _dispatcher.dispatch(row);
        await _outbox.markSynced(row.id);
        _status.progress();
      } catch (e, s) {
        final attempts = row.attemptCount + 1;
        if (attempts >= _maxAttempts) {
          await _outbox.markFailed(row.id, e.toString());
          _status.fail();
          AppLogger.instance.e(
            'Sync command failed permanently ${row.op}',
            e,
            s,
          );
        } else {
          await _outbox.reschedule(row.id, error: e.toString());
          AppLogger.instance.w('Sync command retry ${row.op} ($attempts)', e);
        }
        _status.finish();
        return;
      }
    }
    _status.finish();
  }
}
