part of 'view_course_category_imports.dart';

class ViewCourseCategory extends StatefulWidget {
  const ViewCourseCategory({super.key});

  @override
  State<ViewCourseCategory> createState() => _ViewCourseCategoryState();
}

class _ViewCourseCategoryState extends State<ViewCourseCategory> {
  ViewCourseCategoryController controller = Get.put(
    ViewCourseCategoryController(),
  );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonText.medium(
                        mobileView?'Category':ViewCourseCategoryStrings.viewCategory,
                        size: 18,
                      ),
                    ),
                    mobileView
                        ? Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Obx(
                              () => filterView(
                                () {
                                  showBottomSheet(
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: context.height,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 25,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? AppColors.mainDarkBgColor
                                              : AppColors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 20,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CommonText.medium(
                                                    ApprovalsStrings.filter,
                                                    size: 16,
                                                  ),
                                                  commonCloseIcon(context),
                                                ],
                                              ),
                                            ),
        
                                            CommonDivider(),
        
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 20,
                                                      ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      usersDropDown(),
                                                      Gap(20),
        
                                                      createdByDropDown(),
                                                      Gap(20),
        
                                                      customDatePicker(
                                                        controller.dateController,
                                                      ),
                                                      Gap(20),
                                                      statusDropDown(),
                                                      Gap(20),
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
                                                        controller
                                                            .clearSelections();
                                                      },
                                                      label:
                                                          ApprovalsStrings.clear,
                                                      borderSide: BorderSide(
                                                        color:
                                                            AppColors.primary500,
                                                      ),
                                                      textColor:
                                                          AppColors.primary500,
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
                                                      label: AppCommonStrings
                                                          .btnApply,
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
                                },
                                controller.courseManagementList.length.toString(),
                              ),
                            ),
                          )
                        : SizedBox(),
        
                    InkWell(
                      onTap: () {
                        context.go(AppRouteName.addCourseView);
                      },
                      child: Container(
                        decoration: commonCardDecoration(7),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgImageFromAsset(
                              AppCommonIcon.circleAddIcon,
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? AppColors.bodyTextDarkColor
                                    : AppColors.bodyTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Gap(12),
                            CommonText.medium(
                              ViewCourseCategoryStrings.addCourse,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CommonDivider(),
        
              _courseApprovalView(),
            ],
          ),
        ),
      ),
    );
  }

  _courseApprovalView() {
    var mobileView = ResponsiveView.isMobile(context);
    return Padding(
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
                      Expanded(child: statusDropDown()),
                      Gap(20),
                      Expanded(child: createdByDropDown()),
                      Gap(20),

                      Expanded(
                        child: customDatePicker(controller.dateController),
                      ),
                      Gap(20),
                      InkWell(
                        onTap: () {
                          controller.clearSelections();
                        },
                        child: CommonText.medium(
                          ApprovalsStrings.clearAll,
                          size: 14,
                          color: AppColors.error500,
                        ),
                      ),
                      Gap(20),
                      CommonText.semiBold(
                        '${controller.courseManagementList.length.toString()} Results',
                        size: 15,
                        color: AppColors.primary500,
                      ),
                    ],
                  ),

            Gap(mobileView ? 0 : 20),
            ListView.builder(
              itemCount: controller.courseManagementList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = controller.courseManagementList[index];
                return InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    // context.go(
                    //   '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                    //   extra: {'data': data, 'title': 'category'},
                    // );
                  },
                  child: CommonCourseView(
                    course: data,
                    showRate: true,
                    showSwitch: true,
                    showCheckBox: true,
                    showMenuButton: true,
                    viewCourseOnTap: () {
                      // context.go(
                      //   '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                      //   extra: {'data': data, 'title': 'category'},
                      // );
                    },
                    declinedOnTap: () {},
                    deleteOnTap: () {},
                    editViewCourseOnTap: () {
                      context.push(
                        '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                        extra: {'data': data, 'title': 'category'},
                      );
                    },
                    editCourseOnTap: () {
                      context.push(
                        AppRouteName.addCourseView,
                        extra: {'data': data},
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget usersDropDown() {
    return Obx(
      () => CustomDropdownFormField<String>(
        hintText: "Select",
        items: controller.usersList,
        value: controller.selectedUser.value.isEmpty
            ? null
            : controller.selectedUser.value,
        onChanged: (val) {
          controller.selectedUser.value = val ?? '';
        },
        validator: (val) => val == null || val.isEmpty ? "Please select" : null,
      ),
    );
  }

  Widget statusDropDown() {
    return Obx(
      () => CustomDropdownFormField<String>(
        hintText: "Status",
        items: controller.statusList,
        value: controller.selectedStatus.value.isEmpty
            ? null
            : controller.selectedStatus.value,
        onChanged: (val) {
          controller.selectedStatus.value = val ?? '';
        },
        validator: (val) => val == null || val.isEmpty ? "Status" : null,
      ),
    );
  }

  Widget createdByDropDown() {
    return Obx(
      () => CustomDropdownFormField<String>(
        hintText: "Created by",
        items: controller.createdByList,
        value: controller.createdBy.value.isEmpty
            ? null
            : controller.createdBy.value,
        onChanged: (val) {
          controller.createdBy.value = val ?? '';
        },
        validator: (val) => val == null || val.isEmpty ? "Created by" : null,
      ),
    );
  }

  Widget customDatePicker(TextEditingController? dateController) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return CommonDatePicker(
      hintText: ApprovalsStrings.requestDate,
      controller: dateController,
      suffixIcon: SvgImageFromAsset(
        AppCommonIcon.calenderIcon,
        height: 16,
        width: 16,
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
          BlendMode.srcIn,
        ),
      ),
      onDatePicked: (date) {},
    );
  }
}
