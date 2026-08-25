class SuggestionModel {
  final String id;
  final String citizenId;
  final CitizenInfo citizen;
  final String desc;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SuggestionModel({
    required this.id,
    required this.citizenId,
    required this.citizen,
    required this.desc,
    this.createdAt,
    this.updatedAt,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'],
      citizenId: json['citizen_id'],
      citizen: CitizenInfo.fromJson(json['citizen']),
      desc: json['desc'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citizen_id': citizenId,
      'desc': desc,
    };
  }
}

class CitizenInfo {
  final String id;
  final String fullName;
  final String phonenumber;

  CitizenInfo({
    required this.id,
    required this.fullName,
    required this.phonenumber,
  });

  factory CitizenInfo.fromJson(Map<String, dynamic> json) {
    return CitizenInfo(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
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
