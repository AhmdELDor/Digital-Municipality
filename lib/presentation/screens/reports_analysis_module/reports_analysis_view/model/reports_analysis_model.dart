import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/reports_analysis_module/reports_analysis_view/model/summary_metric_model.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/dashboard/model/instructor_model.dart';
import 'course_completion_model.dart';

class ReportsAnalysisModel {
  Summary summary;
  CourseCompletion courseCompletion;
  List<CourseModel> topCourses;
  List<InstructorModel> instructors;

  ReportsAnalysisModel({
    required this.summary,
    required this.courseCompletion,
    required this.topCourses,
    required this.instructors,
  });

  /// 🔹 Empty defaults (no nulls!)
  ReportsAnalysisModel.empty()
      : summary = Summary.empty(),
        courseCompletion = CourseCompletion.empty(),
        topCourses = [],
        instructors = [];

  factory ReportsAnalysisModel.fromRawJson(String str) =>
      ReportsAnalysisModel.fromJson(json.decode(str));

  factory ReportsAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ReportsAnalysisModel(
      summary: json["summary"] != null
          ? Summary.fromJson(json["summary"])
          : Summary.empty(),
      courseCompletion: json["courseCompletion"] != null
          ? CourseCompletion.fromJson(json["courseCompletion"])
          : CourseCompletion.empty(),
      topCourses: (json["topCourses"] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),
      instructors: (json["instructors"] as List<dynamic>? ?? [])
          .map((e) => InstructorModel.fromJson(e))
          .toList(),
    );
  }
}

