import 'dart:convert';

enum OutboxOp {
  bucketCreate,
  bucketUpdateBudget,
  bucketSetCurrency,
  bucketTransfer,
  bucketDelete,
  weekSetManualTotal,
  expenseCreate,
  expenseEdit,
  expenseDelete,
  bigExpenseCreate,
  categoryCreate,
  categoryDelete,
  inviteByUsername,
  joinByCode,
  joinRequestDecide,
  joinRequestCancel,
  markNotificationsRead,
  profileUpdate,
}

extension OutboxOpName on OutboxOp {
  String get wire => name;

  static OutboxOp fromWire(String value) => OutboxOp.values.firstWhere(
    (op) => op.name == value,
    orElse: () => OutboxOp.expenseCreate,
  );
}

class OutboxCommand {
  const OutboxCommand({
    required this.id,
    required this.op,
    required this.entity,
    required this.entityId,
    required this.payload,
    this.baseVersion,
    this.priority = 0,
  });

  final String id;
  final OutboxOp op;
  final String entity;
  final String entityId;
  final Map<String, dynamic> payload;
  final int? baseVersion;
  final int priority;

  String encodePayload() => jsonEncode(payload);

  static Map<String, dynamic> decodePayload(String raw) {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }
}
