class ClassModel {
  int id = 0;
  String name = '';
  String image = '';
  String title = '';
  String time = '';
  String instructor = '';
  String description = '';

  ClassModel({
    required this.id,
    required this.name,
    required this.image,
    required this.title,
    required this.time,
    required this.instructor,
    required this.description,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      instructor: json['instructor'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
