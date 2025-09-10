/// Payment History Model
class PaymentHistoryModel {
  int courseId;
  String courseImage;
  String courseName;
  double courseFees;
  String paymentDate;
  int coins;
  String paymentMethod;
  String status;

  PaymentHistoryModel({
    required this.courseId,
    required this.courseImage,
    required this.courseName,
    required this.courseFees,
    required this.paymentDate,
    required this.coins,
    required this.paymentMethod,
    required this.status,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      courseId: json['courseId'] ?? 0,
      courseImage: json['courseImage'] ?? '',
      courseName: json['courseName'] ?? '',
      courseFees: (json['courseFees'] != null)
          ? double.tryParse(json['courseFees'].toString()) ?? 0.0
          : 0.0,
      paymentDate: json['paymentDate'] ?? '',
      coins: json['coins'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? '',
    );
  }
}