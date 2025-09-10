import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/approvals_module/approvals_course_view/model/university_model.dart';

import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/dashboard/model/instructor_model.dart';


class ApprovalsModel {
  List<CourseModel> coursesApprovalsList = [];
  List<InstructorModel> instructorApprovalsList = [];
  List<UniversityModel> universityApprovalsList = [];
  List<String> courseCategoryList = [];
  List<String> languageList = [];
  List<double> priceRangeList = [];
  List<String> identityProofList = [];
  List<String> registrationProofList = [];

  ApprovalsModel.empty();
  ApprovalsModel({
    required this.coursesApprovalsList,
    required this.instructorApprovalsList,
    required this.universityApprovalsList,
    required this.courseCategoryList,
    required this.languageList,
    required this.priceRangeList,
    required this.identityProofList,
    required this.registrationProofList,
  });
  factory ApprovalsModel.fromRawJson(String str) =>
      ApprovalsModel.fromJson(json.decode(str));

  factory ApprovalsModel.fromJson(Map<String, dynamic> json) {
    return ApprovalsModel(
      coursesApprovalsList:
          (json['courses_approvals_list'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
      instructorApprovalsList:
          (json['instructor_approvals_list'] as List<dynamic>?)
              ?.map((e) => InstructorModel.fromJson(e))
              .toList() ??
          [],
      universityApprovalsList:
          (json['university_approvals_list'] as List<dynamic>?)
              ?.map((e) => UniversityModel.fromJson(e))
              .toList() ??
          [],
      courseCategoryList:
          (json['course_category_list'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      languageList:
          (json['language_list'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      priceRangeList:
          (json['price_range_list'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      identityProofList:
          (json['identity_proof_list'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      registrationProofList:
          (json['registration_proof_list'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
