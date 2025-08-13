// part of 'view_common_imports.dart';
//
// class CommonTitleAndMoreItemWidget extends StatelessWidget {
//   final String title;
//   final VoidCallback? onTap;
//   final bool? isShowMore;
//
//   const CommonTitleAndMoreItemWidget({
//     super.key,
//     required this.title,
//     this.onTap,
//     this.isShowMore,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CommonText.extraBold(title, size: 16),
//         if(isShowMore??true)
//         InkWell(
//           onTap: onTap,
//           child: Container(
//             width: 38,
//             height: 24,
//             decoration: BoxDecoration(
//               borderRadius: ShapeBorderRadius.medium,
//               color:
//                   Get.find<ThemeController>().isDarkMode
//                       ? AppColors.white.withValues(alpha: 0.08)
//                       : AppColors.primary300,
//             ),
//             alignment: Alignment.center,
//             child: SvgImageFromAsset(
//               AppCommonIcon.arrowLeftIcon,
//               colorFilter: ColorFilter.mode(
//                 Get.find<ThemeController>().isDarkMode
//                     ? AppColors.white
//                     : AppColors.greyscale800,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
