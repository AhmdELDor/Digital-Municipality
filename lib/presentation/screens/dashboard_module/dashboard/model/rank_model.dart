class RankModel {
  int rank;
  String name;
  int points;
  String image;
RankModel.empty():rank=0,name='',points=0,image='';
  RankModel({
    required this.rank,
    required this.name,
    required this.points,
    required this.image,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) => RankModel(
    rank: json['rank'] ?? 0,
    name: json['name'] ?? '',
    points: json['points'] ?? 0,
    image: json['image'] ?? '',
  );
}