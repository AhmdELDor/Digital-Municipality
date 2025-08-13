enum UserTypeEnum {
  golfer,
  retailer,
  caddy,
}

extension UserTypeEnumExtension on UserTypeEnum {
  String get stringValue {
    switch (this) {
      case UserTypeEnum.golfer:
        return "Golfer";
      case UserTypeEnum.retailer:
        return "Retailer";
      case UserTypeEnum.caddy:
        return "Caddy";
    }
  }
}
