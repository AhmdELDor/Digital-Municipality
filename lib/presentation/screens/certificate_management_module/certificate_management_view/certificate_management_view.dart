part of 'certificate_management_view_imports.dart';

class CertificateManagementView extends StatefulWidget {
  const CertificateManagementView({super.key});

  @override
  State<CertificateManagementView> createState() =>
      _CertificateManagementViewState();
}

class _CertificateManagementViewState extends State<CertificateManagementView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CertificateManagementViewController controller = Get.put(
    CertificateManagementViewController(),
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
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    commonHeaderText(
                      title: CertificateManagementStrings.certificateManagement,
                    ),
                    CommonCircleAddButton(
                      onTap: () {
                        commonDialogBox(
                          context: context,
                          child: SizedBox(width: mobileView?null:560, child: AddCertificateView()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              CommonDivider(),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDarkMode?AppColors.grey100Color:AppColors.lightBorderColor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        CommonImageAssets.certificateImg,
                        height: mobileView?null:255,
                        width: mobileView?null:361,
                      ),
                      Positioned(
                        top: 10,
                          right: 10,
                          child: menuButton())
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.lightBorderColor),
        ),
        child: Center(
          child: SvgImageFromAsset(
            AppCommonIcon.moreIcon,
            colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
