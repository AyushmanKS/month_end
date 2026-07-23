import 'dart:convert';

enum NotificationCategory {
  system,
  bucket,
  expense,
  membership,
  ownership,
  security,
  billing,
  announcement,
  unknown,
}

class UserNotification {
  const UserNotification({
    required this.id,
    required this.recipientUid,
    required this.eventId,
    required this.type,
    required this.category,
    required this.title,
    required this.body,
    this.bucketId,
    this.bucketName = '',
    this.actorUid,
    this.metadata = const {},
    this.correlationId,
    this.createdAt,
    this.readAt,
    this.archivedAt,
  });

  final String id;
  final String recipientUid;
  final String eventId;
  final String type;
  final NotificationCategory category;
  final String title;
  final String body;
  final String? bucketId;
  final String bucketName;
  final String? actorUid;
  final Map<String, dynamic> metadata;
  final String? correlationId;
  final DateTime? createdAt;
  final DateTime? readAt;
  final DateTime? archivedAt;

  bool get isUnread => readAt == null && archivedAt == null;
  bool get isArchived => archivedAt != null;

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] as String,
      recipientUid: json['recipient_uid'] as String,
      eventId: json['event_id'] as String? ?? '',
      type: json['type'] as String? ?? 'unknown',
      category: categoryFrom(json['category'] as String?),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      bucketId: json['bucket_id'] as String?,
      bucketName: json['bucket_name'] as String? ?? '',
      actorUid: json['actor_uid'] as String?,
      metadata: _decodeMetadata(json['metadata']),
      correlationId: json['correlation_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      archivedAt: json['archived_at'] != null
          ? DateTime.parse(json['archived_at'] as String)
          : null,
    );
  }

  static Map<String, dynamic> _decodeMetadata(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        return decoded is Map<String, dynamic> ? decoded : const {};
      } catch (_) {
        return const {};
      }
    }
    return const {};
  }

  static NotificationCategory categoryFrom(String? value) {
    switch (value) {
      case 'system':
        return NotificationCategory.system;
      case 'bucket':
        return NotificationCategory.bucket;
      case 'expense':
        return NotificationCategory.expense;
      case 'membership':
        return NotificationCategory.membership;
      case 'ownership':
        return NotificationCategory.ownership;
      case 'security':
        return NotificationCategory.security;
      case 'billing':
        return NotificationCategory.billing;
      case 'announcement':
        return NotificationCategory.announcement;
      default:
        return NotificationCategory.unknown;
    }
  }

  static String categoryWire(NotificationCategory category) => category.name;
}
