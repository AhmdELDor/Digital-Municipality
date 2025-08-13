part of 'instructor_detail_imports.dart';

class InstructorDetailView extends StatefulWidget {
  const InstructorDetailView({super.key});

  @override
  State<InstructorDetailView> createState() => _InstructorDetailViewState();
}

class _InstructorDetailViewState extends State<InstructorDetailView> {
  InstructorDetailController controller = Get.put(InstructorDetailController());
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CommonText.semiBold(
                      InstructorDetailViewStrings.instructorApprovals,
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
                      onPressed: () {},
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
                      onPressed: () {},
                      label: ApprovalsStrings.decline,
                      textSize: mobileView ? 14 : 16,
                      textWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightBgColor,
                border: Border.all(color: AppColors.lightBorderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary100.withValues(alpha: 0.35),
                    offset: Offset(2, 2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15

                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [AppColors.primary500, AppColors.brand600],
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText.semiBold(
                              controller.data.value.name,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _commonLeadingText(String leading){
    return CommonText.regular(leading,size: 15,color: AppColors.bodyTextColor,);
  }
  _commonTrailingText(String trailing){
    return CommonText.medium(trailing,size: 16,);
  }
_verifyButton(){
    return CommonText.medium(AppCommonStrings.btnVerify,size: 14,color: AppColors.primary500,);
}
  deskTopCommonView({required String leading, required String trailing, bool showVerifyButton = false}){
    return Row(
      children: [
        _commonLeadingText(leading),
        _commonLeadingText(trailing),
        showVerifyButton?_verifyButton():SizedBox()

      ],
    );
  }

}
