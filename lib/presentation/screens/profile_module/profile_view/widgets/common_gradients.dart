import 'dart:math' as math;

import 'package:flutter/material.dart';

profileTotalRevenueGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(263.22 * (3.1416 / 180)), // convert deg → radians
    colors: const [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFFFE2F0), // #FFE2F0
    ],
    stops: const [0.1663, 1.0], // 16.63% and ~100%
  );
}

profileTotalRevenueDarkGradient() {
  return LinearGradient(
    colors: const [
      Color(0xFF000000), // #000000
      Color(0xFF37051D), // #37051D
    ],
    stops: const [0.1663, 1.0], // 16.63% and 100%
    transform: GradientRotation(263.22 * (3.1416 / 180)), // convert degrees → radians
  );
}

profileTotalStudentsGradient() {
  return LinearGradient(
    colors: const [
      Color(0xFFFAFCFF),                 // #FAFCFF
      Color.fromRGBO(255, 248, 234, 0.5) // rgba(255, 248, 234, 0.5)
    ],
    stops: const [0.1775, 1.0], // 17.75% and clamped ~100%
    transform: GradientRotation(262.87 * math.pi / 180), // degrees → radians
  );
}

profileTotalStudentsDarkGradient() {
  return LinearGradient(
    colors: const [
      Color(0xFF000000),                  // #000000
      Color.fromRGBO(61, 43, 4, 0.5),     // rgba(61, 43, 4, 0.5)
    ],
    stops: const [0.1775, 1.0], // 17.75% and clamped ~100%
    transform: GradientRotation(262.87 * math.pi / 180), // degrees → radians
  );
}

profileNewUsersGradient() {
  return LinearGradient(
    colors: const [
      Color(0xFFFAFCFF), // #FAFCFF
      Color(0xFFF0F3FF), // #F0F3FF
    ],
    stops: const [
      0.0, // Flutter clamps negative (-3.05%) → 0.0
      1.0, // Flutter clamps >100% (151.03%) → 1.0
    ],
    transform: GradientRotation(258.37 * math.pi / 180), // deg → radians
  );
}

profileNewUsersDarkGradient() {
  return LinearGradient(
    colors: const [
      Color(0xFF000000), // #000000
      Color(0xFF141B37), // #141B37
    ],
    stops: const [
      0.0, // Flutter clamps -3.05% → 0.0
      1.0, // Flutter clamps 151.03% → 1.0
    ],
    transform: GradientRotation(258.37 * math.pi / 180), // deg → radians
  );
}