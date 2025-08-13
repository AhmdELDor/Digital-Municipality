import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import 'image.dart';

class SocialButtonWithTitle extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;
  final ColorFilter? colorFilter;

  const SocialButtonWithTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.greyColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgImageFromAsset(
                  icon,
                  colorFilter: colorFilter,
                ),
                const Gap(7),
                Flexible(
                  child: CommonText.medium(
                    title,
                    size: 16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

