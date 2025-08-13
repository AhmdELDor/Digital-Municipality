import 'package:flutter/material.dart';

bool isTablet(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > 768; // Return true if screen width > 768 (Tablet/iPad)
}