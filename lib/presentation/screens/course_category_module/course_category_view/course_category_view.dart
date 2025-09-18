part of 'course_category_imports.dart';

class CourseCategoryView extends StatefulWidget {
  const CourseCategoryView({super.key});

  @override
  State<CourseCategoryView> createState() => _CourseCategoryViewState();
}

class _CourseCategoryViewState extends State<CourseCategoryView> {
  CourseCategoryController controller = Get.put(CourseCategoryController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonHeaderText(title: DashboardViewStrings.category),
                  CommonCircleAddButton(
                    onTap: () {
                      commonDialogBox(
                        context: context,
                        child: SizedBox(
                          width: 560,
                          child: AddCourseCategoryView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            CommonDivider(),

            Obx(
              () => Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: ResponsiveGridRow(
                  children: List.generate(
                    controller.courseCategoryList.length,
                    (index) {
                      final data = controller.courseCategoryList[index];
                      return ResponsiveGridCol(
                        lg: 2,
                        xs: 12,
                        child: Container(
                          decoration: commonCardDecoration(12),
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonCacheImage(
                                    data.image,
                                    ImagePlaceHolder.imagePlaceHolderDark,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Gap(mobileView ? 20 : 0),
                                  mobileView
                                      ? Expanded(child: commonDetailView(data))
                                      : SizedBox(),
                                  menuButton(),
                                ],
                              ),
                              Gap(20),
                              mobileView ? SizedBox() : commonDetailView(data),
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
    );
  }

  Widget menuButton() {
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
      padding: EdgeInsetsGeometry.zero,
      menuPadding: EdgeInsetsGeometry.zero,
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
          onTap: () {
            context.push(
              '${AppRouteName.courseCategoryView}/${AppRouteName.viewCourseCategory}',
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
          value: 3,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                width: 560,
                child: CommonDeleteDialogBox(
                  tittle: CourseCategoryStrings.deleteCategory,
                  subtitle: CourseCategoryStrings.deleteCategoryDes,
                  doneOnPressed: () {
                    showSuccessMessage(context: context, title: 'Category Delete Successfully', content: '');
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
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.mainDarkBgColor
              : AppColors.lightBgColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
          ),
        ),
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

  Widget commonDetailView(CourseCategoryModel data) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.medium(
          data.name,
          color: isDarkMode ? AppColors.headingsLightColor : AppColors.black,
          size: 17,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(12),
        CommonText.regular(
          '${data.noOfCourses.toString()} Courses',
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(12),
        CommonText.regular(
          '${data.noOfAttendees.toString()} Attendees',
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
