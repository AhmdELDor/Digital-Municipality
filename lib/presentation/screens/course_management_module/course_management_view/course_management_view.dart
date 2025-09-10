part of 'course_management_view_imports.dart';

class CourseManagementView extends StatefulWidget {
  const CourseManagementView({super.key});

  @override
  State<CourseManagementView> createState() => _CourseManagementViewState();
}

class _CourseManagementViewState extends State<CourseManagementView> {
  CourseManagementController controller = Get.put(CourseManagementController());
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
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CommonText.medium(
                      DashboardViewStrings.courseManagement,
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

                  CommonCircleAddButton(),
                  Gap(20),
                  mobileView
                      ? SizedBox()
                      : Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.error500
                                : AppColors.error100,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: SvgImageFromAsset(
                              AppCommonIcon.deleteIcon,
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? AppColors.white
                                    : AppColors.error500,
                                BlendMode.srcIn,
                              ),
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
                final course = controller.courseManagementList[index];
                return CommonCourseView(
                  course: course,
                  viewCourseOnTap: () {


                  },
                  declinedOnTap: () {},
                  deleteOnTap: () {

                  },
                  showMenuButton: true,
                  editViewCourseOnTap: () {
                    context.push(
                      '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                      extra: {'data': course, 'title': 'view'},
                    );
                  },
                  differentView: true,

                  deleteCourseOnTap: () {
                    commonDialogBox(
                      context: context,
                      child: SizedBox(
                        width: 560,
                        child: CommonDeleteDialogBox(
                          tittle: CourseApproveDialogStrings.deleteCourse,
                          subtitle: CourseApproveDialogStrings.deleteCourseDes,
                          doneOnPressed: () {
                            //Navigator.pop(context); // close dialog

                            if (index <
                                controller.courseManagementList.length) {
                              controller.courseManagementList.removeAt(index);
                              controller.courseManagementList.refresh();
                            }
                            Navigator.of(context, rootNavigator: true).pop();

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
                  editCourseOnTap: () {
                    context.push(
                      AppRouteName.addCourseView,
                      extra: {'data': course},
                    );
                  },


                );

                //   InkWell(
                //   hoverColor: Colors.transparent,
                //   // onTap: () {
                //   //   context.go(
                //   //     '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                //   //     extra: {'data': data, 'title': 'view'},
                //   //   );
                //   //   // context.push(AppRouteName.courseApprovalsDetailView,extra: data);
                //   // },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       ClipRRect(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(12),
                //           bottomLeft: Radius.circular(12),
                //         ),
                //         child: commonCacheImage(
                //           course.image,
                //           ImagePlaceHolder.imagePlaceHolderDark,
                //           height: 200,
                //           width: 250,
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: isDarkMode
                //                 ? AppColors.mainDarkBgColor
                //                 : AppColors.lightBgColor,
                //             border: Border(
                //               top: BorderSide(
                //                 color: isDarkMode
                //                     ? AppColors.grey100Color
                //                     : AppColors.lightBorderColor,
                //                 width: 1,
                //               ),
                //               bottom: BorderSide(
                //                 color: isDarkMode
                //                     ? AppColors.grey100Color
                //                     : AppColors.lightBorderColor,
                //                 width: 1,
                //               ),
                //               right: BorderSide(
                //                 color: isDarkMode
                //                     ? AppColors.grey100Color
                //                     : AppColors.lightBorderColor,
                //                 width: 1,
                //               ),
                //             ),
                //             borderRadius: BorderRadius.only(
                //               topRight: Radius.circular(12),
                //               bottomRight: Radius.circular(12),
                //             ),
                //             // border: Border.all(color: isDarkMode ? AppColors.grey100Color :AppColors.lightBorderColor,width: 1),
                //           ),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Padding(
                //                 padding: EdgeInsets.only(
                //                   top: 12,
                //                   left: 20,
                //                   right: 20,
                //                 ),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Expanded(
                //                       child: Column(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.start,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           CommonText.medium(
                //                             course.name,
                //                             size: 18,
                //                           ),
                //                           Gap(5),
                //
                //                           Padding(
                //                             padding: const EdgeInsets.only(
                //                               right: 90,
                //                             ),
                //                             child: CommonText.regular(
                //                               course.description,
                //                               size: 16,
                //                               color: isDarkMode
                //                                   ? AppColors.bodyTextDarkColor
                //                                   : AppColors.bodyTextColor,
                //                               maxLines: 2,
                //                               overflow: TextOverflow.ellipsis,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                     // InkWell(
                //                     //   onTap: () {
                //                     //     context.go(
                //                     //             '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                //                     //             extra: {'data': course, 'title': 'view'},
                //                     //           );
                //                     //   },
                //                     //     child: Text('data',style: TextStyle(color: Colors.yellow,fontSize: 30),)),
                //                     PopupMenuButton<int>(
                //                       icon: SvgImageFromAsset(
                //                         AppCommonIcon.moreIcon,
                //                         colorFilter: ColorFilter.mode(
                //                           AppColors.white,
                //                           BlendMode.srcIn,
                //                         ),
                //                       ),
                //                       color: isDarkMode
                //                           ? AppColors.mainDarkBgColor
                //                           : AppColors.lightBgColor,
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(9),
                //                       ),
                //                       // onSelected: (value) {
                //                       //   if (value == 2) {
                //                       //     // Navigator.pop(
                //                       //     //   context,
                //                       //     // ); // Close the popup menu first
                //                       //
                //                       //     context.push(
                //                       //       '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                //                       //       extra: {
                //                       //         'data': course,
                //                       //         'title': 'view',
                //                       //       },
                //                       //     );
                //                       //   }
                //                       // },
                //
                //                       onSelected: (value) {
                //                         if (value == 2) {
                //                           debugPrint("👉 Navigating with course: ${course.name}, id: ${course.id}");
                //                           //Navigator.of(context).pop();
                //                           context.push(
                //                             '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                //                             extra: {
                //                               'data': course,
                //                               'title': 'view',
                //                             },
                //                           );
                //                         }
                //                       },
                //
                //
                //                       itemBuilder: (context) => [
                //                         PopupMenuItem<int>(
                //                           value: 1,
                //                           child: Row(
                //                             children: [
                //                               SvgImageFromAsset(
                //                                 AppCommonIcon.editIcon,
                //                                 width: 18,
                //                                 height: 18,
                //                               ),
                //                               const SizedBox(width: 10),
                //                               Text(
                //                                 'Edit',
                //                                 style: TextStyle(
                //                                   color: isDarkMode
                //                                       ? Colors.white
                //                                       : Colors.black,
                //                                   fontSize: 16,
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                         PopupMenuItem<int>(
                //                           value: 2,
                //                           child: Row(
                //                             children: [
                //                               SvgImageFromAsset(
                //                                 AppCommonIcon.showPasswordIcon,
                //                                 width: 18,
                //                                 height: 18,
                //                               ),
                //                               const SizedBox(width: 10),
                //                               Text(
                //                                 'View',
                //                                 style: TextStyle(
                //                                   color: isDarkMode
                //                                       ? Colors.white
                //                                       : Colors.black,
                //                                   fontSize: 16,
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                         PopupMenuItem<int>(
                //                           value: 3,
                //                           child: Row(
                //                             children: [
                //                               SvgImageFromAsset(
                //                                 AppCommonIcon.deleteIcon,
                //                                 width: 18,
                //                                 height: 18,
                //                               ),
                //                               const SizedBox(width: 10),
                //                               Text(
                //                                 'Delete',
                //                                 style: TextStyle(
                //                                   color: isDarkMode
                //                                       ? Colors.white
                //                                       : Colors.black,
                //                                   fontSize: 16,
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //
                //                     // CourseApprovalsSecondMenuButton(
                //                     //   course: course,
                //                     //   editCourseOnTap: () {},
                //                     //   viewCourseOnTap: () {
                //                     //
                //                     //   },
                //                     //   deleteCourseOnTap: () {},
                //                     // ),
                //                   ],
                //                 ),
                //               ),
                //               Gap(12),
                //               Padding(
                //                 padding: EdgeInsets.symmetric(horizontal: 20),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   children: [
                //                     CommonText.semiBold(
                //                       '\$${course.courseFees.toString()}',
                //                       size: 20,
                //                       color: AppColors.primary500,
                //                     ),
                //                     Gap(20),
                //                     Row(
                //                       children: [
                //                         SvgImageFromAsset(
                //                           AppCommonIcon.starIcon,
                //                         ),
                //                         Gap(7),
                //                         CommonText.semiBold(
                //                           course.rate.toString(),
                //                           size: 16,
                //                           color: AppColors.secondary500,
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               Gap(12),
                //               CommonDivider(),
                //
                //               Padding(
                //                 padding: EdgeInsets.symmetric(horizontal: 20),
                //                 child: Row(
                //                   children: [
                //                     Expanded(
                //                       child: horizontalDetailView(course),
                //                     ),
                //                     customSwitch(),
                //                   ],
                //                 ),
                //               ),
                //               Gap(7),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget horizontalDetailView(CourseModel course) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            commonDetail(CommonImageAssets.book, course.courseCategory),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.language, course.language),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.video, ApprovalsStrings.videoClass),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(
              CommonImageAssets.cap,
              '${course.noOfSession.toString()} Sessions',
            ),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(
              CommonImageAssets.video,
              '${course.noOfLectures.toString()} Lectures',
            ),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(AppCommonIcon.calenderIcon, course.date),
          ],
        ),
      ),
    );
  }

  Widget commonDetail(String image, title) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgImageFromAsset(
          image,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(
            isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
            BlendMode.srcIn,
          ),
        ),
        Gap(10),
        CommonText.regular(
          title,
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
      ],
    );
  }

  Widget verticalDivider() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: 20,
      width: 1,
      color: isDarkMode ? AppColors.grey100Color : AppColors.headingsLightColor,
    );
  }

  Widget customSwitch() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    RxBool isSwitch = false.obs;
    return SizedBox(
      height: 17,
      width: 17,
      child: Obx(
        () => Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: isSwitch.value,
            onChanged: (value) {
              setState(() {
                isSwitch.value = value;
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
