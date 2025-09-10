import 'dart:convert';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import 'contact_information.dart';
import 'other_information.dart';

class InstructorManagementDetail {
  final ContactInformation contactInformation;
  final List<String> verificationDocuments;
  final OtherInformation otherInformation;
  final List<CourseModel> coursesList;
  final String noOfStudents;
  final String noOfCourses;
  final String noOfRating;

  InstructorManagementDetail({
    required this.contactInformation,
    this.verificationDocuments = const [],
    required this.otherInformation,
    this.coursesList = const [],
    this.noOfStudents = '',
    this.noOfCourses = '',
    this.noOfRating = '',
  });

  factory InstructorManagementDetail.empty() => InstructorManagementDetail(
    contactInformation: ContactInformation.empty(),
    otherInformation: OtherInformation.empty(),
  );

  factory InstructorManagementDetail.fromRawJson(String str) =>
      InstructorManagementDetail.fromJson(json.decode(str));

  factory InstructorManagementDetail.fromJson(Map<String, dynamic> json) {
    return InstructorManagementDetail(
      contactInformation: json['contact_information'] != null
          ? ContactInformation.fromJson(json['contact_information'])
          : ContactInformation.empty(),
      verificationDocuments: (json['verification_documents'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      otherInformation: json['other_information'] != null
          ? OtherInformation.fromJson(json['other_information'])
          : OtherInformation.empty(),
      coursesList: (json['courses_list'] as List?)
          ?.map((e) => CourseModel.fromJson(e))
          .toList() ??
          [],
      noOfStudents: json['noOfStudents']?.toString() ?? '',
      noOfCourses: json['noOfCourses']?.toString() ?? '',
      noOfRating: json['noOfRating']?.toString() ?? '',
    );
  }
}
