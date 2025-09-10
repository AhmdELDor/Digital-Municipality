class Summary {
  final SummaryMetric totalStudents;
  final SummaryMetric totalRevenue;
  final SummaryMetric courseCompletionRate;
  final SummaryMetric activeInstructors;
  final SummaryMetric newUsersToday;
  final SummaryMetric activeCourses;

  final SummaryMetric profileTotalRevenue;
  final SummaryMetric profileTotalStudents;
  final SummaryMetric profileNewUsersToday;

  Summary({
    required this.totalStudents,
    required this.totalRevenue,
    required this.courseCompletionRate,
    required this.activeInstructors,
    required this.newUsersToday,
    required this.activeCourses,
    required this.profileTotalRevenue,
    required this.profileTotalStudents,
    required this.profileNewUsersToday,
  });
  factory Summary.empty() => Summary(
    totalStudents: SummaryMetric.empty(),
    totalRevenue: SummaryMetric.empty(),
    courseCompletionRate: SummaryMetric.empty(),
    activeInstructors: SummaryMetric.empty(),
    newUsersToday: SummaryMetric.empty(),
    activeCourses: SummaryMetric.empty(),
    profileTotalRevenue: SummaryMetric.empty(),
    profileTotalStudents: SummaryMetric.empty(),
    profileNewUsersToday: SummaryMetric.empty(),


  );
  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalStudents: SummaryMetric.fromJson(json["totalStudents"]),
    totalRevenue: SummaryMetric.fromJson(json["totalRevenue"]),
    courseCompletionRate:
    SummaryMetric.fromJson(json["courseCompletionRate"]),
    activeInstructors: SummaryMetric.fromJson(json["activeInstructors"]),
    newUsersToday: SummaryMetric.fromJson(json["newUsersToday"]),
    activeCourses: SummaryMetric.fromJson(json["activeCourses"]),

    profileTotalRevenue: SummaryMetric.fromJson(json["total_revenue"]),
    profileTotalStudents: SummaryMetric.fromJson(json["total_students"]),
    profileNewUsersToday: SummaryMetric.fromJson(json["new_users_today"]),
  );
}




class SummaryMetric {
  final int value;
  final int changePercent;
  final bool isPositive;
  final String logo;

  SummaryMetric({
    required this.value,
    required this.changePercent,
    required this.isPositive,
    required this.logo,
  });

  factory SummaryMetric.empty() =>
      SummaryMetric(value: 0, changePercent: 0, isPositive: true, logo: '');

  factory SummaryMetric.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SummaryMetric.empty();
    return SummaryMetric(
      value: json["value"] ?? 0,
      changePercent: json["changePercent"] ?? 0,
      isPositive: json["isPositive"] ?? true,
      logo: json["logo"] ?? '',
    );
  }
}
