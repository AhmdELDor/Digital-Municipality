import 'dart:convert';

import 'package:education_admin_portal/presentation/screens/student_management_module/student_management_detail/model/payment_history_model.dart';
import 'package:get/get.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../instructor_management_module/instructor_management_detail_view/model/contact_information.dart';

class StudentManagementDetailModel {
  ContactInformation? contactInformation;
  int leaderBoardPosition = 0;
  int totalEarnedCoins = 0;
  int totalCourse = 0;
  int completedCourse = 0;
  int ongoingCourses = 0;
  List<CourseModel> coursesList = [];
  List<PaymentHistoryModel> paymentHistoryList = [];

  /// Example toggle
  RxBool isSwitch = true.obs;

  StudentManagementDetailModel({
    required this.contactInformation,
    required this.leaderBoardPosition,
    required this.totalEarnedCoins,
    required this.totalCourse,
    required this.completedCourse,
    required this.ongoingCourses,
    required this.coursesList,
    required this.paymentHistoryList,
    required this.isSwitch,
  });
  StudentManagementDetailModel.empty();
  factory StudentManagementDetailModel.fromRawJson(String str) =>
      StudentManagementDetailModel.fromJson(json.decode(str));
  factory StudentManagementDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentManagementDetailModel(
      contactInformation: ContactInformation.fromJson(
        json['contact_information'] ?? {},
      ),
      leaderBoardPosition: json['leaderBoardPosition'] ?? 0,
      totalEarnedCoins: json['totalEarnedCoins'] ?? 0,
      totalCourse: json['totalCourse'] ?? 0,
      completedCourse: json['completedCourse'] ?? 0,
      ongoingCourses: json['ongoingCourses'] ?? 0,
      coursesList: (json['courses_list'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),
      paymentHistoryList: (json['payment_history_list'] as List<dynamic>? ?? [])
          .map((e) => PaymentHistoryModel.fromJson(e))
          .toList(),
      isSwitch: true.obs,
    );
  }
}
