class UserModel {
  final String id; // Changed from int to String
  final String name;
  final String phonenumber;
  final String? email;
  final String? profileImage;
  final String? role;
  final String? address; // Added address field from API
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phonenumber,
    this.email,
    this.profileImage,
    this.role,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '0', // Convert to String
      name: json['full_name'] ?? json['name'] ?? '', // Try full_name first, then name
      phonenumber: json['phonenumber'] ?? '',
      email: json['email'],
      profileImage: json['profile_image'],
      role: json['role'],
      address: json['address'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'phonenumber': phonenumber,
      'email': email,
      'profile_image': profileImage,
      'role': role,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for updating user data
  UserModel copyWith({
    String? id,
    String? name,
    String? phonenumber,
    String? email,
    String? profileImage,
    String? role,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
