import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/course_category_model.dart';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/course_model.dart';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/user_model.dart';
import 'package:education_admin_portal/presentation/screens/quiz_module/quiz_main_view/model/status_model.dart';
import 'package:education_admin_portal/presentation/screens/test_module/main_test_view/model/test_model.dart';


class TestDetailModel {
  List<CourseModel> coursesList = [];
  List<CourseCategoryModel> courseCategoryList = [];
  List<StatusModel> statusList = [];
  List<UserModel> usersList = [];
  List<TestModel> testList = [];

  TestDetailModel.empty();
  TestDetailModel({
    required this.coursesList,
    required this.courseCategoryList,
    required this.statusList,
    required this.usersList,
    required this.testList,
  });
  factory TestDetailModel.fromRawJson(String str) =>
      TestDetailModel.fromJson(json.decode(str));

  factory TestDetailModel.fromJson(Map<String, dynamic> json) {
    return TestDetailModel(
      coursesList:
      (json['coursesList'] as List<dynamic>?)
          ?.map((e) => CourseModel.fromJson(e))
          .toList() ??
          [],
      courseCategoryList:
      (json['categoryList'] as List<dynamic>?)
          ?.map((e) => CourseCategoryModel.fromJson(e))
          .toList() ??
          [],
      statusList:
      (json['statusList'] as List<dynamic>?)
          ?.map((e) => StatusModel.fromJson(e))
          .toList() ??
          [],
      usersList:
      (json['usersList'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e))
          .toList() ??
          [],
      testList:
      (json['test_list'] as List<dynamic>?)
          ?.map((e) => TestModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
