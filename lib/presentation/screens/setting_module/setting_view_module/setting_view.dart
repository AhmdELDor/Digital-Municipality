part of 'setting_view_imports.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SettingViewController controller = Get.put(SettingViewController());
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mobileView
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: CommonSearchField(
                      controller: controller.searchController,
                      hintText: DashboardViewStrings.searchAnything,
                    ),
                  )
                : SizedBox(),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonHeaderText(title: SettingViewStrings.setting),
                  Obx(
                    () => controller.selectedIndex.value == 1
                        ? CommonCircleAddButton(
                            onTap: () {
                              commonDialogBox(
                                context: context,
                                child: SizedBox(width: 560, child: AddFaqView()),
                              );
                            },
                          )
                        : controller.selectedIndex.value == 2
                        ? Row(
                            children: [
                              CommonCircleAddButton(
                                onTap: () {
                                  commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: 560,
                                      child: AddPrivacyPolicy(),
                                    ),
                                  );
                                },
                              ),
                              Gap(15),
        
                              InkWell(
                                onTap: () {
                                  commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: 560,
                                      child: EditPrivacyPolicyView(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: mobileView ? 32 : 36,
                                  width: mobileView ? 32 : 36,
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppColors.mainDarkBgColor
                                        : AppColors.lightBgColor,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? AppColors.grey100Color
                                          : AppColors.lightBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgImageFromAsset(
                                      AppCommonIcon.editIcon,
                                      colorFilter: ColorFilter.mode(
                                        isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gap(15),
                              InkWell(
                                onTap: () {
                                  commonDialogBox(
                                    context: context,
                                    child: SizedBox(
                                      width: 560,
                                      child: DeletePrivacyPolicyView(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: mobileView ? 32 : 36,
                                  width: mobileView ? 32 : 36,
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppColors.mainDarkBgColor
                                        : AppColors.lightBgColor,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? AppColors.grey100Color
                                          : AppColors.error500,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgImageFromAsset(
                                      AppCommonIcon.deleteIcon,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
            CommonDivider(),
            Gap(20),
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
                  () => customTab(
                    SettingViewStrings.customBranding,
                    CommonImageAssets.customBranding,
                    isSelected: controller.selectedIndex.value == 0,
                  ),
                ),
                Obx(
                  () => customTab(
                    mobileView?SettingViewStrings.faqText:SettingViewStrings.faq,
                    CommonImageAssets.faq,
                    isSelected: controller.selectedIndex.value == 1,
                  ),
                ),
                Obx(
                  () => customTab(
                    SettingViewStrings.privacyPolicy,
                    CommonImageAssets.privacyPolicy,
                    isSelected: controller.selectedIndex.value == 2,
                  ),
                ),
                Obx(
                  () => customTab(
                    SettingViewStrings.contactUs,
                    CommonImageAssets.contactUs,
                    isSelected: controller.selectedIndex.value == 3,
                  ),
                ),
              ],
            ),
            Gap(20),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(child: CustomBrandingView()),
                  SingleChildScrollView(child: FaqView()),
                  SingleChildScrollView(child: PrivacyPolicy()),
                  SingleChildScrollView(child: ContactUsView()),
        
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
