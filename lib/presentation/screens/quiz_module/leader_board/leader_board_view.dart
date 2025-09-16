part of 'leader_board_imports.dart';

class LeaderBoardView extends StatefulWidget {
  const LeaderBoardView({super.key});

  @override
  State<LeaderBoardView> createState() => _LeaderBoardViewState();
}

class _LeaderBoardViewState extends State<LeaderBoardView> {
  LeaderBoardController controller = Get.put(LeaderBoardController());
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
                  CommonText.medium(LeaderBoardStrings.leaderboard, size: 18),
                  mobileView
                      ? Obx(
                          () => filterView(() {
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
                                                coinsDropDown(),
                                                Gap(20),
                                                selectDate()
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
                          }, controller.leaderBoardList.length.toString()),
                        )
                      : SizedBox(),
                ],
              ),
            ),

            CommonDivider(),
            Gap(20),
            mobileView?SizedBox():
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SizedBox(width: 200, child: coinsDropDown()),

                  Gap(25),
                  SizedBox(width: 200, child: selectDate()),
                  Gap(25),
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

                  Obx(
                    () =>  CommonText.semiBold(
                      '${controller.leaderBoardList.length.toString()} Results',
                      size: 15,
                      color: AppColors.primary500,
                    ),
                  ),
                ],
              ),
            ),

            Obx(
              () => Padding(
                padding:  EdgeInsets.only(top:mobileView?0: 25, left: 20, bottom: 20),
                child: ResponsiveGridRow(
                  children: List.generate(controller.leaderBoardList.length, (
                    index,
                  ) {
                    final data = controller.leaderBoardList[index];
                    return ResponsiveGridCol(
                      lg: 4,
                      xs: 12,
                      child: leaderView(data),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget leaderView(LeaderBoardModel data){
  var mobileView = ResponsiveView.isMobile(context);
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      decoration: commonCardDecoration(12),
      margin: EdgeInsetsGeometry.only(right: 20, bottom: 20),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular( mobileView ? 50:72),
                child: commonCacheImage(
                  data.image,
                  ImagePlaceHolder.imagePlaceHolderDark,
                  height: mobileView ? 50 : 72,
                  width: mobileView ? 50 : 72,
                ),
              ),
              Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonText.medium(data.name, size: mobileView?15:16),
                    Gap(3),
                    CommonText.regular(
                      data.email,
                      size: mobileView?15:16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    Gap(3),
                    CommonText.regular(
                      data.phoneNo,
                      size:mobileView?15: 16,
                      color: AppColors.greyTextColor,
                    ),
                  ],
                ),
              ),
              Container(
                height: mobileView?60:80,
                width: mobileView?60:80,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkCircleOne
                      : AppColors.circleOne,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    height: mobileView?48:64,
                    width:mobileView?48: 64,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkCircleTwo
                          : AppColors.circleTwo,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: mobileView?37.5:50,
                        width: mobileView?37.5:50,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.darkCircleThree
                              : AppColors.circleThree,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            height: mobileView?27:36,
                            width: mobileView?27:36,
                            decoration: BoxDecoration(
                              color: AppColors.circleFour,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CommonText.medium(
                                data.rank.toString(),
                                size: 18,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(15),
          CommonDivider(height: 1.5,),
          Gap(15),
          mobileView?Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leadingText(
                    LeaderBoardStrings.totalCoins,
                  ), Gap(12),
                  trailingText(data.totalCoins.toString()),
                ],
              ),
              Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leadingText(
                    LeaderBoardStrings.dateUpdated,
                  ),
                  Gap(12),
                  trailingText(data.date),
                ],
              ),

            ],
          ):

          Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  leadingText(
                    LeaderBoardStrings.totalCoins,
                  ),
                  trailingText(data.totalCoins.toString()),
                ],
              ),
              Gap(15),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  leadingText(
                    LeaderBoardStrings.dateUpdated,
                  ),
                  Gap(15),
                  trailingText(data.date),
                ],
              ),
            ],
          ),
        ],
      ),
    );
}
  Widget coinsDropDown() {
    return Obx(
      () => AlwaysDownDropdown<String>(
        hintText: "Coins Range",
        items: controller.ranges,
        value: controller.selectedRange.value,
        onChanged: (value) {
          controller.selectedRange.value = value;
        },
       // validator: (val) => val == null || val.isEmpty ? "Coins Range" : null,
      ),
    );
  }

  Widget selectDate() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return CommonDatePicker(
      hintText: AddClassStrings.selectDate,
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

  Widget leadingText(String leading) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return CommonText.regular(
      leading,
      size: 15,
      color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
    );
  }

  Widget trailingText(String trailing) {
    return CommonText.regular(trailing, size: 15);
  }
}
