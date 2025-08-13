import 'dart:convert';
import '../../../approvals_module/approvals_module/model/course_curriculum_model.dart';
import '../../../approvals_module/approvals_module/model/course_feature_list_model.dart';


class CourseModel {
  int id = 0;
  String name = '';
  String image = '';
  int coursesNo = 0;
  double courseFees = 0.0;
  double rate = 0.0;
  String instructorName = '';
  int noOfLectures = 0;
  String date = '';
  String description = '';
  int noOfSession = 0;
  String instructorProfileImg = '';
  String courseCategory = '';
  double attendance=0.0;
  String language = '';
  String courseType = '';
  List<String> learningOutComesList = [];
  String requirements = '';
  List<CourseCurriculumModel> courseCurriculumList = [];
  List<CourseFeatureListModel> courseFeatureList = [];
  CourseModel.empty();
  CourseModel({
    required this.id,
    required this.name,
    required this.image,
    required this.coursesNo,
    required this.courseFees,
    required this.rate,
    required this.instructorName,
    required this.noOfLectures,
    required this.date,
    required this.description,
    required this.noOfSession,
    required this.instructorProfileImg,
    required this.courseCategory,
    required this.language,
    required this.courseType,
    required this.learningOutComesList,
    required this.requirements,
    required this.courseCurriculumList,
    required this.courseFeatureList,
    required this.attendance,
  });
  factory CourseModel.fromRawJson(String str) =>
      CourseModel.fromJson(json.decode(str));

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      coursesNo: json['coursesNo'] ?? 0,

      courseFees: json['courseFees'] ?? 0.0,
      rate: json['rate'] ?? 0.0,
      instructorName: json['instructorName'] ?? '',
      noOfLectures: json['noOfLectures'] ?? 0,

      date: json['date'] ?? '',
      description: json['description'] ?? '',
      noOfSession: json['noOfSession'] ?? 0,
      attendance: json['attendance'] ?? 0.0,
      instructorProfileImg: json['instructorProfileImg'] ?? '',
      courseCategory: json['courseCategory'] ?? '',
      language: json['language'] ?? '',
      courseType: json['courseType'] ?? '',
      learningOutComesList:
          (json['learning_outcomes_list'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      requirements: json['requirements'] ?? '',
      courseCurriculumList:
          (json['course_curriculum_list'] as List<dynamic>?)
              ?.map((e) => CourseCurriculumModel.fromJson(e))
              .toList() ??
          [],
      courseFeatureList:
          (json['course_features_list'] as List<dynamic>?)
              ?.map((e) => CourseFeatureListModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
