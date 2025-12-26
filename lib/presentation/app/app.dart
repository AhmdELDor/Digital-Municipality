import 'dart:async';

import 'package:education_admin_portal/presentation/app/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/connectivity_helper.dart';
import '../../core/themes/app_themes.dart';

import 'app_route.dart';

class EducationAdminPortal extends StatefulWidget {
  final ConnectivityHelper connectivityHelper;

  const EducationAdminPortal({super.key, required this.connectivityHelper});

  @override
  State<EducationAdminPortal> createState() => _EducationAdminPortalState();
}

class _EducationAdminPortalState extends State<EducationAdminPortal> {
  final themeController = Get.put(ThemeController());
  final RxBool hasInternet = true.obs;

  late StreamSubscription internetSub;
  // @override
  // void initState() {
  //   //widget.connectivityHelper.initialize() ;
  //   super.initState();
  //   widget.connectivityHelper.initialize();
  //
  //   internetSub = widget.connectivityHelper.onConnectivityChanged.listen((
  //     connected,
  //   ) {
  //     hasInternet.value = connected;
  //     if (!connected) {
  //       //Get.toNamed(AppRouteName.noInternetView,);
  //     } else {
  //       Get.back();
  //     }
  //   });
  //   // initFirebase();
  // }

  // @override
  // void dispose() {
  //   widget.connectivityHelper.dispose();
  //   internetSub.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      
      // Localization configuration
      locale: const Locale('ar', ''), // Set Arabic as default
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: AppRoute.appRouter,
      builder: (context, child) {
        themeController.updateStatusBarColor(context);
        return Directionality(
          textDirection: TextDirection.rtl, // Force RTL for Arabic
          child: child!,
        );
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
