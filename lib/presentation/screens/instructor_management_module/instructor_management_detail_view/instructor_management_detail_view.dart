part of 'instructor_management_detail_imports.dart';

class InstructorManagementDetailView extends StatefulWidget {
  const InstructorManagementDetailView({super.key});

  @override
  State<InstructorManagementDetailView> createState() =>
      _InstructorManagementDetailViewState();
}

class _InstructorManagementDetailViewState
    extends State<InstructorManagementDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  InstructorManagementDetailController controller = Get.put(
    InstructorManagementDetailController(),
  );

  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    final detail = GoRouterState.of(context).extra as InstructorModel;
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
        child: Obx(
          () =>  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonText.medium(
                    InstructorDetailViewStrings.instructorProfile,
                    size: 17,
                  ),
                ),
                Gap(15),
                CommonDivider(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        lg: 3,
                        xs: 12,
                        child: Padding(
                          padding:  EdgeInsets.only(right:mobileView?0: 15,bottom: mobileView?25:0),
                          child: contactInformationView(detail),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 3,xs: 12,
                        child: Padding(
                          padding:  EdgeInsets.only(right:mobileView?0: 15,bottom: mobileView?15:0),
                          child: verificationDocuments(),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 3,xs: 12,
                        child: Padding(
                          padding:  EdgeInsets.only(right: mobileView?0:15,bottom: mobileView?15:0),
                          child: otherInformation(),
                        ),
                      ),
                      ResponsiveGridCol(lg: 3,xs: 12, child: statisticsView()),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CommonText.medium(
                    InstructorManagementDetailStrings.courses,
                    size: 17,
                  ),
                ),

                ListView.builder(
                  itemCount: controller.data.value.coursesList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemBuilder: (context, index) {
                    final data = controller.data.value.coursesList[index];
                    return InkWell(
                      onTap: () {
                        // context.go(
                        //   '${AppRouteName.instructorManagementView}/${AppRouteName.instructorManagementDetailView}',
                        //   extra: {'data': data},
                        // );
                      },
                      child: CommonCourseView(course: data,differentView: true,
                        viewCourseOnTap: () {
                          // context.go(
                          //   '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                          //   extra: {'data': data, 'title': 'view'},
                          // );
                        },
                          declinedOnTap: () {

                          },
                          deleteOnTap: () {

                          },
                        editViewCourseOnTap: () {
                            context.go(
                              '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                              extra: {'data': data, 'title': 'view'},
                            );
                          }
                        ,),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contactInformationView(InstructorModel detail) {
    var mobileView = ResponsiveView.isMobile(context);

    return Container(
      height: mobileView?null:340,
      decoration: mobileView?null:commonCardDecoration(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: mobileView?0:12, vertical:mobileView?0: 12),
              child: CommonText.regular(
                InstructorManagementDetailStrings.contactInformation,
                size: 16,
              ),
            ),
            mobileView?SizedBox(): CommonDivider(),
            Gap(15),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:mobileView?0: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: mobileView ? 72 :65,

                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: mobileView ? 72 :65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                CommonImageAssets.instructorProfileDetailBg,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          child: Container(
                            height: mobileView ? 72 :64,
                            width: mobileView ? 72 :64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: commonCacheImage(
                                detail.image,
                                ImagePlaceHolder.imagePlaceHolderDark,
                                height: mobileView ? 72 : 64,
                                width: mobileView ? 72 : 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(40),
                  commonDetailText(
                    InstructorManagementDetailStrings.name,
                    controller.data.value.contactInformation.name,
                  ),
                  Gap(15),
                  CommonDivider(),
                  Gap(15),
                  commonDetailText(
                    InstructorManagementDetailStrings.email,
                    controller.data.value.contactInformation.email,
                  ),
                  Gap(15),
                  CommonDivider(),
                  Gap(15),
                  commonDetailText(
                    InstructorManagementDetailStrings.mobileNo,
                    controller.data.value.contactInformation.phoneNo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verificationDocuments() {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: mobileView?null:340,
      decoration:  mobileView?null:commonCardDecoration(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:mobileView?0: 12, vertical: mobileView?0: 12),
              child: CommonText.regular(
                InstructorManagementDetailStrings.verificationDocuments,
                size: 16,
              ),
            ),
            mobileView?SizedBox(): CommonDivider(),
            Gap(25),
            ListView.builder(
              itemCount: controller.data.value.verificationDocuments.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: mobileView?0:12),
              itemBuilder: (context, index) {
                return Container(
                  decoration:BoxDecoration(
                    color: isDarkMode?AppColors.cardDarkBgColor:AppColors.lightBgColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color:isDarkMode?AppColors.grey100Color:AppColors.lightBorderColor,width: 1.5)

                  ),
                  // height: 112,
                  margin: EdgeInsetsGeometry.only(bottom: mobileView?15:20),
                  padding: EdgeInsets.symmetric(vertical:  mobileView?15:25,horizontal: mobileView?15:0),
                  child: mobileView?Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgImageFromAsset(CommonImageAssets.pdf),
                      Gap(15),
                      CommonText.medium(
                        controller.data.value.verificationDocuments[index],
                        size: 14,
                        color: isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                      ),
                    ],
                  ):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgImageFromAsset(CommonImageAssets.pdf),
                      Gap(15),
                      CommonText.medium(
                        controller.data.value.verificationDocuments[index],
                        size: 15,
                        color: isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget otherInformation() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Container(
      decoration: mobileView?null:commonCardDecoration(12),
      height: mobileView?null:340,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal:mobileView?0:12, vertical: 12),
              child: CommonText.regular(
                InstructorManagementDetailStrings.otherInformation,
                size: mobileView?15:16,
              ),
            ),
            mobileView?SizedBox():CommonDivider(),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal:mobileView?0: 12, vertical:mobileView?0: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText.regular(
                    InstructorManagementDetailStrings.specialization,
                    size: mobileView?14:16,
                    color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.headingsColor,
                  ),
                  Gap(12),
                  CommonText.regular(
                    controller.data.value.otherInformation.specialization
                        .toString(),
                    size: 16,
                    color: isDarkMode
                        ? AppColors.headingsLightColor
                        : AppColors.bodyTextColor,
                  ),
                  Gap(12),

                  CommonText.regular(
                    InstructorManagementDetailStrings.about,
                    size: mobileView?14:16,
                    color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.headingsColor,
                  ),
                  CommonText.regular(
                    controller.data.value.otherInformation.about.toString(),
                    size: 15,
                    color: isDarkMode
                        ? AppColors.headingsLightColor
                        : AppColors.bodyTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statisticsView() {
    var mobileView = ResponsiveView.isMobile(context);
    return Container(
      height: mobileView?null:340,
      decoration: mobileView?null:commonCardDecoration(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: mobileView?0:12, vertical: mobileView?0:12),
              child: CommonText.regular(
                InstructorManagementDetailStrings.statistics,
                size: 16,
              ),
            ),
            mobileView?SizedBox(): CommonDivider(),
            Gap(12),

          mobileView?Row(
            children: [
              Expanded(
                child: Container(
                  decoration: studentGradient(),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgImageFromAsset(CommonImageAssets.noOfStudents),
                      Gap(15),
                      CommonText.light(
                        '${controller.data.value.noOfStudents.toString()}\nStudents',
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(15),
              Expanded(
                child: Container(
                  decoration: noOfCoursesGradient(),
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgImageFromAsset(CommonImageAssets.noOfCourses),
                      Gap(15),
                      CommonText.light(
                        '${controller.data.value.noOfCourses.toString()}\nCourses',
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(15),
              Expanded(
                child: Container(
                  decoration: noOfRatingGradient(),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgImageFromAsset(CommonImageAssets.noOfRating),
                      Gap(15),
                      CommonText.light(
                        '${controller.data.value.noOfRating.toString()}\nRating',
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ):desktopStatistics()
          ],
        ),
      ),
    );
  }
  Widget commonDetailText(String title, subtitle) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobileView?0:12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CommonText.regular(
              title,
              size: 16,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: CommonText.regular(
              subtitle,
              size: 16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

desktopStatistics(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration:studentGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonText.regular(
                    '${controller.data.value.noOfStudents.toString()}Students',
                    size: 16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgImageFromAsset(CommonImageAssets.noOfStudents),
              ],
            ),
          ),
          Gap(15),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: noOfCoursesGradient(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonText.regular(
                      '${controller.data.value.noOfCourses.toString()} Courses',
                      size: 16, maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SvgImageFromAsset(CommonImageAssets.noOfCourses),
                ],
              ),
            ),
          Gap(15),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration: noOfRatingGradient(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonText.regular(
                    '${controller.data.value.noOfRating.toString()} Rating',
                    size: 16, maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgImageFromAsset(CommonImageAssets.noOfRating),
              ],
            ),
          ),
        ],
      ),
    );
}
studentGradient(){
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDarkMode
            ? [
          Color(0xFF000000), // Dark start
          Color(0xFF1E0A27), // Dark end
        ]
            : [
          Color(0xFFF8FBFF), // Light start
          Color(0xFFFDF9FF), // Light end
        ],
        stops: [0.1052, 0.9044],
        transform: GradientRotation(264.83 * (3.1416 / 180)),
      ),
      border: Border.all(
        color: isDarkMode
            ? AppColors.grey100Color
            : AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(9),
    );
}
noOfCoursesGradient(){
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDarkMode
            ? [
          Color(0xFF000000), // Dark start
          Color(0xFF08280B), // Dark end
        ]
            : [
          Color(0xFFF8FBFF), // Light start
          Color(0xFFF4FFF5), // Light end
        ],
        stops: [0.1052, 0.9044],
        transform: GradientRotation(264.83 * (3.1416 / 180)),
      ),
      border: Border.all(
        color: isDarkMode
            ? AppColors.grey100Color
            : AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(9),
    );
}
noOfRatingGradient(){
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDarkMode
            ? [
          Color(0xFF000000), // Dark start
          Color(0xFF2A1B09), // Dark end
        ]
            : [
          Color(0xFFF8FBFF), // Light start
          Color(0xFFFFFAF4), // Light end
        ],
        stops: [0.1052, 0.9044],
        transform: GradientRotation(264.83 * (3.1416 / 180)),
      ),
      border: Border.all(
        color: isDarkMode
            ? AppColors.grey100Color
            : AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(9),
    );

}



}
