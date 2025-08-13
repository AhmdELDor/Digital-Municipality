part of 'approvals_course_detail_imports.dart';

class CourseApprovalsDetailView extends StatefulWidget {
  const CourseApprovalsDetailView({super.key});

  @override
  State<CourseApprovalsDetailView> createState() =>
      _CourseApprovalsDetailViewState();
}

class _CourseApprovalsDetailViewState extends State<CourseApprovalsDetailView>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  CourseApprovalsDetailController controller = Get.put(
    CourseApprovalsDetailController(),
  );
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    final courseData = GoRouterState.of(context).extra as CourseModel;
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

        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _headerView()),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverTabBarDelegate(
                  _tabBar(),
                  backgroundColor: isDarkMode
                      ? AppColors.mainDarkBgColor
                      : AppColors.white,
                ),
              ),
            ];
          },
          body: mobileView?_tabBarView():
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 20, vertical: 20),
            child: ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 9,
                  xs: 12,
                  child: Container(
                    margin: EdgeInsets.only(right: mobileView ? 0 : 20),
                    decoration: mobileView
                        ? null
                        : BoxDecoration(
                      color: isDarkMode
                          ? AppColors.mainDarkBgColor
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.grey100Color
                            : AppColors.lightBorderColor,
                        width: 1,
                      ),
                    ),
                    child: SizedBox(
                      height: context.height,
                      child:  _tabBarView(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 3,
                  xs: 0,
                  child: SizedBox(
                    height: context.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _desktopUserView(courseData),
                          Gap(20),
                          courseFeaturesView(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )

      // body: Padding(
      //   padding: EdgeInsets.symmetric(
      //     horizontal: mobileView ? 0 : 20,
      //     vertical: 20,
      //   ),
      //   child: NestedScrollView(
      //     headerSliverBuilder: (context, innerBoxIsScrolled) {
      //       return [
      //         SliverToBoxAdapter(
      //           child: _headerView(),
      //         ),
      //
      //         SliverPersistentHeader(
      //           pinned: true,
      //           delegate: SliverTabBarDelegate(
      //             _tabBar(),
      //             backgroundColor: isDarkMode
      //                 ? AppColors.mainDarkBgColor
      //                 : AppColors.white,
      //           ),
      //         ),
      //       ];
      //     },
      //     body: SingleChildScrollView(
      //       physics: NeverScrollableScrollPhysics(),
      //       child: SafeArea(
      //         child: ResponsiveGridRow(
      //           children: [
      //             ResponsiveGridCol(
      //               lg: 9,
      //               xs: 12,
      //               child: Container(
      //                 height: context.height,
      //                 margin: EdgeInsetsGeometry.only(
      //                   right: mobileView ? 0 : 20,
      //                 ),
      //                 decoration: mobileView
      //                     ? null
      //                     : BoxDecoration(
      //                   color: isDarkMode
      //                       ? AppColors.mainDarkBgColor
      //                       : AppColors.white,
      //                   borderRadius: BorderRadius.circular(20),
      //                   border: Border.all(
      //                     color: isDarkMode
      //                         ? AppColors.grey100Color
      //                         : AppColors.lightBorderColor,
      //                     width: 1,
      //                   ),
      //                 ),
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(
      //                     mobileView ? 0 : 20,
      //                   ),
      //                   child: Expanded(
      //                     child: TabBarView(
      //                       controller: tabController,
      //                       children: [
      //                         SingleChildScrollView(
      //
      //                             child: AboutCoursesView()),
      //                         CurriculumView(),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //
      //             ResponsiveGridCol(
      //               lg: 3,
      //               xs: 0,
      //               child: SizedBox(
      //                 height: context.height * 0.9,
      //                 child: SingleChildScrollView(
      //                   child: Obx(
      //                         () => Column(
      //                       mainAxisAlignment: MainAxisAlignment.start,
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         _desktopUserView(courseData),
      //                         Gap(20),
      //                         courseFeaturesView(),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  _tabBar(){
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return  TabBar(
      controller: tabController,
      labelColor: AppColors.lightPrimaryColor,
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
        color: AppColors.lightPrimaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      indicator: BoxDecoration(
        color: isDarkMode
            ? AppColors.cardDarkBg2Color
            : AppColors.primary50,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary500,
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(
          text:
          CourseApprovalsDetailStrings.aboutCourse,
        ),
        Tab(
          text: CourseApprovalsDetailStrings.curriculum,
        ),
      ],
    );
  }
  _tabBarView(){
    return SafeArea(
      child: TabBarView(
        controller: tabController,
        children: [
          // Make this scrollable
          SingleChildScrollView(child: AboutCoursesView()),
          SingleChildScrollView(child: CurriculumView()),
        ],
      ),
    );
  }
_headerView(){
  var mobileView = ResponsiveView.isMobile(context);
    return Column(
      children: [
        mobileView
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: CommonSearchField(
                        controller: controller.searchController,
                        hintText: DashboardViewStrings.searchAnything,
                      ),
            )
            : SizedBox(),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: CommonText.semiBold(
                  CourseApprovalsDetailStrings.courseApprovals,
                  size: mobileView?15:17,
                  fontWeight: mobileView?FontWeight.w500:FontWeight.w600,
                ),
              ),
              SizedBox(
                width: mobileView ? 72 : 120,
                child: PrimaryButton(
                  height: mobileView ? 32 : 36,
                  backgroundColor: AppColors.error500,
                  onPressed: () {},
                  label: ApprovalsStrings.decline,
                  textSize: mobileView ? 14 : 16,
                  textWeight: FontWeight.w400,
                ),
              ),
              Gap(10),
              SizedBox(
                width: mobileView ? 77 : 120,
                child: PrimaryButton(
                  height: mobileView ? 32 : 36,
                  backgroundColor: AppColors.success500,
                  onPressed: () {},
                  label: ApprovalsStrings.decline,
                  textSize: mobileView ? 14 : 16,
                  textWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Gap(20),
        mobileView ? _deviceUserView() : SizedBox(),
        Gap(mobileView ? 20 : 0),
      ],
    );
}
  _desktopUserView(CourseModel courseData) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Obx(
      () =>  Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: commonCacheImage(
                courseData.image,
                ImagePlaceHolder.imagePlaceHolderDark,
                height: 250,
              ),
            ),
            Gap(10),
            CommonText.medium(controller.data.value.name, size: 17),
            Gap(20),
            CommonDivider(),
            Gap(20),
            CommonText.semiBold(
              controller.data.value.courseFees.toString(),
              size: 20,
              color: AppColors.primary500,
            ),
            Gap(15),
          ],
        ),
      ),
    );
  }
  _deviceUserView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: commonCacheImage(
                controller.data.value.image,
                ImagePlaceHolder.imagePlaceHolderDark,
                height: 93,
                width: 140,
              ),
            ),
            Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText.medium(
                    controller.data.value.name,
                    size: 17,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonText.semiBold(
                        controller.data.value.courseFees.toString(),
                        size: 18,
                        color: AppColors.primary500,
                      ),
                      Gap(7),
                      SvgImageFromAsset(AppCommonIcon.starIcon),
                      Gap(7),
                      CommonText.semiBold(
                        controller.data.value.rate.toString(),
                        size: 16,
                        color: AppColors.secondary500,
                      ),
                    ],
                  ),
                  CommonText.regular(
                    '${controller.data.value.attendance.toString()} K Attendees',
                    size: 15,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


