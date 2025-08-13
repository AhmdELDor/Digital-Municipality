part of 'approvals_view_imports.dart';

class ApprovalsView extends StatefulWidget {
  const ApprovalsView({super.key});

  @override
  State<ApprovalsView> createState() => _ApprovalsViewState();
}

class _ApprovalsViewState extends State<ApprovalsView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      controller.selectedIndex.value = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonText.semiBold(
                    DashboardViewStrings.approvals,
                    size: 17,
                  ),
                ),
                mobileView
                    ? filterView(() {
                        showBottomSheet(
                          enableDrag: false,

                          context: context,
                          builder: (context) {
                            return Container(
                              height: context.height,
                              padding: EdgeInsets.symmetric(vertical: 25),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.mainDarkBgColor
                                    : AppColors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonText.medium(
                                          ApprovalsStrings.filter,
                                          size: 16,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: SvgImageFromAsset(
                                            AppCommonIcon.closeIcon,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  CommonDivider(),

                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            controller.selectedIndex.value==0? _courseFilterView():
                                            controller.selectedIndex.value==1?_instructorFilterView():_universityFilterView()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: OutlineButton(
                                            height: 40,
                                            onPressed: () {
                                              controller.clearAllSelection();
                                            },
                                            label: ApprovalsStrings.clear,
                                            borderSide: BorderSide(
                                              color: AppColors.primary500,
                                            ),
                                            textColor: AppColors.primary500,
                                            textSize: 16,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(20),
                                        Expanded(
                                          child: PrimaryButton(
                                            height: 40,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            label: AppCommonStrings.btnApply,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      })
                    : SizedBox(),
              ],
            ),
          ),
          CommonDivider(),
          TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary500, width: 1),
              ),
            ),
            tabAlignment: TabAlignment.start,

            tabs: [
              Obx(
                () => Tab(
                  child: customTabWithBadge(
                    ApprovalsStrings.coursesApproval,
                    controller.data.value.coursesApprovalsList.length,
                    isSelected: controller.selectedIndex.value == 0,
                  ),
                ),
              ),
              Obx(
                () => Tab(
                  child: customTabWithBadge(
                    ApprovalsStrings.instructorsApproval,
                    controller.data.value.instructorApprovalsList.length,
                    isSelected: controller.selectedIndex.value == 1,
                  ),
                ),
              ),
              Obx(
                () => Tab(
                  child: customTabWithBadge(
                    ApprovalsStrings.universityApproval,
                    controller.data.value.universityApprovalsList.length,
                    isSelected: controller.selectedIndex.value == 2,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: [
                  _courseApprovalView(),
                  _instructorView(),
                  _universityView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _courseApprovalView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mobileView
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: usersDropDown()),
                        Gap(20),
                        Expanded(child: courseCategoryDropDown()),
                        Gap(20),
                        Expanded(child: languageDropDown()),
                        Gap(20),
                        Expanded(child: priceRangeDropDown()),
                        Gap(20),

                        Expanded(
                          child: customDatePicker(controller.dateController),
                        ),
                        Gap(20),
                        CommonText.medium(
                          ApprovalsStrings.clearAll,
                          size: 14,
                          color: AppColors.error500,
                        ),
                        Gap(20),
                        CommonText.semiBold(
                          '${controller.data.value.coursesApprovalsList.length.toString()} Results',
                          size: 15,
                          color: AppColors.primary500,
                        ),
                      ],
                    ),

              Gap(mobileView ? 0 : 20),
              ListView.builder(
                itemCount: controller.data.value.coursesApprovalsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data =
                      controller.data.value.coursesApprovalsList[index];
                  return InkWell(
                    onTap: () {
                      context.push(AppRouteName.courseApprovalsDetailView,extra: data);
                    },
                      child: CommonCourseView(course: data));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _instructorView() {
    var mobileView = ResponsiveView.isMobile(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mobileView
                  ? SizedBox()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: instructorUsersDropDown()),
                  Gap(20),
                  Expanded(child: identityProofTypeDropDown()),
                  Gap(20),
                  Expanded(child: qualificationProofTypeDropDown()),

                  Gap(20),

                  Expanded(
                    child: customDatePicker(
                      controller.instructorDateController,
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    child: CommonText.medium(
                      ApprovalsStrings.clearAll,
                      size: 14,
                      color: AppColors.error500,
                    ),
                  ),
                  Gap(20),
                  CommonText.semiBold(
                    '${controller.data.value.coursesApprovalsList.length.toString()} Results',
                    size: 15,
                    color: AppColors.primary500,
                  ),
                ],
              ),

              Gap(mobileView ? 0 : 20),
              ResponsiveGridRow(
                children: List.generate(
                  controller.data.value.instructorApprovalsList.length,
                  (index) {
                    final data =
                        controller.data.value.instructorApprovalsList[index];
                    return ResponsiveGridCol(
                      lg: 3,
                      xs: 12,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: mobileView ? 0 : 15,
                          bottom: mobileView ? 20 : 0,
                        ),
                        child: InstructorView(data: data),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _universityView() {
    var mobileView = ResponsiveView.isMobile(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mobileView
                  ? SizedBox()
                  :Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: registrationProofTypeDropDown()),

                  Gap(20),

                  Expanded(
                    child: customDatePicker(
                      controller.universityDateController,
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    child: CommonText.medium(
                      ApprovalsStrings.clearAll,
                      size: 14,
                      color: AppColors.error500,
                    ),
                  ),
                  Gap(20),
                  CommonText.semiBold(
                    '${controller.data.value.coursesApprovalsList.length.toString()} Results',
                    size: 15,
                    color: AppColors.primary500,
                  ),
                ],
              ),

              Gap(mobileView ? 0 : 20),
              ResponsiveGridRow(
                children: List.generate(
                  controller.data.value.universityApprovalsList.length,
                  (index) {
                    final data =
                        controller.data.value.universityApprovalsList[index];
                    return ResponsiveGridCol(
                      lg: 3,
                      xs: 12,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: mobileView ? 0 : 15,
                          bottom: mobileView ? 20 : 0,
                        ),
                        child: UniversityView(data: data),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _courseFilterView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        usersDropDown(),
        Gap(15),
        courseCategoryDropDown(),
        Gap(15),
        languageDropDown(),
        Gap(15),
        priceRangeDropDown(),
        Gap(15),
        customDatePicker(controller.dateController),
      ],
    );
  }

  _instructorFilterView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        instructorUsersDropDown(),
        Gap(15),
        identityProofTypeDropDown(),
        Gap(15),
        qualificationProofTypeDropDown(),
        Gap(15),
        customDatePicker(controller.instructorDateController),
      ],
    );
  }

  _universityFilterView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        registrationProofTypeDropDown(),
        Gap(15),
        customDatePicker(controller.universityDateController),
      ],
    );
  }
}
