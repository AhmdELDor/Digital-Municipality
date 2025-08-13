class ClassApprovalModel {
  int id;
  String name;
  String date;
  String time;
  String instructorName;
  String instructorProfileImg;

  ClassApprovalModel({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.instructorName,
    required this.instructorProfileImg,
  });

  factory ClassApprovalModel.fromJson(Map<String, dynamic> json) => ClassApprovalModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    instructorName: json['instructorName'] ?? '',
    instructorProfileImg: json['instructorProfileImg'] ?? '',
  );
}