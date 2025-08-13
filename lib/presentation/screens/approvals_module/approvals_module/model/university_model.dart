class UniversityModel {
  int id;
  String name;
  String image;
  String date;
  String email;
  String phoneNo;
  List<String>verificationDetailList=[];

  UniversityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
    required this.email,
    required this.phoneNo,
    required this.verificationDetailList,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) => UniversityModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    date: json['date'] ?? '',
    email: json['email'] ?? '',
    phoneNo: json['phoneNo'] ?? '',
    verificationDetailList:  (json['verification_detail_list'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [],

  );
}