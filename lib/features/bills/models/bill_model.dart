class BillModel {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final String paymentType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BillModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.paymentType,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount'];
    return BillModel(
      id: (json['id'] ?? json['uuid'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: json['description']?.toString() ?? json['desc']?.toString(),
      amount: amountValue is num ? amountValue.toDouble() : double.tryParse(amountValue?.toString() ?? '0') ?? 0,
      paymentType: (json['payment_type'] ?? json['type'] ?? json['paymentType'] ?? '').toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'payment_type': paymentType,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  BillModel copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? paymentType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentType: paymentType ?? this.paymentType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
