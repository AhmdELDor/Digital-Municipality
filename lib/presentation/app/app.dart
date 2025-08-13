import 'dart:async';

import 'package:education_admin_portal/presentation/app/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/connectivity_helper.dart';
import '../../core/themes/app_themes.dart';

import 'app_route.dart';

class EducationApp extends StatefulWidget {
  final ConnectivityHelper connectivityHelper;

  const EducationApp({super.key, required this.connectivityHelper});

  @override
  State<EducationApp> createState() => _EducationAppState();
}

class _EducationAppState extends State<EducationApp> {
  final themeController = Get.put(ThemeController());
  final RxBool hasInternet = true.obs;

  late StreamSubscription internetSub;
  @override
  void initState() {
    //widget.connectivityHelper.initialize() ;
    super.initState();
    widget.connectivityHelper.initialize();

    internetSub = widget.connectivityHelper.onConnectivityChanged.listen((
      connected,
    ) {
      hasInternet.value = connected;
      if (!connected) {
        //Get.toNamed(AppRouteName.noInternetView,);
      } else {
        Get.back();
      }
    });
    // initFirebase();
  }

  @override
  void dispose() {
    widget.connectivityHelper.dispose();
    internetSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: AppRoute.appRouter,
      builder: (context, child) {
        themeController.updateStatusBarColor(context);
        return child!;
      },
    );
    // GetMaterialApp(
    //   navigatorObservers: [routeObserver],
    //   debugShowCheckedModeBanner: false,
    //   themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    //   theme: AppTheme.lightTheme,
    //   darkTheme: AppTheme.darkTheme,
    //   //initialRoute: AppRouteName.splashView,
    //   initialRoute: AppRouteName.signInView,
    //
    //   getPages: AppRoute.routes,
    //   builder: (context, child) {
    //     themeController.updateStatusBarColor(context);
    //     return child!;
    //   },
    // ),
  }
}
