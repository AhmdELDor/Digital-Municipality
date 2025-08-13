enum OtpScreenType { register, forgotPassword }

extension OtpScreenTypeExtension on OtpScreenType {
  int get intValue {
    switch (this) {
      case OtpScreenType.forgotPassword:
        return 2;
      case OtpScreenType.register:
        return 1;
    }
  }
}
