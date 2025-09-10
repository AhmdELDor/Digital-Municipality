class PaymentMethodModel {
  int id;
  String name;
  String image;
  int paymentReceivedNo;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.image,
    required this.paymentReceivedNo,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      paymentReceivedNo: json['payment_received_no'] ?? 0,
    );
  }
}