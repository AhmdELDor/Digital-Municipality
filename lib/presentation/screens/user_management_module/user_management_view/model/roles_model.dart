import 'package:get/get.dart';

class RolesModel {
  final int id;
  final String role;
  final String dateCreated;

  RxBool isSwitch = true.obs;
  RolesModel({
    required this.id,
    required this.role,
    required this.dateCreated,
    required this.isSwitch,
  });

  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(
      id: json["id"] ?? 0,
      role: json["role"] ?? "",
      dateCreated: json["dateCreated"] ?? "",
      isSwitch: true.obs,
    );
  }
}
