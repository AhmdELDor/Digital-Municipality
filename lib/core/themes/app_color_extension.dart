import 'package:flutter/material.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  final Color success;
  final Color successLight;
  final Color failure;
  final Color failureLight;

  const AppColorTheme({
    required this.failure,
    required this.failureLight,
    required this.success,
    required this.successLight,
  });

  @override
  ThemeExtension<AppColorTheme> copyWith({
    Color? failure,
    Color? failureLight,
    Color? success,
    Color? successLight,
  }) {
    return AppColorTheme(
      failure: failure ?? this.failure,
      failureLight: failureLight ?? this.failureLight,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp(
      ThemeExtension<AppColorTheme>? other, double t) {
    if (other is! AppColorTheme) return this;
    return AppColorTheme(
      failure: Color.lerp(failure, other.failure, t) ?? failure,
      failureLight:
          Color.lerp(failureLight, other.failureLight, t) ?? other.failureLight,
      success: Color.lerp(success, other.success, t) ?? success,
      successLight:
          Color.lerp(successLight, other.successLight, t) ?? other.successLight,
    );
  }
}

extension AppColorThemeExtension on BuildContext {
  AppColorTheme get appColor {
    var extension = Theme.of(this).extension<AppColorTheme>();
    assert(extension != null);
    return extension!;
  }
}
