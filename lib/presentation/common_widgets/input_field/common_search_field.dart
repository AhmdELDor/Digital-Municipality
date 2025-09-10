import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';

class CommonSearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldSetter<String>? onSubmitted;
  final FormFieldSetter<String>? onChanged;
  final VoidCallback? onSearchTap;
  final VoidCallback? onSuffixPressed;
  final VoidCallback? onPrefixPressed;
  final String? hintText;
  final String? labelText;
  final bool? autofocus;
  final bool? readOnly;
  final bool? suffixHide;
  final Widget? suffixWidget;

  const CommonSearchField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.onSearchTap,
    this.autofocus,
    this.readOnly,
    this.onSuffixPressed,
    this.suffixWidget,
    this.onPrefixPressed,
    this.suffixHide = true,
  });

  @override
  State<CommonSearchField> createState() => _CommonSearchFieldState();
}

class _CommonSearchFieldState extends State<CommonSearchField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly ?? false,
      autofocus: widget.autofocus ?? false,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      onTap: widget.onSearchTap,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Get.find<ThemeController>().isDarkMode
            ? AppColors.headingsLightColor
            : AppColors.headingsColor,
      ),
      controller: widget.controller,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: ShapeBorderRadius.small,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.small,
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.greyColor,

            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.small,
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.greyColor,

            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.small,
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.greyColor,

            width: 1,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: ShapeBorderRadius.small,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: ShapeBorderRadius.small,
        ),
        fillColor: Colors.transparent,
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Get.find<ThemeController>().isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 20),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8, left: 15, right: 3, bottom: 9),
              child: SvgPicture.asset(
                AppCommonIcon.searchIcon,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  Get.find<ThemeController>().isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Gap(8),
            Container(
              width: 1,
              height: 24,
              color: Get.find<ThemeController>().isDarkMode
                  ? AppColors.grey100Color
                  : AppColors.headingsLightColor,
            ),
          ],
        ),
        suffixIcon:
            /* widget.suffixHide ?? true
                ? const SizedBox.shrink()
                :*/
            widget.suffixWidget ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   width: 1,
                //   height: 18,
                //   color: Get.find<ThemeController>().isDarkMode
                //       ? AppColors.headingsDarkColor
                //       : AppColors.grey100Color,
                // ),
                Gap(10),
                // InkWell(
                //   onTap: widget.onSuffixPressed, // onSuffixPressed,
                //   child: const SvgImageFromAsset.square(
                //     AppCommonIcon.microphoneIcon,
                //     fit: BoxFit.scaleDown,
                //     colorFilter: ColorFilter.mode(
                //       AppColors.primary600,
                //       BlendMode.srcIn,
                //     ),
                //   ),
                // ),
              ],
            ),
      ),
    );
  }
}
