class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String? status;
  final String? category;
  final String? location;
  final List<String> images;
  final String? startDate;
  final String? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.status,
    this.category,
    this.location,
    this.images = const [],
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  String? get coverImage => images.isNotEmpty ? images.first : null;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: (json['id'] ?? json['uuid'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: json['status']?.toString(),
      category: json['category']?.toString(),
      location: json['location']?.toString(),
      images: _mapImages(json['image_urls']),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'image_urls': images,
      'start_date': startDate,
      'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? category,
    String? location,
    List<String>? images,
    String? startDate,
    String? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      location: location ?? this.location,
      images: images ?? this.images,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static List<String> _mapImages(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }
}
