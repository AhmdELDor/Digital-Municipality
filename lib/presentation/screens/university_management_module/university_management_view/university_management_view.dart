part of 'university_management_imports.dart';

class UniversityManagementView extends StatefulWidget {
  const UniversityManagementView({super.key});

  @override
  State<UniversityManagementView> createState() =>
      _UniversityManagementViewState();
}

class _UniversityManagementViewState extends State<UniversityManagementView> {
  UniversityManagementViewController controller = Get.put(
    UniversityManagementViewController(),
  );
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonHeaderText(
                      title: UniversityViewStrings.universityManagement,
                    ),
                    CommonCircleAddButton(
                      onTap: () {
                        commonDialogBox(
                          context: context,
                          child: SizedBox(
                            width: 560,
                            child: AddUniversityView(
                              title: UniversityViewStrings.addUniversity,
                              nameController: controller.nameController,
                              emailController: controller.emailController,
                              formKey: controller.formKey,
                              onPressed: () {
                                final isValid = controller.formKey.currentState!
                                    .validate();
                                FocusScope.of(
                                  context,
                                ).unfocus(); // ✅ safer than Get.focusScope

                                if (!isValid) return;

                                controller.formKey.currentState!.save();
                                // ✅ Close previous dialog safely
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();

                                commonDialogBox(
                                  context: context,
                                  child: SizedBox(
                                    width: 560,
                                    child: CommonDialogView(
                                      image: CommonImageAssets.inviteSent,
                                      title: UniversityInviteSentStrings
                                          .invitationSent,
                                      subtitle: UniversityInviteSentStrings
                                          .invitationSentDes,
                                      buttonBackgroundColor:
                                          AppColors.primary500,
                                      buttonName:
                                          InviteSendStrings.backToDashboard,
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              CommonDivider(),
              Gap(20),
              Obx(
                () => controller.universityList.isEmpty
                    ? Center(child: CommonNoResultFound())
                    : Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: ResponsiveGridRow(
                          children: List.generate(
                            controller.universityList.length,
                            (index) {
                              final data = controller.universityList[index];
                              return ResponsiveGridCol(
                                lg: 3,
                                xs: 12,
                                child: universityView(data, index),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget universityView(UniversityModel data, int index) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsetsGeometry.only(right: 20, bottom: mobileView ? 20 : 0),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.mainDarkBgColor
            : AppColors.lightBorderColor,
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          isDarkMode
              ? BoxShadow()
              : BoxShadow(
                  color: AppColors.primary100.withValues(alpha: 0.35),
                  offset: Offset(2, 2),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: commonCacheImage(
                  data.image,
                  ImagePlaceHolder.imagePlaceHolderDark,
                  height: 140,
                  width: double.infinity,
                ),
              ),
              Positioned(top: 10, right: 10, child: menuButton(data, index)),
            ],
          ),
          Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: CommonText.medium(data.name, size: 15)),
              SvgImageFromAsset(AppCommonIcon.starIcon),
              Gap(7),
              CommonText.semiBold(
                data.rate.toString(),
                size: 16,
                color: AppColors.secondary500,
              ),
            ],
          ),
          Gap(12),
          CommonText.regular(
            data.about,
            size: 15,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
        ],
      ),
    );
  }

  menuButton(UniversityModel data, int index) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      position: PopupMenuPosition.under,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.02),
          border: Border.all(color: AppColors.lightBorderColor, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: SvgImageFromAsset(
          AppCommonIcon.moreIcon,
          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            context.go(
              '${AppRouteName.universityManagementView}/${AppRouteName.universityManagementDetailView}',
              extra: data,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.showPasswordIcon,
              UniversityViewStrings.viewUniversity,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                width: 560,
                child: CommonDialogView(
                  image: CommonImageAssets.deActiveSecurity,
                  title:
                      UniversityDeActiveStrings.universityAccountDeactivation,
                  subtitle: UniversityDeActiveStrings
                      .universityAccountDeactivationDes,
                  buttonBackgroundColor: AppColors.warning500,
                  buttonName: DeActiveStrings.deactivate,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              CommonImageAssets.deActive,
              InstructorManagementStrings.deactive,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                width: 560,
                child: CommonDialogView(
                  image: CommonImageAssets.suspendImg,
                  title: UniversitySuspensionStrings.universitySuspension,
                  subtitle: UniversitySuspensionStrings.universitySuspensionDes,
                  buttonBackgroundColor: AppColors.error500,
                  buttonName: SuspendStrings.suspend,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              CommonImageAssets.suspend,
              InstructorManagementStrings.suspend,
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
                  tittle: CourseApproveDialogStrings.deleteUniversity,
                  subtitle: CourseApproveDialogStrings.deleteUniversityDes,
                  doneOnPressed: () {
                    //Navigator.pop(context); // close dialog

                    if (index < controller.universityList.length) {
                      controller.universityList.removeAt(index);
                      controller.universityList
                          .refresh(); // ✅ refresh reactive state
                    }
                    Navigator.of(context, rootNavigator: true).pop();

                    showSuccessMessage(
                      context: context,
                      title: 'University Deleted Successfully',
                      content: '',
                    );
                  },
                ),
              ),
            );
          },
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
}
