class ContactInformation {
  final String name;
  final String email;
  final String phoneNo;

  ContactInformation({
    this.name = '',
    this.email = '',
    this.phoneNo = '',
  });

  factory ContactInformation.fromJson(Map<String, dynamic> json) {
    return ContactInformation(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
    );
  }

  factory ContactInformation.empty() => ContactInformation();
}
