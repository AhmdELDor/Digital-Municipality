import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/widgets/button.dart';
import '../../../common_widgets/widgets/image.dart';
import '../../../common_widgets/widgets/text.dart';
import '../controller/add_course_controller.dart';

Widget buildStepTab(
    int index,
    String label,
    String image,
    String activeImage,
    BuildContext context

    ) {
  AddCourseController controller = Get.put(AddCourseController());
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  final current = controller.selectedIndex.value;
  final isSelected = current == index;
  final isCompleted = current > index;

  if (isSelected) {
    // ✅ Active step → show image tab only
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkBg2Color : AppColors.primary50,
        border: Border(
          bottom: BorderSide(color: AppColors.primary500, width: 1),
        ),
      ),

      child: customTab(label, image, activeImage,context, isSelected: true),
    );
  } else {
    // ⭕ Not active → dotted circle with step number inside
    return CustomPaint(
      painter: DottedCirclePainter(
        color: isCompleted
            ? AppColors
            .primary500 // blue for completed
            : AppColors.greyColor.withValues(alpha: 0.5), // grey for upcoming
      ),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: CommonText.medium(
            '0${index + 1}',
            size: 12,
            color: isCompleted
                ? AppColors.primary500
                : AppColors.greyTextColor,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

Widget customTab(
    String label,
    String image,
    String activeImage,
    BuildContext context,
    {
      required bool isSelected,
    }) {
  var mobileView = ResponsiveView.isMobile(context);
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgImageFromAsset(
          isSelected ? activeImage : image,
          height: mobileView ? 18 : 24,
          width: mobileView ? 18 : 24,
        ),
        Gap(7),
        CommonText.semiBold(
          label,
          size: mobileView ? 12 : 16,
          color: isSelected ? AppColors.primary500 : AppColors.bodyTextColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ],
    ),
  );
}

Widget bottomButton() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Row(
    children: [
      PrimaryButton(
        height: 42,
        onPressed: () {},
        label: AddCoursesStrings.previous,
        textSize: 16,
        textWeight: FontWeight.w500,
        backgroundColor: AppColors.lightBgColor,
        borderSide: BorderSide(color: AppColors.lightBorderColor, width: 1),
        textColor: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
      ),
      PrimaryButton(
        height: 42,
        onPressed: () {},
        label: AddCoursesStrings.saveAndNext,
        textSize: 16,
        textWeight: FontWeight.w500,
      ),
    ],
  );
}
class DottedCirclePainter extends CustomPainter {
  final Color color;

  DottedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint dotPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5;

    final int dotsCount = 20;
    for (int i = 0; i < dotsCount; i++) {
      double angle = (2 * 3.1415926 * i) / dotsCount;
      final double x = radius + radius * 0.95 * cos(angle);
      final double y = radius + radius * 0.95 * sin(angle);
      canvas.drawPoints(PointMode.points, [Offset(x, y)], dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}