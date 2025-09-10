part of 'approvals_course_view_imports.dart';

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
                    ? Obx(
                        () => filterView(
                          () {
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
                                              MainAxisAlignment.spaceBetween,
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
                                                controller
                                                            .selectedIndex
                                                            .value ==
                                                        0
                                                    ? _courseFilterView()
                                                    : controller
                                                              .selectedIndex
                                                              .value ==
                                                          1
                                                    ? _instructorFilterView()
                                                    : _universityFilterView(),
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
                                                      .clearAllSelection();
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
                                                label:
                                                    AppCommonStrings.btnApply,
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
                          controller.data.value.coursesApprovalsList.length
                              .toString(),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          CommonDivider(),
          Gap(25),
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
                        InkWell(
                          onTap: () {
                            controller.clearCoursesFilterSelections();
                          },
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
              controller.data.value.coursesApprovalsList.isEmpty
                  ? Center(child: CommonNoResultFound())
                  : ListView.builder(
                      itemCount:
                          controller.data.value.coursesApprovalsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data =
                            controller.data.value.coursesApprovalsList[index];
                        return InkWell(
                          onTap: () {
                            context.go(
                              '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                              extra: {'data': data},
                            );
                            // context.push(AppRouteName.courseApprovalsDetailView,extra: data);
                          },
                          child: CommonCourseView(
                            course: data,
                            viewCourseOnTap: () {
                              // context.go(
                              //   '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                              //   extra: {'data': data, 'title': 'view'},
                              // );

                              context.go(
                                '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                                extra: {'data': data},
                              );
                            },
                            declinedOnTap: () {
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
                                        FocusScope.of(context).unfocus();

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
                                                        .continueAndDecline,
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
                            deleteOnTap: () {
                              commonDialogBox(
                                context: context,
                                child: SizedBox(
                                  width: 560,
                                  child: CommonDeleteDialogBox(
                                    tittle:
                                        CourseApproveDialogStrings.deleteCourse,
                                    subtitle: CourseApproveDialogStrings
                                        .deleteCourseDes,
                                    doneOnPressed: () {
                                      //Navigator.pop(context); // close dialog

                                      if (index <
                                          controller
                                              .data
                                              .value
                                              .coursesApprovalsList
                                              .length) {
                                        controller
                                            .data
                                            .value
                                            .coursesApprovalsList
                                            .removeAt(index);
                                        controller.data
                                            .refresh(); // ✅ refresh reactive state
                                      }
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop();

                                      showSuccessMessage(
                                        context: context,
                                        title: 'Course Deleted Successfully',
                                        content: '',
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            editViewCourseOnTap: () {

                            },
                          ),
                        );
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
                          child: InkWell(
                            onTap: () {
                              controller.clearAllSelection();
                            },
                            child: CommonText.medium(
                              ApprovalsStrings.clearAll,
                              size: 14,
                              color: AppColors.error500,
                            ),
                          ),
                        ),
                        Gap(20),
                        CommonText.semiBold(
                          '${controller.data.value.instructorApprovalsList.length.toString()} Results',
                          size: 15,
                          color: AppColors.primary500,
                        ),
                      ],
                    ),

              Gap(mobileView ? 0 : 20),
              controller.data.value.instructorApprovalsList.isEmpty
                  ? Center(child: CommonNoResultFound())
                  : ResponsiveGridRow(
                      children: List.generate(
                        controller.data.value.instructorApprovalsList.length,
                        (index) {
                          final data = controller
                              .data
                              .value
                              .instructorApprovalsList[index];
                          return ResponsiveGridCol(
                            lg: 3,
                            xs: 12,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: mobileView ? 0 : 15,
                                bottom: mobileView ? 20 : 0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  context.push(
                                    '${AppRouteName.approvalsView}/${AppRouteName.instructorDetailView}',

                                    extra: data,
                                  );
                                },
                                child: InstructorView(
                                  data: data,
                                  approveOnTap: () {
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
                                            image:
                                                CommonImageAssets.courseApprove,
                                            title: InstructorDialogStrings
                                                .instructorApproved,
                                            subtitle: InstructorDialogStrings
                                                .instructorApprovedDes,
                                            buttonName: InstructorDialogStrings
                                                .goToInstructor,
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
                                  declinedOnTap: () {
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
                                            feedbackController: controller
                                                .instructorFeedbackController,
                                            formKey: controller.formKey,
                                            onPressed: () {
                                              final isValid = controller
                                                  .formKey
                                                  .currentState!
                                                  .validate();
                                              FocusScope.of(context).unfocus();

                                              if (!isValid) return;

                                              controller.formKey.currentState!
                                                  .save();
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
                                                          InstructorDialogStrings
                                                              .instructorDeclined,
                                                      subtitle:
                                                          InstructorDialogStrings
                                                              .instructorDeclinedDes,
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
                                  deleteOnTap: () {
                                    commonDialogBox(
                                      context: context,
                                      child: SizedBox(
                                        width: 560,
                                        child: CommonDeleteDialogBox(
                                          tittle: CourseApproveDialogStrings
                                              .deleteInstructor,
                                          subtitle: CourseApproveDialogStrings
                                              .deleteInstructorDes,
                                          doneOnPressed: () {
                                            //Navigator.pop(context); // close dialog

                                            if (index <
                                                controller
                                                    .data
                                                    .value
                                                    .instructorApprovalsList
                                                    .length) {
                                              controller
                                                  .data
                                                  .value
                                                  .instructorApprovalsList
                                                  .removeAt(index);
                                              controller.data
                                                  .refresh(); // ✅ refresh reactive state
                                            }
                                            Navigator.of(
                                              context,
                                              rootNavigator: true,
                                            ).pop();

                                            showSuccessMessage(
                                              context: context,
                                              title:
                                                  'Instructor Deleted Successfully',
                                              content: '',
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
                  : Row(
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
                          child: InkWell(
                            onTap: () {
                              controller.clearAllSelection();
                            },
                            child: CommonText.medium(
                              ApprovalsStrings.clearAll,
                              size: 14,
                              color: AppColors.error500,
                            ),
                          ),
                        ),
                        Gap(20),
                        CommonText.semiBold(
                          '${controller.data.value.universityApprovalsList.length.toString()} Results',
                          size: 15,
                          color: AppColors.primary500,
                        ),
                      ],
                    ),

              Gap(mobileView ? 0 : 20),
              controller.data.value.universityApprovalsList.isEmpty
                  ? Center(child: CommonNoResultFound())
                  : ResponsiveGridRow(
                      children: List.generate(controller.data.value.universityApprovalsList.length, (
                        index,
                      ) {
                        final data = controller
                            .data
                            .value
                            .universityApprovalsList[index];
                        return ResponsiveGridCol(
                          lg: 3,
                          xs: 12,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: mobileView ? 0 : 15,
                              bottom: mobileView ? 20 : 0,
                            ),
                            child: InkWell(
                              onTap: () {
                                context.push(
                                  '${AppRouteName.approvalsView}/${AppRouteName.universityDetailView}',

                                  extra: data,
                                );
                              },
                              child: UniversityView(
                                data: data,
                                approveOnTap: () {
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
                                          image:
                                              CommonImageAssets.courseApprove,
                                          title: UniversityDialogStrings
                                              .universityApproved,
                                          subtitle: UniversityDialogStrings
                                              .universityApprovedDes,
                                          buttonName: UniversityDialogStrings
                                              .goToUniversity,
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
                                declinedOnTap: () {
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
                                          title: UniversityDialogStrings
                                              .feedBackToUniversity,
                                          hintText: UniversityDialogStrings
                                              .feedBackToUniversityHint,
                                          feedbackController: controller
                                              .universityFeedbackController,
                                          formKey: controller.formKey,

                                          onPressed: () {
                                            final isValid = controller
                                                .formKey
                                                .currentState!
                                                .validate();
                                            FocusScope.of(context).unfocus();

                                            if (!isValid) return;

                                            controller.formKey.currentState!
                                                .save();
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
                                                        UniversityDialogStrings
                                                            .universityDeclined,
                                                    subtitle:
                                                        UniversityDialogStrings
                                                            .universityDeclinedDes,
                                                    buttonName:
                                                        UniversityDialogStrings
                                                            .goToUniversity,
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
                                deleteOnTap: () {
                                  commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: 560,
                                      child: CommonDeleteDialogBox(
                                        tittle: CourseApproveDialogStrings
                                            .deleteUniversity,
                                        subtitle: CourseApproveDialogStrings
                                            .deleteUniversityDes,
                                        doneOnPressed: () {
                                          //Navigator.pop(context); // close dialog

                                          if (index <
                                              controller
                                                  .data
                                                  .value
                                                  .universityApprovalsList
                                                  .length) {
                                            controller
                                                .data
                                                .value
                                                .universityApprovalsList
                                                .removeAt(index);
                                            controller.data
                                                .refresh(); // ✅ refresh reactive state
                                          }
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop();
                                          // ScaffoldMessenger.of(context).showSnackBar(
                                          //   SnackBar(
                                          //     content: Text('Course Deleted Successfully'),
                                          //     backgroundColor: Colors.green,
                                          //     duration: Duration(seconds: 2),
                                          //   ),
                                          // );

                                          showSuccessMessage(
                                            context: context,
                                            title:
                                                'University Deleted Successfully',
                                            content: '',
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }),
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
