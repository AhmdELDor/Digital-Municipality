import 'dart:convert';
import '../../../reports_analysis_module/reports_analysis_view/model/summary_metric_model.dart';

class ProfileModel {
  int id = 0;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String joinedDate = '';
  String userRole = '';
  String userProfileImg = '';
  Location location;
  Summary statistics;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.joinedDate,
    required this.userRole,
    required this.userProfileImg,
    required this.location,
    required this.statistics,
  });
  ProfileModel.empty()
    : location = Location.empty(),
      statistics = Summary.empty();
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userProfileImg: json['user_profile_img'] ?? '',
      joinedDate: json['joined_date'] ?? '',
      userRole: json['user_role'] ?? '',

      location: json["location"] != null
          ? Location.fromJson(json["location"])
          : Location.empty(),
      statistics: json["statistics"] != null
          ? Summary.fromJson(json["statistics"])
          : Summary.empty(),

    );
  }


  factory ProfileModel.fromRawJson(String str) =>
      ProfileModel.fromJson(json.decode(str));


}

class Location {
  String country = '';
  String city = '';
  String postalCode = '';

  Location({
    required this.country,
    required this.city,
    required this.postalCode,
  });
  Location.empty();
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }


}


