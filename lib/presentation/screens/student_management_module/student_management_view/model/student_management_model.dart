import 'package:get/get.dart';

class StudentManagementModel {
  int id;
  String name;
  String image;
  String email;
  String phoneNo;
  int totalEnrolledCourse;
  int totalCoinsEarned;
  int leaderBoardPosition;
  RxBool isSwitch = true.obs;
  StudentManagementModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.phoneNo,
    required this.totalEnrolledCourse,
    required this.totalCoinsEarned,
    required this.leaderBoardPosition,
    required this.isSwitch,
  });

  factory StudentManagementModel.fromJson(Map<String, dynamic> json) =>
      StudentManagementModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        email: json['email'] ?? '',
        phoneNo: json['phoneNo'] ?? '',
        totalEnrolledCourse: json['totalEnrolledCourse'] ?? 0,
        totalCoinsEarned: json['totalCoinsEarned'] ?? 0,
        leaderBoardPosition: json['leaderBoardPosition'] ?? 0,
        isSwitch: true.obs,
      );
}
