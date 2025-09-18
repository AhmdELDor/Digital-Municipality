part of 'side_drawer_imports.dart';

class SideDrawerMenu extends StatefulWidget {
  const SideDrawerMenu({super.key});

  @override
  State<SideDrawerMenu> createState() => _SideDrawerMenuState();
}

class _SideDrawerMenuState extends State<SideDrawerMenu> {
  SideDrawerController controller = Get.put(SideDrawerController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: MediaQuery.sizeOf(context).height,
      //width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkBgColor : AppColors.white,
        border: Border(
          right: BorderSide(color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor, width: 1.5),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(15),
              Align(
                alignment: Alignment.center,
                child: SvgImageFromAsset(
                  CommonImageAssets.appLogo,
                  width: 28,
                  height: 40,
                ),
              ),
              Gap(15),
              CommonDivider(),
              //Container(height: 1, color: AppColors.lightBorderColor),
              Gap(15),
              commonDrawerView(
                index: 0,
                image: AppCommonIcon.homeIcon,
                title: DashboardViewStrings.dashboard,
                onTap: () {
                  controller.drawerSelection(0);
                  context.go(AppRouteName.dashboardView);
                },
                activeImage: AppCommonIcon.activeHomeIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 1,
                image: AppCommonIcon.approvalsIcon,
                title: DashboardViewStrings.approvals,
                onTap: () {
                  controller.drawerSelection(1);
                  context.go(AppRouteName.approvalsView);
                },
                activeImage: AppCommonIcon.activeApprovalsIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 2,
                image: AppCommonIcon.courseManagementIcon,
                title: DashboardViewStrings.courseManagement,
                onTap: () {
                  controller.drawerSelection(2);
                  context.go(AppRouteName.courseManagementView);
                },
                activeImage: AppCommonIcon.activeCourseManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 3,
                image: AppCommonIcon.classManagementIcon,
                title: DashboardViewStrings.classManagement,
                onTap: () {
                  controller.drawerSelection(3);
                  context.go(AppRouteName.classManagementView);
                },
                activeImage: AppCommonIcon.activeClassManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 4,
                image: AppCommonIcon.instructorManagementIcon,
                title: DashboardViewStrings.instructorManagement,
                onTap: () {
                  controller.drawerSelection(4);
                  context.go(AppRouteName.instructorManagementView);
                },
                activeImage: AppCommonIcon.activeInstructorManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 5,
                image: AppCommonIcon.universityManagementIcon,
                title: DashboardViewStrings.universityManagement,
                onTap: () {
                  controller.drawerSelection(5);
                  context.go(AppRouteName.universityManagementView);
                },
                activeImage: AppCommonIcon.activeUniversityManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 6,
                image: AppCommonIcon.categoryIcon,
                title: DashboardViewStrings.category,
                onTap: () {
                  controller.drawerSelection(6);
                  context.go(AppRouteName.courseCategoryView);
                },
                activeImage: AppCommonIcon.activeCategoryIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 7,
                image: AppCommonIcon.quizIcon,
                title: DashboardViewStrings.quiz,
                onTap: () {
                  controller.drawerSelection(7);
                  context.go(AppRouteName.quizView);
                },
                activeImage: AppCommonIcon.activeQuizIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 8,
                image: AppCommonIcon.testIcon,
                title: DashboardViewStrings.test,
                onTap: () {
                  controller.drawerSelection(8);
                  context.go(AppRouteName.mainTestView);
                },
                activeImage: AppCommonIcon.activeTestIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 9,
                image: AppCommonIcon.studentManagementIcon,
                title: DashboardViewStrings.studentManagement,
                onTap: () {
                  controller.drawerSelection(9);
                  context.go(AppRouteName.studentManagementView);
                },
                activeImage: AppCommonIcon.activeStudentManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 10,
                image: AppCommonIcon.financeManagementIcon,
                title: DashboardViewStrings.financeManagement,
                onTap: () {
                  controller.drawerSelection(10);
                  context.go(AppRouteName.financeManagementView);
                },
                activeImage: AppCommonIcon.activeFinanceManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 11,
                image: AppCommonIcon.reportsAndAnalyticsIcon,
                title: DashboardViewStrings.reportsAndAnalytics,
                onTap: () {
                  controller.drawerSelection(11);
                  context.go(AppRouteName.reportsAnalysisView);
                },
                activeImage: AppCommonIcon.activeReportsAndAnalyticsIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 12,
                image: AppCommonIcon.certificateManagementIcon,
                title: DashboardViewStrings.certificateManagement,
                onTap: () {
                  controller.drawerSelection(12);
                  context.go(AppRouteName.certificateManagementView);
                },
                activeImage: AppCommonIcon.activeCertificateManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 13,
                image: AppCommonIcon.userManagementIcon,
                title: DashboardViewStrings.userManagement,
                onTap: () {
                  controller.drawerSelection(13);
                  context.go(AppRouteName.userManagementView);
                },
                activeImage: AppCommonIcon.activeUserManagementIcon,
              ),
              Gap(20),
              commonDrawerView(
                index: 14,
                image: AppCommonIcon.settingIcon,
                title: DashboardViewStrings.setting,
                onTap: () {
                  controller.drawerSelection(14);
                  context.go(AppRouteName.settingView);
                },
                activeImage: AppCommonIcon.activeSettingIcon,
              ),
              Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonDrawerView({
    required int index,
    required String image,
    required String title,
    required void Function() onTap,
    required String activeImage,
  }) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Obx(
      () => InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 5,
              decoration: BoxDecoration(
                color: controller.selectedDrawerIndex.value == index
                    ? AppColors.brand600
                    : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Gap(12),
            Container(
              height: 50,
              width: 225,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: controller.selectedDrawerIndex.value == index
                    ? LinearGradient(
                        colors: [AppColors.brand700, AppColors.primary500],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  controller.selectedDrawerIndex.value == index
                      ? SvgImageFromAsset(activeImage, height: 20, width: 20)
                      : SvgImageFromAsset(
                          image,
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            isDarkMode
                                ? AppColors.white
                                : AppColors.headingsColor,
                            BlendMode.srcIn,
                          ),
                        ),
                  Gap(7),
                  CommonText.semiBold(
                    title,
                    size: 14,
                    fontWeight: controller.selectedDrawerIndex.value == index
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: controller.selectedDrawerIndex.value == index
                        ? AppColors.white
                        : isDarkMode
                        ? AppColors.headingsLightColor
                        : AppColors.headingsColor,
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
