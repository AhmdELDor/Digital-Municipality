import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/user_management_controller.dart';

class AddRoleView extends StatefulWidget {
  const AddRoleView({super.key});

  @override
  State<AddRoleView> createState() => _AddRoleViewState();
}

class _AddRoleViewState extends State<AddRoleView> {
  UserManagementController controller = Get.put(UserManagementController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText.semiBold(
                        UserManagementStrings.addRole,
                        size: 18,
                      ),
                      commonCloseIcon(context),
                    ],
                  ),
                ),

                CommonDivider(),
                Gap(25),

                // Role input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      commonHeader(UserManagementStrings.role),
                      Gap(10),
                      CommonTextField(
                        labelText: UserManagementStrings.enterRollName,
                        controller: controller.roleController,
                        textInputAction: TextInputAction.next,
                        hintText: UserManagementStrings.enterRollName,
                        validator: (value) {
                          return validateEmptyValue(
                            value,
                            'Role name is Required',
                          );
                        },
                      ),
                      Gap(15),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: TableBorder.all(
                                borderRadius: BorderRadius.circular(12),
                                color: isDarkMode?AppColors.grey100Color:AppColors.headingsLightColor,
                                width: 1,
                              ),
                              
                              columnSpacing: 30,
                              columns: [
                                DataColumn(
                                  label: commonTitleText(
                                    UserManagementStrings.permissions,
                                  ),
                                ),
                                DataColumn(
                                  label: commonTitleText(
                                    UserManagementStrings.create,
                                  ),
                                ),
                                DataColumn(
                                  label: commonTitleText(
                                    UserManagementStrings.read,
                                  ),
                                ),
                                DataColumn(
                                  label: commonTitleText(
                                    UserManagementStrings.update,
                                  ),
                                ),
                                DataColumn(
                                  label: commonTitleText(
                                    UserManagementStrings.delete,
                                  ),
                                ),
                              ],
                              // decoration: BoxDecoration(
                              //   color: Colors.yellow
                              // ),
                              headingRowHeight: 36,
                              headingRowColor: WidgetStateColor.resolveWith((states) => isDarkMode?AppColors.mainDarkBgColor:AppColors.lightBgColor,),
                              rows: controller.permissions.map((p) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      CommonText.regular(
                                        p,
                                        size: 15,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                    ),
                                    ...["create", "read", "update", "delete"].map((
                                      action,
                                    ) {
                                      return DataCell(
                                        Checkbox(
                                          value: controller
                                              .permissionMatrix[p]![action],
                                          onChanged: (val) {
                                            controller.togglePermission(
                                              p,
                                              action,
                                              val ?? false,
                                            );
                                          },
                                          checkColor: AppColors.white,
                                          activeColor: AppColors.primary500,
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }).toList(),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
              Gap(20),
              Expanded(
                child: PrimaryButton(
                  onPressed: () {
                    controller.saveRole(context);
                  },
                  label: UserManagementStrings.addRole,
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

  Widget commonTitleText(String title) {
    return CommonText.regular(title, size: 14);
  }
}
