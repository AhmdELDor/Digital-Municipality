import 'package:flutter/material.dart';

extension $StringExtension on String {
  Color hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
