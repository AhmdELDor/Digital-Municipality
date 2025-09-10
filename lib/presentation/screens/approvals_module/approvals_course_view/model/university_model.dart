import 'dart:convert';

import '../../../dashboard_module/dashboard/model/course_model.dart';

class UniversityModel {
  int id = 0;
  String name = '';
  String image = '';
  String date = '';
  String email = '';
  String phoneNo = '';
  List<String> verificationDetailList = [];
  String about = '';
  String instagramAccount = '';
  String faceBookAccount = '';
  String youTubeChannel = '';
  String identityProf = '';
  String qualificationProf = '';
  String courseCompletionCertificateProf = '';
  String courseCertificate = '';
  double rate = 0.0;
  List<CourseModel> coursesList = [];
  UniversityModel.empty();
  UniversityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
    required this.email,
    required this.phoneNo,
    required this.verificationDetailList,
    required this.about,
    required this.instagramAccount,
    required this.faceBookAccount,
    required this.youTubeChannel,
    required this.identityProf,
    required this.qualificationProf,
    required this.courseCompletionCertificateProf,
    required this.rate,
    required this.courseCertificate,
    required this.coursesList,
  });
  factory UniversityModel.fromRawJson(String str) =>
      UniversityModel.fromJson(json.decode(str));
  factory UniversityModel.fromJson(Map<String, dynamic> json) =>
      UniversityModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        date: json['date'] ?? '',
        email: json['email'] ?? '',
        phoneNo: json['phoneNo'] ?? '',
        verificationDetailList:
            (json['verification_detail_list'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        about: json['about'] ?? '',
        instagramAccount: json['instagramAccount'] ?? '',
        faceBookAccount: json['faceBookAccount'] ?? '',
        youTubeChannel: json['youTubeChannel'] ?? '',
        identityProf: json['identityProf'] ?? '',
        qualificationProf: json['qualificationProf'] ?? '',
        courseCompletionCertificateProf:
            json['courseCompletionCertificateProf'] ?? '',
        rate: json['rate'] ?? 0.0,
        courseCertificate: json['course_certificate'] ?? '',
        coursesList:
            (json['courses_list'] as List?)
                ?.map((e) => CourseModel.fromJson(e))
                .toList() ??
            [],
      );
}
