import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/app_route.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/view_common_widget/common_circle_add_button.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/common_notes_view.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_cache_image.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../controller/dashboard_controller.dart';
import '../model/class_approval_model.dart';
import '../model/monthly_data_model.dart';
import '../model/rank_model.dart';
import '../model/user_summery_chart_model.dart';
import 'add_note_dailog_box.dart';
import 'dotted_circle_painter.dart';

Widget commonViewAll(String title, bool showViewAll) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CommonText.medium(
            title,
            size: 15,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        showViewAll
            ? CommonText.medium(
                AppCommonStrings.viewAll,
                size: 13,
                color: isDarkMode
                    ? AppColors.greyTextDarkColor
                    : AppColors.greyTextColor,
              )
            : SizedBox(),
      ],
    ),
  );
}

//dashboard overview
Widget dashboardOverView({
  required String title,
  required String image,
  required String total,
  required String scholarship,
  required double margin,
  required Gradient gradient,
  required Color color,
  required BuildContext context,
}) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  var mobileView = ResponsiveView.isMobile(context);
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    margin: EdgeInsets.only(right: margin, bottom: mobileView ? 12 : 0),
    decoration: BoxDecoration(
      border: Border.all(
        color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(9),
      gradient: gradient,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonText.light(
                title,
                size: 15,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: Center(child: SvgImageFromAsset(image)),
            ),
          ],
        ),
        Gap(20),
        CommonText.medium(total, size: 18),
        Gap(4),
        CommonText.light(
          '+$scholarship % from last month',
          size: 13,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
      ],
    ),
  );
}

LinearGradient totalStudentGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFAFCFF), // #FAFCFF
    Color.fromRGBO(255, 237, 239, 0.75), // rgba(255, 237, 239, 0.75)
  ],
  stops: [0.0023, 2.0084], // equivalent to 0.23% and 200.84%
);

LinearGradient totalStudentDarkGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF000000), // #000000
    Color.fromRGBO(53, 8, 13, 0.75), // rgba(53, 8, 13, 0.75)
  ],
  // Optional: adjust the stops for smoother transition
  stops: [0.0023, 1.0], // 0.23% → 0.0023, capped 200.84% → 1.0
);

LinearGradient totalInstructorGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFAFCFF), // #FAFCFF
    Color(0xFFF4EEFF), // #F4EEFF
  ],
  stops: [
    0.0007, // 0.07% → 0.0007
    1.0, // 210.92% → clamped to 1.0
  ],
);
LinearGradient totalInstructorDarkGradient = LinearGradient(
  begin: Alignment.topCenter, // 180.08° ≈ top to bottom
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF000000), // #000000
    Color(0xFF281A43), // #281A43
  ],
  stops: [
    0.0007, // 0.07% => 0.0007
    1.0, // 210.92% => clamped to 1.0
  ],
);

LinearGradient totalCoursesGradient = LinearGradient(
  begin: Alignment.topCenter, // 179.92deg ≈ vertical top to bottom
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFAFCFF), // #FAFCFF
    Color(0xFFFFF7ED), // #FFF7ED
  ],
  stops: [
    0.0007, // 0.07% → 0.0007
    1.0, // 228.22% → clamped to 1.0
  ],
);
LinearGradient totalCoursesDarkGradient = LinearGradient(
  begin: Alignment.topCenter, // 179.92° ≈ top to bottom
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF000000), // #000000
    Color(0xFF311B00), // #311B00
  ],
  stops: [
    0.0007, // 0.07% → 0.0007
    1.0, // 228.22% → capped at 1.0
  ],
);

LinearGradient monthlyRevenueGradient = LinearGradient(
  begin: Alignment.topCenter, // 179.71° ≈ top to bottom
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFAFCFF), // #FAFCFF
    Color(0xFFE8FFF0), // #E8FFF0
  ],
  stops: [
    0.0025, // 0.25% → 0.0025
    1.0, // 184.32% → clamped to 1.0
  ],
);
LinearGradient monthlyRevenueDarkGradient = LinearGradient(
  begin: Alignment.topCenter, // 179.71° ≈ vertical top to bottom
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF000000), // Black
    Color(0xFF0B3119), // Dark green
  ],
  stops: [
    0.0025, // 0.25% → 0.0025
    1.0, // 184.32% → clamped to 1.0
  ],
);

//revenue chart
Widget revenueChart() {
  DashboardController controller = Get.put(DashboardController());
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonText.medium(DashboardViewStrings.revenueChart, size: 16),
              SizedBox(
                width: 100,
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedYear.value,
                    icon: SvgImageFromAsset(AppCommonIcon.downArrowIcon),
                    // underline: SizedBox(),
                    decoration: dropDownDecoration(),

                    items: controller.yearlyData.keys.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: CommonText.medium(
                          year,
                          size: 16,
                          color: isDarkMode
                              ? AppColors.bodyTextDarkColor
                              : AppColors.bodyTextColor,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => controller.selectedYear.value = val!,
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(15),
        CommonDivider(),
        Gap(15),
        SizedBox(
          height: 255,
          child: Obx(
            () => SfCartesianChart(
              borderColor: Colors.transparent,
              plotAreaBorderColor: Colors.transparent,
              primaryXAxis: CategoryAxis(
                axisLine: AxisLine(color: Colors.transparent),
                majorTickLines: MajorTickLines(color: Colors.transparent),
                majorGridLines: MajorGridLines(color: Colors.transparent),
                labelStyle: TextStyle(
                  color: isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.compact(),
                axisLine: AxisLine(color: Colors.transparent),
                majorGridLines: MajorGridLines(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                ),
                labelStyle: TextStyle(
                  color: isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                elevation: 0,
                shadowColor: Colors.transparent,
                canShowMarker: false,
                color: Colors.transparent,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  final MonthlyData monthlyData = data as MonthlyData;
                  final String valueFormatted = NumberFormat.compact().format(
                    monthlyData.value,
                  );
                  return Container(
                    width: 71,
                    height: 33,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.mainDarkBgColor
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.grey100Color
                            : AppColors.headingsLightColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CommonText.regular(valueFormatted, size: 17),
                    ),
                  );
                },
              ),
              series: [
                ColumnSeries<MonthlyData, String>(
                  borderColor: Colors.transparent,
                  dataSource: controller.chartData,
                  xValueMapper: (MonthlyData data, _) => data.month,
                  yValueMapper: (MonthlyData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                  ), // ✅ hide labels above bars
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    colors: [AppColors.purple200, AppColors.purple100],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

//request for approvals
Widget requestForApprovals() {
  DashboardController controller = Get.put(DashboardController());
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonViewAll(DashboardViewStrings.requestForApprovals, true),

        CommonDivider(),
        Gap(15),
        ListView.builder(
          itemCount: controller.dashboardData.value.classApprovalsList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 12, right: 12),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final data =
                controller.dashboardData.value.classApprovalsList[index];
            return classApprovalsCardView(data);
          },
        ),
      ],
    ),
  );
}

Widget classApprovalsCardView(ClassApprovalModel data) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Container(
    decoration: commonCardDecoration(12),
    margin: EdgeInsetsGeometry.only(bottom: 12),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.medium(
          data.name,
          size: 13,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
        Gap(15),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     SvgImageFromAsset(AppCommonIcon.calenderIcon),
        //     Gap(10),
        //     CommonText.medium(
        //       data.date,
        //       size: 12,
        //       color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.bodyTextColor,
        //     ),
        //     Gap(10),
        //     Container(
        //       height: 20,
        //       width: 1,
        //       color: isDarkMode?AppColors.grey100Color:AppColors.headingsLightColor,
        //     ),
        //     Gap(10),
        //     SvgImageFromAsset(AppCommonIcon.clockIcon),
        //     Gap(10),
        //     CommonText.medium(
        //       data.time,
        //       size: 12,
        //       color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.bodyTextColor,
        //     ),
        //   ],
        // ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 8, // space between lines if wrapped
          children: [
            SvgImageFromAsset(
              AppCommonIcon.calenderIcon,
              colorFilter: ColorFilter.mode(
                isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
            CommonText.medium(
              data.date,
              size: 12,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
            Container(
              height: 20,
              width: 1,
              color: isDarkMode
                  ? AppColors.grey100Color
                  : AppColors.headingsLightColor,
            ),
            SvgImageFromAsset(
              AppCommonIcon.clockIcon,
              colorFilter: ColorFilter.mode(
                isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
            CommonText.medium(
              data.time,
              size: 12,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
          ],
        ),

        Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            commonCacheImage(
              data.instructorProfileImg,
              ImagePlaceHolder.imagePlaceHolderDark,
              width: 24,
              height: 24,
            ),
            Gap(7),
            CommonText.medium(
              data.instructorName,
              size: 12,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
          ],
        ),
      ],
    ),
  );
}

//my notes
Widget myNotesView(BuildContext context) {
  var mobileView = ResponsiveView.isMobile(context);
  DashboardController controller = Get.put(DashboardController());
  return Container(
    decoration: commonCardDecoration(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText.medium(
                  DashboardViewStrings.myNotes,
                  size: 15,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  commonDialogBox(
                    context: context,
                    child: SizedBox(
                      width: 560,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: AddNoteDialogBox(
                          titleController: controller.noteTitleController,
                          noteController: controller.noteController,

                        ),
                      ),
                    ),
                  );
                },
                child: CommonCircleAddButton()
              ),
            ],
          ),
        ),
        Gap(15),
        CommonDivider(),
        Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ResponsiveGridRow(
                children: List.generate(
                  controller.dashboardData.value.myNotesList.length > 3
                      ? 3
                      : controller.dashboardData.value.myNotesList.length,
                  (index) {
                    final data =
                        controller.dashboardData.value.myNotesList[index];
                    return ResponsiveGridCol(
                      lg: 4, // 3 cards = 4 columns each on 12-grid
                      xs: 12,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 20,
                          bottom: 15,
                          left: mobileView
                              ? 20
                              : index == 0
                              ? 12
                              : 0,
                        ),
                        child: CommonNotesView(note: data),
                      ),
                    );
                  },
                ),
              ),
            ),

            mobileView ? SizedBox() : viewAllButton(context),
          ],
        ),

        if (mobileView)
          Align(alignment: Alignment.center, child: viewAllButton(context))
        else
          SizedBox(),
        Gap(mobileView ? 15 : 0),
      ],
    ),
  );
}

Widget viewAllButton(BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  DashboardController controller = Get.put(DashboardController());
  return InkWell(
    onTap: () {
      context.push(
        AppRouteName.notesListView,
        extra: controller.dashboardData.value.myNotesList,
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonText.medium(
          AppCommonStrings.viewAll,
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
        const SizedBox(width: 5),
        SvgImageFromAsset(
          AppCommonIcon.leftArrowIcon,
          height: 24,
          colorFilter: ColorFilter.mode(
            isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
            BlendMode.srcIn,
          ),
        ),
      ],
    ),
  );
}

//top instructor view
Widget instructorView() {
  DashboardController controller = Get.put(DashboardController());
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonViewAll(DashboardViewStrings.topInstructor, true),

        CommonDivider(),
        Gap(15),
        ListView.builder(
          itemCount: controller.dashboardData.value.instructorList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            final data = controller.dashboardData.value.instructorList[index];
            return Container(
              decoration: commonCardDecoration(12),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              margin: EdgeInsetsGeometry.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(44),
                    child: commonCacheImage(
                      data.image,
                      ImagePlaceHolder.imagePlaceHolderDark,
                      width: 44,
                      height: 44,
                    ),
                  ),
                  Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CommonText.medium(
                                data.name,
                                size: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            CommonText.semiBold(
                              data.joiningDate,
                              size: 13,
                              color: AppColors.primary500,
                            ),
                          ],
                        ),
                        Gap(5),
                        CommonText.regular(
                          data.qualification,
                          size: 13,
                          color: isDarkMode
                              ? AppColors.bodyTextDarkColor
                              : AppColors.bodyTextColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Gap(12),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          runSpacing: 8, // space between lines if wrapped
                          children: [
                            Container(
                              height: 25,
                              width: 87,

                              decoration: commonDetailCardDecoration(),
                              child: Center(
                                child: CommonText.medium(
                                  '${data.noOfStudents.toString()} Students',
                                  size: 12,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                ),
                              ),
                            ),
                            Gap(10),
                            Container(
                              height: 25,
                              width: 75,

                              decoration: commonDetailCardDecoration(),
                              child: Center(
                                child: CommonText.medium(
                                  '${data.noOfCourses.toString()} Courses',
                                  size: 12,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                ),
                              ),
                            ),
                            Gap(10),
                            Container(
                              height: 25,
                              width: 51,

                              decoration: commonDetailCardDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgImageFromAsset(AppCommonIcon.starIcon),
                                  Gap(5),
                                  CommonText.medium(
                                    data.rate.toString(),
                                    size: 13,
                                    color: AppColors.secondary500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

//user summery view
Widget userSummeryView(BuildContext context) {
  var mobileView = ResponsiveView.isMobile(context);
  DashboardController controller = Get.put(DashboardController());
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonViewAll(DashboardViewStrings.userSummary, false),
        CommonDivider(),
        Gap(15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Doughnut Chart
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.grey100Color
                              : AppColors.lightBorderColor,
                          width: 6,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        series: <CircularSeries>[
                          DoughnutSeries<UserSummeryChartData, String>(
                            dataSource: controller.pieChartData,
                            pointColorMapper: (UserSummeryChartData data, _) =>
                                data.color,
                            xValueMapper: (UserSummeryChartData data, _) =>
                                data.x,
                            yValueMapper: (UserSummeryChartData data, _) =>
                                data.y,
                            radius: '105%',
                            innerRadius: '60%',
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelIntersectAction: LabelIntersectAction.none, // allow overlap
                              labelPosition: ChartDataLabelPosition.inside,
                              builder: (data, point, series, pointIndex, seriesIndex) {
                                final chartData = data as UserSummeryChartData;
                                return CommonText.semiBold(
                                  '${chartData.y}%',
                                  color: AppColors.white,
                                  size: 12,
                                );
                              },
                            ),

                          ),
                        ],
                      ),
                    ),

                    /// Dotted Circular Border
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(painter: DottedCirclePainter()),
                    ),

                    /// Center Image
                    SvgImageFromAsset(
                      CommonImageAssets.studentImg,
                      height: 47,
                      width: 47,
                    ),
                  ],
                ),
              ),
              Gap(15),
              mobileView
                  ? SizedBox()
                  : Expanded(
                      child: Column(
                        children: [
                          newUsersView(
                            title: DashboardViewStrings.newUsers,
                            percentage: controller.dashboardData.value.newUsers
                                .toString(),
                            color: AppColors.purple600,
                          ),
                          Gap(45),
                          newUsersView(
                            title: DashboardViewStrings.activeUsers,
                            percentage: controller
                                .dashboardData
                                .value
                                .activeUsers
                                .toString(),
                            color: AppColors.success500,
                          ),
                          Gap(45),
                          newUsersView(
                            title: DashboardViewStrings.inactiveUsers,
                            percentage: controller
                                .dashboardData
                                .value
                                .inactiveUsers
                                .toString(),
                            color: AppColors.secondary500,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Gap(mobileView ? 15 : 0),
        mobileView
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mobileView ? 15 : 0,
                  vertical: mobileView ? 15 : 0,
                ),
                child: Column(
                  children: [
                    newUsersView(
                      title: DashboardViewStrings.newUsers,
                      percentage: controller.dashboardData.value.newUsers
                          .toString(),
                      color: AppColors.purple600,
                    ),
                    Gap(mobileView ? 20 : 45),
                    newUsersView(
                      title: DashboardViewStrings.activeUsers,
                      percentage: controller.dashboardData.value.activeUsers
                          .toString(),
                      color: AppColors.success500,
                    ),
                    Gap(mobileView ? 20 : 45),
                    newUsersView(
                      title: DashboardViewStrings.inactiveUsers,
                      percentage: controller.dashboardData.value.inactiveUsers
                          .toString(),
                      color: AppColors.secondary500,
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    ),
  );
}

Widget newUsersView({
  required String title,
  required String percentage,
  required Color color,
}) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CommonText.regular(
              title,
              size: 14,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CommonText.regular('$percentage%', size: 14),
        ],
      ),
      Gap(15),
      LinearProgressIndicator(
        color: color,
        value: 0.5,
        backgroundColor: isDarkMode
            ? AppColors.grey100Color
            : AppColors.headingsLightColor,
        borderRadius: BorderRadius.circular(3),
      ),
    ],
  );
}

//top courses view
Widget topCoursesView() {
  DashboardController controller = Get.put(DashboardController());
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonViewAll(DashboardViewStrings.topCourses, true),

        CommonDivider(),

        SizedBox(
          height: 312,
          child: ListView.builder(
            itemCount: controller.dashboardData.value.topCoursesList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final course =
                  controller.dashboardData.value.topCoursesList[index];
              return Container(
                width: 200,
                margin: EdgeInsets.only(right: 12),
                decoration: commonCardDecoration(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: commonCacheImage(
                          course.image,
                          ImagePlaceHolder.imagePlaceHolderDark,
                          width: double.infinity,
                          height: 100,
                        ),
                      ),
                    ),
                    Gap(7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CommonText.medium(course.name, size: 15),
                    ),
                    Gap(7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CommonText.regular(
                        course.courseCategory,
                        size: 13,
                        color: isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                      ),
                    ),
                    Gap(7),
                    Divider(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.headingsLightColor,
                    ),
                    Gap(7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CommonText.regular(
                        '${course.attendance.toString()}Attendees',
                        size: 13,
                        color: isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                      ),
                    ),
                    Gap(7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CommonText.regular(
                            'Course by:',
                            size: 13,
                            color: isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                          ),
                          CommonText.medium(course.instructorName, size: 13),
                        ],
                      ),
                    ),
                    Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: PrimaryButton(
                        height: 30,
                        onPressed: () {},
                        label: DashboardViewStrings.viewCourse,
                        textSize: 13,
                        textWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

//quiz leader board view
Widget buildLeaderBoardCard(BuildContext context) {
  DashboardController controller = Get.put(DashboardController());
  var mobileView = ResponsiveView.isMobile(context);
  return Container(
    margin: EdgeInsets.only(right: mobileView ? 0 : 4),
    height: mobileView ? null : 367,

    decoration: commonCardDecoration(12),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText.medium(
                  DashboardViewStrings.quizLeaderBoard,
                  size: 16,
                ),
                SizedBox(
                  width: 100,
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedQuizLeaderBoardYear.value,
                      icon: SvgImageFromAsset(AppCommonIcon.downArrowIcon),
                      decoration: dropDownDecoration(),
                      items: controller.leaderBoardYear.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: CommonText.medium(
                            year,
                            size: 16,
                            color: AppColors.bodyTextColor,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          controller.selectedQuizLeaderBoardYear.value = val!,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(15),
          CommonDivider(),
          Gap(15),
          ResponsiveGridRow(
            children: [
              ResponsiveGridCol(
                lg: 6,
                xs: 12,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.dashboardData.value.rankList.length,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: mobileView ? 15 : 90,
                  ),
                  itemBuilder: (context, index) {
                    final data = controller.dashboardData.value.rankList[index];
                    return Row(
                      children: [
                        commonCacheImage(
                          data.image,
                          ImagePlaceHolder.imagePlaceHolderDark,
                          width: 44,
                          height: 44,
                        ),
                        Gap(12),
                        Expanded(child: CommonText.medium(data.name, size: 16)),
                        CommonText.medium(
                          '${data.points}',
                          size: 16,
                          color: AppColors.primary500,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CommonDivider(),
                  ),
                ),
              ),

              ResponsiveGridCol(
                lg: 6,
                xs: 12,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 15,
                    bottom: mobileView ? 15 : 0,
                    left: mobileView ? 15 : 0,
                  ),
                  child: rankView(),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget rankView() {
  DashboardController controller = Get.put(DashboardController());
  final rank1 = controller.dashboardData.value.rankList.firstWhere(
    (e) => e.rank == 1,
    orElse: () => RankModel.empty(),
  );
  final rank2 = controller.dashboardData.value.rankList.firstWhere(
    (e) => e.rank == 2,
    orElse: () => RankModel.empty(),
  );
  final rank3 = controller.dashboardData.value.rankList.firstWhere(
    (e) => e.rank == 3,
    orElse: () => RankModel.empty(),
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      // Rank 2 → Left
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            commonView(
              image: rank2.image,
              name: rank2.name,
              courses: "${rank2.points.toString().padLeft(2, '0')} Points",
            ),
            Gap(15),
            commonContainer(height: 85, title: '2'),
          ],
        ),
      ),

      // Rank 1 → Center (Taller)
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            commonView(
              image: rank1.image,
              name: rank1.name,
              courses: "${rank1.points.toString().padLeft(2, '0')}Points",
            ),
            Gap(15),
            commonContainer(height: 126, title: '1'),
          ],
        ),
      ),

      // Rank 3 → Right
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            commonView(
              image: rank3.image,
              name: rank2.name,
              courses: "${rank3.points.toString().padLeft(2, '0')} Points",
            ),
            Gap(15),
            commonContainer(height: 85, title: '3'),
          ],
        ),
      ),
    ],
  );
}

Widget commonContainer({required double height, required String title}) {
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.primary500,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(33),
        topRight: Radius.circular(33),
      ),
      border: Border.all(color: AppColors.primary100),
    ),
    child: Center(
      child: CommonText.semiBold(title, size: 44, color: AppColors.white),
    ),
  );
}

Widget commonView({
  required String image,
  required String name,
  required String courses,
}) {
  return Column(
    children: [
      commonCacheImage(
        image,
        ImagePlaceHolder.imagePlaceHolderDark,
        height: 60,
        width: 60,
      ),
      Gap(10),
      CommonText.medium(name, size: 15),
      Gap(10),
      Container(
        height: 28,
        width: 96,
        decoration: BoxDecoration(
          color: AppColors.primary500,
          borderRadius: BorderRadius.circular(27.6),
        ),
        child: Center(
          child: CommonText.medium(courses, size: 12, color: AppColors.white),
        ),
      ),
    ],
  );
}

//top categories view
Widget topCategoriesView(BuildContext context) {
  DashboardController controller = Get.put(DashboardController());
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  var mobileView = ResponsiveView.isMobile(context);
  return Container(
    height: mobileView ? null : 357,
    decoration: commonCardDecoration(12),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonViewAll(DashboardViewStrings.topCategories, false),
          CommonDivider(),
          Gap(15),
          ListView.builder(
            itemCount: controller.dashboardData.value.topCategoriesList.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 12),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final category =
                  controller.dashboardData.value.topCategoriesList[index];
              return Container(
                decoration: commonCardDecoration(12),
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: commonCacheImage(
                        category.image,
                        ImagePlaceHolder.imagePlaceHolderDark,
                        width: 44,
                        height: 44,
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText.medium(
                            category.name,
                            size: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(5),
                          CommonText.medium(
                            '${category.noOfCourses.toString()} Courses',
                            size: 13,
                            color: isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: commonDetailCardDecoration(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonText.medium(
                            '${category.noOfPeople.toString()}K',
                            size: 12,
                            color: isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                          ),
                          Gap(5),
                          SvgImageFromAsset(
                            AppCommonIcon.peopleIcon,
                            colorFilter: ColorFilter.mode(
                              isDarkMode
                                  ? AppColors.bodyTextDarkColor
                                  : AppColors.bodyTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
