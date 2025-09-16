import 'dart:math';
import 'package:education_admin_portal/core/constants/app_assets.dart';
import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme_controller.dart';

// class CustomDropdownFormField<T> extends StatelessWidget {
//   final String? hintText;
//   final List<T> items;
//   final T? value;
//   final String Function(T)? itemAsString;
//   final void Function(T?) onChanged;
//   final String? Function(T?)? validator;
//   final double borderRadius;
//   final bool isExpanded;
//
//   const CustomDropdownFormField({
//     super.key,
//     this.hintText,
//     required this.items,
//     required this.value,
//     required this.onChanged,
//     this.validator,
//     this.itemAsString,
//     this.borderRadius = 6,
//     this.isExpanded = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Get.find<ThemeController>().isDarkMode;
//     return DropdownButtonFormField<T>(
//       alignment: Alignment.bottomCenter,
//       value: value,
//       isExpanded: isExpanded,
//
//       icon: SvgImageFromAsset(
//         AppCommonIcon.downArrowIcon,
//         colorFilter: ColorFilter.mode(
//           isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
//           BlendMode.srcIn,
//         ),
//       ),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: isDarkMode
//             ? AppColors.mainDarkBgColor
//             : AppColors.lightBgColor,
//         hintStyle: TextStyle(
//           color: isDarkMode
//               ? AppColors.bodyTextDarkColor
//               : AppColors.bodyTextColor,
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 12,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.lightBorderColor,
//             width: 1.5,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.lightBorderColor,
//             width: 1.5,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.lightBorderColor,
//             width: 1.5,
//           ),
//         ),
//
//         hintText: hintText,
//       ),
//       items: items.map((T item) {
//         return DropdownMenuItem<T>(
//           value: item,
//           child: CommonText.regular(
//             itemAsString != null ? itemAsString!(item) : item.toString(),
//             size: 14,
//             color: isDarkMode
//                 ? AppColors.bodyTextDarkColor
//                 : AppColors.bodyTextColor,
//             fontWeight: FontWeight.w400,
//           ),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: validator,menuMaxHeight: MediaQuery.of(context).size.height,
//     );
//   }
// }
//
// class CustomCourseDropdownFormField<T> extends StatelessWidget {
//   final String? hintText;
//   final List<T> items;
//   final T? value;
//   final String Function(T)? itemAsString;
//   final void Function(T?) onChanged;
//   final String? Function(T?)? validator;
//   final double borderRadius;
//   final bool isExpanded;
//
//   const CustomCourseDropdownFormField({
//     super.key,
//     this.hintText,
//     required this.items,
//     required this.value,
//     required this.onChanged,
//     this.validator,
//     this.itemAsString,
//     this.borderRadius = 6,
//     this.isExpanded = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Get.find<ThemeController>().isDarkMode;
//     return DropdownButtonFormField<T>(
//       value: value,
//       isExpanded: isExpanded,
//       icon: SvgImageFromAsset(
//         AppCommonIcon.downArrowIcon,
//         colorFilter: ColorFilter.mode(
//           isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
//           BlendMode.srcIn,
//         ),
//       ),
//       decoration: InputDecoration(
//         // filled: true,
//         // fillColor: isDarkMode?AppColors.mainDarkBgColor:AppColors.lightBgColor,
//         hintStyle: TextStyle(
//           color: isDarkMode
//               ? AppColors.bodyTextDarkColor
//               : AppColors.bodyTextColor,
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 12,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.headingsLightColor,
//             width: 1.5,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.headingsLightColor,
//             width: 1.5,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.lightBorderColor,
//             width: 1.5,
//           ),
//         ),
//
//         hintText: hintText,
//       ),
//       items: items.map((T item) {
//         return DropdownMenuItem<T>(
//           value: item,
//           child: CommonText.regular(
//             itemAsString != null ? itemAsString!(item) : item.toString(),
//             size: 14,
//             color: isDarkMode
//                 ? AppColors.bodyTextDarkColor
//                 : AppColors.bodyTextColor,
//             fontWeight: FontWeight.w400,
//           ),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: validator,
//     );
//   }
// }




class AlwaysDownDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String? hintText;
  final String Function(T)? itemAsString;
  final void Function(T?) onChanged;
  final double borderRadius;
  final double? maxMenuHeight;
final Color? color;
  const AlwaysDownDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.itemAsString,
    this.borderRadius = 6,
    this.maxMenuHeight, this.color,
  });

  @override
  State<AlwaysDownDropdown<T>> createState() => _AlwaysDownDropdownState<T>();
}

class _AlwaysDownDropdownState<T> extends State<AlwaysDownDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);

    // get position & size of the target widget
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset target = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;

    // available space below the field (leave 8-16 px padding)
    final double availableBelow = screenHeight - target.dy - size.height - 8.0;

    // compute menu max height:
    // prefer the availableBelow (so it stays visible below)
    // fallback to a reasonable maximum if availableBelow is too large/small
    final double configuredMax = widget.maxMenuHeight ?? 300;
    final double menuMaxHeight = (availableBelow > 80)
        ? min(availableBelow, configuredMax)
        : min(max(screenHeight - 16.0, 0), configuredMax);

    _overlayEntry = OverlayEntry(builder: (context) {
      final bool isDarkMode = Get.find<ThemeController>().isDarkMode;

      return Positioned.fill(
        child: GestureDetector(
          // catch taps outside the menu to close it
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,
          child: Stack(
            children: [
              // The follower will position itself relative to the CompositedTransformTarget
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height), // open below the field
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: menuMaxHeight,
                    ),
                    child: SizedBox(
                      width: size.width, // match width of the field
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          return InkWell(
                            onTap: () {
                              widget.onChanged(item);
                              _removeOverlay();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: CommonText.regular(
                                widget.itemAsString?.call(item) ?? item.toString(),
                                size: 14,
                                color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;

      if (mounted) {
        // safe to call setState only if widget still alive
        setState(() => _isOpen = false);
      } else {
        // if widget already disposed, just reset the flag silently
        _isOpen = false;
      }
    }
  }


  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    final displayText = widget.value != null
        ? (widget.itemAsString?.call(widget.value as T) ?? widget.value.toString())
        : (widget.hintText ?? '');

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: widget.color ?? (isDarkMode
                ? AppColors.mainDarkBgColor
                : AppColors.lightBgColor),
            border: Border.all(
              color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CommonText.regular(
                  displayText,
                  size: 14,
                  color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Transform.rotate(
                angle: _isOpen ? 3.14 : 0, // simple rotate when open
                child: SvgImageFromAsset(
                  AppCommonIcon.downArrowIcon,
                  colorFilter: ColorFilter.mode(
                    isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
                    BlendMode.srcIn,
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



