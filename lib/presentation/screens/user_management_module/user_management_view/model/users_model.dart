import 'package:get/get.dart';

class UsersModel {
  final int id;
  final String name;
  final String image;
  final String email;
  final String role;
  final String dateCreated;
  final String mobileNo;
  final String avatarUrl;
  final String description;
  RxBool isSwitch = true.obs;
  UsersModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.role,
    required this.dateCreated,
    required this.mobileNo,
    required this.avatarUrl,
    required this.description,
    required this.isSwitch,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      dateCreated: json["dateCreated"] ?? "",
      mobileNo: json["phone_no"] ?? "",
      avatarUrl: json["avatarUrl"] ?? "",
      description: json["description"] ?? "",
      isSwitch: true.obs,
    );
  }


}
