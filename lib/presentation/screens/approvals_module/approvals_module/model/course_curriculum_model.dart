import 'lectures_model.dart';

class CourseCurriculumModel {
  String title = '';
  int noOfCompletedLectures = 0;
  List<LecturesModel> lecturesList = [];
  CourseCurriculumModel({
    required this.title,
    required this.lecturesList,
    required this.noOfCompletedLectures,
  });

  factory CourseCurriculumModel.fromJson(Map<String, dynamic> json) {
    return CourseCurriculumModel(
      title: json['title'] ?? '',
      lecturesList:
      (json['lectures_list'] as List<dynamic>?)
          ?.map((e) => LecturesModel.fromJson(e))
          .toList() ??
          [],
      noOfCompletedLectures: json['noOfCompletedLectures'] ?? 0,
    );
  }
}