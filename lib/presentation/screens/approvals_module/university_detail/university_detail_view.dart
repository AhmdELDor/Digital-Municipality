part of 'university_detail_imports.dart';

class UniversityDetailView extends StatefulWidget {
  const UniversityDetailView({super.key});

  @override
  State<UniversityDetailView> createState() => _UniversityDetailViewState();
}

class _UniversityDetailViewState extends State<UniversityDetailView> {
  UniversityDetailController controller = Get.put(UniversityDetailController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final instructorData = GoRouterState.of(context).extra as UniversityModel;
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
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CommonSearchField(
                        controller: controller.searchController,
                        hintText: DashboardViewStrings.searchAnything,
                      ),
                    )
                  : SizedBox(),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonText.semiBold(
                            UniversityDialogStrings.universityApprovals,
                            size: mobileView ? 15 : 17,
                            fontWeight: mobileView
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: mobileView ? 72 : 120,
                          child: PrimaryButton(
                            height: mobileView ? 32 : 36,
                            backgroundColor: AppColors.error500,
                            onPressed: () {
                              commonDialogBox(
                                context: context,
                                child: SizedBox(
                                  width: 560,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    child: FeedBackInstructorDialog(
                                      title: UniversityDialogStrings
                                          .feedBackToUniversity,
                                      hintText: UniversityDialogStrings
                                          .feedBackToUniversityHint,
                                      feedbackController:
                                          controller.feedbackController,
                                      formKey: controller.formKey,

                                      onPressed: () {
                                        final isValid = controller
                                            .formKey
                                            .currentState!
                                            .validate();
                                        FocusScope.of(context).unfocus();

                                        if (!isValid) return;

                                        controller.formKey.currentState!.save();
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                        commonDialogBox(
                                          context: context,
                                          child: SizedBox(
                                            width: 560,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20,
                                                  ),
                                              child: CourseApproveDialog(
                                                image: CommonImageAssets
                                                    .courseDecline,
                                                title: UniversityDialogStrings
                                                    .universityDeclined,
                                                subtitle:
                                                    UniversityDialogStrings
                                                        .universityDeclinedDes,
                                                buttonName:
                                                    UniversityDialogStrings
                                                        .goToUniversity,
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).pop();
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            label: ApprovalsStrings.decline,
                            textSize: mobileView ? 14 : 16,
                            textWeight: FontWeight.w400,
                          ),
                        ),
                        Gap(10),
                        SizedBox(
                          width: mobileView ? 77 : 120,
                          child: PrimaryButton(
                            height: mobileView ? 32 : 36,
                            backgroundColor: AppColors.success500,
                            onPressed: () {
                              commonDialogBox(
                                context: context,
                                child: SizedBox(
                                  width: 560,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                    child: CourseApproveDialog(
                                      image: CommonImageAssets.courseApprove,
                                      title: UniversityDialogStrings
                                          .universityApproved,
                                      subtitle: UniversityDialogStrings
                                          .universityApprovedDes,
                                      buttonName: UniversityDialogStrings
                                          .goToUniversity,
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            label: ApprovalsStrings.approve,
                            textSize: mobileView ? 14 : 16,
                            textWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  CommonDivider(),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ResponsiveGridRow(
                  children: [
                    ResponsiveGridCol(
                      lg: 9,
                      xs: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: mobileView ? 0 : 15,
                          vertical: 15,
                        ),
                        decoration: mobileView
                            ? BoxDecoration()
                            : BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.mainDarkBgColor
                                    : AppColors.lightBgColor,
                                border: Border.all(
                                  color: isDarkMode
                                      ? AppColors.grey100Color
                                      : AppColors.lightBorderColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  isDarkMode
                                      ? BoxShadow()
                                      : BoxShadow(
                                          color: AppColors.primary100
                                              .withValues(alpha: 0.35),
                                          offset: Offset(2, 2),
                                          blurRadius: 20,
                                          spreadRadius: 1,
                                        ),
                                ],
                              ),
                        child: Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary500,
                                      AppColors.brand600,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    commonCacheImage(
                                      controller.data.value.image,
                                      ImagePlaceHolder.imagePlaceHolderDark,
                                      height: 100,
                                      width: 100,
                                    ),
                                    Gap(20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText.semiBold(
                                          instructorData.name,
                                          size: 20,
                                          color: AppColors.white,
                                        ),
                                        Gap(12),
                                        CommonText.regular(
                                          controller.data.value.email,
                                          size: 15,
                                          color: AppColors.white,
                                        ),
                                        Gap(12),

                                        CommonText.regular(
                                          controller.data.value.phoneNo,
                                          size: 15,
                                          color: AppColors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Gap(20),
                              userDetailView(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonLeadingText(String leading) {
    return SizedBox(
      width: 240,
      child: CommonText.regular(
        leading,
        size: 15,
        color: AppColors.bodyTextColor,
      ),
    );
  }

  Widget _commonTrailingText(
    String trailing,
    void Function()? onTap,
    TextDecoration? decoration,
  ) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return InkWell(
      onTap: onTap,
      child: CommonText.medium(
        trailing,
        size: 16,
        decoration: decoration,
        decorationColor: isDarkMode ? AppColors.white : AppColors.headingsColor,
      ),
    );
  }

  _verifyButton() {
    return CommonText.medium(
      AppCommonStrings.btnVerify,
      size: 14,
      color: AppColors.primary500,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.primary500,
    );
  }

  deskTopCommonTextView({
    required String leading,
    required String trailing,
    bool showVerifyButton = false,
    void Function()? onTap,
    TextDecoration? decoration,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          _commonLeadingText(leading),
          Expanded(child: _commonTrailingText(trailing, onTap, decoration)),
          showVerifyButton ? _verifyButton() : SizedBox(),
        ],
      ),
    );
  }

  deviceCommonTextView({
    required String leading,
    required String trailing,
    bool showVerifyButton = false,
    void Function()? onTap,
    TextDecoration? decoration,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commonLeadingText(leading),
          Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _commonTrailingText(trailing, onTap, decoration),
              showVerifyButton ? _verifyButton() : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  userDetailView() {
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mobileView
            ? deviceCommonTextView(
                leading: InstructorDetailViewStrings.emailId,
                trailing: controller.data.value.email,
                showVerifyButton: true,
              )
            : deskTopCommonTextView(
                leading: InstructorDetailViewStrings.emailId,
                trailing: controller.data.value.email,
                showVerifyButton: true,
              ),

        CommonDivider(),

        mobileView
            ? deviceCommonTextView(
                leading: InstructorDetailViewStrings.mobileNo,
                trailing: controller.data.value.phoneNo,
                showVerifyButton: true,
              )
            : deskTopCommonTextView(
                leading: InstructorDetailViewStrings.mobileNo,
                trailing: controller.data.value.phoneNo,
                showVerifyButton: true,
              ),

        CommonDivider(),

        mobileView
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _commonLeadingText(InstructorDetailViewStrings.about),
                    Gap(12),
                    CommonText.regular(controller.data.value.about, size: 15),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _commonLeadingText(InstructorDetailViewStrings.about),

                    Expanded(
                      child: CommonText.regular(
                        controller.data.value.about,
                        size: 15,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

        CommonDivider(),

        mobileView
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _commonLeadingText(
                      InstructorDetailViewStrings.identityProof,
                    ),
                    Gap(12),
                    Row(
                      children: [
                        CommonText.medium(
                          controller.data.value.identityProf,
                          size: 16,
                        ),
                        Gap(20),
                        SvgImageFromAsset(CommonImageAssets.pdf),
                        Gap(3),
                        Expanded(
                          child: CommonText.regular(
                            'Drivinglicence.pdf',
                            size: 14,
                            color: AppColors.bodyTextColor,
                          ),
                        ),
                        SvgImageFromAsset(AppCommonIcon.downloadIcon),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    _commonLeadingText(
                      UniversityDialogStrings.courseCompletionCertificate,
                    ),
                    Expanded(
                      child: CommonText.medium(
                        controller.data.value.courseCompletionCertificateProf,
                        size: 16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(20),
                    SvgImageFromAsset(CommonImageAssets.pdf),
                    Gap(3),
                    Expanded(
                      child: CommonText.regular(
                        'Completioncertificate.pdf',
                        size: 14,
                        color: AppColors.bodyTextColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SvgImageFromAsset(AppCommonIcon.downloadIcon),
                  ],
                ),
              ),

        CommonDivider(),

        mobileView
            ? deviceCommonTextView(
                leading: InstructorDetailViewStrings.instagramAccount,
                trailing: controller.data.value.instagramAccount,
                showVerifyButton: false,
                decoration: TextDecoration.underline,
                onTap: () {
                  _launchURL(controller.data.value.instagramAccount);
                },
              )
            : deskTopCommonTextView(
                leading: InstructorDetailViewStrings.instagramAccount,
                trailing: controller.data.value.instagramAccount,
                showVerifyButton: false,
                decoration: TextDecoration.underline,
                onTap: () {
                  _launchURL(controller.data.value.instagramAccount);
                },
              ),

        CommonDivider(),

        mobileView
            ? deviceCommonTextView(
                leading: InstructorDetailViewStrings.facebookAccount,
                trailing: controller.data.value.faceBookAccount,
                showVerifyButton: false,
                decoration: TextDecoration.underline,
                onTap: () {

                  _launchURL(controller.data.value.faceBookAccount);
                },
              )
            : deskTopCommonTextView(
                leading: InstructorDetailViewStrings.facebookAccount,
                trailing: controller.data.value.faceBookAccount,
                showVerifyButton: false,
                decoration: TextDecoration.underline,
                onTap: () {
                  _launchURL(controller.data.value.faceBookAccount);
                },
              ),

        CommonDivider(),

        mobileView
            ? deviceCommonTextView(
                leading: InstructorDetailViewStrings.youTubeChannel,
                trailing: controller.data.value.youTubeChannel,
                showVerifyButton: false,
                decoration: TextDecoration.underline,
                onTap: () {
                  _launchURL(controller.data.value.youTubeChannel);
                },
              )
            : deskTopCommonTextView(
                leading: InstructorDetailViewStrings.youTubeChannel,
                trailing: controller.data.value.youTubeChannel,
                showVerifyButton: false,
                decoration: TextDecoration.underline,
                onTap: () {
                  _launchURL(controller.data.value.youTubeChannel);
                },
              ),

        CommonDivider(),

        mobileView
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _commonLeadingText(
                      InstructorDetailViewStrings.identityProof,
                    ),
                    Gap(12),
                    Row(
                      children: [
                        CommonText.medium(
                          controller.data.value.identityProf,
                          size: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(20),
                        SvgImageFromAsset(CommonImageAssets.pdf),
                        Gap(3),
                        Expanded(
                          child: CommonText.regular(
                            'Drivinglicence.pdf',
                            size: 14,
                            color: AppColors.bodyTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SvgImageFromAsset(AppCommonIcon.downloadIcon),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    _commonLeadingText(
                      InstructorDetailViewStrings.identityProof,
                    ),
                    Expanded(
                      child: CommonText.medium(
                        controller.data.value.identityProf,
                        size: 16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(20),
                    SvgImageFromAsset(CommonImageAssets.pdf),
                    Gap(3),
                    Expanded(
                      child: CommonText.regular(
                        'Drivinglicence.pdf',
                        size: 14,
                        color: AppColors.bodyTextColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SvgImageFromAsset(AppCommonIcon.downloadIcon),
                  ],
                ),
              ),

        CommonDivider(),

        mobileView
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _commonLeadingText(
                      InstructorDetailViewStrings.qualificationProof,
                    ),
                    Gap(12),
                    Row(
                      children: [
                        CommonText.medium(
                          controller.data.value.qualificationProf,
                          size: 16,
                        ),
                        Gap(20),
                        SvgImageFromAsset(CommonImageAssets.pdf),
                        Gap(3),
                        Expanded(
                          child: CommonText.regular(
                            'Universitydegree.pdf',
                            size: 14,
                            color: AppColors.bodyTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SvgImageFromAsset(AppCommonIcon.downloadIcon),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    _commonLeadingText(
                      InstructorDetailViewStrings.qualificationProof,
                    ),

                    Expanded(
                      child: CommonText.medium(
                        controller.data.value.qualificationProf,
                        size: 16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(20),
                    SvgImageFromAsset(CommonImageAssets.pdf),
                    Gap(3),
                    Expanded(
                      child: CommonText.regular(
                        'Universitydegree.pdf',
                        size: 14,
                        color: AppColors.bodyTextColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SvgImageFromAsset(AppCommonIcon.downloadIcon),
                  ],
                ),
              ),
      ],
    );
  }

  _launchURL(String urlData) async {
    final url = urlData;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
