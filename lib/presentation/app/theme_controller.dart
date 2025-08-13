import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  void _loadTheme() async {
    final box = GetStorage();
    if (box.hasData('isDarkMode')) {
      _isDarkMode.value = box.read('isDarkMode');
    }
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    final box = GetStorage();
    box.write('isDarkMode', _isDarkMode.value);
    // update();
  }

  void updateStatusBarColor(BuildContext context) {
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      (GetPlatform.isIOS)
          ? theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle(
              statusBarIconBrightness: theme.brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark, // Status bar icon color
            ),
    );
  }
}
