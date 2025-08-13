import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Check if a screen exists by checking if its controller is initialized
bool isScreenExists<T extends GetxController>() {
  return Get.isRegistered<T>();
}

void showSnackBar({String title = "", String desc = ""}) {
  Get.snackbar(
    title,
    desc,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 3),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    icon: const Icon(size: 40, Icons.check_circle, color: Colors.white),
  );
}
