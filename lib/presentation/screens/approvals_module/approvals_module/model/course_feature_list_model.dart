class CourseFeatureListModel {
  String image = '';
  String name = '';
  CourseFeatureListModel({required this.image, required this.name});

  factory CourseFeatureListModel.fromJson(Map<String, dynamic> json) {
    return CourseFeatureListModel(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
