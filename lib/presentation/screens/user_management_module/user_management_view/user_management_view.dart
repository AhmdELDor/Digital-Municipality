part of 'user_management_view_imports.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  UserManagementController controller = Get.put(UserManagementController());
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
        child: DefaultTabController(
          length: 2,
          child: Builder(
            builder: (context) {
              final TabController tabController = DefaultTabController.of(
                context,
              );

              return Column(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonHeaderText(
                          title: UserManagementStrings.userManagement,
                        ),
                        CommonCircleAddButton(
                          onTap: () {
                            tabController.index == 0
                                ? commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: mobileView ? null : 560,
                                      child: AddUserView(),
                                    ),
                                  )
                                : commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: mobileView ? null : 560,
                                      child: AddRoleView(),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),

                  CommonDivider(),
                  Gap(20),
                  tabBarView(tabController, isDarkMode, mobileView),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: manageUsersList(mobileView, isDarkMode),
                        ),
                        SingleChildScrollView(
                          child: manageRolesList(mobileView, isDarkMode),
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
  }

  Widget tabBarView(
    TabController tabController,
    bool isDarkMode,
    bool mobileView,
  ) {
    return TabBar(
      controller: tabController,
      labelColor: AppColors.primary500,
      dividerColor: Colors.transparent,
      padding: EdgeInsets.zero,
      unselectedLabelStyle: TextStyle(
        color: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
        fontWeight: FontWeight.w500,
        fontSize: mobileView ? 15 : 16,
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
        color: isDarkMode ? AppColors.cardDarkBg2Color : AppColors.primary50,
        border: Border(bottom: BorderSide(color: AppColors.primary500)),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
      ),
      tabs: [
        Tab(text: UserManagementStrings.manageUsers),
        Tab(text: UserManagementStrings.manageRoles),
      ],
    );
  }

  Widget manageUsersList(bool mobileView, isDarkMode) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: ResponsiveGridRow(
          children: List.generate(controller.usersList.length, (index) {
            final data = controller.usersList[index];
            return ResponsiveGridCol(
              lg: 4,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                decoration: commonCardDecoration(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              mobileView ? 50 : 72,
                            ),
                            child: commonCacheImage(
                              data.avatarUrl,
                              ImagePlaceHolder.imagePlaceHolderDark,
                              height: mobileView ? 50 : 72,
                              width: mobileView ? 50 : 72,
                            ),
                          ),
                          Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CommonText.medium(
                                  data.name,
                                  size: mobileView ? 15 : 16,
                                ),
                                Gap(3),
                                CommonText.regular(
                                  data.email,
                                  size: mobileView ? 15 : 16,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // mobileView
                          //     ? Obx(
                          //         () => commonSwitch(
                          //           value: data.isSwitch.value,
                          //           onChanged: (value) {
                          //             setState(() {
                          //               data.isSwitch.value = value;
                          //             });
                          //           },
                          //         ),
                          //       )
                          //     : SizedBox(),
                          Gap(mobileView ? 20 : 0),
                          menuButton(),
                        ],
                      ),
                    ),

                    CommonDivider(height: 1.5),
                    Gap(15),
                    commonLeadingTrailingView(
                      UserManagementStrings.role,
                      data.role,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CommonDivider(),
                    ),

                    commonLeadingTrailingView(
                      UserManagementStrings.dateCreated,
                      data.dateCreated,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CommonDivider(),
                    ),
                    commonLeadingTrailingView(
                      UserManagementStrings.mobileNo,
                      data.mobileNo,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CommonDivider(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonText.regular(
                              UserManagementStrings.active,
                              size: 15,
                              color: isDarkMode
                                  ? AppColors.bodyTextDarkColor
                                  : AppColors.bodyTextColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          commonSwitch(
                            value: data.isSwitch.value,
                            onChanged: (value) {
                              setState(() {
                                data.isSwitch.value = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // mobileView
                    //     ? SizedBox()
                    //     : Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 15),
                    //         child: CommonDivider(),
                    //       ),

                    // Gap(mobileView ? 0 : 15),
                    // mobileView
                    //     ? SizedBox()
                    //     : Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 15),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             CommonText.regular(
                    //               StudentManagementStrings.status,
                    //               size: 15,
                    //               color: isDarkMode
                    //                   ? AppColors.bodyTextDarkColor
                    //                   : AppColors.bodyTextColor,
                    //             ),
                    //             commonSwitch(
                    //               value: data.isSwitch.value,
                    //               onChanged: (value) {
                    //                 setState(() {
                    //                   data.isSwitch.value = value;
                    //                 });
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    // Gap(mobileView ? 0 : 15),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget manageRolesList(bool mobileView, isDarkMode) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: ResponsiveGridRow(
          children: List.generate(controller.rolesList.length, (index) {
            final data = controller.rolesList[index];
            return ResponsiveGridCol(
              lg: 3,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                decoration: commonCardDecoration(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonText.regular(data.role, size: 18),
                          // mobileView
                          //     ? commonSwitch(
                          //         value: data.isSwitch.value,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             data.isSwitch.value = value;
                          //           });
                          //         },
                          //       )
                          //     : SizedBox(),
                          // Gap(mobileView ? 20 : 0),
                          menuButton(),
                        ],
                      ),
                    ),
                    Gap(25),
                    CommonDivider(height: 1.5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonText.regular(data.dateCreated, size: 18),
                          Obx(
                            () => commonSwitch(
                              value: data.isSwitch.value,
                              onChanged: (value) {
                                setState(() {
                                  data.isSwitch.value = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  menuButton() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: commonPopTextView(AppCommonIcon.moreIcon),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.editIcon,
              CourseManagementStrings.edit,
              null,
            ),
          ),
        ),

        PopupMenuItem(
          value: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.deleteIcon,
              ApprovalsStrings.delete,
              null,
            ),
          ),
        ),
      ],
    );
  }

  Widget commonSwitch({
    required bool value,
    required void Function(bool) onChanged,
  }) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SizedBox(
      height: 17,
      width: 17,
      child: Transform.scale(
        scale: 0.7,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          // value: data.isSwitch.value,
          //  onChanged: (value) {
          //    setState(() {
          //      data.isSwitch.value = value;
          //    });
          //  },
          activeTrackColor: AppColors.primary500,
          thumbColor: AppColors.white,
          inactiveThumbColor: isDarkMode
              ? AppColors.mainDarkBgColor
              : AppColors.white,
          inactiveTrackColor: isDarkMode
              ? AppColors.greyDarkColor
              : AppColors.background100,
        ),
      ),
    );
  }
}
