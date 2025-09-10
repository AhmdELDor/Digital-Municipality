part of 'student_management_detail_imports.dart';

class StudentManagementDetailView extends StatefulWidget {
  const StudentManagementDetailView({super.key});

  @override
  State<StudentManagementDetailView> createState() =>
      _StudentManagementDetailViewState();
}

class _StudentManagementDetailViewState
    extends State<StudentManagementDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StudentManagementDetailController controller = Get.put(
    StudentManagementDetailController(),
  );

  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    final studentsDetail =
        GoRouterState.of(context).extra as StudentManagementModel;
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        searchController: controller.searchController,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        showBackIcon: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final courses = controller.data.value.coursesList;

          if (courses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final completed = courses
              .where((c) => c.status == "Completed")
              .toList();
          final ongoing = courses.where((c) => c.status == "Ongoing").toList();

          return DefaultTabController(
            length: 4,
            child: Builder(
              builder: (context) {
                final TabController tabController = DefaultTabController.of(
                  context,
                );

                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      /// -------- Profile & Statistics section --------
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      hintText:
                                          DashboardViewStrings.searchAnything,
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: CommonText.medium(
                                StudentManagementDetailStrings.studentProfile,
                                size: 18,
                              ),
                            ),
                            CommonDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: ResponsiveGridRow(
                                children: [
                                  ResponsiveGridCol(
                                    lg: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: _buildContactInfoCard(
                                        studentsDetail,
                                        mobileView,
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    lg: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: mobileView ? 0 : 15,
                                        top: mobileView ? 25 : 0,
                                      ),
                                      child: _buildLeaderboardCard(mobileView),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    lg: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: mobileView ? 0 : 15,
                                        top: mobileView ? 25 : 0,
                                      ),
                                      child: _buildStatisticsCard(mobileView),
                                    ),
                                  ),
                                  ResponsiveGridCol(lg: 3, child: SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// -------- TabBar pinned at top after scroll --------
                      SliverAppBar(
                        pinned: true,
                        floating: false,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(
                            20,
                          ), // 👈 fixed height
                          child: AnimatedBuilder(
                            animation: tabController,
                            builder: (context, _) {
                              return TabBar(
                                controller: tabController,
                                labelColor: AppColors.primary500,
                                dividerColor: isDarkMode
                                    ? AppColors.grey100Color
                                    : AppColors.greyColor,
                                unselectedLabelStyle: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                indicator: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.cardDarkBg2Color
                                      : AppColors.primary50,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.primary500,
                                    ),
                                  ),
                                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
                                ),
                                tabs: [
                                  SizedBox(
                                    height: 50,
                                    child: tabView(
                                      CommonImageAssets.cap,
                                      'All Courses',
                                      courses.length,
                                      tabController.index == 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: tabView(
                                      CommonImageAssets.cap,
                                      'Completed Courses',
                                      completed.length,
                                      tabController.index == 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: tabView(
                                      CommonImageAssets.cap,
                                      'Ongoing Courses',
                                      ongoing.length,
                                      tabController.index == 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: tabView(
                                      CommonImageAssets.paymentHistory,
                                      'Payment History',
                                      ongoing.length,
                                      tabController.index == 3,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ];
                  },

                  /// -------- TabBarView scrollable content --------
                  body: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        buildCourseList(courses, context),
                        buildCourseList(completed, context),
                        buildCourseList(ongoing, context),
                        paymentListView(mobileView),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  /// Contact Info Card
  Widget _buildContactInfoCard(
    StudentManagementModel studentsDetail,
    bool mobileView,
  ) {
    return Container(
      height: mobileView ? null : 336,
      decoration: mobileView ? null : commonCardDecoration(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mobileView ? 0 : 12,
                vertical: mobileView ? 0 : 12,
              ),
              child: CommonText.regular(
                InstructorManagementDetailStrings.contactInformation,
                size: 16,
              ),
            ),
            mobileView ? const SizedBox() : CommonDivider(),
            const Gap(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: mobileView ? 72 : 65,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: mobileView ? 72 : 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                CommonImageAssets.instructorProfileDetailBg,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          child: Container(
                            height: mobileView ? 72 : 64,
                            width: mobileView ? 72 : 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: commonCacheImage(
                                studentsDetail.image,
                                ImagePlaceHolder.imagePlaceHolderDark,
                                height: mobileView ? 72 : 64,
                                width: mobileView ? 72 : 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                  commonDetailText(
                    InstructorManagementDetailStrings.name,
                    controller.data.value.contactInformation?.name,
                    context,
                  ),
                  const Gap(15),
                  CommonDivider(),
                  const Gap(15),
                  commonDetailText(
                    InstructorManagementDetailStrings.email,
                    controller.data.value.contactInformation?.email,
                    context,
                  ),
                  const Gap(15),
                  CommonDivider(),
                  const Gap(15),
                  commonDetailText(
                    InstructorManagementDetailStrings.mobileNo,
                    controller.data.value.contactInformation?.phoneNo,
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Leaderboard Card
  Widget _buildLeaderboardCard(bool mobileView) => Container(
    height: mobileView ? null : 336,
    decoration: mobileView ? null : commonCardDecoration(12),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mobileView ? 0 : 12,
              vertical: mobileView ? 0 : 12,
            ),
            child: CommonText.regular(
              StudentManagementDetailStrings.pointsAndLLeaderBoard,
              size: 16,
            ),
          ),

          mobileView ? SizedBox() : CommonDivider(),
          const Gap(17),
          mobileView
              ? Row(
                  children: [
                    Expanded(
                      child: commonPointsView(
                        CommonImageAssets.leaderboardPosition,
                        StudentManagementDetailStrings.leaderBoardPosition,
                        controller.data.value.leaderBoardPosition.toString(),
                        mobileView,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: commonPointsView(
                        CommonImageAssets.totalEarned,
                        StudentManagementDetailStrings.totalEarnedCoins,
                        controller.data.value.totalEarnedCoins.toString(),
                        mobileView,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonPointsView(
                      CommonImageAssets.leaderboardPosition,
                      StudentManagementDetailStrings.leaderBoardPosition,
                      controller.data.value.leaderBoardPosition.toString(),
                      mobileView,
                    ),
                    const Gap(17),
                    commonPointsView(
                      CommonImageAssets.totalEarned,
                      StudentManagementDetailStrings.totalEarnedCoins,
                      controller.data.value.totalEarnedCoins.toString(),
                      mobileView,
                    ),
                    const Gap(12),
                  ],
                ),
        ],
      ),
    ),
  );

  /// Statistics Card
  Widget _buildStatisticsCard(bool mobileView) => Container(
    height: mobileView ? null : 336,
    decoration: mobileView ? null : commonCardDecoration(12),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mobileView ? 0 : 12,
              vertical: mobileView ? 0 : 12,
            ),
            child: CommonText.regular(
              StudentManagementDetailStrings.statistics,
              size: 16,
            ),
          ),
      
          mobileView ? SizedBox() : CommonDivider(),
          const Gap(15),
          commonStatisticsView(
            StudentManagementDetailStrings.totalCourses,
            controller.data.value.totalCourse.toString(),
            mobileView,
          ),
          const Gap(15),
          commonStatisticsView(
            StudentManagementDetailStrings.completedCourses,
            controller.data.value.completedCourse.toString(),
            mobileView,
          ),
          const Gap(15),
          commonStatisticsView(
            StudentManagementDetailStrings.ongoingCourses,
            controller.data.value.ongoingCourses.toString(),
            mobileView,
          ),
        ],
      ),
    ),
  );
}
