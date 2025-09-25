part of 'class_management_view_imports.dart';

class ClassManagementView extends StatefulWidget {
  const ClassManagementView({super.key});

  @override
  State<ClassManagementView> createState() => _ClassManagementViewState();
}

class _ClassManagementViewState extends State<ClassManagementView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ClassManagementController controller = Get.put(ClassManagementController());
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonHeaderText(
                            title: DashboardViewStrings.classManagement,
                          ),
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

                    CommonDivider(),

                    ResponsiveGridRow(
                      children: [
                        ResponsiveGridCol(
                          lg: 3,
                          xs: 12,
                          child: Container(
                            height: mobileView ? null : context.height,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.mainDarkBgColor
                                  : AppColors.greyBgColor.withValues(alpha: 0.25),
                              border: Border(
                                right: BorderSide(
                                  color: isDarkMode
                                      ? AppColors.grey100Color
                                      : AppColors.lightBorderColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  child: CommonText.medium(
                                    ClassManagementStrings.upcomingClass,
                                    size: 14,
                                  ),
                                ),

                                mobileView ? SizedBox() : CommonDivider(height: 1.5),
                                mobileView
                                    ? SizedBox(
                                        height: 140,
                                        child: Obx(
                                          () => ListView.builder(
                                            itemCount:
                                                controller.upComingClassicList.length,
                                            // shrinkWrap: true,
                                            // physics: NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final data =
                                                  controller.upComingClassicList[index];
                                              return _upcomingClassView(data);
                                            },
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Obx(
                                          () => ListView.builder(
                                            itemCount:
                                                controller.upComingClassicList.length,
                                            // shrinkWrap: true,
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final data =
                                                  controller.upComingClassicList[index];
                                              return _upcomingClassView(data);
                                            },
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),

                        ResponsiveGridCol(
                          lg: 9,
                          xs: 12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _monthBackwardOrForwardButton(),
                                Container(
                                  height: context.height * 0.7,
                                  padding: EdgeInsets.only(
                                    left: mobileView ? 0 : 50,
                                    right: mobileView ? 0 : 50,
                                    bottom: mobileView ? 0 : 50,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mobileView
                                        ? Colors.transparent
                                        : isDarkMode
                                        ? AppColors.cardDarkBgColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(mobileView ? 0 : 20),
                                      bottomLeft: Radius.circular(mobileView ? 0 : 20),
                                    ),
                                    border: mobileView
                                        ? Border(
                                            left: BorderSide(
                                              color: isDarkMode
                                                  ? AppColors.grey100Color
                                                  : AppColors.lightBorderColor,
                                              width: 1.5,
                                            ),
                                            bottom: BorderSide(
                                              color: isDarkMode
                                                  ? AppColors.grey100Color
                                                  : AppColors.lightBorderColor,
                                              width: 1.5,
                                            ),
                                            right: BorderSide(
                                              color: isDarkMode
                                                  ? AppColors.grey100Color
                                                  : AppColors.lightBorderColor,
                                              width: 1.5,
                                            ),
                                          )
                                        : Border.all(
                                            color: isDarkMode
                                                ? AppColors.grey100Color
                                                : AppColors.lightBorderColor,
                                            width: 1.5,
                                          ),
                                  ),
                                  child: Column(
                                    children: [_weekNameView(), _calenderView()],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _monthBackwardOrForwardButton() {
    var mobileView = ResponsiveView.isMobile(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90EB), Color(0xFF285CCD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back Button
          Container(
            height: mobileView ? 32 : 48,
            width: mobileView ? 32 : 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  controller.calendarController.backward!();
                },
              ),
            ),
          ),
          Gap(20),
          // Month-Year text
          CommonText.bold(
            DateFormat.yMMMM().format(controller.currentMonth),
            size: mobileView ? 16 : 32,
            color: AppColors.lightBgColor,
          ),
          Gap(20),
          // Forward Button
          Container(
            height: mobileView ? 32 : 48,
            width: mobileView ? 32 : 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  controller.calendarController.forward!();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _weekNameView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: mobileView
            ? isDarkMode
                  ? AppColors.cardDarkBg2Color
                  : AppColors.white
            : isDarkMode
            ? AppColors.mainDarkBgColor
            : AppColors.white,
        border: Border(
          left: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
          right: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
          bottom: mobileView
              ? BorderSide(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                  width: 1,
                )
              : BorderSide(color: Colors.transparent),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            .map(
              (day) => Expanded(
                child: Center(
                  child: CommonText.medium(
                    day,
                    size: mobileView ? 14 : 16,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.headingsColor,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  _calenderView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Expanded(
      child: SfCalendar(
        controller: controller.calendarController,
        view: CalendarView.month,
        headerHeight: 0, // hide default header
        viewHeaderHeight: 0,

        weekNumberStyle: WeekNumberStyle(
          textStyle: TextStyle(color: Colors.orange),
          backgroundColor: Colors.green,
        ),

        monthCellBuilder: (BuildContext context, MonthCellDetails details) {
          final DateTime date = details.date;
          final bool isToday =
              date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year;

          // Color textColor = Colors.black;
          //
          // if (date.weekday == DateTime.sunday) {
          //   textColor = Colors.red; // Sunday red
          // } else if (date.weekday == DateTime.saturday) {
          //   textColor = Colors.blue; // Saturday blue
          // }
          return Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isToday
                  ? isDarkMode
                        ? Color(0xff1B2A50)
                        : AppColors.primary50
                  : isDarkMode
                  ? AppColors.mainDarkBgColor
                  : AppColors.white,
              border: Border.all(
                color: isDarkMode
                    ? AppColors.grey100Color
                    : AppColors.lightBorderColor,
                width: 1,
              ),
            ),
            child: isToday
                ? InkWell(
                    onTap: () {
                      context.go(
                        '${AppRouteName.classManagementView}/${AppRouteName.todayClassView}',
                        extra: date,
                      );

                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText.medium(
                                date.day.toString(),
                                size: 13,
                                textAlign: TextAlign.left,
                                color: isToday && isDarkMode
                                    ? AppColors.headingsLightColor
                                    : isDarkMode
                                    ? AppColors.bodyTextDarkColor
                                    : AppColors.headingsColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              mobileView
                                  ? SizedBox()
                                  : CommonText.semiBold(
                                      'Today',
                                      size: 13,
                                      textAlign: TextAlign.left,
                                      color: AppColors.lightPrimaryColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ),
                        ),
                        Gap(10),
                        CommonText.medium(
                          '4 Class',
                          size: 12,
                          textAlign: TextAlign.left,
                          color: isToday && isDarkMode
                              ? AppColors.headingsLightColor
                              : isDarkMode
                              ? AppColors.bodyTextDarkColor
                              : AppColors.headingsColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                : Align(
              alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,top: 5),
                    child: CommonText.medium(
                        date.day.toString(),
                        size: 16,
                        textAlign: TextAlign.left,
                        color: mobileView
                            ? isDarkMode
                                  ? AppColors.bodyTextDarkColor
                                  : AppColors.headingsColor
                            : isDarkMode
                            ? AppColors.headingsLightColor
                            : AppColors.headingsColor,
                      ),
                  ),
                ),
            // Text(
            //   date.day.toString(),
            //   style: TextStyle(
            //     color: textColor,
            //     fontWeight: isToday
            //         ? FontWeight.bold
            //         : FontWeight.normal,
            //     fontSize: 14,
            //   ),
            // ),
          );
        },

        headerStyle: CalendarHeaderStyle(
          textStyle: TextStyle(color: Colors.red),
        ),
        onViewChanged: (ViewChangedDetails details) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              controller.currentMonth =
                  details.visibleDates[details.visibleDates.length ~/ 2];
            });
          });
        },
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showTrailingAndLeadingDates: false,
        ),
        viewHeaderStyle: ViewHeaderStyle(
          // backgroundColor: Colors.yellow,
          dateTextStyle: TextStyle(
            color: isDarkMode
                ? AppColors.headingsLightColor
                : AppColors.headingsColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          dayTextStyle: TextStyle(
            color: isDarkMode
                ? AppColors.headingsLightColor
                : AppColors.headingsColor,
            fontSize: 16,
          ),
        ),
        appointmentBuilder: (context, calendarAppointmentDetails) => Container(
          decoration: BoxDecoration(
            // color:AppColors.calenderViewColor,
            color: Colors.yellow,
            border: Border.all(color: AppColors.error500, width: 1.5),
          ),
        ),
        headerDateFormat: 'MMM yyyy', // Month-Year format
      ),
    );
  }

  _upcomingClassView(ClassModel data) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    // var mobileView = ResponsiveView.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkBg2Color : AppColors.lightBgColor,
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(radius: 3, backgroundColor: AppColors.primary500),
              Gap(7),
              CommonText.bold(data.time, size: 13, color: AppColors.primary500),
            ],
          ),
          Gap(12),
          CommonText.regular(data.name, size: 14),
          Gap(10),
          CommonText.regular(
            data.description,
            size: 13,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
        ],
      ),
    );
  }
}
