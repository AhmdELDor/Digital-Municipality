class CategoryModel {
  int id;
  String name;
  String image;
  int noOfCourses;
  double noOfPeople;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.noOfCourses,
    required this.noOfPeople,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    noOfCourses: json['noOfCourses'] ?? 0,
    noOfPeople: (json['noOfPeople'] as num?)?.toDouble() ?? 0.0,
  );
}