class OtherInformation {
  final String specialization;
  final String about;

  OtherInformation({
    this.specialization = '',
    this.about = '',
  });

  factory OtherInformation.fromJson(Map<String, dynamic> json) {
    return OtherInformation(
      specialization: json['specialization'] ?? '',
      about: json['about'] ?? '',
    );
  }

  factory OtherInformation.empty() => OtherInformation();
}
