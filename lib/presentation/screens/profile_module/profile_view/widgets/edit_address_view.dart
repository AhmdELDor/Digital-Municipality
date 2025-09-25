import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/profile_view_controller.dart';

class EditAddressView extends StatefulWidget {
  const EditAddressView({super.key});

  @override
  State<EditAddressView> createState() =>
      _EditAddressViewState();
}

class _EditAddressViewState extends State<EditAddressView> {
  ProfileViewController controller = Get.put(ProfileViewController());
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.semiBold(
                ProfileViewStrings.editAddress,
                size: 18,
              ),
              commonCloseIcon(context),
            ],
          ),
        ),
        CommonDivider(),
        Gap(20),
        SizedBox(
          height: context.height * 0.3,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   commonHeader(ProfileViewStrings.country),
                   Gap(10),
                   Obx(
                         () => AlwaysDownDropdown<String>(
                       color: Colors.transparent,
                       hintText: "Select Country",
                       items: controller.countryList,
                       value: controller.selectedCountry?.value.isEmpty == true
                           ? null
                           : controller.selectedCountry?.value,
                       onChanged: (val) {
                         controller.selectedCountry?.value = val!;
                         controller.updateCities(val!);
                       },
                     ),
                   ),
                   Gap(20),
                   commonHeader(ProfileViewStrings.city),
                   Gap(10),
                   Obx(
                         () => AlwaysDownDropdown<String>(

                       color: Colors.transparent,
                       hintText: controller.selectedCountry?.value.isEmpty == true
                           ? "Select Country first"
                           : "Select City",
                       items: controller.cityList,
                       value: controller.selectedCity?.value.isEmpty == true
                           ? null
                           : controller.selectedCity?.value,
                             onChanged: (val) {
                               if (controller.selectedCountry?.value.isNotEmpty == true) {
                                 controller.selectedCity?.value = val!;
                               }
                             },



                     ),
                   ),
                   Gap(20),
                   commonHeader(ProfileViewStrings.postalCode),
                   Gap(10),
                   CommonTextField(
                     hintText: ProfileViewStrings.postalCode,
                     controller: controller.postalCodeController,
                     textInputAction: TextInputAction.next,
                     validator: (value) {
                       return validateEmptyValue(value, 'Postal Code is Required');
                     },
                     keyboardType: TextInputType.number,
                   ),
                 ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Row(
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: UserManagementStrings.update,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
