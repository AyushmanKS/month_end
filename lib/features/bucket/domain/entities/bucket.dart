class Bucket {
  const Bucket({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.joinCode,
    required this.monthlyBudget,
    required this.monthStartDate,
    required this.remainingMainBucket,
    required this.createdAt,
    this.currency = 'INR',
  });

  final String id;
  final String name;
  final String ownerId;
  final String joinCode;
  final double monthlyBudget;
  final DateTime monthStartDate;
  final double remainingMainBucket;
  final DateTime createdAt;
  final String currency;

  double get spentSoFar => monthlyBudget - remainingMainBucket;

  double get monthlyProgress =>
      monthlyBudget <= 0 ? 0 : (spentSoFar / monthlyBudget).clamp(0.0, 1.0);

  bool isOwnedBy(String userId) => ownerId == userId;

  Bucket copyWith({
    String? name,
    String? ownerId,
    double? monthlyBudget,
    double? remainingMainBucket,
    DateTime? monthStartDate,
    String? currency,
  }) {
    return Bucket(
      id: id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      joinCode: joinCode,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthStartDate: monthStartDate ?? this.monthStartDate,
      remainingMainBucket: remainingMainBucket ?? this.remainingMainBucket,
      createdAt: createdAt,
      currency: currency ?? this.currency,
    );
  }

  factory Bucket.fromJson(Map<String, dynamic> json) {
    return Bucket(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      ownerId: json['owner_id'] as String,
      joinCode: json['join_code'] as String? ?? '',
      monthlyBudget: _toDouble(json['monthly_budget']),
      monthStartDate: DateTime.parse(json['month_start_date'] as String),
      remainingMainBucket: _toDouble(json['remaining_main_bucket']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      currency: json['currency'] as String? ?? 'INR',
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
