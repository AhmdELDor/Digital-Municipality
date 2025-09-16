part of 'approvals_course_detail_imports.dart';

class CourseApprovalsDetailView extends StatefulWidget {
  final CourseModel? course;
  final String? title;
  const CourseApprovalsDetailView({super.key, this.course, this.title});

  @override
  State<CourseApprovalsDetailView> createState() =>
      _CourseApprovalsDetailViewState();
}

class _CourseApprovalsDetailViewState extends State<CourseApprovalsDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CourseApprovalsDetailController controller = Get.put(
    CourseApprovalsDetailController(),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.course == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final tabCount = widget.title != null ? 4 : 2;
    final isDarkMode = Get.find<ThemeController>().isDarkMode;
    final mobileView = ResponsiveView.isMobile(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        searchController: controller.searchController,
        showBackIcon: true,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),

      body: DefaultTabController(
        length: tabCount,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _headerView(widget.title)),

              if (mobileView)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverTabBarDelegate(
                    _tabBar(widget.title),
                    backgroundColor: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.white,
                  ),
                ),
            ];
          },
          body: mobileView
              ? _tabBarView(widget.title)
              : SizedBox(
                  height: 200,
                  //color: Colors.yellow,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: mobileView ? 0 : 20,
                      vertical: 20,
                    ),
                    child: ResponsiveGridRow(
                      children: [
                        ResponsiveGridCol(
                          lg: 9,
                          xs: 12,
                          child: Container(
                            height: context.height,
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
                            child: Column(
                              children: [
                                if (!mobileView)
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: _tabBar(widget.title),
                                  ),
                                Expanded(child: _tabBarView(widget.title)),
                              ],
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
                                  _desktopUserView(widget.course),
                                  Gap(30),
                                  courseFeaturesView(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  _tabBar(String? title) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    final mobileView = ResponsiveView.isMobile(context);
    return TabBar(
      //controller: tabController,
      labelColor: AppColors.lightPrimaryColor,
      dividerColor: isDarkMode ? AppColors.grey100Color : AppColors.greyColor,
      unselectedLabelStyle: TextStyle(
        color: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
        fontWeight: FontWeight.w500,
        fontSize: mobileView?15:16,
      ),
      labelStyle: TextStyle(
        color: AppColors.lightPrimaryColor,
        fontWeight: FontWeight.w600,
        fontSize: mobileView?15:16,
      ),
      indicator: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkBg2Color : AppColors.primary50,
        border: Border(bottom: BorderSide(color: AppColors.primary500)),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
      ),
      padding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: true,
      tabAlignment:TabAlignment.start ,
      tabs: [
        Tab(text: CourseApprovalsDetailStrings.aboutCourse),
        Tab(text: CourseApprovalsDetailStrings.curriculum),
        if (title != null) Tab(text: CourseApprovalsDetailStrings.attendees),
        if (title != null) Tab(text: CourseApprovalsDetailStrings.reviews),
      ],
    );
  }

  Widget _tabBarView(String? title) {
    return SafeArea(
      child: TabBarView(
        children: title != null
            ? [
                SingleChildScrollView(child: AboutCoursesView()),
                SingleChildScrollView(child: CurriculumView()),
                SingleChildScrollView(child: AttendeesView()),
                SingleChildScrollView(child: ReviewsView()),
              ]
            : [
                SingleChildScrollView(child: AboutCoursesView()),
                SingleChildScrollView(child: CurriculumView()),
              ],
      ),
    );
  }

  _headerView(String? title) {
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      children: [
        mobileView
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: CommonSearchField(
                  controller: controller.searchController,
                  hintText: DashboardViewStrings.searchAnything,
                ),
              )
            : SizedBox(),

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CommonText.semiBold(
                      title == 'category'
                          ? ViewCourseCategoryStrings.viewCourse
                          : title == 'view'
                          ? ViewCourseCategoryStrings.viewCourse
                          : CourseApprovalsDetailStrings.courseApprovals,
                      size: mobileView ? 15 : 17,
                      fontWeight: mobileView
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                  title == 'category'
                      ? SizedBox()
                      : title == 'view'
                      ? SizedBox()
                      : SizedBox(
                          width: mobileView ? 72 : 120,
                          child: PrimaryButton(
                            height: mobileView ? 32 : 36,
                            backgroundColor: AppColors.error500,
                            onPressed: () {
                              commonDialogBox(
                                context: context,
                                child: SizedBox(
                                  width: 560,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    child: FeedBackInstructorDialog(
                                      feedbackController:
                                          controller.feedbackController,
                                      formKey: controller.formKey,

                                      onPressed: () {
                                        final isValid = controller
                                            .formKey
                                            .currentState!
                                            .validate();
                                        FocusScope.of(
                                          context,
                                        ).unfocus(); // ✅ safer than Get.focusScope

                                        if (!isValid) return;

                                        controller.formKey.currentState!.save();
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                        commonDialogBox(
                                          context: context,
                                          child: SizedBox(
                                            width: 560,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20,
                                                  ),
                                              child: CourseApproveDialog(
                                                image: CommonImageAssets
                                                    .courseDecline,
                                                title:
                                                    CourseApproveDialogStrings
                                                        .courseDeclined,
                                                subtitle:
                                                    CourseApproveDialogStrings
                                                        .courseDeclinedDes,
                                                buttonName:
                                                    CourseApproveDialogStrings
                                                        .goToCourse,
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).pop();
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            label: ApprovalsStrings.decline,
                            textSize: mobileView ? 14 : 16,
                            textWeight: FontWeight.w400,
                          ),
                        ),
                  Gap(10),
                  title == 'category'
                      ? SizedBox()
                      : title == 'view'
                      ? SizedBox()
                      :SizedBox(
                          width: mobileView ? 77 : 120,
                          child: PrimaryButton(
                            height: mobileView ? 32 : 36,
                            backgroundColor: AppColors.success500,
                            onPressed: () {
                              commonDialogBox(
                                context: context,
                                child: SizedBox(
                                  width: 560,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    child: CourseApproveDialog(
                                      image: CommonImageAssets.courseApprove,
                                      title: CourseApproveDialogStrings
                                          .courseApproved,
                                      subtitle: CourseApproveDialogStrings
                                          .courseApprovedDes,
                                      buttonName:
                                          CourseApproveDialogStrings.goToCourse,
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              );
                            },
                            label: ApprovalsStrings.approve,
                            textSize: mobileView ? 14 : 16,
                            textWeight: FontWeight.w400,
                          ),
                        ),
                ],
              ),
            ),

            CommonDivider(),
          ],
        ),
        Gap(20),
        mobileView ? _deviceUserView() : SizedBox(),
        Gap(mobileView ? 20 : 0),
      ],
    );
  }

  _desktopUserView(CourseModel? courseData) {
    if (courseData == null) return SizedBox();
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Obx(
      () => Container(
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
            Row(
              children: [
                Expanded(
                  child: CommonText.semiBold(
                    controller.data.value.courseFees.toString(),
                    size: 20,
                    color: AppColors.primary500,
                  ),
                ),
                SvgImageFromAsset(AppCommonIcon.starIcon),
                Gap(3),
                CommonText.semiBold('4.5', size: 18,color: AppColors.secondary500,),

              ],
            ),
            Gap(20),
            CommonDivider(),
            Gap(20),
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
