import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/rank_model.dart';
import 'course_model.dart';
import 'course_category_model.dart';
import 'class_approval_model.dart';
import 'instructor_model.dart';
import 'notes_model.dart';

class DashboardDataModel {
  int totalStudents;
  int scholarship;
  int totalInstructors;
  int totalCourses;
  int monthlyRevenue;
  int newUsers;
  int activeUsers;
  int inactiveUsers;
  List<ClassApprovalModel> classApprovalsList;
  List<NoteModel> myNotesList;
  List<InstructorModel> instructorList;
  List<CourseModel> topCoursesList;
  List<RankModel> rankList;
  List<CourseCategoryModel> topCategoriesList;

  DashboardDataModel({
    required this.totalStudents,
    required this.scholarship,
    required this.totalInstructors,
    required this.totalCourses,
    required this.monthlyRevenue,
    required this.newUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.classApprovalsList,
    required this.myNotesList,
    required this.instructorList,
    required this.topCoursesList,
    required this.rankList,
    required this.topCategoriesList,
  });
  DashboardDataModel.empty()
    : totalStudents = 0,
      scholarship = 0,
      totalInstructors = 0,
      totalCourses = 0,
      monthlyRevenue = 0,
      newUsers = 0,
      activeUsers = 0,
      inactiveUsers = 0,
      classApprovalsList = [],
      myNotesList = [],
      instructorList = [],
      topCoursesList = [],
      rankList = [],
      topCategoriesList = [];

  factory DashboardDataModel.fromRawJson(String str) =>
      DashboardDataModel.fromJson(json.decode(str));

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
        totalStudents: json['totalStudents'] ?? 0,
        scholarship: json['scholarship'] ?? 0,
        totalInstructors: json['totalInstructors'] ?? 0,
        totalCourses: json['totalCourses'] ?? 0,
        monthlyRevenue: json['monthlyRevenue'] ?? 0,
        newUsers: json['newUsers'] ?? 0,
        activeUsers: json['activeUsers'] ?? 0,
        inactiveUsers: json['inactiveUsers'] ?? 0,
        classApprovalsList:
            (json['class_approvals_list'] as List<dynamic>?)
                ?.map((e) => ClassApprovalModel.fromJson(e))
                .toList() ??
            [],
        myNotesList:
            (json['my_notes_list'] as List<dynamic>?)
                ?.map((e) => NoteModel.fromJson(e))
                .toList() ??
            [],
        instructorList:
            (json['instructor_list'] as List<dynamic>?)
                ?.map((e) => InstructorModel.fromJson(e))
                .toList() ??
            [],
        topCoursesList:
            (json['top_courses_list'] as List<dynamic>?)
                ?.map((e) => CourseModel.fromJson(e))
                .toList() ??
            [],
        rankList:
            (json['rank_list'] as List<dynamic>?)
                ?.map((e) => RankModel.fromJson(e))
                .toList() ??
            [],
        topCategoriesList:
            (json['top_categories_list'] as List<dynamic>?)
                ?.map((e) => CourseCategoryModel.fromJson(e))
                .toList() ??
            [],
      );
}
