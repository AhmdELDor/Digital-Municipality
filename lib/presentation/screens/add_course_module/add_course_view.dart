part of 'add_course_view_imports.dart';

class AddCourseView extends StatefulWidget {
  const AddCourseView({super.key});

  @override
  State<AddCourseView> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView>
    with TickerProviderStateMixin {
  AddCourseController controller = Get.put(AddCourseController());
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    final args = GoRouterState.of(context).extra as Map?;
    final data = args?['data'];

    // fill controllers once
    if (data != null) {
      controller.fillData(data);
    }
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
        child: mobileView ? mobileDetailView() : desktopDetailView(),
      ),
    );
  }

  Widget desktopDetailView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: CommonText.semiBold(AddCoursesStrings.addCourses, size: 17),
          ),
          ResponsiveGridRow(
            children: [
              ResponsiveGridCol(
                lg: 9,
                child: SizedBox(
                  height: context.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 600,
                        child: TabBar(
                          controller: tabController,
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            Obx(
                              () => Tab(
                                child: customTab(
                                  AddCoursesStrings.basicInformation,
                                  CommonImageAssets.basicInformation,
                                  CommonImageAssets.activeBasicInformation,
                                  context,
                                  isSelected: controller.selectedIndex.value == 0,
                                ),
                              ),
                            ),
                            Obx(
                              () => Tab(
                                child: customTab(
                                  AddCoursesStrings.extraInformation,
                                  CommonImageAssets.extraInFormation,
                                  CommonImageAssets.activeExtraInFormation,
                                  context,
                                  isSelected: controller.selectedIndex.value == 1,
                                ),
                              ),
                            ),
                            Obx(
                              () => Tab(
                                child: customTab(
                                  AddCoursesStrings.curriculum,
                                  CommonImageAssets.curriculum,
                                  CommonImageAssets.activeCurriculum,
                                  context,
                                  isSelected: controller.selectedIndex.value == 2,
                                ),
                              ),
                            ),
                          ],
                          indicator: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.cardDarkBg2Color
                                : AppColors.primary50,
                            border: Border(
                              bottom: BorderSide(color: AppColors.primary500),
                            ),
                            // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 25,
                          ),
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              BasicInformationView(),
                              ExtraInformationView(),
                              CourseCurriculumView(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        child: Obx(
                              () =>controller.selectedIndex.value == 2?SizedBox():  Row(
                            children: [
                              SizedBox(
                                width: 160,
                                child: PrimaryButton(
                                  height: 42,
                                  onPressed: () {
                                    if (controller.selectedIndex.value > 0) {
                                      tabController.animateTo(controller.selectedIndex.value - 1);
                                    }
                                  },
                                  label: AddCoursesStrings.previous,
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                  backgroundColor: isDarkMode
                                      ? AppColors.mainDarkBgColor
                                      : AppColors.lightBgColor,
                                  borderSide: BorderSide(
                                    color: AppColors.primary500,
                                    width: 1,
                                  ),
                                  textColor: AppColors.primary500,
                                ),
                              ),
                              Gap(25),
                              SizedBox(
                                width: 160,
                                child: PrimaryButton(
                                  height: 42,
                                  onPressed: () {
                                    if (controller.selectedIndex.value < 2) {
                                      tabController.animateTo(controller.selectedIndex.value + 1);
                                    }
                                  },
                                  label: controller.selectedIndex.value==2?AddCoursesStrings.addCourse:AddCoursesStrings.saveAndNext,
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mobileDetailView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: CommonText.semiBold(AddCoursesStrings.addCourses, size: 17),
        ),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(3, (index) {
                      return Obx(() {
                        return Padding(
                          padding: EdgeInsets.only(
                            left:
                                index == 0 &&
                                    controller.selectedIndex.value == 0
                                ? 0
                                : 10,
                            right: 10,
                          ),
                          child: Tab(
                            child: buildStepTab(
                              index,
                              index == 0
                                  ? AddCoursesStrings.basicInformation
                                  : index == 1
                                  ? AddCoursesStrings.extraInformation
                                  : AddCoursesStrings.curriculum,
                              '',
                              index == 0
                                  ? CommonImageAssets.activeBasicInformation
                                  : index == 1
                                  ? CommonImageAssets.activeExtraInFormation
                                  : CommonImageAssets.activeCurriculum,
                              context,
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                ),
              ),
              Gap(10),
              InkWell(
                onTap: () {
                  if (controller.selectedIndex.value > 0) {
                    tabController.animateTo(controller.selectedIndex.value - 1);
                  }
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.lightBgColor,
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: controller.selectedIndex.value == 0
                          ? isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor
                          : AppColors.bodyTextColor,
                      size: 17,
                    ),
                  ),
                ),
              ),
              Gap(7),
              InkWell(
                onTap: () {
                  if (controller.selectedIndex.value < 2) {
                    tabController.animateTo(controller.selectedIndex.value + 1);
                  }
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.lightBgColor,
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                      size: 17,
                    ),
                  ),
                ),
              ),
              Gap(10),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                BasicInformationView(),
                ExtraInformationView(),
                CourseCurriculumView(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Obx(
            () =>  Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    height: 42,
                    onPressed: () {
                      if (controller.selectedIndex.value > 0) {
                        tabController.animateTo(controller.selectedIndex.value - 1);
                      }
                    },
                    label: AddCoursesStrings.previous,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                    backgroundColor: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.lightBgColor,
                    borderSide: BorderSide(
                      color: AppColors.primary500,
                      width: 1,
                    ),
                    textColor: AppColors.primary500,
                  ),
                ),
                Gap(25),
                Expanded(
                  child: PrimaryButton(
                    height: 42,
                    onPressed: () {
                      if (controller.selectedIndex.value < 2) {
                        tabController.animateTo(controller.selectedIndex.value + 1);
                      }
                    },
                    label: controller.selectedIndex.value==2?AddCoursesStrings.addCourse:AddCoursesStrings.saveAndNext,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
