class NoteModel {
  int id;
  String name;
  String backgroundImage;
  String date;
  String description;
  String notesColor;

  NoteModel({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.date,
    required this.description,
    required this.notesColor,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    backgroundImage: json['backgroundImage'] ?? '',
    date: json['date'] ?? '',
    description: json['description'] ?? '',
    notesColor: json['notesColor'] ?? '',
  );
}
