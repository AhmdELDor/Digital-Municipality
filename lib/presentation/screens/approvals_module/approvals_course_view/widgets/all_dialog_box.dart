import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';

class CourseApproveDialog extends StatefulWidget {
  final String image, title, subtitle, buttonName;
  final  void Function()? onPressed;
  const CourseApproveDialog({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonName, this.onPressed,
  });

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
              child: commonCloseIcon(context)
            ),
            Gap(20),
            SvgImageFromAsset(widget.image, height: 80, width: 80),
            Gap(20),
            CommonText.medium(
              widget.title,
              size: 18,
            ),
            Gap(15),
            CommonText.regular(
              widget.subtitle,
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
                    onPressed: widget.onPressed,
                    label:  widget.buttonName,
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

// class CourseDeclineDialog extends StatefulWidget {
//   const CourseDeclineDialog({super.key});
//
//   @override
//   State<CourseDeclineDialog> createState() => _CourseDeclineDialogState();
// }
//
// class _CourseDeclineDialogState extends State<CourseDeclineDialog> {
//   final formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
//     return SingleChildScrollView(
//       child: Form(
//         key: formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: SvgImageFromAsset(AppCommonIcon.closeIcon),
//               ),
//             ),
//             Gap(20),
//             Image.asset(
//               CommonImageAssets.courseDecline,
//               height: 125,
//               width: 125,
//             ),
//             Gap(20),
//             CommonText.medium(
//               CourseApproveDialogStrings.courseDeclined,
//               size: 18,
//             ),
//             Gap(15),
//             CommonText.regular(
//               CourseApproveDialogStrings.courseDeclinedDes,
//               size: 15,
//               textAlign: TextAlign.center,
//               color: isDarkMode
//                   ? AppColors.bodyTextDarkColor
//                   : AppColors.bodyTextColor,
//             ),
//             Gap(25),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlineButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     label: AppCommonStrings.btnCancel,
//                     borderSide: BorderSide(color: AppColors.primary500),
//                     textColor: AppColors.primary500,
//                     textSize: 16,
//                     textWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Gap(15),
//                 Expanded(
//                   child: PrimaryButton(
//                     onPressed: () {},
//                     label: CourseApproveDialogStrings.goToCourse,
//                     textSize: 16,
//                     textWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FeedBackInstructorDialog extends StatefulWidget {
  final TextEditingController feedbackController;
  final void Function()? onPressed;
  final Key? formKey;
  final String? title,hintText;
  const FeedBackInstructorDialog({super.key, required this.feedbackController, this.onPressed, this.formKey, this.hintText, this.title});

  @override
  State<FeedBackInstructorDialog> createState() =>
      _FeedBackInstructorDialogState();
}

class _FeedBackInstructorDialogState extends State<FeedBackInstructorDialog> {
  //final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.semiBold(
                 widget.title?? CourseApproveDialogStrings.feedbackToInstructor,
                  size: 18,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgImageFromAsset(AppCommonIcon.closeIcon),
                ),
              ],
            ),
            Gap(15),
            CommonDivider(),
            Gap(15),
            CommonText.regular(CourseApproveDialogStrings.feedback, size: 14),
            Gap(10),
            CommonTextField(
              hintText: widget.hintText??CourseApproveDialogStrings.feedbackDes,
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
                    onPressed: widget.onPressed,
                    // onPressed: () {
                    //   final isValid = formKey.currentState!.validate();
                    //   Get.focusScope!.unfocus();
                    //
                    //   if (!isValid) return;
                    //
                    //   formKey.currentState!.save();
                    //
                    //   Navigator.pop(context);
                    // },
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
