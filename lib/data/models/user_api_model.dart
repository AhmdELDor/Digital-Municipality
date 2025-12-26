import 'pagination_meta.dart';

class UserApiModel {
  final String id;
  final String fullName;
  final String phonenumber;
  final String role;
  final String address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserApiModel({
    required this.id,
    required this.fullName,
    required this.phonenumber,
    required this.role,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      role: json['role'] ?? 'citizen',
      address: json['address'] ?? '',
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
      'full_name': fullName,
      'phonenumber': phonenumber,
      'role': role,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CreateUserRequest {
  final String fullName;
  final String phonenumber;
  final String role;
  final String address;
  final String password;

  CreateUserRequest({
    required this.fullName,
    required this.phonenumber,
    required this.role,
    required this.address,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phonenumber': phonenumber,
      'role': role,
      'address': address,
      'password': password,
    };
  }
}

class UpdateUserRequest {
  final String fullName;
  final String phonenumber;
  final String role;
  final String address;
  final String? password; // Optional - only if changing password

  UpdateUserRequest({
    required this.fullName,
    required this.phonenumber,
    required this.role,
    required this.address,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'full_name': fullName,
      'phonenumber': phonenumber,
      'role': role,
      'address': address,
    };
    
    // Only include password if it's provided
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    
    return data;
  }
}

class UsersListResponse {
  final List<UserApiModel> users;
  final PaginationMeta meta;
  final String message;

  UsersListResponse({
    required this.users,
    required this.meta,
    required this.message,
  });

  factory UsersListResponse.fromJson(Map<String, dynamic> json) {
    return UsersListResponse(
      users: (json['data'] as List<dynamic>?)
              ?.map((item) => UserApiModel.fromJson(item))
              .toList() ?? [],
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class UserResponse {
  final UserApiModel user;
  final String message;

  UserResponse({
    required this.user,
    required this.message,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: UserApiModel.fromJson(json['data']),
      message: json['message'] ?? '',
    );
  }
}
