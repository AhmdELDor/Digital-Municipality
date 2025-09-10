import 'dart:math';

import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/view_common_widget/common_card_decoration.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/instructor_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../controller/reports_analysis_controller.dart';
import '../model/course_completion_rate_model.dart';
import '../model/summary_metric_model.dart';

Widget commonReportsCardView({
  required bool isDarkMode,
  required SummaryMetric data,
  required String name,
  required LinearGradient gradient,
  required bool mobileView,
  required EdgeInsetsGeometry margin
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    margin: margin ,
    decoration: BoxDecoration(
      border: Border.all(
        color: isDarkMode
            ? AppColors.grey100Color
            : AppColors.headingsLightColor,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(12),
      gradient: gradient,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            commonCacheImage(
              data.logo,
              ImagePlaceHolder.imagePlaceHolderDark,
              height: 20,
              width: 20,
              color: isDarkMode ? AppColors.white : null,
            ),
            Gap(3),
            Expanded(child: CommonText.light(name, size: 16,maxLines: 1,overflow: TextOverflow.ellipsis,)),
          ],
        ),
        Gap(40),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.medium(data.value.toString(), size: 18),
                  Gap(3),
                  CommonText.light(
                    ReportsAnalysis.comparingLastMonth,
                    size: 12,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: data.isPositive
                    ? AppColors.success600
                    : AppColors.error600,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgImageFromAsset(
                    data.isPositive
                        ? AppCommonIcon.positiveIcon
                        : AppCommonIcon.negativeIcon,
                  ),
                  Gap(5),
                  CommonText.medium(
                    '${data.changePercent.toString()}%',
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget courseCompletionRate() {
  ReportsAnalysisController controller = Get.put(ReportsAnalysisController());
  final double completion = controller.data.value.courseCompletion.currentRate
      .toDouble();
  final double remaining = 100 - completion;

  final List<CourseCompletionRateModel> bgData = [
    CourseCompletionRateModel('Completed', 100), // full solid background
  ];

  final List<CourseCompletionRateModel> fgData = [
    CourseCompletionRateModel('Completed', completion),
    CourseCompletionRateModel('Remaining', remaining),
  ];
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;

  return Container(
    decoration: commonCardDecoration(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: CommonText.medium(
            ReportsAnalysis.courseCompletionRate,
            size: 16,
          ),
        ),
        CommonDivider(),
        Gap(15),
        Center(
          child: SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 🔹 Background (solid #EAF4FF)
                SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<CourseCompletionRateModel, String>(
                      dataSource: bgData,
                      xValueMapper: (d, _) => d.x,
                      yValueMapper: (d, _) => d.y,
                      radius: '100%',
                      innerRadius: '75%',
                      pointColorMapper: (_, __) => const Color(0xFFEAF4FF),
                    ),
                  ],
                ),

                /// 🔹 Foreground (75% gradient arc)
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return SweepGradient(
                      startAngle: 226.42 * (pi / 180),
                      endAngle: (226.42 + 360) * (pi / 180),
                      center: const FractionalOffset(0.5207, 0.5369),
                      colors: const [
                        Color(0xFF1DEBD5),
                        Color(0xFF747FFF),
                        Color(0xFF33A6F3),
                        Color(0xFF1DEBD5),
                        Color(0xFF747FFF),
                      ],
                      stops: const [0.0, 0.35, 0.65, 0.85, 1.0],
                    ).createShader(bounds);
                  },
                  child: SfCircularChart(
                    series: <CircularSeries>[
                      DoughnutSeries<CourseCompletionRateModel, String>(
                        dataSource: fgData,
                        xValueMapper: (d, _) => d.x,
                        yValueMapper: (d, _) => d.y,
                        radius: '100%',
                        innerRadius: '75%',
                        pointColorMapper: (d, _) => d.x == 'Completed'
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),

                /// 🔹 Center text
                CommonText.medium('75%', size: 32),
              ],
            ),
          ),
        ),
        Gap(20),
        CommonDivider(),

        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // important
            children: [
              commonAverageView(
                title: ReportsAnalysis.last6MonthAverage,
                data: controller.data.value.courseCompletion.last6MonthAverage,
              ),
              VerticalDivider(
                color: isDarkMode
                    ? AppColors.grey100Color
                    : AppColors.lightBorderColor,
                thickness: 1.5,
                width: 10,
                endIndent: 1,
                indent: 0,
              ),
              commonAverageView(
                title: ReportsAnalysis.last3YearAverage,
                data: controller.data.value.courseCompletion.last3YearAverage,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget commonAverageView({required String title, required SummaryMetric data}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(15),
        CommonText.regular(title, size: 15),
        Gap(17),
        CommonText.medium('${data.value.toString()}%', size: 28),
        Gap(17),
        Container(
          width: 109,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: data.isPositive ? AppColors.success600 : AppColors.error600,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgImageFromAsset(
                data.isPositive
                    ? AppCommonIcon.positiveIcon
                    : AppCommonIcon.negativeIcon,
              ),
              Gap(5),
              CommonText.medium('${data.changePercent.toString()}%', size: 14),
              CommonText.medium(data.isPositive ? 'Higher' : 'Lower', size: 14),
            ],
          ),
        ),
        Gap(15),
      ],
    ),
  );
}

Widget commonDataTableTitle(String title) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Expanded(
    child: CommonText.regular(
      title,
      size: 16,
      color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget instructorPerformanceReport(InstructorModel data) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Container(
    decoration: commonCardDecoration(12),
    margin: EdgeInsetsGeometry.only(left: 20,bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(72),
                child: commonCacheImage(
                  data.image,
                  ImagePlaceHolder.imagePlaceHolderDark,
                  height: 72,
                  width: 72,
                ),
              ),
              Gap(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonText.medium(
                      data.name,
                      size: 16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(5),
                    CommonText.regular(
                      data.email,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(5),
                    CommonText.regular(
                      data.phoneNo,
                      size: 16,
                      color: AppColors.greyTextColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        CommonDivider(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leadingTitle(ReportsAnalysis.assignedCourses,),
              trailingTitle(data.assignedCourses.toString()),
            ],
          ),
        ),

        CommonDivider(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: leadingTitle(ReportsAnalysis.avgStudentRating,)),
              SvgImageFromAsset(AppCommonIcon.starIcon,height: 12,width: 12,),
              Gap(3),
              CommonText.medium(
                data.rate.toString(),
                size: 16,
                color:AppColors.secondary500 ,
              )
            ],
          ),
        ),

        CommonDivider(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leadingTitle(ReportsAnalysis.totalCourses,),
              trailingTitle(data.totalCourses.toString()),
            ],
          ),
        ),

      ],
    ),
  );
}

Widget leadingTitle(String title) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return CommonText.regular(
    title,
    size: 15,
    color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
  );
}
Widget trailingTitle(String title) {

  return CommonText.regular(
    title,
    size: 15,

  );
}