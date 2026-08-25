class CircularModel {
  final String id;
  final String title;
  final String? content;
  final String? imageUrl;
  final DateTime? publishedAt;
  final bool isPublished;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CircularModel({
    required this.id,
    required this.title,
    this.content,
    this.imageUrl,
    this.publishedAt,
    required this.isPublished,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CircularModel.fromJson(Map<String, dynamic> json) {
    return CircularModel(
      id: (json['id'] ?? json['uuid'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: json['content']?.toString(),
      imageUrl: (json['image'] ?? json['image_url'])?.toString(),
      publishedAt: json['published_at'] != null 
          ? DateTime.tryParse(json['published_at'].toString()) 
          : null,
      isPublished: json['is_published'] == true || json['is_published'] == 1,
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': imageUrl,
      'is_published': isPublished,
      'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  CircularModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isPublished,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CircularModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isPublished: isPublished ?? this.isPublished,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
