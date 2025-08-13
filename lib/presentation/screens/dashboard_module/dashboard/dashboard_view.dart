part of 'dashboard_imports.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    double margin = 17;
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
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        xs: 12,
                        lg: 3,
                        child: dashboardOverView(
                          title: DashboardViewStrings.totalStudents,
                          image: CommonImageAssets.studentLogo,
                          total: controller.dashboardData.value.totalStudents
                              .toString(),
                          scholarship: controller.dashboardData.value.scholarship
                              .toString(),
                          margin: mobileView ? 0 : 12,
                          gradient: isDarkMode
                              ? totalStudentDarkGradient
                              : totalStudentGradient,
                          color: AppColors.pink600,
                          context: context,
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        lg: 3,
                        child: dashboardOverView(
                          title: DashboardViewStrings.totalInstructors,
                          image: CommonImageAssets.totalInstructorLogo,
                          total: controller.dashboardData.value.totalInstructors
                              .toString(),
                          scholarship: controller.dashboardData.value.scholarship
                              .toString(),
                          margin: mobileView ? 0 : 12,
                          gradient: isDarkMode
                              ? totalInstructorDarkGradient
                              : totalInstructorGradient,
                          color: AppColors.purple600,
                          context: context,
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        lg: 3,
                        child: dashboardOverView(
                          title: DashboardViewStrings.totalCourses,
                          image: CommonImageAssets.totalCoursesLogo,
                          total: controller.dashboardData.value.totalCourses
                              .toString(),
                          scholarship: controller.dashboardData.value.scholarship
                              .toString(),
                          margin: mobileView ? 0 : 12,
                          gradient: isDarkMode
                              ? totalCoursesDarkGradient
                              : totalCoursesGradient,
                          color: AppColors.secondary500,
                          context: context,
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        lg: 3,
                        child: dashboardOverView(
                          title: DashboardViewStrings.monthlyRevenue,
                          image: CommonImageAssets.monthlyRevenueLogo,
                          total:
                              '\$${controller.dashboardData.value.monthlyRevenue.toString()}',
                          scholarship: controller.dashboardData.value.scholarship
                              .toString(),
                          margin: 0,
                          gradient: isDarkMode
                              ? monthlyRevenueDarkGradient
                              : monthlyRevenueGradient,
                          color: AppColors.success500,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        xs: 12,
                        lg: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            height: mobileView ? null : 350,
                            margin: EdgeInsetsGeometry.only(
                              right: mobileView ? 0 : margin,
                            ),
                            decoration: commonCardDecoration(12),
        
                            child: revenueChart(),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        lg: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            decoration: commonCardDecoration(12),
                            height: mobileView ? null : 350,
                            child: requestForApprovals(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  myNotesView(context),
        
                  ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        lg: 4,
                        xs: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            height: mobileView ? null : 375,
                            margin: EdgeInsetsGeometry.only(
                              right: mobileView ? 0 : margin,
                            ),
                            decoration: commonCardDecoration(12),
                            child: instructorView(),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 4,
                        xs: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            //color: Colors.pink,
                            height: mobileView ? null : 375,
                            margin: EdgeInsetsGeometry.only(
                              right: mobileView ? 0 : margin,
                            ),
                            decoration: commonCardDecoration(12),
                            child: userSummeryView(context),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 4,
                        xs: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            height: 375,
                            decoration: commonCardDecoration(12),
                            child: topCoursesView(),
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  mobileView
                      ? Column(
                          children: [
                            buildLeaderBoardCard(context),
                            Gap(15),
                            topCategoriesView(context),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: buildLeaderBoardCard(context),
                            ),
                            Gap(15),
                            Expanded(flex: 4, child: topCategoriesView(context)),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
