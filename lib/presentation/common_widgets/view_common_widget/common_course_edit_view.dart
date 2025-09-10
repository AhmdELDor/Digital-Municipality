import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../utils/extensions/responsive.dart';
import '../../app/theme_controller.dart';
import '../../screens/dashboard_module/dashboard/model/course_model.dart';
import '../widgets/common_cache_image.dart';
import '../widgets/common_divider.dart';
import '../widgets/image.dart';
import '../widgets/text.dart';

class CommonCourseEditView extends StatefulWidget {
  final CourseModel data;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommonCourseEditView({
    super.key,
    required this.data,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CommonCourseEditView> createState() => _CommonCourseEditViewState();
}

class _CommonCourseEditViewState extends State<CommonCourseEditView> {
  RxBool isSwitch = false.obs;
  OverlayEntry? _overlayEntry;
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    bool mobileView = ResponsiveView.isMobile(context);

    return InkWell(
      hoverColor: Colors.transparent,
      child: mobileView ? _buildMobileCard(isDarkMode) : _buildDesktopCard(isDarkMode),
    );
  }

  /// Mobile card
  Widget _buildMobileCard(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              child: commonCacheImage(
                widget.data.image,
                ImagePlaceHolder.imagePlaceHolderDark,
                height: 170,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                key: _menuKey,
                onTap: () {
                  if (_overlayEntry == null) {
                    _showOverlayMenu();
                  } else {
                    _hideOverlayMenu();
                  }
                },
                child: Icon(Icons.more_vert, color: Colors.yellow),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
            border: Border.all(
              color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.medium(widget.data.name, size: 15),
                Gap(7),
                CommonText.regular(
                  widget.data.description,
                  size: 13,
                  color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(7),
                Row(
                  children: [
                    CommonText.semiBold('\$${widget.data.courseFees}', size: 18, color: AppColors.primary500),
                    Gap(20),
                    SvgImageFromAsset(AppCommonIcon.starIcon),
                    Gap(7),
                    CommonText.semiBold(widget.data.rate.toString(), size: 16, color: AppColors.secondary500),
                  ],
                ),
                Gap(12),
                CommonDivider(),
                Gap(12),
                horizontalDetailView(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Desktop card
  Widget _buildDesktopCard(bool isDarkMode) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
          child: commonCacheImage(
            widget.data.image,
            ImagePlaceHolder.imagePlaceHolderDark,
            height: 200,
            width: 250,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
              border: Border.all(
                color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText.medium(widget.data.name, size: 18),
                            Gap(5),
                            CommonText.regular(
                              widget.data.description,
                              size: 16,
                              color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        key: _menuKey,
                        onTap: () {
                          if (_overlayEntry == null) {
                            _showOverlayMenu();
                          } else {
                            _hideOverlayMenu();
                          }
                        },
                        child: Icon(Icons.more_vert, color: Colors.yellow),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CommonText.semiBold('\$${widget.data.courseFees}', size: 20, color: AppColors.primary500),
                      Gap(20),
                      Row(
                        children: [
                          SvgImageFromAsset(AppCommonIcon.starIcon),
                          Gap(7),
                          CommonText.semiBold(widget.data.rate.toString(), size: 16, color: AppColors.secondary500),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(12),
                CommonDivider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: horizontalDetailView()),
                      customSwitch(),
                    ],
                  ),
                ),
                Gap(7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Overlay menu
  void _showOverlayMenu() {
    final renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideOverlayMenu,
            behavior: HitTestBehavior.translucent,
          ),
          Positioned(
            top: offset.dy + size.height,
            left: offset.dx,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  color: Get.find<ThemeController>().isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _menuItem('View', Colors.green, widget.onView),
                    _menuItem('Edit', Colors.blue, widget.onEdit),
                    _menuItem('Delete', Colors.red, widget.onDelete),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlayMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _menuItem(String title, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: () {
        _hideOverlayMenu();
        onTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(title, style: TextStyle(color: color)),
      ),
    );
  }

  Widget horizontalDetailView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            commonDetail(CommonImageAssets.book, widget.data.courseCategory),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.language, widget.data.language),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.video, ApprovalsStrings.videoClass),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.cap, '${widget.data.noOfSession} Sessions'),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.video, '${widget.data.noOfLectures} Lectures'),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(AppCommonIcon.calenderIcon, widget.data.date),
          ],
        ),
      ),
    );
  }

  Widget commonDetail(String image, title) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgImageFromAsset(
          image,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(
            isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
            BlendMode.srcIn,
          ),
        ),
        Gap(10),
        CommonText.regular(
          title,
          size: 14,
          color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
        ),
      ],
    );
  }

  Widget verticalDivider() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: 20,
      width: 1,
      color: isDarkMode ? AppColors.grey100Color : AppColors.headingsLightColor,
    );
  }

  Widget customSwitch() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SizedBox(
      height: 17,
      width: 17,
      child: Obx(
            () => Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: isSwitch.value,
            onChanged: (value) => isSwitch.value = value,
            activeTrackColor: AppColors.primary500,
            thumbColor: AppColors.white,
            inactiveThumbColor: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
            inactiveTrackColor: isDarkMode ? AppColors.greyDarkColor : AppColors.background100,
          ),
        ),
      ),
    );
  }
}
