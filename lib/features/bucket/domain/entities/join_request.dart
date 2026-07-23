enum JoinRequestStatus { pending, accepted, rejected, cancelled, unknown }

class JoinRequest {
  const JoinRequest({
    required this.id,
    required this.bucketId,
    required this.bucketName,
    required this.requesterUid,
    required this.status,
    this.requesterName,
    this.requesterPhoto,
    this.createdAt,
    this.decidedAt,
  });

  final String id;
  final String bucketId;
  final String bucketName;
  final String requesterUid;
  final JoinRequestStatus status;
  final String? requesterName;
  final String? requesterPhoto;
  final DateTime? createdAt;
  final DateTime? decidedAt;

  bool get isPending => status == JoinRequestStatus.pending;

  JoinRequest copyWith({JoinRequestStatus? status, DateTime? decidedAt}) {
    return JoinRequest(
      id: id,
      bucketId: bucketId,
      bucketName: bucketName,
      requesterUid: requesterUid,
      status: status ?? this.status,
      requesterName: requesterName,
      requesterPhoto: requesterPhoto,
      createdAt: createdAt,
      decidedAt: decidedAt ?? this.decidedAt,
    );
  }

  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    return JoinRequest(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String,
      bucketName: json['bucket_name'] as String? ?? '',
      requesterUid: json['requester_uid'] as String,
      status: statusFromWire(json['status'] as String?),
      requesterName: json['requester_name'] as String?,
      requesterPhoto: json['requester_photo'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      decidedAt: json['decided_at'] != null
          ? DateTime.parse(json['decided_at'] as String)
          : null,
    );
  }

  static JoinRequestStatus statusFromWire(String? value) {
    switch (value) {
      case 'pending':
        return JoinRequestStatus.pending;
      case 'accepted':
        return JoinRequestStatus.accepted;
      case 'rejected':
        return JoinRequestStatus.rejected;
      case 'cancelled':
        return JoinRequestStatus.cancelled;
      default:
        return JoinRequestStatus.unknown;
    }
  }

  static String statusToWire(JoinRequestStatus status) => status.name;
}
