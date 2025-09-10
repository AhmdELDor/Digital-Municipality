class LanguageModel {
  int id;
  String name;

  LanguageModel({required this.id, required this.name});

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      LanguageModel(id: json['id'] ?? 0, name: json['name'] ?? '');
}
