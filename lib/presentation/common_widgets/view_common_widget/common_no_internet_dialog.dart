//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/app_strings.dart';
// import '../../app/theme_controller.dart';
// import '../widgets/button.dart';
//
// // void showFullScreenDialog(BuildContext context) {
// void showNoInternetFullScreenDialog(BuildContext context) {
//   bool isDarkMode = Get.find<ThemeController>().isDarkMode;
//   Get.dialog(
//     AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor:
//         Theme.of(context).colorScheme.surface,
//         // Desired status bar color
//         statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
//         statusBarIconBrightness:
//             isDarkMode ? Brightness.light : Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor:
//             Theme.of(context).colorScheme.surface,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       CommonImageAssets.noConnectionIcon,
//                       height: 107,
//                     ),
//                     Gap(16),
//                     CommonText.semiBold(ConnectionStrings.noConnection, size: 16),
//                     Gap(4),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: CommonText.regular(
//                         ConnectionStrings.noInternetFound,
//                         size: 14,
//                         textAlign: TextAlign.center,
//                         color:
//                            AppColors.greyscale400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: MediaQuery.of(context).padding.bottom + 20,
//                 left: 16,
//                 right: 16,
//                 child: PrimaryButton(
//                   onPressed: () {},
//                   label: ConnectionStrings.tryAgain,
//                   height: 48,
//                   borderRadius: 8,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//     barrierDismissible: true,
//   );
// }
//
// /* showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'FullScreenDialog',
//     pageBuilder: (_, __, ___) {
//       return Scaffold(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(AppCommonIcon.noConnectionIcon,height: 107,),
//                     Gap(16),
//                     CommonText.semiBold(HomeStrings.noConnection, size: 16),
//                     Gap(4),
//                     CommonText.regular(
//                       HomeStrings.noInternetFound,
//                       size: 14,
//                       textAlign: TextAlign.center,
//                       color:
//                       Get.find<ThemeController>().isDarkMode
//                           ? AppDarkThemeColors.appBGGreyColor4
//                           : AppLightThemeColors.appBGGreyColor4,
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: MediaQuery.of(context).padding.bottom,
//                 left: 0,
//                 right: 0,
//                 child: PrimaryButton(
//                   onPressed: () {},
//                   label: HomeStrings.tryAgain,
//                   height: 48,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//     transitionDuration: Duration(milliseconds: 300),
//     transitionBuilder: (_, anim, __, child) {
//       return SlideTransition(
//         position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
//         child: child,
//       );
//     },
//   );*/
// // }
