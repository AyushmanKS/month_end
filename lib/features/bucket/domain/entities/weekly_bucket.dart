enum WeeklyBucketStatus { active, closed }

class WeeklyBucket {
  const WeeklyBucket({
    required this.id,
    required this.bucketId,
    required this.weekIndex,
    required this.startDate,
    required this.endDate,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.status,
  });

  final String id;
  final String bucketId;
  final int weekIndex;
  final DateTime startDate;
  final DateTime endDate;
  final double allocatedAmount;
  final double spentAmount;
  final double remainingAmount;
  final WeeklyBucketStatus status;

  bool get isActive => status == WeeklyBucketStatus.active;

  double get progress => allocatedAmount <= 0
      ? 0
      : (spentAmount / allocatedAmount).clamp(0.0, 1.0);

  bool get isOverThreshold => progress >= 0.8;
  bool get isOverBudget => spentAmount > allocatedAmount;

  WeeklyBucket copyWith({
    double? allocatedAmount,
    double? spentAmount,
    double? remainingAmount,
    WeeklyBucketStatus? status,
  }) {
    return WeeklyBucket(
      id: id,
      bucketId: bucketId,
      weekIndex: weekIndex,
      startDate: startDate,
      endDate: endDate,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
    );
  }

  factory WeeklyBucket.fromJson(Map<String, dynamic> json) {
    return WeeklyBucket(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String? ?? '',
      weekIndex: (json['week_index'] as num?)?.toInt() ?? 0,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      allocatedAmount: _toDouble(json['allocated_amount']),
      spentAmount: _toDouble(json['spent_amount']),
      remainingAmount: _toDouble(json['remaining_amount']),
      status: (json['status'] as String?) == 'closed'
          ? WeeklyBucketStatus.closed
          : WeeklyBucketStatus.active,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
