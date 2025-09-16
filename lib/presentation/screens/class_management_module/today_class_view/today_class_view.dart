part of 'today_class_view_imports.dart';

class TodayClassView extends StatefulWidget {
  const TodayClassView({super.key});

  @override
  State<TodayClassView> createState() => _TodayClassViewState();
}

class _TodayClassViewState extends State<TodayClassView> {
  TodayClassController controller = Get.put(TodayClassController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final extras = GoRouterState.of(context).extra;
    final DateTime? date = extras is DateTime ? extras : null;
    String formattedDate = date != null
        ? DateFormat("dd MMMM yyyy").format(date)
        : "No date";
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
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Row(
                  children: [
                    Expanded(child: commonHeaderText(title: formattedDate)),
                    mobileView
                        ? Obx(
                          () =>  filterView(() {
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        commonCloseIcon(context)
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
                                            usersDropDown(),
                                            Gap(12),
                                            courseCategoryDropDown()
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
                                              controller.clearCoursesFilterSelections();
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
                                            label: AppCommonStrings.btnApply,
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
                      },controller.todayClassicList.length.toString()),
                    ):SizedBox(),
                    Gap(15),
                    CommonCircleAddButton(
                      onTap: () {
                        context.go(
                          '${AppRouteName.classManagementView}/${AppRouteName.addClassView}',
        
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, ),
                child:  mobileView
                    ? SizedBox()
                    :Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 200, child: usersDropDown()),
                    Gap(20),
                    SizedBox(width: 200, child: courseCategoryDropDown()),
                    Gap(20),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.clearCoursesFilterSelections();
                        },
                        child: CommonText.medium(
                          ApprovalsStrings.clearAll,
                          size: 14,
                          color: AppColors.error500,
                        ),
                      ),
                    ),
                    Gap(20),
                    Obx(
                      () =>  CommonText.semiBold(
                        '${controller.todayClassicList.length.toString()} Results',
                        size: 15,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(mobileView?0:20),
              CommonDivider(),
        
        
              Padding(
                padding:  EdgeInsets.only(
                  left: 20,
                  right: mobileView?20:170,
                  top: 20,
                  bottom: 20,
                ),
                child: Obx(
                  () => ResponsiveGridRow(
                    children: List.generate(controller.todayClassicList.length, (
                      index,
                    ) {
                      final data = controller.todayClassicList[index];
                      return ResponsiveGridCol(
                        lg: 4,
                        child: todayClassView(data,context)
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}
