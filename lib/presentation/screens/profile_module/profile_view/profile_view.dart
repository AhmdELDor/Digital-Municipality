part of 'profile_view_imports.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileViewController controller = Get.put(ProfileViewController());
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
        showBackIcon: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
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
                          hintText: DashboardViewStrings.searchAnything,
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: CommonText.semiBold(
                    ProfileViewStrings.myProfile,
                    size: 17,
                  ),
                ),
                CommonDivider(),
                Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: mobileView ? null : 140,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(CommonImageAssets.userProfileBg),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: commonCacheImage(
                            controller.data.value.userProfileImg,
                            ImagePlaceHolder.imagePlaceHolderLight,
                            height: mobileView ? 64 : 100,
                            width: mobileView ? 64 : 100,
                          ),
                        ),
                        Gap(15),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.semiBold(
                                '${controller.data.value.firstName}${controller.data.value.lastName}',
                                size: mobileView ? 16 : 20,
                                color: AppColors.white,
                              ),
                              Gap(5),
                              CommonText.regular(
                                'Super Admin',
                                size: mobileView ? 14 : 15,
                                color: AppColors.white,
                              ),
                              Gap(5),
                              CommonText.regular(
                                'Ahmedabad, India',
                                size: mobileView ? 14 : 15,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            commonDialogBox(
                              context: context,
                              child: SizedBox(
                                width: 560,
                                child: EditProfileView(),
                              ),
                            );
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.lightBorderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: SvgImageFromAsset(
                                AppCommonIcon.editIcon,
                                colorFilter: ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                mobileView
                    ? deviceView(isDarkMode, mobileView)
                    : desktopView(isDarkMode, mobileView),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget desktopView(bool isDarkMode, mobileView) {
    return ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
          lg: 9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText.semiBold(
                              ProfileViewStrings.personalInformation,
                              size: 17,
                            ),
                            SizedBox(
                              width: 77,
                              child: PrimaryButton(
                                textSize: 16,
                                textWeight: FontWeight.w400,
                                onPressed: () {
                                  commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: 560,
                                      child: EditPersonalInformation(),
                                    ),
                                  );
                                },
                                label: ProfileViewStrings.edit,
                                height: 34,
                                prefixIcon: SvgImageFromAsset(
                                  AppCommonIcon.editIcon,
                                  height: 13,
                                  width: 13,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CommonDivider(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.fName,
                              controller.data.value.firstName,
                            ),
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.lName,
                              controller.data.value.lastName,
                            ),
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.joined,
                              controller.data.value.joinedDate,
                            ),
                          ],
                        ),
                      ),
                      Gap(30),

                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.email,
                              controller.data.value.email,
                            ),
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.phoneNo,
                              controller.data.value.phone,
                            ),
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.userRole,
                              controller.data.value.userRole,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(35),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText.semiBold(
                              ProfileViewStrings.address,
                              size: 17,
                            ),
                            SizedBox(
                              width: 77,
                              child: PrimaryButton(
                                textSize: 16,
                                textWeight: FontWeight.w400,
                                onPressed: () {
                                  commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: 560,
                                      child: EditAddressView(),
                                    ),
                                  );
                                },
                                label: ProfileViewStrings.edit,
                                height: 34,
                                prefixIcon: SvgImageFromAsset(
                                  AppCommonIcon.editIcon,
                                  height: 13,
                                  width: 13,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      CommonDivider(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.country,
                              controller.data.value.location.country,
                            ),
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.city,
                              controller.data.value.location.city,
                            ),
                            commonTitleAndSubtitleText(
                              ProfileViewStrings.postalCode,
                              controller.data.value.location.postalCode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ResponsiveGridCol(
          lg: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              commonReportsCardView(
                isDarkMode: isDarkMode,
                textColor: AppColors.white,
                data: controller.data.value.statistics.profileTotalRevenue,
                name: ReportsAnalysis.totalRevenue,
                leading: '\$',
                gradient: isDarkMode
                    ? profileTotalRevenueDarkGradient()
                    : profileTotalRevenueGradient(),
                margin: EdgeInsetsGeometry.only(
                  right: mobileView ? 0 : 20,
                  top: 17,
                ),
                mobileView: mobileView,
              ),
              commonReportsCardView(
                isDarkMode: isDarkMode,
                data: controller.data.value.statistics.profileTotalStudents,
                name: ReportsAnalysis.totalStudents,
                gradient: isDarkMode
                    ? profileTotalStudentsDarkGradient()
                    : profileTotalStudentsGradient(),
                textColor: AppColors.white,
                margin: EdgeInsetsGeometry.only(
                  right: mobileView ? 0 : 20,
                  top: 15,
                ),
                mobileView: mobileView,
              ),
              commonReportsCardView(
                isDarkMode: isDarkMode,
                data: controller.data.value.statistics.profileNewUsersToday,
                name: ReportsAnalysis.newUsersToday,
                gradient: isDarkMode
                    ? profileNewUsersDarkGradient()
                    : profileNewUsersGradient(),
                mobileView: mobileView,
                textColor: AppColors.white,
                margin: EdgeInsetsGeometry.only(
                  right: mobileView ? 0 : 20,
                  top: 15,
                ),
              ),
              Gap(20),
            ],
          ),
        ),
      ],
    );
  }

  Widget deviceView(bool isDarkMode, mobileView) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: commonReportsCardView(
                    isDarkMode: isDarkMode,
                    data: controller.data.value.statistics.profileTotalRevenue,
                    name: ReportsAnalysis.totalRevenue,
                    leading: '\$',
                    gradient: isDarkMode
                        ? profileTotalRevenueDarkGradient()
                        : profileTotalRevenueGradient(),
                    textColor: AppColors.white,
                    margin: EdgeInsetsGeometry.only(
                      right: mobileView ? 0 : 20,
                      top: 17,
                    ),
                    mobileView: mobileView,
                  ),
                ),
                Gap(15),
                SizedBox(
                  width: 250,
                  child: commonReportsCardView(
                    isDarkMode: isDarkMode,
                    data: controller.data.value.statistics.profileTotalStudents,
                    name: ReportsAnalysis.totalStudents,
                    gradient: isDarkMode
                        ? profileTotalStudentsDarkGradient()
                        : profileTotalStudentsGradient(),
                    margin: EdgeInsetsGeometry.only(
                      right: mobileView ? 0 : 20,
                      top: 15,
                    ),
                    mobileView: mobileView,
                    textColor: AppColors.headingsColor,
                  ),
                ),
                Gap(15),
                SizedBox(
                  width: 250,
                  child: commonReportsCardView(
                    isDarkMode: isDarkMode,
                    textColor: AppColors.headingsColor,
                    data: controller.data.value.statistics.profileNewUsersToday,
                    name: ReportsAnalysis.newUsersToday,
                    gradient: isDarkMode
                        ? profileNewUsersDarkGradient()
                        : profileNewUsersGradient(),
                    mobileView: mobileView,
                    margin: EdgeInsetsGeometry.only(
                      right: mobileView ? 0 : 20,
                      top: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.grey100Color
                    : AppColors.lightBorderColor,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText.semiBold(
                        ProfileViewStrings.personalInformation,
                        size: 15,
                      ),
                      SizedBox(
                        width: 73,
                        child: PrimaryButton(
                          textSize: 16,
                          textWeight: FontWeight.w400,
                          onPressed: () {
                            commonDialogBox(
                              context: context,
                              child: SizedBox(
                                width: 560,
                                child: EditPersonalInformation(),
                              ),
                            );
                          },
                          label: ProfileViewStrings.edit,
                          height: 34,
                          prefixIcon: SvgImageFromAsset(
                            AppCommonIcon.editIcon,
                            height: 13,
                            width: 13,
                            colorFilter: ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CommonDivider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.fName,
                        controller.data.value.firstName,
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.lName,
                        controller.data.value.lastName,
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.joined,
                        controller.data.value.joinedDate,
                      ),

                      Gap(15),
                      CommonDivider(),
                      Gap(15),

                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.email,
                        controller.data.value.email,
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.phoneNo,
                        controller.data.value.phone,
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.userRole,
                        controller.data.value.userRole,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.grey100Color
                    : AppColors.lightBorderColor,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText.semiBold(ProfileViewStrings.address, size: 17),
                      SizedBox(
                        width: 73,
                        child: PrimaryButton(
                          textSize: 16,
                          textWeight: FontWeight.w400,
                          onPressed: () {
                            commonDialogBox(
                              context: context,
                              child: SizedBox(
                                width: 560,
                                child: EditAddressView(),
                              ),
                            );
                          },
                          label: ProfileViewStrings.edit,
                          height: 34,
                          prefixIcon: SvgImageFromAsset(
                            AppCommonIcon.editIcon,
                            height: 13,
                            width: 13,
                            colorFilter: ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                CommonDivider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.country,
                        controller.data.value.location.country,
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.city,
                        controller.data.value.location.city,
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      commonDeviceTitleAndSubtitleText(
                        ProfileViewStrings.postalCode,
                        controller.data.value.location.postalCode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget commonTitleAndSubtitleText(String title, subtitle) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonText.medium(
            title,
            size: 16,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.headingsColor,
          ),
          Gap(7),
          CommonText.medium(subtitle, size: 16),
        ],
      ),
    );
  }

  Widget commonDeviceTitleAndSubtitleText(String title, subtitle) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText.regular(
          title,
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
        Gap(7),
        CommonText.medium(subtitle, size: 14),
      ],
    );
  }
}
