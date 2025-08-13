import 'dart:convert';

class InstructorModel {
  int id=0;
  String name='';
  String image='';
  String qualification='';
  double noOfStudents=0.0;
  int noOfCourses=0;
  double rate=0.0;
  String joiningDate='';
  String email='';
  String phoneNo='';
  List<String>verificationDetailList=[];
  String about='';
  String instagramAccount='';
  String faceBookAccount='';
  String youTubeChannel='';
  String identityProf='';
  String qualificationProf='';

  InstructorModel.empty();
  InstructorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.qualification,
    required this.noOfStudents,
    required this.noOfCourses,
    required this.rate,
    required this.joiningDate,
    required this.email,
    required this.phoneNo,
    required this.verificationDetailList,
    required this.about,
    required this.instagramAccount,
    required this.faceBookAccount,
    required this.youTubeChannel,
    required this.identityProf,
    required this.qualificationProf,
  });
  factory InstructorModel.fromRawJson(String str) =>
      InstructorModel.fromJson(json.decode(str));
  factory InstructorModel.fromJson(Map<String, dynamic> json) => InstructorModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    qualification: json['qualification'] ?? '',
    noOfStudents: (json['noOfStudents'] as num?)?.toDouble() ?? 0.0,
    noOfCourses: json['noOfCourses'] ?? 0,
    rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    joiningDate: json['joining_date'] ?? '',
    email: json['email'] ?? '',
    phoneNo: json['phoneNo'] ?? '',
    verificationDetailList:  (json['verification_detail_list'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [],
    about: json['about'] ?? '',
    instagramAccount: json['instagramAccount'] ?? '',
    faceBookAccount: json['faceBookAccount'] ?? '',
    youTubeChannel: json['youTubeChannel'] ?? '',
    identityProf: json['identityProf'] ?? '',
    qualificationProf: json['qualificationProf'] ?? '',
  );
}