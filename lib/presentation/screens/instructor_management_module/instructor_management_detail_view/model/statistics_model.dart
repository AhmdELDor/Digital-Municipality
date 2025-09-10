class StatisticsModel {
  String? image;
  String? data;

  StatisticsModel({this.image, this.data});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(image: json['image'], data: json['data']);
  }
}
