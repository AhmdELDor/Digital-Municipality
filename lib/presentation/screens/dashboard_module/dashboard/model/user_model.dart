class UserModel {
  int id;
  String name;
  String image;
  String review;
  int rate;
  String email;
  String phoneNo;
  String description;

  UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.review,
    required this.rate,
    required this.email,
    required this.phoneNo,
    required this.description,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    review: json['review'] ?? '',
    rate: json['rate'] ??0,
    email: json['email'] ?? '',
    phoneNo: json['phoneNo'] ?? '',
    description: json['description'] ?? '',

  );
}