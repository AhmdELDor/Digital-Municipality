class PollModel {
  final String id;
  final String title;
  final String? description;
  final Map<String, int> options;
  final DateTime? startAt;
  final DateTime? endAt;
  final String status;
  final int votesCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PollModel({
    required this.id,
    required this.title,
    this.description,
    required this.options,
    this.startAt,
    this.endAt,
    required this.status,
    required this.votesCount,
    this.createdAt,
    this.updatedAt,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      options: _parseOptions(json['options']),
      startAt: json['start_at'] != null ? DateTime.tryParse(json['start_at'].toString()) : null,
      endAt: json['end_at'] != null ? DateTime.tryParse(json['end_at'].toString()) : null,
      status: json['status']?.toString() ?? 'pending',
      votesCount: int.tryParse(json['votes_count']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  static Map<String, int> _parseOptions(dynamic raw) {
    if (raw is Map) {
      final result = <String, int>{};
      raw.forEach((key, value) {
        result[key.toString()] = int.tryParse(value.toString()) ?? 0;
      });
      return result;
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'options': options,
      if (startAt != null) 'start_at': startAt!.toIso8601String(),
      if (endAt != null) 'end_at': endAt!.toIso8601String(),
      'status': status,
      'votes_count': votesCount,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  int get totalVotes => options.values.fold(0, (sum, count) => sum + count);

  List<MapEntry<String, int>> get sortedOptions {
    final entries = options.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  double getPercentage(String option) {
    if (totalVotes == 0) return 0.0;
    final votes = options[option] ?? 0;
    return (votes / totalVotes) * 100;
  }

  String get statusArabic {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'نشط';
      case 'ended':
        return 'منتهي';
      default:
        return status;
    }
  }

  bool get isActive => status == 'in_progress';
  bool get hasEnded => status == 'ended';
}
