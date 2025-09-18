part of 'reports_analysis_imports.dart';

class ReportsAnalysisView extends StatefulWidget {
  const ReportsAnalysisView({super.key});

  @override
  State<ReportsAnalysisView> createState() => _ReportsAnalysisViewState();
}

class _ReportsAnalysisViewState extends State<ReportsAnalysisView> {
  ReportsAnalysisController controller = Get.put(ReportsAnalysisController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        searchController: controller.searchController,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              mobileView
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: CommonSearchField(
                        controller: controller.searchController,
                        hintText: DashboardViewStrings.searchAnything,
                      ),
                    )
                  : SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: commonHeaderText(title: ReportsAnalysis.reportAnalytics),
              ),
              CommonDivider(),

              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ResponsiveGridRow(
                        children: [
                          ResponsiveGridCol(
                            lg: 8,
                            xs: 12,
                            child: SizedBox(
                              //height: 500,
                              child: ResponsiveGridRow(
                                children: [
                                  ResponsiveGridCol(
                                    lg: 6,
                                    xs: 12,
                                    child: commonReportsCardView(
                                      isDarkMode: isDarkMode,
                                      data: controller
                                          .data
                                          .value
                                          .summary
                                          .totalStudents,
                                      name: ReportsAnalysis.totalStudents,
                                      gradient: isDarkMode
                                          ? totalStudentDarkGradient()
                                          : totalStudentGradient(),
                                      mobileView: mobileView,
                                      textColor: isDarkMode?AppColors.white:AppColors.headingsColor,
                                      margin: EdgeInsetsGeometry.only(
                                        right: mobileView ? 0 : 20,
                                        top: 20,
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    lg: 6,
                                    xs: 12,
                                    child: commonReportsCardView(
                                      textColor: isDarkMode?AppColors.white:AppColors.headingsColor,
                                      isDarkMode: isDarkMode,
                                      data: controller
                                          .data
                                          .value
                                          .summary
                                          .totalRevenue,
                                      name: ReportsAnalysis.totalRevenue,
                                      leading: '\$',
                                      gradient: isDarkMode
                                          ? totalRevenueDarkGradient()
                                          : totalRevenueGradient(),
                                      mobileView: mobileView,
                                      margin: EdgeInsetsGeometry.only(
                                        right: mobileView ? 0 : 20,
                                        top: 20,
                                      ),
                                    ),
                                  ),

                                  ResponsiveGridCol(
                                    lg: 6,
                                    xs: 12,
                                    child: commonReportsCardView(
                                      isDarkMode: isDarkMode,
                                      data: controller
                                          .data
                                          .value
                                          .summary
                                          .courseCompletionRate,
                                      name:
                                          ReportsAnalysis.courseCompletionRate,
                                      gradient: isDarkMode
                                          ? courseCompletionDarkGradient()
                                          : courseCompletionGradient(),
                                      trailing: '%',
                                      mobileView: mobileView,
                                      margin: EdgeInsetsGeometry.only(
                                        right: mobileView ? 0 : 20,
                                        top: 20,
                                      ),
                                      textColor: isDarkMode?AppColors.white:AppColors.headingsColor,
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    lg: 6,
                                    xs: 12,
                                    child: commonReportsCardView(
                                      isDarkMode: isDarkMode,
                                      data: controller
                                          .data
                                          .value
                                          .summary
                                          .activeInstructors,
                                      name: ReportsAnalysis.activeInstructor,
                                      textColor: isDarkMode?AppColors.white:AppColors.headingsColor,

                                      gradient: isDarkMode
                                          ? activeInstructorDarkGradient()
                                          : activeInstructorGradient(),
                                      mobileView: mobileView,
                                      margin: EdgeInsetsGeometry.only(
                                        right: mobileView ? 0 : 20,
                                        top: 20,
                                      ),
                                    ),
                                  ),

                                  ResponsiveGridCol(
                                    lg: 6,
                                    xs: 12,
                                    child: commonReportsCardView(
                                      isDarkMode: isDarkMode,
                                      data: controller
                                          .data
                                          .value
                                          .summary
                                          .newUsersToday,
                                      name: ReportsAnalysis.newUsersToday,
                                      textColor: isDarkMode?AppColors.white:AppColors.headingsColor,
                                      gradient: isDarkMode
                                          ? newUsersDarkGradient()
                                          : newUsersGradient(),
                                      mobileView: mobileView,
                                      margin: EdgeInsetsGeometry.only(
                                        right: mobileView ? 0 : 20,
                                        top: 20,
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    lg: 6,
                                    xs: 12,
                                    child: commonReportsCardView(
                                      isDarkMode: isDarkMode,
                                      textColor: isDarkMode?AppColors.white:AppColors.headingsColor,
                                      data: controller
                                          .data
                                          .value
                                          .summary
                                          .activeCourses,
                                      name: ReportsAnalysis.activeCourses,
                                      gradient: isDarkMode
                                          ? activeCoursesDarkGradient()
                                          : activeCoursesGradient(),
                                      mobileView: mobileView,
                                      margin: EdgeInsetsGeometry.only(
                                        right: mobileView ? 0 : 20,
                                        top: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ResponsiveGridCol(
                            lg: 4,
                            child: SizedBox(
                              //height: 500,
                              //color: Colors.yellow,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: courseCompletionRate(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ResponsiveGridRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveGridCol(
                            lg: 12,
                            xs: 12,
                            sm: 12,
                            md: 12,
                            xl: 12,

                            child: Container(
                              decoration: commonCardDecoration(18),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    child: CommonText.medium(
                                      ReportsAnalysis.topCourseCompletionRated,
                                      size: 17,
                                    ),
                                  ),
                                  CommonDivider(),

                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: constraints.maxWidth,
                                          ),
                                          child: DataTable(
                                            columnSpacing: 50.0,
                                            horizontalMargin: 20.0,

                                            //dividerThickness: 1.5,
                                            border: TableBorder(
                                              horizontalInside: BorderSide(
                                                width: 1,

                                                color: isDarkMode
                                                    ? AppColors.grey100Color
                                                    : AppColors
                                                          .lightBorderColor,
                                              ),
                                            ),

                                            // border: TableBorder.all(),
                                            columns: [
                                              DataColumn(
                                                label: commonDataTableTitle(
                                                  ReportsAnalysis.course,
                                                ),
                                              ),
                                              DataColumn(
                                                label: commonDataTableTitle(
                                                  ReportsAnalysis
                                                      .avgTimeToComplete,
                                                ),
                                              ),
                                              DataColumn(
                                                label: commonDataTableTitle(
                                                  ReportsAnalysis
                                                      .completionRate,
                                                ),
                                              ),
                                              DataColumn(
                                                label: commonDataTableTitle(
                                                  ReportsAnalysis
                                                      .comparingToLastMonth,
                                                ),
                                              ),
                                            ],
                                            rows: List.generate(
                                              controller
                                                  .data
                                                  .value
                                                  .topCourses
                                                  .length,
                                              (index) {
                                                final data = controller
                                                    .data
                                                    .value
                                                    .topCourses[index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(
                                                      CommonText.medium(
                                                        data.name,
                                                        size: 15,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      CommonText.medium(
                                                        data.avgTimeToComplete,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Row(
                                                        children: [
                                                          CommonText.medium(
                                                            '${data.completionRate.toString()}%',
                                                            size: 15,
                                                            color: AppColors
                                                                .primary500,
                                                          ),
                                                          Gap(12),
                                                          SizedBox(
                                                            width: 200,
                                                            child: LinearProgressIndicator(
                                                              color: AppColors
                                                                  .primary500,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .greyBgColor,
                                                              value:
                                                                  data.completionRate /
                                                                  100,
                                                              minHeight: 15,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            padding:
                                                                EdgeInsets.symmetric(

                                                                  vertical: 3,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                              color:
                                                                  data
                                                                      .compareLastMonth!
                                                                      .isPositive
                                                                  ? AppColors
                                                                        .success600
                                                                  : AppColors
                                                                        .error600,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgImageFromAsset(
                                                                  data
                                                                          .compareLastMonth!
                                                                          .isPositive
                                                                      ? AppCommonIcon
                                                                            .positiveIcon
                                                                      : AppCommonIcon
                                                                            .negativeIcon,
                                                                ),
                                                                Gap(5),
                                                                CommonText.medium(
                                                                  '${data.compareLastMonth!.value.toString()}%',
                                                                  size: 14,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Gap(10),
                                                          CommonText.medium(
                                                            '${data.completionRate - data.compareLastMonth!.value}%',
                                                            size: 17,
                                                            color: isDarkMode
                                                                ? AppColors
                                                                      .bodyTextDarkColor
                                                                : AppColors
                                                                      .bodyTextColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: commonHeaderText(
                        title: ReportsAnalysis.instructorPerformanceReport,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ResponsiveGridRow(
                        children: List.generate(
                          controller.data.value.instructors.length,
                          (index) {
                            final data =
                                controller.data.value.instructors[index];
                            return ResponsiveGridCol(
                              lg: 4,
                              xs: 12,
                              child: instructorPerformanceReport(data),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
