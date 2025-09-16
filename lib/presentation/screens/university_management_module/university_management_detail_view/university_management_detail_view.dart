part of 'university_management_detail_imports.dart';

class UniversityManagementDetailView extends StatefulWidget {
  const UniversityManagementDetailView({super.key});

  @override
  State<UniversityManagementDetailView> createState() =>
      _UniversityManagementDetailViewState();
}

class _UniversityManagementDetailViewState
    extends State<UniversityManagementDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UniversityManagementDetailController controller = Get.put(
    UniversityManagementDetailController(),
  );
  @override
  Widget build(BuildContext context) {
    final universityDetail = GoRouterState.of(context).extra as UniversityModel;
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonHeaderText(title: universityDetail.name),
                    CommonCircleAddButton(
                      onTap: () {
                        commonDialogBox(
                          context: context,
                          child: SizedBox(
                            width: 560,
                            child: AddDetailView(
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
                                Navigator.of(context, rootNavigator: true).pop();

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
                                      buttonBackgroundColor: AppColors.primary500,
                                      buttonName:
                                          InviteSendStrings.backToDashboard,
                                      onPressed: () {
                                        Navigator.pop(context);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Obx(
                  () =>  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: commonCacheImage(
                              controller.data.value.image,
                              ImagePlaceHolder.imagePlaceHolderDark,
                              height: mobileView ? 160 : 200,
                              width: double.infinity,
                            ),
                          ),
                          CommonText.semiBold(
                            universityDetail.name,
                            size: mobileView ? 24 : 40,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                      Gap(20),
                     mobileView? CommonText.regular(
                        UniversityDialogStrings.courseCompletionCertificate,
                        size: 15,

                      ):SizedBox(),
                      Gap(mobileView?15:0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.mainDarkBgColor
                              : AppColors.lightBgColor,
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.grey100Color
                                : AppColors.headingsLightColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            mobileView?SizedBox():
                            Expanded(
                              child: CommonText.regular(
                                UniversityDialogStrings.courseCompletionCertificate,
                                size: 16,

                              ),
                            ),

                          
                            SvgImageFromAsset(CommonImageAssets.pdf),
                            Gap(12),
                            CommonText.regular(
                              controller.data.value.courseCertificate,
                              size: 16,
                              color: isDarkMode
                                  ? AppColors.bodyTextDarkColor
                                  : AppColors.headingsColor,
                            ),
                            mobileView?Spacer():Gap(40),
                            SvgImageFromAsset(AppCommonIcon.downloadIcon),
                          ],
                        ),
                      ),
                      Gap(20),
                      CommonText.medium(
                        'University Courses (${controller.data.value.coursesList.length})',
                        size: 17,
                        color: isDarkMode
                            ? AppColors.headingsLightColor
                            : AppColors.headingsColor,
                      ),
                      Gap(20),
                      ListView.builder(
                        itemCount: controller.data.value.coursesList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = controller.data.value.coursesList[index];
                          return InkWell(
                            onTap: () {
                              // context.go(
                              //   '${AppRouteName.instructorManagementView}/${AppRouteName.instructorManagementDetailView}',
                              //   extra: {'data': data},
                              // );
                            },
                            child: CommonCourseView(
                              course: data,
                              differentView: true,
                              viewCourseOnTap: () {
                                // context.go(
                                //   '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                                //   extra: {'data': data, 'title': 'view'},
                                // );
                              },
                              declinedOnTap: () {

                              },
                              deleteOnTap: () {

                              },
                              editViewCourseOnTap: () {
                                context.go(
                                  '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
                                  extra: {'data': data, 'title': 'view'},
                                );
                              },
                            ),
                          );
                        },
                      ),
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
}
