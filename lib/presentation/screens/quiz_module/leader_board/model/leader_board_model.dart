class LeaderBoardModel {
  int id;
  String name;
  String image;
  String email;
  String phoneNo;
  int totalCoins;
  String date;
  int rank;

  LeaderBoardModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.phoneNo,
    required this.totalCoins,
    required this.date,
    required this.rank,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      LeaderBoardModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        email: json['email'] ?? '',
        phoneNo: json['phoneNo'] ?? '',
        totalCoins: json['totalCoins'] ?? 0,
        date: json['date'] ?? '',
        rank: json['rank'] ?? 0,
      );
}
