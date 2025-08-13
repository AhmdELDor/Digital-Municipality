class NotificationModel {
  int id;
  String title;
  String msg;
  bool read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.msg,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        msg: json['msg'] ?? '',
        read: json['read'] ?? false,
      );
}
