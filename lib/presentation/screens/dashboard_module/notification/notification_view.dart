part of 'notification_view_imports.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with TickerProviderStateMixin {
  NotificationController controller = Get.put(NotificationController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.medium(
                          NotificationStrings.notification,
                          size: 18,
                        ),
                        Obx(
                          () => CommonText.regular(
                            '${controller.notificationList.where((e) => !e.read).length} unread notification',
                            size: 14,
                            color: isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 152,
                      child: PrimaryButton(
                        height: 40,
                        backgroundColor: isDarkMode
                            ? AppColors.mainDarkBgColor
                            : AppColors.primary50,
                        textSize: 15,
                        textWeight: FontWeight.w600,
                        borderSide: BorderSide(color: AppColors.primary500),
                        onPressed: () {},
                        label: NotificationStrings.markASAllRead,
                        textColor: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 20),
                child: TabBar(
                  onTap: (value) {
                    controller.changeTab(value);
                  },
                  labelColor: AppColors.lightPrimaryColor,
                  dividerColor: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.greyColor,
                  unselectedLabelStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  indicator: BoxDecoration(
                    // color: isDarkMode
                    //     ? AppColors.cardDarkBg2Color
                    //     : AppColors.brand500,
                    border: Border(
                      bottom: BorderSide(color: AppColors.primary500, width: 1),
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: NotificationStrings.all),
                    Tab(text: NotificationStrings.newText),
                    Tab(text: NotificationStrings.unread),
                    // Tab(text: secondTabTitle),
                  ],
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    NotificationListView(),
                    NotificationListView(),
                    NotificationListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
