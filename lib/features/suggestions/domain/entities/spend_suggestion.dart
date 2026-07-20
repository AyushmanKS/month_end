class SpendSuggestion {
  const SpendSuggestion({
    required this.id,
    required this.bucketId,
    required this.message,
    required this.percentChange,
    required this.createdAt,
    this.weekId,
    this.categoryId,
  });

  final String id;
  final String bucketId;
  final String message;
  final double percentChange;
  final DateTime createdAt;
  final String? weekId;
  final String? categoryId;

  bool get isIncrease => percentChange >= 0;

  factory SpendSuggestion.fromJson(Map<String, dynamic> json) {
    return SpendSuggestion(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String,
      message: json['message'] as String? ?? '',
      percentChange: _toDouble(json['percent_change']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      weekId: json['week_id'] as String?,
      categoryId: json['category_id'] as String?,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
