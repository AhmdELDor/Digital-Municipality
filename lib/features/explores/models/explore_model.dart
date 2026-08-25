class ExploreModel {
  final String id;
  final String title;
  final String desc;
  final String? category;
  final String type;
  final String citizenId;
  final CitizenInfo? citizen;
  final List<String> imagesUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ExploreModel({
    required this.id,
    required this.title,
    required this.desc,
    this.category,
    required this.type,
    required this.citizenId,
    this.citizen,
    required this.imagesUrl,
    this.startDate,
    this.endDate,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ExploreModel.fromJson(Map<String, dynamic> json) {
    return ExploreModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      category: json['category']?.toString(),
      type: json['type']?.toString() ?? 'post',
      citizenId: json['citizen_id']?.toString() ?? '',
      citizen: json['citizen'] != null
          ? CitizenInfo.fromJson(json['citizen'] as Map<String, dynamic>)
          : null,
      imagesUrl: json['images_url'] != null
          ? (json['images_url'] is List
              ? List<String>.from(json['images_url'])
              : [])
          : [],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      status: json['status']?.toString() ?? 'pending',
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
      'desc': desc,
      if (category != null) 'category': category,
      'type': type,
      'citizen_id': citizenId,
      'images_url': imagesUrl,
      if (startDate != null) 'start_date': startDate!.toIso8601String().split('T')[0],
      if (endDate != null) 'end_date': endDate!.toIso8601String().split('T')[0],
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  String get typeArabic {
    switch (type) {
      case 'promotion':
        return 'عروضات';
      case 'post':
        return 'منشور';
      default:
        return type;
    }
  }

  String get statusArabic {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'موافق عليه';
      default:
        return status;
    }
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isPromotion => type == 'promotion';
  bool get isPost => type == 'post';
  bool get hasImages => imagesUrl.isNotEmpty;
  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());
  bool get isActive => isApproved && !isExpired;
}

class CitizenInfo {
  final String id;
  final String fullName;
  final String phonenumber;

  const CitizenInfo({
    required this.id,
    required this.fullName,
    required this.phonenumber,
  });

  factory CitizenInfo.fromJson(Map<String, dynamic> json) {
    return CitizenInfo(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      phonenumber: json['phonenumber']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phonenumber': phonenumber,
    };
  }
}
