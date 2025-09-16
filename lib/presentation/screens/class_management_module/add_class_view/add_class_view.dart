part of 'add_class_view_imports.dart';

class AddClassView extends StatefulWidget {
  const AddClassView({super.key});

  @override
  State<AddClassView> createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AddClassController controller = Get.put(AddClassController());
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
              child: commonHeaderText(title: AddClassStrings.addClass),
            ),

            CommonDivider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: 10,
                    xs: 12,
                    child: mobileView ? deviceView() : _desktopView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _desktopView() {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mobileView ? 0 : 15,
        vertical: mobileView ? 0 : 25,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: mobileView
              ? Colors.transparent
              : isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    classNameView(),
                    Gap(25),
                    Row(
                      children: [
                        Expanded(child: selectDate()),
                        Gap(25),
                        Expanded(child: selectTime(context)),
                      ],
                    ),
                    Gap(25),
                    selectInstructorView(),
                    Gap(25),
                  ],
                ),
              ),
              Gap(30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selectCourseView(),
                    Gap(25),
                    imageVideoView(),
                    Gap(25),
                    descriptionController(context),
                  ],
                ),
              ),
            ],
          ),
          Gap(30),
          Row(
            children: [
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {},
                  label: AppCommonStrings.btnCancel,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                  backgroundColor: isDarkMode
                      ? AppColors.mainDarkBgColor
                      : AppColors.lightBgColor,
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  textColor: isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                ),
              ),
              Gap(25),
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {},
                  label: AddClassStrings.scheduleClass,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  deviceView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                classNameView(),
                Gap(15),
                selectCourseView(),
                Gap(15),
                selectDate(),
                Gap(15),
                selectTime(context),
                Gap(15),
                imageVideoView(),
                Gap(15),
                selectInstructorView(),
                Gap(15),
                descriptionController(context),
                Gap(25),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {},
                  label: AppCommonStrings.btnCancel,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                  backgroundColor: isDarkMode
                      ? AppColors.mainDarkBgColor
                      : AppColors.lightBgColor,
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  textColor: isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                ),
              ),
              Gap(25),
              Expanded(
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {},
                  label: AddClassStrings.scheduleClass,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
