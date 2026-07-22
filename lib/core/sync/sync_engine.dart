import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../db/app_database.dart';
import '../logging/app_logger.dart';
import 'outbox_command.dart';
import 'outbox_repository.dart';
import 'sync_status.dart';

class SyncEngine {
  SyncEngine(this._client, this._outbox, this._status);

  final SupabaseClient _client;
  final OutboxRepository _outbox;
  final SyncStatusNotifier _status;

  static const int _maxAttempts = 8;

  bool _running = false;
  bool _dirty = false;
  bool _recovered = false;

  Future<void> sync() async {
    if (_client.auth.currentUser == null) return;
    if (_running) {
      _dirty = true;
      return;
    }
    _running = true;
    try {
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
        await _dispatch(row);
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

  Future<void> _dispatch(OutboxData row) async {
    final op = OutboxOpName.fromWire(row.op);
    final p = OutboxCommand.decodePayload(row.payload);
    switch (op) {
      case OutboxOp.bucketCreate:
        await _client.rpc(
          'create_bucket',
          params: {
            'p_id': row.entityId,
            'p_name': p['name'],
            'p_budget': p['budget'],
            'p_currency': p['currency'] ?? 'INR',
          },
        );
      case OutboxOp.bucketUpdateBudget:
        await _client.rpc(
          'update_monthly_budget',
          params: {'p_bucket_id': row.entityId, 'p_budget': p['budget']},
        );
      case OutboxOp.bucketSetCurrency:
        await _client.rpc(
          'set_bucket_currency',
          params: {
            'p_bucket_id': row.entityId,
            'p_currency': p['currency'],
            'p_rate': p['rate'] ?? 1,
            'p_expected_current': p['expected'],
          },
        );
      case OutboxOp.bucketTransfer:
        await _client.rpc(
          'transfer_bucket_ownership',
          params: {'p_bucket_id': row.entityId, 'p_new_owner': p['newOwner']},
        );
      case OutboxOp.bucketDelete:
        await _client.rpc(
          'delete_bucket',
          params: {'p_bucket_id': row.entityId},
        );
      case OutboxOp.weekSetManualTotal:
        await _client.rpc(
          'set_week_manual_total',
          params: {'p_week_id': row.entityId, 'p_amount': p['amount']},
        );
      case OutboxOp.expenseCreate:
        await _client.rpc(
          'add_expense',
          params: {
            'p_id': row.entityId,
            'p_bucket_id': p['bucketId'],
            'p_amount': p['amount'],
            'p_category_id': p['categoryId'],
            'p_note': p['note'],
            'p_receipt': p['receipt'],
            'p_occurred_at': p['occurredAt'],
            'p_local_date': p['localDate'],
          },
        );
      case OutboxOp.expenseEdit:
        await _client.rpc(
          'edit_expense',
          params: {
            'p_expense_id': row.entityId,
            'p_amount': p['amount'],
            'p_category_id': p['categoryId'],
            'p_note': p['note'],
            'p_receipt': p['receipt'],
          },
        );
      case OutboxOp.expenseDelete:
        await _client.rpc(
          'delete_expense',
          params: {'p_expense_id': row.entityId},
        );
      case OutboxOp.bigExpenseCreate:
        await _client.rpc(
          'add_big_expense',
          params: {
            'p_id': row.entityId,
            'p_bucket_id': p['bucketId'],
            'p_title': p['title'],
            'p_amount': p['amount'],
          },
        );
      case OutboxOp.categoryCreate:
        await _client.rpc(
          'add_custom_category',
          params: {
            'p_id': row.entityId,
            'p_name': p['name'],
            'p_icon': p['icon'],
          },
        );
      case OutboxOp.categoryDelete:
        await _client.rpc(
          'delete_custom_category',
          params: {'p_id': row.entityId},
        );
      case OutboxOp.joinByCode:
        await _client.rpc(
          'join_bucket_with_code',
          params: {'p_code': p['code']},
        );
      case OutboxOp.markNotificationsRead:
        await _client.rpc(
          'mark_notifications_read',
          params: {'p_bucket_id': row.entityId},
        );
      case OutboxOp.inviteByUsername:
        final user = await _client
            .from('users')
            .select('id')
            .eq('username', p['username'])
            .maybeSingle();
        if (user != null) {
          await _client.from('bucket_members').upsert({
            'bucket_id': row.entityId,
            'user_id': user['id'],
          });
        }
      case OutboxOp.profileUpdate:
        await _client.from('users').upsert({
          'id': row.entityId,
          if (p['name'] != null) 'name': p['name'],
          if (p['username'] != null) 'username': p['username'],
        });
    }
  }
}
