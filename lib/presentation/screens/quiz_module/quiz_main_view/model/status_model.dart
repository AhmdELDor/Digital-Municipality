class StatusModel {
  int id;
  String name;

  StatusModel({required this.id, required this.name});

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      StatusModel(id: json['id'] ?? 0, name: json['name'] ?? '');
}
