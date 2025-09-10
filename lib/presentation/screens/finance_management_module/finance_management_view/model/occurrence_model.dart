class OccurrenceModel {
  int id;
  String name;

  OccurrenceModel({required this.id, required this.name});

  factory OccurrenceModel.fromJson(Map<String, dynamic> json) =>
      OccurrenceModel(id: json['id'] ?? 0, name: json['name'] ?? '');
}
