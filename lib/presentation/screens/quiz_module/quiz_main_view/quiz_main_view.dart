part of 'quiz_view_imports.dart';

class QuizMainView extends StatefulWidget {
  const QuizMainView({super.key});

  @override
  State<QuizMainView> createState() => _QuizMainViewState();
}

class _QuizMainViewState extends State<QuizMainView> {
  QuizMainViewController controller = Get.put(QuizMainViewController());
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
                hintText: DashboardViewStrings.searchAnything,
              ),
            )
                : SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonText.medium(QuizStrings.quiz, size: 18),
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
                                                            coursesDropDown(),
                                                            Gap(20),
                                                            courseCategoryDropDown(),
                                                            Gap(20),
                                                            statusDropDown(),
                                                            Gap(20),

                                                            createdByDropDown(),
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
                                      controller.data.value.quizList.length.toString(),
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          CommonCircleAddButton(
                            onTap: () {
                              context.push(
                                '${AppRouteName.quizView}/${AppRouteName.addQuiz}',
                                extra: {'title': 'Quiz'},
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    CommonDivider(),

                    mobileView
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: coursesDropDown()),
                                Gap(20),

                                Expanded(child: courseCategoryDropDown()),
                                Gap(20),
                                Expanded(child: statusDropDown()),
                                Gap(20),
                                Expanded(child: createdByDropDown()),
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
                                Obx(
                                  () => CommonText.semiBold(
                                    '${controller.data.value.quizList.length.toString()} Results',
                                    size: 15,
                                    color: AppColors.primary500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                    Obx(
                      () => Padding(
                        padding: EdgeInsets.only(left: 20, top: mobileView ? 20 : 0),
                        child: ResponsiveGridRow(
                          children: List.generate(controller.data.value.quizList.length, (
                            index,
                          ) {
                            final data = controller.data.value.quizList[index];
                            return ResponsiveGridCol(
                              lg: 4,
                              xs: 12,
                              child: Container(
                                decoration: commonCardDecoration(12),
                                margin: EdgeInsets.only(bottom: 20, right: 20),

                                child: mobileView
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                    9,
                                                  ),
                                                  child: commonCacheImage(
                                                    data.image,
                                                    ImagePlaceHolder
                                                        .imagePlaceHolderDark,
                                                    height: 65,
                                                    width: 65,
                                                  ),
                                                ),
                                                Gap(12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CommonText.medium(
                                                        data.name,
                                                        size: 14,
                                                      ),
                                                      CommonText.regular(
                                                        data.tag,
                                                        size: 14,
                                                        color: isDarkMode
                                                            ? AppColors
                                                                  .bodyTextDarkColor
                                                            : AppColors.bodyTextColor,
                                                      ),
                                                      CommonText.regular(
                                                        data.course,
                                                        size: 14,
                                                        color: AppColors.greyTextColor, maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Gap(5),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  child: commonSwitch(data),
                                                ),
                                                Gap(17),
                                                menuButton(data, index),
                                              ],
                                            ),
                                          ),
                                          CommonDivider(),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText.regular(
                                                        QuizStrings.totalQuestions,
                                                        size: 14,
                                                        color: isDarkMode
                                                            ? AppColors
                                                                  .bodyTextDarkColor
                                                            : AppColors.bodyTextColor,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Gap(3),
                                                      CommonText.regular(
                                                        '${data.totalQuestions.toString()} Questions',
                                                        size: 14,
                                                      ),
                                                    ],
                                                  ),
                                                ),  Gap(5),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText.regular(
                                                        QuizStrings.totalAttendees,
                                                        size: 14,
                                                        color: isDarkMode
                                                            ? AppColors
                                                                  .bodyTextDarkColor
                                                            : AppColors.bodyTextColor,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Gap(3),
                                                      CommonText.regular(
                                                        '${data.totalAttendees.toString()} Attendees',
                                                        size: 14,
                                                      ),
                                                    ],
                                                  ),
                                                ),  Gap(5),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText.regular(
                                                        QuizStrings.answerChangeable,
                                                        size: 14,
                                                        color: isDarkMode
                                                            ? AppColors
                                                                  .bodyTextDarkColor
                                                            : AppColors.bodyTextColor,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Gap(3),
                                                      CommonText.regular(
                                                        data.answerChangeable,
                                                        size: 14,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                    9,
                                                  ),
                                                  child: commonCacheImage(
                                                    data.image,
                                                    ImagePlaceHolder
                                                        .imagePlaceHolderDark,
                                                    height: 75,
                                                    width: 75,
                                                  ),
                                                ),
                                                Gap(12),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText.medium(
                                                        data.name,
                                                        size: 16,
                                                      ),
                                                      Gap(5),
                                                      CommonText.regular(
                                                        data.tag,
                                                        size: 16,
                                                        color: isDarkMode
                                                            ? AppColors
                                                                  .bodyTextDarkColor
                                                            : AppColors.bodyTextColor,
                                                      ),
                                                      Gap(5),
                                                      CommonText.regular(
                                                        data.course,
                                                        size: 16,
                                                        color: AppColors.greyTextColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                menuButton(data, index),
                                              ],
                                            ),
                                          ),
                                          CommonDivider(),

                                          commonView(
                                            QuizStrings.totalQuestions,
                                            '${data.totalQuestions.toString()} Questions',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: CommonDivider(),
                                          ),

                                          commonView(
                                            QuizStrings.totalAttendees,
                                            '${data.totalAttendees.toString()} Attendees',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: CommonDivider(),
                                          ),
                                          commonView(
                                            QuizStrings.answerChangeable,
                                            data.answerChangeable,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: CommonDivider(),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: CommonText.regular(
                                                    QuizStrings.quizStatus,
                                                    size: 15,
                                                    color: isDarkMode
                                                        ? AppColors.bodyTextDarkColor
                                                        : AppColors.bodyTextColor,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                commonSwitch(data),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commonView(String leading, trailing) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CommonText.regular(
              leading,
              size: 15,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CommonText.regular(trailing, size: 15),
        ],
      ),
    );
  }

  Widget commonSwitch(QuizModel data) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SizedBox(
      height: 17,
      width: 17,
      child: Obx(
        () => Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: data.isSwitch.value,
            onChanged: (value) {
              setState(() {
                data.isSwitch.value = value;
              });
            },
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
      ),
    );
  }

  Widget menuButton(QuizModel data, int index) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side: BorderSide(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 2,
        ),
      ),
      position: PopupMenuPosition.under,
      padding: EdgeInsetsGeometry.zero,
      menuPadding: EdgeInsetsGeometry.zero,

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            context.push(
              '${AppRouteName.quizView}/${AppRouteName.addQuiz}',
              extra: {'data': data},
            );
          },
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
          onTap: () {
            context.go(
              '${AppRouteName.quizView}/${AppRouteName.viewQuiz}',
              extra: data,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.showPasswordIcon,
              CourseManagementStrings.view,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () {
            context.go(
              '${AppRouteName.quizView}/${AppRouteName.leaderBoardView}',
              extra: data,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              CommonImageAssets.viewLeaderBoard,
              QuizStrings.viewLeaderBoard,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                width: 560,
                child: CommonDeleteDialogBox(
                  tittle: QuizStrings.deleteQuiz,
                  subtitle: QuizStrings.deleteQuizDes,
                  doneOnPressed: () {
                    //Navigator.pop(context); // close dialog

                    if (index < controller.data.value.quizList.length) {
                      controller.data.value.quizList.removeAt(index);
                      controller.data.refresh(); // ✅ refresh reactive state
                    }
                    Navigator.of(context, rootNavigator: true).pop();

                    showSuccessMessage(
                      context: context,
                      title: 'Quiz Deleted Successfully',
                      content: '',
                    );
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.deleteIcon,
              NotesListStrings.delete,
              null,
            ),
          ),
        ),
      ],
      child: Container(
        height: 32,
        width: 32,
        decoration: commonCardDecoration(7),
        child: Center(
          child: SvgImageFromAsset(
            AppCommonIcon.moreIcon,
            colorFilter: ColorFilter.mode(
              isDarkMode ? AppColors.white : AppColors.headingsColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget coursesDropDown() {
    return Obx(
      () => AlwaysDownDropdown<CourseModel>(
        hintText: "Course",
        items: controller.data.value.coursesList,
        value: controller.selectedCourse.value,
        onChanged: (val) {
          controller.selectedCourse.value = val;
        },
        itemAsString: (item) => item.name,
        //validator: (val) => val == null ? "Course" : null,
      ),
    );
  }

  Widget courseCategoryDropDown() {
    return Obx(
      () => AlwaysDownDropdown<CourseCategoryModel>(
        hintText: "Category",
        items: controller.data.value.courseCategoryList,
        value: controller.selectedCategory.value,
        onChanged: (val) {
          controller.selectedCategory.value = val;
        },
        itemAsString: (item) => item.name,
        //validator: (val) => val == null ? "Category" : null,
      ),
    );
  }

  Widget statusDropDown() {
    return Obx(
      () => AlwaysDownDropdown<StatusModel>(
        hintText: "Status",
        items: controller.data.value.statusList,
        value: controller.selectedStatus.value,
        onChanged: (val) {
          controller.selectedStatus.value = val;
        },
        itemAsString: (item) => item.name,
        //validator: (val) => val == null ? "Status" : null,
      ),
    );
  }



  Widget createdByDropDown() {
    return Obx(
      () => AlwaysDownDropdown<UserModel>(
        hintText: "Created by",
        items: controller.data.value.usersList,
        value: controller.createdBy.value,
        onChanged: (val) {
          controller.createdBy.value = val;
        },
        itemAsString: (item) => item.name,
        //validator: (val) => val == null ? "Created by" : null,
      ),
    );
  }
}
