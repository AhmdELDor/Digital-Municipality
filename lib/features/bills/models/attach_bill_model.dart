class AttachBillModel {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final DateTime? dueDate;
  final DateTime? paidDate;
  final String? note;
  final String? citizenId;
  final String? citizenName;
  final String? citizenPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttachBillModel({
    required this.id,
    required this.title,
    required this.amount,
    this.description,
    this.dueDate,
    this.paidDate,
    this.note,
    this.citizenId,
    this.citizenName,
    this.citizenPhone,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPaid => paidDate != null;

  factory AttachBillModel.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount'];
    final userData = json['user'] ?? json['citizen'];
    return AttachBillModel(
      id: (json['id'] ?? json['uuid'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: json['description']?.toString() ?? json['desc']?.toString(),
      amount: amountValue is num ? amountValue.toDouble() : double.tryParse(amountValue?.toString() ?? '0') ?? 0,
      dueDate: json['due_date'] != null ? DateTime.tryParse(json['due_date'].toString()) : null,
      paidDate: json['paid_date'] != null ? DateTime.tryParse(json['paid_date'].toString()) : null,
      note: json['note']?.toString(),
      citizenId: json['citizen_id']?.toString() ?? (userData?['id']?.toString()),
      citizenName: json['citizen_name']?.toString() ?? userData?['name']?.toString() ?? userData?['full_name']?.toString(),
      citizenPhone: json['citizen_phone']?.toString() ?? userData?['phone']?.toString() ?? userData?['phonenumber']?.toString(),
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
      'due_date': dueDate?.toIso8601String(),
      'paid_date': paidDate?.toIso8601String(),
      'note': note,
      'citizen_id': citizenId,
      'citizen_name': citizenName,
      'citizen_phone': citizenPhone,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  AttachBillModel copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? dueDate,
    DateTime? paidDate,
    String? note,
    String? citizenId,
    String? citizenName,
    String? citizenPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttachBillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      note: note ?? this.note,
      citizenId: citizenId ?? this.citizenId,
      citizenName: citizenName ?? this.citizenName,
      citizenPhone: citizenPhone ?? this.citizenPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
