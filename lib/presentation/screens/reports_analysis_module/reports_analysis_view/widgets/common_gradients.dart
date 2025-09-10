import 'package:flutter/material.dart';

totalStudentGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: const GradientRotation(
      262.87 * (3.1415926535 / 180),
    ), // convert deg to rad
    colors: [
      Color(0xFFFAFCFF), // #FAFCFF
      Color.fromRGBO(255, 248, 234, 0.5), // rgba(255, 248, 234, 0.5)
    ],
    stops: [0.1775, 1.3864], // match 17.75% and 138.64%
  );
}

totalStudentDarkGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      262.87 * (3.1415926535 / 180),
    ), // convert degrees to radians
    colors: [
      Color(0xFF000000), // #000000
      Color.fromRGBO(61, 46, 12, 0.5), // rgba(61, 46, 12, 0.5)
    ],
    stops: [
      0.1775,
      1.0,
    ], // normalized: 17.75% → 0.1775, 138.64% → capped at 1.0
  );
}

totalRevenueGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      263.22 * (3.1415926535 / 180),
    ), // convert degrees to radians
    colors: [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFE2EDFF), // #E2EDFF
    ],
    stops: [
      0.1663, // 16.63% → 0.1663
      1.0, // 188.96% → capped at 1.0 (Flutter only accepts 0–1)
    ],
  );
}

totalRevenueDarkGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      263.22 * (3.1415926535 / 180),
    ), // convert degrees to radians
    colors: [
      Color(0xFF000000), // #000000
      Color(0xFF152C4D), // #152C4D
    ],
    stops: [
      0.1663, // 16.63% → 0.1663
      1.0, // 188.96% capped at 1.0
    ],
  );
}

courseCompletionGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      262.95 * (3.1415926535 / 180),
    ), // degrees → radians
    colors: [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFFFF3FE), // #FFF3FE
    ],
    stops: [
      0.0685, // 6.85% → 0.0685
      1.0, // 148.55% → capped at 1.0
    ],
  );
}

courseCompletionDarkGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      262.95 * (3.1415926535 / 180),
    ), // convert deg → rad
    colors: [
      Color(0xFF000000), // #000000
      Color(0xFF270D25), // #270D25
    ],
    stops: [
      0.0685, // 6.85% → 0.0685
      1.0, // 148.55% capped at 1.0 (Flutter only accepts 0–1)
    ],
  );
}

activeInstructorGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      263.05 * (3.1415926535 / 180),
    ), // deg → rad
    colors: [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFEDFFF3), // #EDFFF3
    ],
    stops: [
      0.0, // -5.32% → clamped to 0.0 (Flutter doesn’t allow negative stops)
      1.0, // 142.14% → capped at 1.0
    ],
  );
}

activeInstructorDarkGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      263.05 * (3.1415926535 / 180),
    ), // deg → rad
    colors: [
      Color(0xFF000000), // #000000
      Color(0xFF091D10), // #091D10
    ],
    stops: [
      0.0, // -5.32% → clamped to 0.0
      1.0, // 142.14% → capped at 1.0
    ],
  );
}

newUsersGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      258.37 * (3.1415926535 / 180),
    ), // deg → rad
    colors: [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFF0F3FF), // #F0F3FF
    ],
    stops: [
      0.0, // -3.05% → clamped to 0.0
      1.0, // 151.03% → capped at 1.0
    ],
  );
}

newUsersDarkGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      258.37 * (3.1415926535 / 180),
    ), // deg → rad
    colors: [
      Color(0xFF000000), // #000000
      Color(0xFF141B37), // #141B37
    ],
    stops: [
      0.0, // -3.05% → clamped to 0.0
      1.0, // 151.03% → capped at 1.0
    ],
  );
}

activeCoursesGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      258.37 * (3.1415926535 / 180),
    ), // deg → rad
    colors: [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFF0F3FF), // #F0F3FF
    ],
    stops: [
      0.0, // -3.05% → clamped to 0.0
      1.0, // 151.03% → capped at 1.0
    ],
  );
}

activeCoursesDarkGradient() {
  return LinearGradient(
    transform: const GradientRotation(
      263.57 * (3.1415926535 / 180),
    ), // deg → rad
    colors: [
      Color(0xFF000000), // #000000
      Color(0xFF211326), // #211326
    ],
    stops: [
      0.0, // -9.42% → clamped to 0.0
      1.0, // 132.76% → capped at 1.0
    ],
  );
}

