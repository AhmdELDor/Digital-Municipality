class ComplaintModel {
  final String id;
  final String title;
  final String desc;
  final ComplaintUser user;
  final List<String> images;
  final String status;
  final String? result;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ComplaintModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.user,
    this.images = const [],
    required this.status,
    this.result,
    this.createdAt,
    this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      desc: (json['desc'] ?? '').toString(),
      user: ComplaintUser.fromJson(json['user'] ?? {}),
      images: _mapImages(json['images_url']),
      status: (json['status'] ?? 'received').toString(),
      result: json['result']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'user': user.toJson(),
      'images_url': images,
      'status': status,
      'result': result,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  static List<String> _mapImages(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }
}

class ComplaintUser {
  final String fullName;
  final String phoneNumber;

  const ComplaintUser({
    required this.fullName,
    required this.phoneNumber,
  });

  factory ComplaintUser.fromJson(Map<String, dynamic> json) {
    return ComplaintUser(
      fullName: (json['full_name'] ?? '').toString(),
      phoneNumber: (json['phonenumber'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phonenumber': phoneNumber,
    };
  }
}
