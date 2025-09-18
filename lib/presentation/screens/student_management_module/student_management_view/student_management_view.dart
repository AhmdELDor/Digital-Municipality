part of 'student_management_imports.dart';

class StudentManagementView extends StatefulWidget {
  const StudentManagementView({super.key});

  @override
  State<StudentManagementView> createState() => _StudentManagementViewState();
}

class _StudentManagementViewState extends State<StudentManagementView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StudentManagementController controller = Get.put(
    StudentManagementController(),
  );
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
        child: SingleChildScrollView(
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
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CommonText.medium(
                  StudentManagementStrings.studentManagement,
                  size: 18,
                ),
              ),
        
              CommonDivider(),
             // Gap(20),
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ResponsiveGridRow(
                    children: List.generate(
                      controller.studentManagementList.length,
                      (index) {
                        final data = controller.studentManagementList[index];
                        return ResponsiveGridCol(
                          lg: 4,
                          child: Container(
                            // padding: EdgeInsets.symmetric(
                            //   horizontal: 12,
                            //   vertical: 13,
                            // ),
                            margin: EdgeInsets.only(bottom: 20, right: 20),
                            decoration: commonCardDecoration(12),
                            child: Column(
                              children: [
        
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          mobileView ? 50 : 72,
                                        ),
                                        child: commonCacheImage(
                                          data.image,
                                          ImagePlaceHolder.imagePlaceHolderDark,
                                          height: mobileView ? 40 : 72,
                                          width: mobileView ? 40 : 72,
                                        ),
                                      ),
                                      Gap(12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CommonText.medium(
                                              data.name,
                                              size: mobileView ? 15 : 16,
                                            ),
                                            Gap(3),
                                            CommonText.regular(
                                              data.email,
                                              size: mobileView ? 12 : 16,
                                              color: isDarkMode
                                                  ? AppColors.bodyTextDarkColor
                                                  : AppColors.bodyTextColor,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Gap(3),
                                            CommonText.regular(
                                              data.phoneNo,
                                              size: mobileView ? 15 : 16,
                                              color: AppColors.greyTextColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(12),
                                      mobileView ?commonSwitch(data):SizedBox(),
                                      Gap(mobileView ?20:0),  menuButton(data,index),
                                    ],
                                  ),
                                ),
        
                                CommonDivider(height: 1.5),
                                Gap(15),
                                commonLeadingTrailingView(
                                  StudentManagementStrings.totalCourseEnrolled,
                                  '${data.totalEnrolledCourse.toString()} Questions',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: CommonDivider(),
                                ),
        
                                commonLeadingTrailingView(
                                  StudentManagementStrings.totalCoinsEarned,
                                  '${data.totalCoinsEarned.toString()} Attendees',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: CommonDivider(),
                                ),
                                commonLeadingTrailingView(
                                  StudentManagementStrings.leaderBoardPosition,
                                  '#${data.leaderBoardPosition}',
                                ),
                                mobileView?SizedBox(): Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: CommonDivider(),
                                ),
                                Gap(mobileView?0:15),mobileView?SizedBox():
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 15,),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText.regular(
                                        StudentManagementStrings.status,
                                        size: 15,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                      commonSwitch(data),
                                    ],
                                  ),
                                ),
                                Gap(mobileView?0:15)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  menuButton(StudentManagementModel data,int index) {
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
      child: commonPopTextView(AppCommonIcon.moreIcon),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            context.go(
                    '${AppRouteName.studentManagementView}/${AppRouteName.studentManagementDetailView}',
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
            commonDialogBox(
              context: context,
              child: SizedBox(
                width: 560,
                child: CommonDeleteDialogBox(
                  tittle: StudentManagementStrings.deleteStudent,
                  subtitle: StudentManagementStrings.deleteStudentDes,
                  doneOnPressed: () {
                    //Navigator.pop(context); // close dialog

                    if (index <
                        controller.studentManagementList.length) {
                      controller.studentManagementList.removeAt(index);
                      controller.studentManagementList.refresh();
                    }
                    Navigator.of(context, rootNavigator: true).pop();

                    showSuccessMessage(
                      context: context,
                      title: 'Student Deleted Successfully',
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
              ApprovalsStrings.delete,
              null,
            ),
          ),
        ),
      ],
    );
  }

  Widget commonSwitch(StudentManagementModel data) {
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
}
