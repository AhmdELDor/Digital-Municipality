class CourseCategoryModel {
  int id;
  String name;
  String image;
  int noOfCourses;
  double noOfPeople;
  double noOfAttendees;

  CourseCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.noOfCourses,
    required this.noOfPeople,
    required this.noOfAttendees,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) => CourseCategoryModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    noOfCourses: json['noOfCourses'] ?? 0,
    noOfPeople: (json['noOfPeople'] as num?)?.toDouble() ?? 0.0,
    noOfAttendees: (json['noOfAttendees'] as num?)?.toDouble() ?? 0.0,
  );
}