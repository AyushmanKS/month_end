enum AppNotificationType {
  expenseAdded,
  expenseEdited,
  expenseDeleted,
  bigExpenseAdded,
  budgetThreshold,
  ownershipTransferred,
  memberLeft,
  unknown,
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.bucketId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.actorUid,
    this.readBy = const [],
  });

  final String id;
  final String bucketId;
  final AppNotificationType type;
  final String message;
  final DateTime createdAt;
  final String? actorUid;
  final List<String> readBy;

  bool isReadBy(String userId) => readBy.contains(userId);

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String,
      type: _typeFrom(json['type'] as String?),
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      actorUid: json['actor_uid'] as String?,
      readBy: (json['read_by'] as List?)?.cast<String>() ?? const [],
    );
  }

  static AppNotificationType _typeFrom(String? value) {
    switch (value) {
      case 'expense_added':
        return AppNotificationType.expenseAdded;
      case 'expense_edited':
        return AppNotificationType.expenseEdited;
      case 'expense_deleted':
        return AppNotificationType.expenseDeleted;
      case 'big_expense_added':
        return AppNotificationType.bigExpenseAdded;
      case 'budget_threshold':
        return AppNotificationType.budgetThreshold;
      case 'ownership_transferred':
        return AppNotificationType.ownershipTransferred;
      case 'member_left':
        return AppNotificationType.memberLeft;
      default:
        return AppNotificationType.unknown;
    }
  }
}
