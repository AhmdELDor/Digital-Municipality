import 'package:education_admin_portal/core/constants/app_assets.dart';
import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme_controller.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final String? hintText;
  final List<T> items;
  final T? value;
  final String Function(T)? itemAsString;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final double borderRadius;
  final bool isExpanded;

  const CustomDropdownFormField({
    super.key,
    this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.itemAsString,
    this.borderRadius = 6,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: isExpanded,
      icon: SvgImageFromAsset(
        AppCommonIcon.downArrowIcon,
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
          BlendMode.srcIn,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode
            ? AppColors.mainDarkBgColor
            : AppColors.lightBgColor,
        hintStyle: TextStyle(
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),

        hintText: hintText,
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: CommonText.regular(
            itemAsString != null ? itemAsString!(item) : item.toString(),
            size: 14,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            fontWeight: FontWeight.w400,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class CustomCourseDropdownFormField<T> extends StatelessWidget {
  final String? hintText;
  final List<T> items;
  final T? value;
  final String Function(T)? itemAsString;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final double borderRadius;
  final bool isExpanded;

  const CustomCourseDropdownFormField({
    super.key,
    this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.itemAsString,
    this.borderRadius = 6,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: isExpanded,
      icon: SvgImageFromAsset(
        AppCommonIcon.downArrowIcon,
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
          BlendMode.srcIn,
        ),
      ),
      decoration: InputDecoration(
        // filled: true,
        // fillColor: isDarkMode?AppColors.mainDarkBgColor:AppColors.lightBgColor,
        hintStyle: TextStyle(
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.headingsLightColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.headingsLightColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),

        hintText: hintText,
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: CommonText.regular(
            itemAsString != null ? itemAsString!(item) : item.toString(),
            size: 14,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            fontWeight: FontWeight.w400,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
