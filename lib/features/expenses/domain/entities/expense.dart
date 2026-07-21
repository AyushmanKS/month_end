class Expense {
  const Expense({
    required this.id,
    required this.bucketId,
    required this.weekId,
    required this.addedByUid,
    required this.amount,
    required this.categoryId,
    required this.createdAt,
    this.note,
    this.receiptImageUrl,
    this.editedByUid,
    this.addedByName,
  });

  final String id;
  final String bucketId;
  final String? weekId;
  final String addedByUid;
  final double amount;
  final String? categoryId;
  final String? note;
  final String? receiptImageUrl;
  final DateTime createdAt;
  final String? editedByUid;
  final String? addedByName;

  bool get hasReceipt => receiptImageUrl != null && receiptImageUrl!.isNotEmpty;

  bool canEdit({required String userId, required String ownerId}) =>
      addedByUid == userId || ownerId == userId;

  Expense copyWith({
    double? amount,
    String? categoryId,
    String? note,
    String? receiptImageUrl,
    String? editedByUid,
  }) {
    return Expense(
      id: id,
      bucketId: bucketId,
      weekId: weekId,
      addedByUid: addedByUid,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      createdAt: createdAt,
      editedByUid: editedByUid ?? this.editedByUid,
      addedByName: addedByName,
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    final adder = json['users'];
    return Expense(
      id: json['id'] as String,
      bucketId: json['bucket_id'] as String,
      weekId: json['week_id'] as String?,
      addedByUid: json['added_by_uid'] as String? ?? '',
      amount: _toDouble(json['amount']),
      categoryId: json['category_id'] as String?,
      note: json['note'] as String?,
      receiptImageUrl: json['receipt_image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      editedByUid: json['edited_by_uid'] as String?,
      addedByName: adder is Map ? adder['name'] as String? : null,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
