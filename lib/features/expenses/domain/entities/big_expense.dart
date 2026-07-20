class BigExpense {
  const BigExpense({
    required this.id,
    required this.bucketId,
    required this.addedByUid,
    required this.title,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String bucketId;
  final String addedByUid;
  final String title;
  final double amount;
  final DateTime createdAt;

  factory BigExpense.fromJson(Map<String, dynamic> json) {
    return BigExpense(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String,
      addedByUid: json['added_by_uid'] as String,
      title: json['title'] as String? ?? '',
      amount: _toDouble(json['amount']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
