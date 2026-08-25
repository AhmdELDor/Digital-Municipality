class ServiceModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? logo;
  final bool priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.logo,
    this.priority = false,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasLogo => logo != null && logo!.isNotEmpty;

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: (json['id'] ?? json['uuid'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      phoneNumber: (json['phone_number'] ?? json['phonenumber'] ?? '').toString(),
      logo: json['logo']?.toString(),
      priority: json['priority'] is bool
          ? json['priority'] as bool
          : (json['priority']?.toString() == '1'),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'logo': logo,
      'priority': priority,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? logo,
    bool? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      logo: logo ?? this.logo,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
