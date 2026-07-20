class BucketMember {
  const BucketMember({
    required this.bucketId,
    required this.userId,
    required this.joinedAt,
    this.name,
    this.photoUrl,
  });

  final String bucketId;
  final String userId;
  final DateTime joinedAt;
  final String? name;
  final String? photoUrl;

  factory BucketMember.fromJson(Map<String, dynamic> json) {
    final user = json['users'];
    return BucketMember(
      bucketId: json['bucket_id'] as String,
      userId: json['user_id'] as String,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      name: user is Map ? user['name'] as String? : json['name'] as String?,
      photoUrl:
          user is Map ? user['photo_url'] as String? : json['photo_url'] as String?,
    );
  }
}
