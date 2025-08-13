import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/app_route.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';

class CourseApproveDialog extends StatefulWidget {
  const CourseApproveDialog({super.key});

  @override
  State<CourseApproveDialog> createState() => _CourseApproveDialogState();
}

class _CourseApproveDialogState extends State<CourseApproveDialog> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgImageFromAsset(AppCommonIcon.closeIcon),
              ),
            ),
            Gap(20),
            Image.asset(
              CommonImageAssets.courseApprove,
              height: 125,
              width: 125,
            ),
            Gap(20),
            CommonText.medium(
              CourseApproveDialogStrings.courseApproved,
              size: 18,
            ),
            Gap(15),
            CommonText.regular(
              CourseApproveDialogStrings.courseApprovedDes,
              size: 15,
              textAlign: TextAlign.center,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
            Gap(25),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: AppCommonStrings.btnCancel,
                    borderSide: BorderSide(color: AppColors.primary500),
                    textColor: AppColors.primary500,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
                Gap(15),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {},
                    label: CourseApproveDialogStrings.goToCourse,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDeclineDialog extends StatefulWidget {
  const CourseDeclineDialog({super.key});

  @override
  State<CourseDeclineDialog> createState() => _CourseDeclineDialogState();
}

class _CourseDeclineDialogState extends State<CourseDeclineDialog> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgImageFromAsset(AppCommonIcon.closeIcon),
              ),
            ),
            Gap(20),
            Image.asset(
              CommonImageAssets.courseDecline,
              height: 125,
              width: 125,
            ),
            Gap(20),
            CommonText.medium(
              CourseApproveDialogStrings.courseDeclined,
              size: 18,
            ),
            Gap(15),
            CommonText.regular(
              CourseApproveDialogStrings.courseDeclinedDes,
              size: 15,
              textAlign: TextAlign.center,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
            Gap(25),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: AppCommonStrings.btnCancel,
                    borderSide: BorderSide(color: AppColors.primary500),
                    textColor: AppColors.primary500,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
                Gap(15),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {},
                    label: CourseApproveDialogStrings.goToCourse,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class FeedBackInstructorDialog extends StatefulWidget {
  final TextEditingController feedbackController;
  const FeedBackInstructorDialog({super.key, required this.feedbackController});

  @override
  State<FeedBackInstructorDialog> createState() => _FeedBackInstructorDialogState();
}

class _FeedBackInstructorDialogState extends State<FeedBackInstructorDialog> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.semiBold(CourseApproveDialogStrings.feedbackToInstructor, size: 18),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgImageFromAsset(AppCommonIcon.clockIcon),
                ),
              ],
            ),
            Gap(15),
            CommonDivider(),
            Gap(15),
            CommonText.regular(CourseApproveDialogStrings.feedback, size: 14),
            Gap(10),
            CommonTextField(
              hintText: CourseApproveDialogStrings.feedbackDes,
              controller: widget.feedbackController,
              textInputAction: TextInputAction.next,
              maxLines: 4,
              validator: (value) {
                return validateEmptyValue(value, 'Please Enter Feedback');
              },
            ),


            Gap(25),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: AppCommonStrings.btnCancel,
                    borderSide: BorderSide(color: AppColors.primary500),
                    textColor: AppColors.primary500,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
                Gap(20),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();
                      Get.focusScope!.unfocus();

                      if (!isValid) return;

                      formKey.currentState!.save();

                      Navigator.pop(context);
                    },
                    label: CourseApproveDialogStrings.continueAndDecline,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


