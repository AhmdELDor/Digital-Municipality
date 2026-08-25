class User {
  final String id;
  final String fullName;
  final String phonenumber;
  final String role;
  final String? address;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.phonenumber,
    required this.role,
    this.address,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phonenumber: json['phonenumber'] as String,
      role: json['role'] as String,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phonenumber': phonenumber,
      'role': role,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  String get roleArabic {
    switch (role) {
      case 'superadmin':
        return 'مدير عام';
      case 'admin':
        return 'مدير';
      case 'citizen':
        return 'مواطن';
      default:
        return role;
    }
  }

  bool get isSuperAdmin => role == 'superadmin';
  bool get isAdmin => role == 'admin' || role == 'superadmin';
}
