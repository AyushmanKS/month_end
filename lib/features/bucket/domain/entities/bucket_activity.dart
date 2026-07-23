import 'dart:convert';

class BucketActivity {
  const BucketActivity({
    required this.id,
    required this.bucketId,
    required this.type,
    required this.category,
    required this.summary,
    this.actorUid,
    this.metadata = const {},
    this.correlationId,
    this.createdAt,
  });

  final String id;
  final String bucketId;
  final String type;
  final String category;
  final String summary;
  final String? actorUid;
  final Map<String, dynamic> metadata;
  final String? correlationId;
  final DateTime? createdAt;

  factory BucketActivity.fromJson(Map<String, dynamic> json) {
    return BucketActivity(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String,
      type: json['type'] as String? ?? 'unknown',
      category: json['category'] as String? ?? 'bucket',
      summary: json['summary'] as String? ?? '',
      actorUid: json['actor_uid'] as String?,
      metadata: _decode(json['metadata']),
      correlationId: json['correlation_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  static Map<String, dynamic> _decode(dynamic raw) {
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
}
