class DashboardStats {
  final int totalUsers;
  final int totalComplaints;
  final int pendingRequests;
  final int activeBills;
  final int totalProjects;
  final int activePolls;
  final int totalCirculars;
  final int todayNotifications;

  DashboardStats({
    required this.totalUsers,
    required this.totalComplaints,
    required this.pendingRequests,
    required this.activeBills,
    required this.totalProjects,
    required this.activePolls,
    required this.totalCirculars,
    required this.todayNotifications,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['total_users'] ?? 0,
      totalComplaints: json['total_complaints'] ?? 0,
      pendingRequests: json['pending_requests'] ?? 0,
      activeBills: json['active_bills'] ?? 0,
      totalProjects: json['total_projects'] ?? 0,
      activePolls: json['active_polls'] ?? 0,
      totalCirculars: json['total_circulars'] ?? 0,
      todayNotifications: json['today_notifications'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'total_complaints': totalComplaints,
      'pending_requests': pendingRequests,
      'active_bills': activeBills,
      'total_projects': totalProjects,
      'active_polls': activePolls,
      'total_circulars': totalCirculars,
      'today_notifications': todayNotifications,
    };
  }
}
