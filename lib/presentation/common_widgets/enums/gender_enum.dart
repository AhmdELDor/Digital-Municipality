enum Gender { men, women, boys, girls }

extension GenderExtension on Gender {
  String get label {
    switch (this) {
      case Gender.men:
        return "Men";
      case Gender.women:
        return "Women";
      case Gender.boys:
        return "Boys";
      case Gender.girls:
        return "Girls";
    }
  }
}
