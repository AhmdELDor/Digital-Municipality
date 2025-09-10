import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/course_category_model.dart';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/course_model.dart';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/user_model.dart';
import 'package:education_admin_portal/presentation/screens/quiz_module/quiz_main_view/model/quiz_model.dart';
import 'package:education_admin_portal/presentation/screens/quiz_module/quiz_main_view/model/status_model.dart';


class QuizDetailModel {
  List<CourseModel> coursesList = [];
  List<CourseCategoryModel> courseCategoryList = [];
  List<StatusModel> statusList = [];
  List<UserModel> usersList = [];
  List<QuizModel> quizList = [];

  QuizDetailModel.empty();
  QuizDetailModel({
    required this.coursesList,
    required this.courseCategoryList,
    required this.statusList,
    required this.usersList,
    required this.quizList,
  });
  factory QuizDetailModel.fromRawJson(String str) =>
      QuizDetailModel.fromJson(json.decode(str));

  factory QuizDetailModel.fromJson(Map<String, dynamic> json) {
    return QuizDetailModel(
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
      quizList:
          (json['quiz_list'] as List<dynamic>?)
              ?.map((e) => QuizModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
