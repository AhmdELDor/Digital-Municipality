import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../data/models/user_api_model.dart';

class UsersModel {
  final String id;
  final String name;
  final String phonenumber;
  final String role;
  final String address;
  final DateTime? createdAt;
  RxBool isActive = true.obs;

  UsersModel({
    required this.id,
    required this.name,
    required this.phonenumber,
    required this.role,
    required this.address,
    this.createdAt,
    required this.isActive,
  });

  // Get initials for avatar
  String get initials {
    final names = name.trim().split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    }
    return '${names[0].substring(0, 1)}${names[1].substring(0, 1)}'.toUpperCase();
  }

  // Format created date
  String get formattedDate {
    if (createdAt == null) return '';
    return DateFormat('dd MMM yyyy', 'ar').format(createdAt!);
  }

  // Create from API model
  factory UsersModel.fromApi(UserApiModel apiModel) {
    return UsersModel(
      id: apiModel.id,
      name: apiModel.fullName,
      phonenumber: apiModel.phonenumber,
      role: apiModel.role,
      address: apiModel.address,
      createdAt: apiModel.createdAt,
      isActive: true.obs, // Default to active, backend will handle status field
    );
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"] ?? json["full_name"] ?? "",
      phonenumber: json["phone_no"] ?? json["phonenumber"] ?? "",
      role: json["role"] ?? "citizen",
      address: json["address"] ?? "",
      createdAt: json["created_at"] != null 
          ? DateTime.tryParse(json["created_at"]) 
          : null,
      isActive: true.obs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'phonenumber': phonenumber,
      'role': role,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
