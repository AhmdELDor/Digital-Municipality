import 'package:education_admin_portal/presentation/screens/user_management_module/user_management_view/widgets/add_user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/common_text_view/common_header_text.dart';
import '../../../common_widgets/input_field/common_search_field.dart';
import '../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../common_widgets/view_common_widget/common_circle_add_button.dart';
import '../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../common_widgets/view_common_widget/custom_app_bar.dart';
import '../../../common_widgets/widgets/common_cache_image.dart';
import '../../../common_widgets/widgets/common_divider.dart';
import '../../../common_widgets/widgets/text.dart';
import '../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../../side_drawer_module/side_drawer_menu/side_drawer_imports.dart';
import 'controller/user_management_controller.dart';
import 'model/users_model.dart';
import 'widgets/edit_user_view.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  UserManagementController controller = Get.put(UserManagementController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller.fetchUsersFromApi();
  }

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
          mainAxisAlignment: MainAxisAlignment.start,
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
                  CommonText.semiBold(
                    UserManagementStrings.userManagement,
                    size: 18,
                  ),
                  CommonCircleAddButton(
                    onTap: () {
                      commonDialogBox(
                        context: context,
                        child: SizedBox(
                          width: mobileView ? null : 560,
                          child: AddUserView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            CommonDivider(),
            Gap(15),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshUsers();
                },
                child: SingleChildScrollView(
                  child: manageUsersList(mobileView, isDarkMode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget manageUsersList(bool mobileView, isDarkMode) {
    return Obx(() {
      if (controller.isLoading.value && controller.usersList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty && controller.usersList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: CommonText.regular(
              controller.errorMessage.value,
              color: AppColors.error500,
            ),
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: ResponsiveGridRow(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(controller.usersList.length, (index) {
                final data = controller.usersList[index];
                return ResponsiveGridCol(
                  lg: 3,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20),
                    decoration: commonCardDecoration(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Name initials avatar
                              Container(
                                height: mobileView ? 35 : 42,
                                width: mobileView ? 35 : 42,
                                decoration: BoxDecoration(
                                  color: _getAvatarColor(index),
                                  borderRadius: BorderRadius.circular(
                                    mobileView ? 17.5 : 21,
                                  ),
                                ),
                                child: Center(
                                  child: CommonText.semiBold(
                                    data.initials,
                                    size: mobileView ? 14 : 18,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              Gap(8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CommonText.medium(
                                      data.name,
                                      size: mobileView ? 13 : 14,
                                    ),
                                    Gap(3),
                                    CommonText.regular(
                                      data.phonenumber,
                                      size: mobileView ? 12 : 13,
                                      color: isDarkMode
                                          ? AppColors.bodyTextDarkColor
                                          : AppColors.bodyTextColor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(mobileView ? 20 : 0),
                              menuButton(data),
                            ],
                          ),
                        ),

                        CommonDivider(height: 1.5),
                        Gap(10),
                        commonLeadingTrailingView(
                          UserManagementStrings.role,
                          data.role,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CommonDivider(),
                        ),
                        commonLeadingTrailingView(
                          UserManagementStrings.dateCreated,
                          data.formattedDate,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CommonDivider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CommonText.regular(
                                  'العنوان',
                                  size: 13,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Gap(10),
                              Expanded(
                                flex: 2,
                                child: CommonText.regular(
                                  data.address,
                                  size: 13,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CommonDivider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CommonText.regular(
                                  UserManagementStrings.active,
                                  size: 13,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Obx(
                                () => commonSwitch(
                                  value: data.isActive.value,
                                  onChanged: (value) {
                                    data.isActive.value = value;
                                    // TODO: Add API call to update status when backend supports it
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          // Pagination controls
          Obx(() {
            if (controller.paginationMeta.value == null) {
              return SizedBox();
            }

            final meta = controller.paginationMeta.value!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: meta.isFirstPage
                        ? null
                        : () => controller.loadPreviousPage(),
                    icon: Icon(Icons.arrow_back),
                    label: CommonText.medium('السابق', color: AppColors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      disabledBackgroundColor: AppColors.grey100Color,
                    ),
                  ),
                  Gap(20),
                  CommonText.medium(
                    'الصفحة ${controller.currentPage.value} من ${meta.lastPage}',
                    size: 16,
                  ),
                  Gap(20),
                  ElevatedButton.icon(
                    onPressed: meta.isLastPage
                        ? null
                        : () => controller.loadNextPage(),
                    icon: Icon(Icons.arrow_forward),
                    label: CommonText.medium('التالي', color: AppColors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      disabledBackgroundColor: AppColors.grey100Color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.primary500,
      Color(0xFF2196F3),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFF9C27B0),
      Color(0xFFE91E63),
      Color(0xFF00BCD4),
      Color(0xFF8BC34A),
    ];
    return colors[index % colors.length];
  }

  menuButton(UsersModel user) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
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
      child: commonPopTextView(AppCommonIcon.moreIcon),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            if (!mounted) return;
            Future.delayed(Duration.zero, () {
              if (!mounted) return;
              commonDialogBox(
                context: context,
                child: SizedBox(
                  width: mobileView ? null : 560,
                  child: EditUserView(user: user),
                ),
              );
            });
          },
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
          onTap: () {
            if (!mounted) return;
            Future.delayed(Duration.zero, () {
              if (!mounted) return;
              _showDeleteConfirmation(user);
            });
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

  Widget commonSwitch({
    required bool value,
    required void Function(bool) onChanged,
  }) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SizedBox(
      height: 17,
      width: 17,
      child: Transform.scale(
        scale: 0.7,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary500,
          thumbColor: AppColors.white,
          inactiveThumbColor: isDarkMode
              ? AppColors.mainDarkBgColor
              : AppColors.white,
          inactiveTrackColor: isDarkMode
              ? AppColors.greyDarkColor
              : AppColors.background100,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(UsersModel user) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    Get.dialog(
      AlertDialog(
        backgroundColor: isDarkMode
            ? AppColors.mainDarkBgColor
            : AppColors.white,
        title: CommonText.semiBold('تأكيد الحذف', size: 18),
        content: CommonText.regular(
          'هل أنت متأكد من حذف المستخدم "${user.name}"؟',
          size: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CommonText.medium('إلغاء', color: AppColors.bodyTextColor),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.deleteUser(user.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
            ),
            child: CommonText.medium('حذف', color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
