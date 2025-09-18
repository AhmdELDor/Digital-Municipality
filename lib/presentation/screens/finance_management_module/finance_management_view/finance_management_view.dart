part of 'finance_management_imports.dart';

class FinanceManagementView extends StatefulWidget {
  const FinanceManagementView({super.key});

  @override
  State<FinanceManagementView> createState() => _FinanceManagementViewState();
}

class _FinanceManagementViewState extends State<FinanceManagementView> {
  FinanceManagementController controller = Get.put(
    FinanceManagementController(),
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
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Builder(
            builder: (context) {
              final TabController tabController = DefaultTabController.of(
                context,
              );
        
              return Obx(
                () => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      /// -------- Profile & Statistics section --------
                      SliverToBoxAdapter(
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
                                      hintText:
                                          DashboardViewStrings.searchAnything,
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: CommonText.medium(
                                FinanceManagementStrings.financeManagement,
                                size: 18,
                              ),
                            ),
                            CommonDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: ResponsiveGridRow(
                                children: [
                                  ResponsiveGridCol(
                                    xs: 12,
                                    lg: 3,
                                    child: dashboardOverView(
                                      title:
                                          FinanceManagementStrings.totalEarning,

                                      image: CommonImageAssets.totalEarning,
                                      total: '\$${controller.data.value.totalEarning
                                          .toString()}',
                                      scholarship: '20%',
                                      margin: mobileView ? 0 : 12,
                                      gradient: isDarkMode
                                          ? totalStudentDarkGradient
                                          : totalStudentGradient,
                                      color: AppColors.pink600,
                                      context: context,

                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    xs: 12,
                                    lg: 3,
                                    child: dashboardOverView(
                                      title:
                                          FinanceManagementStrings.coursesSelling,
                                      image: CommonImageAssets.courseSelling,
                                      total: controller.data.value.courseSelling
                                          .toString(),
                                      scholarship: '20%',
                                      margin: mobileView ? 0 : 12,
                                      gradient: isDarkMode
                                          ? totalInstructorDarkGradient
                                          : totalInstructorGradient,
                                      color: AppColors.purple600,
                                      context: context,
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    xs: 12,
                                    lg: 3,
                                    child: dashboardOverView(
                                      title:
                                          FinanceManagementStrings.courseEarning,
                                      image: CommonImageAssets.totalCoursesLogo,
                                      total: '\$${controller.data.value.courseEarning
                                          .toString()}',
                                      scholarship: '20%',
                                      margin: mobileView ? 0 : 12,
                                      gradient: isDarkMode
                                          ? totalCoursesDarkGradient
                                          : totalCoursesGradient,
                                      color: AppColors.secondary500,
                                      context: context,
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    xs: 12,
                                    lg: 3,
                                    child: dashboardOverView(
                                      title: FinanceManagementStrings
                                          .instructorPayOut,
                                      image: CommonImageAssets.instructorPayOut,
                                      total: '\$${controller
                                          .data
                                          .value
                                          .instructorPayOut
                                          .toString()}',
                                      scholarship: '35%',
                                      margin: 0,
                                      gradient: isDarkMode
                                          ? monthlyRevenueDarkGradient
                                          : monthlyRevenueGradient,
                                      color: AppColors.success500,
                                      context: context,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
        
                      /// -------- TabBar pinned at top after scroll --------
                      SliverAppBar(
                        pinned: true,
                        floating: false,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(
                            mobileView ? 80 : 20,
                          ), // 👈 fixed height
                          child: mobileView
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    tabBarView(
                                      tabController,
                                      isDarkMode,
                                      mobileView,
                                    ),
                                    Gap(15),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: tabButtons(
                                        tabController,
                                        isDarkMode,
                                        mobileView,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    tabBarView(
                                      tabController,
                                      isDarkMode,
                                      mobileView,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: tabButtons(
                                        tabController,
                                        isDarkMode,
                                        mobileView,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ];
                  },
        
                  /// -------- TabBarView scrollable content --------
                  body: TabBarView(
                    controller: tabController,
                    children: [
                      paymentMethodList(mobileView),
                      paymentReceivedList(mobileView),
                      instructorPayOutList(mobileView),
                    ],
                  ),
                ),
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
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, _) {
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
          isScrollable:true,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            color: isDarkMode
                ? AppColors.cardDarkBg2Color
                : AppColors.primary50,
            border: Border(bottom: BorderSide(color: AppColors.primary500)),
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) )
          ),

          tabs: [
            Tab(text: FinanceManagementStrings.paymentMethods),
            Tab(text: FinanceManagementStrings.paymentReceived),
            Tab(text: FinanceManagementStrings.instructorPayOut),
          ],
        );
      },
    );
  }

  Widget tabButtons(
    TabController tabController,
    bool isDarkMode,
    bool mobileView,
  ) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, _) {
        if (tabController.index == 0) {
          return SizedBox(
            width: mobileView ? 167 : 194,
            child: PrimaryButton(
              height: mobileView ? 34:37,
              textSize: mobileView ? 13: 14,
              onPressed: () {
                commonDialogBox(
                  context: context,
                  child: SizedBox(width: 560, child: AddPaymentMethodView()),
                );
              },
              label: FinanceManagementStrings.addPaymentMethod,
              prefixIcon: SvgImageFromAsset(
                AppCommonIcon.circleAddIcon,
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
            ),
          );
        } else if (tabController.index == 1) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              mobileView
                  ? filterView(
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
                                            coursesDropDown(),
                                            Gap(15),
                                            paymentMethodDropDown(),
                                            Gap(15),
                                            statusDropDown(),
                                            Gap(15),
                                            selectDate(),
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
                                              controller.clearSelections();
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
                      },
                      controller.data.value.paymentReceivedList.length
                          .toString(),
                    )
                  : SizedBox(),
              Gap(mobileView ? 12:0),
              SizedBox(
                width: mobileView ? 177 : 194,
                child: PrimaryButton(
                  height: 37,
                  textSize: mobileView ? 12:14,
                  onPressed: () {
                    commonDialogBox(
                      context: context,
                      child: SizedBox(width: 560, child: AddPaymentView()),
                    );
                  },
                  label: FinanceManagementStrings.addReceivedPayment,
                  prefixIcon: SvgImageFromAsset(
                    AppCommonIcon.circleAddIcon,
                    colorFilter: ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.end,
              children: [
                mobileView
                    ? filterView(
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
                                               occurrenceDropDown(),
                                              Gap(20),
                                              paymentMethodDropDown(),
                                              Gap(20),
                                              statusDropDown(),
                                              Gap(20),
                                             usersDropDown(),
                                              Gap(20),
                                             selectDate(),

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
                                                controller.clearSelections();
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
                        },
                        controller.data.value.instructorPayOutList.length
                            .toString(),
                      )
                    : SizedBox(),
                Gap(mobileView ? 15:0),
                SizedBox(
                  width: mobileView ? 70 : 93,
                  child: PrimaryButton(
                    height: 37,
                    textSize: mobileView ?10:14,
                    onPressed: () {
                      commonDialogBox(
                        context: context,
                        child: SizedBox(width: 560, child: SetPayOutView()),
                      );
                    },
                    label: FinanceManagementStrings.setPayOut,
                  ),
                ),
                Gap(15),
                SizedBox(
                  width: mobileView ? 150 : 192,
                  child: PrimaryButton(
                    height: 37,
                    textSize: mobileView ?10:14,
                    onPressed: () {
                      context.go(
                        '${AppRouteName.financeManagementView}/${AppRouteName.addInstructorPayOut}',
                      );
                    },
                    label: FinanceManagementStrings.addInstructorPayOut,
                    prefixIcon: SvgImageFromAsset(
                      AppCommonIcon.circleAddIcon,
                      colorFilter: ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget paymentMethodList(bool mobileView) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: ResponsiveGridRow(
          children: List.generate(
            controller.data.value.paymentMethodsList.length,
            (index) {
              return ResponsiveGridCol(
                lg: 12,
                xs: 12,
                xl: 3,

                child: Column(
                  children: [
                    _paymentMethodView(
                      mobileView,
                      controller.data.value.paymentMethodsList[index],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget paymentReceivedList(bool mobileView) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mobileView
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Expanded(child: coursesDropDown()),
                        Gap(20),
                        Expanded(child: paymentMethodDropDown()),
                        Gap(20),
                        Expanded(child: statusDropDown()),
                        Gap(20),
                        Expanded(child: selectDate()),
                        Gap(20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.clearSelections();
                            },
                            child: CommonText.medium(
                              ApprovalsStrings.clearAll,
                              size: 14,
                              color: AppColors.error500,
                            ),
                          ),
                        ),
                        CommonText.semiBold(
                          '${controller.data.value.paymentReceivedList.length.toString()} Results',
                          size: 15,
                          color: AppColors.primary500,
                        ),
                      ],
                    ),
                  ),
            Gap(mobileView ? 0 : 25),
            ResponsiveGridRow(
              children: List.generate(
                controller.data.value.paymentReceivedList.length,
                (index) {
                  final data = controller.data.value.paymentReceivedList[index];
                  return ResponsiveGridCol(
                    lg: 4,
                    xs: 12,
                    child: paymentView(data, mobileView,true),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget instructorPayOutList(bool mobileView) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mobileView?SizedBox():
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Expanded(child: occurrenceDropDown()),
                  Gap(20),
                  Expanded(child: paymentMethodDropDown()),
                  Gap(20),
                  Expanded(child: statusDropDown()),
                  Gap(20),
                  Expanded(child: usersDropDown()),
                  Gap(20),
                  Expanded(child: selectDate()),
                  Gap(20),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.clearSelections();
                      },
                      child: CommonText.medium(
                        ApprovalsStrings.clearAll,
                        size: 14,
                        color: AppColors.error500,
                      ),
                    ),
                  ),

                  CommonText.semiBold(
                    '${controller.data.value.paymentReceivedList.length.toString()} Results',
                    size: 15,
                    color: AppColors.primary500,
                  ),
                ],
              ),
            ),
            Gap(mobileView?0:25),
            ResponsiveGridRow(
              children: List.generate(
                controller.data.value.instructorPayOutList.length,
                (index) {
                  final data =
                      controller.data.value.instructorPayOutList[index];
                  return ResponsiveGridCol(
                    lg: 4,
                    child: instructorPayOut(data),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodView(bool mobileView, PaymentMethodModel data) {
    return Container(
      decoration: commonCardDecoration(12),
      margin: EdgeInsetsGeometry.only(right: 20, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 34,
                 // width: 50,
                  child: commonCacheImage(
                    data.image,
                    ImagePlaceHolder.imagePlaceHolderDark,
                    height: 34,
                    fit: BoxFit.cover,
                    //width: 50,
                    //fit: BoxFit.fill
                  ),
                ),
                Spacer(),
                menuButton(),
              ],
            ),
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CommonText.regular(data.name, size: mobileView?16:18),
          ),
          Gap(20),
          CommonDivider(),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CommonText.regular(
              '${data.paymentReceivedNo} Payment Received',
              size:  15,
            ),
          ),
          Gap(12),
        ],
      ),
    );
  }

  Widget instructorPayOut(InstructorModel data) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      decoration: commonCardDecoration(12),
      margin: EdgeInsetsGeometry.only(right: 20,bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: commonCacheImage(
                    data.image,
                    ImagePlaceHolder.imagePlaceHolderDark,
                    height: 64,
                    width: 64,
                    //fit: BoxFit.fill
                  ),
                ),
                Gap(12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.medium(data.name, size: 15),
                      Gap(3),
                      CommonText.regular(
                        data.emiStatus,
                        size: 13,
                        color: isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(3),
                      CommonText.semiBold(
                        '\$${data.courseFees.toString()}',
                        size: 17,
                        color: AppColors.primary500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                menuButton(),
              ],
            ),
          ),
          Gap(20),
          CommonDivider(),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText.regular(
                      StudentManagementDetailStrings.paymentDate,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    CommonText.regular(data.paymentDate, size: 15),
                  ],
                ),
                Gap(12),
                CommonDivider(),
                Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText.regular(
                      FinanceManagementStrings.totalNoOfPayments,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    CommonText.regular(
                      data.totalNoOfPayments.toString(),
                      size: 15,
                    ),
                  ],
                ),
                Gap(12),
                CommonDivider(),
                Gap(12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText.regular(
                      StudentManagementDetailStrings.paymentMethod,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    CommonText.regular(data.paymentMethod, size: 15),
                  ],
                ),
                Gap(12),
                CommonDivider(),
                Gap(12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText.regular(
                      FinanceManagementStrings.paymentID,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    CommonText.regular(data.paymentId, size: 15),
                  ],
                ),
                Gap(12),
                CommonDivider(),
                Gap(12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText.regular(
                      StudentManagementDetailStrings.status,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    CommonText.regular(
                      data.status,
                      size: 15,
                      color: data.status == 'Paid'
                          ? AppColors.success600
                          : data.status == 'Upcoming'
                          ? AppColors.secondary500
                          : AppColors.error600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  menuButton() {
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

  //course dropdown
  Widget coursesDropDown() {
    return AlwaysDownDropdown<CourseModel>(
      hintText: "Course",
      items: controller.data.value.coursesList,
      value: controller.selectedCourse.value,
      onChanged: (val) {
        controller.selectedCourse.value = val;
      },
      itemAsString: (item) => item.name,
      //validator: (val) => val == null ? "Course" : null,
    );
  }
  Widget occurrenceDropDown() {
    return AlwaysDownDropdown<OccurrenceModel>(
      hintText: "Occurrence",
      items: controller.data.value.occurrenceList,
      value: controller.selectedOccurrenceValue.value,
      onChanged: (val) {
        controller.selectedOccurrenceValue.value = val;
      },
      itemAsString: (item) => item.name,
      //validator: (val) => val == null ? "Occurrence" : null,
    );
  }

  //payment method drop down
  Widget paymentMethodDropDown() {
    return AlwaysDownDropdown<PaymentMethodModel>(
      hintText: "Payment Method",
      items: controller.data.value.paymentMethodsList,
      value: controller.selectedPaymentMethod.value,
      onChanged: (val) {
        controller.selectedPaymentMethod.value = val;
      },
      itemAsString: (item) => item.name,
      //validator: (val) => val == null ? "Payment Method" : null,
    );
  }

  //status drop down
  Widget statusDropDown() {
    return AlwaysDownDropdown<StatusModel>(
      hintText: "Status",
      items: controller.data.value.statusList,
      value: controller.selectedStatus.value,
      onChanged: (val) {
        controller.selectedStatus.value = val;
      },
      itemAsString: (item) => item.name,
     // validator: (val) => val == null ? "Status" : null,
    );
  }

  //users drop down
  Widget usersDropDown() {
    return Obx(
      () => AlwaysDownDropdown<UserModel>(
        hintText: "Select",
        items: controller.data.value.usersList,
        value: controller.selectedUser.value,
        onChanged: (val) {
          controller.selectedUser.value = val;
        },
        itemAsString: (item) => item.name,
        //validator: (val) => val == null ? "Please select" : null,
      ),
    );
  }

  //select date
  Widget selectDate() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return CommonDatePicker(
      hintText: AddClassStrings.date,
      controller: controller.dateController,
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

  //payment received dropdown
  Widget coursesPaymentDropDown() {
    return AlwaysDownDropdown<CourseModel>(
      hintText: "Course",
      items: controller.data.value.coursesList,
      value: controller.selectedPaymentCourse.value,
      onChanged: (val) {
        controller.selectedPaymentCourse.value = val;
      },
      itemAsString: (item) => item.name,
      //validator: (val) => val == null ? "Course" : null,
    );
  }

  //payment method drop down
  Widget receivedPaymentMethodDropDown() {
    return AlwaysDownDropdown<PaymentMethodModel>(
      hintText: "Payment Method",
      items: controller.data.value.paymentMethodsList,
      value: controller.selectedPaymentMethodReceived.value,
      onChanged: (val) {
        controller.selectedPaymentMethodReceived.value = val;
      },
      itemAsString: (item) => item.name,
      //validator: (val) => val == null ? "Payment Method" : null,
    );
  }

  //status drop down
  Widget statusPaymentDropDown() {
    return AlwaysDownDropdown<StatusModel>(
      hintText: "Status",
      items: controller.data.value.statusList,
      value: controller.selectedPaymentStatus.value,
      onChanged: (val) {
        controller.selectedPaymentStatus.value = val;
      },
      itemAsString: (item) => item.name,
      //validator: (val) => val == null ? "Status" : null,
    );
  }

  //users drop down
  Widget usersPaymentDropDown() {
    return Obx(
      () => AlwaysDownDropdown<UserModel>(
        hintText: "Select",
        items: controller.data.value.usersList,
        value: controller.selectedPaymentUser.value,
        onChanged: (val) {
          controller.selectedPaymentUser.value = val;
        },
        itemAsString: (item) => item.name,
        //validator: (val) => val == null ? "Please select" : null,
      ),
    );
  }

  //select date
  Widget selectPaymentDate() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return CommonDatePicker(
      hintText: AddClassStrings.date,
      initialDate: DateTime.now(),
      controller: controller.datePaymentController,
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
