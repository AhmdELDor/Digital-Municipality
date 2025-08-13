// import 'dart:async';
// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
//
// import '../../../core/constants/app_assets.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/themes/app_size.dart';
// import '../../app/theme_controller.dart';
// import '../widgets/image.dart';
// import '../widgets/text.dart';
//
// class PaginationDropDownItem<T> {
//   final Widget? icon;
//   final String label;
//   final T value;
//
//   const PaginationDropDownItem({
//     required this.label,
//     required this.value,
//     this.icon,
//   });
// }
//
// class CommonPaginationDropDownField<T> extends StatefulWidget {
//   final TextEditingController? controller;
//   final Iterable<PaginationDropDownItem<T>> items;
//   final String hintText;
//   final String label;
//   final FormFieldValidator<T>? validator;
//   final ValueChanged<T>? fieldSubmitted;
//   final FocusNode? focus;
//   final ValueChanged<T?>? onChanged;
//   final T? value;
//   final InputDecoration? decoration;
//   final bool? onTapEnable;
//
//   const CommonPaginationDropDownField({
//     super.key,
//     required this.items,
//     required this.onChanged,
//     this.hintText = "",
//     this.validator,
//     this.controller,
//     this.fieldSubmitted,
//     this.focus,
//     this.value,
//     this.label = "",
//     this.decoration,
//     this.onTapEnable,
//   });
//
//   @override
//   State<CommonPaginationDropDownField<T>> createState() =>
//       _CommonPaginationDropDownFieldState<T>();
// }
//
// class _CommonPaginationDropDownFieldState<T>
//     extends State<CommonPaginationDropDownField<T>> {
//   late final FocusNode _focus;
//   final ValueNotifier<bool> _isOptionVisible = ValueNotifier(false);
//   final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
//   PaginationDropDownItem<T>? _selectedItem;
//
//   @override
//   void initState() {
//     _focus = widget.focus ?? FocusNode();
//     if (widget.value != null) {
//       _selectedItem = widget.items.firstWhere(
//         (element) => element.value == widget.value,
//       );
//       _updateSelectedItem(
//         widget.items.firstWhere((element) => element.value == widget.value),
//       );
//     }
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(covariant CommonPaginationDropDownField<T> oldWidget) {
//     _updateSelectedItem(
//       widget.value == null
//           ? null
//           : widget.items.firstWhere((element) => element.value == widget.value),
//     );
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void dispose() {
//     widget.controller?.dispose();
//     super.dispose();
//   }
//
//   void _onItemSelected(PaginationDropDownItem<T> item) {
//     setState(() => _updateSelectedItem(item));
//     _key.currentState?.validate();
//     widget.onChanged?.call(item.value);
//   }
//
//   void _updateSelectedItem(PaginationDropDownItem<T>? value) {
//     _selectedItem = value;
//     Timer.run(() => widget.controller?.text = value?.label ?? "");
//   }
//
//   Future<void> _showOptions() async {
//     var renderObject = context.findRenderObject();
//     if (renderObject is! RenderBox) return;
//     var rect = renderObject.localToGlobal(Offset.zero) & renderObject.size;
//
//     _isOptionVisible.value = true;
//     var item = await showGeneralDialog<PaginationDropDownItem<T>>(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "drop_down_option",
//       barrierColor: Colors.black12,
//       pageBuilder:
//           (context, animation, secondaryAnimation) => _DropDownOptionsView(
//             items: widget.items,
//             selectedItem: _selectedItem,
//           ),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         var mediaQuery = MediaQuery.of(context);
//         var height =
//             mediaQuery.size.height -
//             rect.bottomLeft.dy -
//             mediaQuery.padding.bottom;
//         return Stack(
//           fit: StackFit.expand,
//           children: [
//             Positioned.fill(
//               top: rect.bottomLeft.dy - 305,
//               left: rect.bottomLeft.dx,
//               right: mediaQuery.size.width - rect.bottomRight.dx,
//               bottom: mediaQuery.padding.bottom,
//               child: AnimatedBuilder(
//                 animation: animation,
//                 builder:
//                     (context, child) => SizedBox(
//                       height: height * animation.value,
//                       child: child,
//                     ),
//                 child: Align(
//                   alignment: AlignmentDirectional.topCenter,
//                   child: child,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//     _isOptionVisible.value = false;
//     if (item != null) _onItemSelected(item);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (widget.label.isNotEmpty) ...[
//           CommonText.medium(widget.label, size: 14),
//           const Gap(4),
//         ],
//         TextFormField(
//           key: _key,
//           controller: widget.controller,
//           readOnly: true,
//           focusNode: _focus,
//           onTap:
//               (widget.onTapEnable ?? true)
//                   ? widget.onChanged == null
//                       ? null
//                       : _showOptions
//                   : null,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: (_) => widget.validator?.call(widget.value),
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             color:
//             Get.find<ThemeController>().isDarkMode
//                 ? AppColors.white
//                 : AppColors.greyscale800,
//           ),
//           decoration: (widget.decoration ?? const InputDecoration()).copyWith(
//             counterText: "",
//             contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//             focusedErrorBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color:
//                    Theme.of(context).colorScheme.error,
//               ),
//               borderRadius: ShapeBorderRadius.small,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: ShapeBorderRadius.small,
//               borderSide: BorderSide(
//                 color:
//                 Get.find<ThemeController>().isDarkMode
//                     ? AppColors.greyscale400
//                     : AppColors.greyscale200,
//                 width: 1,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
//               borderRadius: ShapeBorderRadius.small,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
//               borderRadius: ShapeBorderRadius.small,
//             ),
//             fillColor: Theme.of(context).colorScheme.surface,
//             errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
//             hintText: widget.hintText,
//             suffixIcon: ValueListenableBuilder<bool>(
//               valueListenable: _isOptionVisible,
//               builder:
//                   (context, isVisible, child) => IconButton(
//                     padding: EdgeInsets.zero,
//                     onPressed: widget.onChanged == null ? null : _showOptions,
//                     icon: AnimatedContainer(
//                       duration: const Duration(milliseconds: 100),
//                       transform: Matrix4.rotationZ(isVisible ? math.pi : 0),
//                       transformAlignment: Alignment.center,
//                       child: const SvgImageFromAsset.square(
//                         AppCommonIcon.arrowDown,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _DropDownOptionsView<T> extends StatefulWidget {
//   final Iterable<PaginationDropDownItem<T>> items;
//   final PaginationDropDownItem<T>? selectedItem;
//
//   const _DropDownOptionsView({required this.items, this.selectedItem});
//
//   @override
//   State<_DropDownOptionsView<T>> createState() =>
//       _DropDownOptionsViewState<T>();
// }
//
// class _DropDownOptionsViewState<T> extends State<_DropDownOptionsView<T>> {
//   final _scrollController = ScrollController();
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Card(
//       margin: const EdgeInsets.only(top: 8),
//       elevation: 4,
//       shadowColor: colorScheme.surface.withAlpha(150),
//       color: colorScheme.onSurface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: ShapeBorderRadius.small,
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: Container(
//         constraints: const BoxConstraints(maxHeight: 240),
//         child: Builder(
//           builder: (context) {
//             if (widget.items.isEmpty) {
//               return const SizedBox(
//                 width: double.maxFinite,
//                 child: Padding(
//                   padding: EdgeInsets.all(32),
//                   // child:
//                   //     SvgImageFromAsset.square(AppCommonIcon.emailIcon, size: 64),
//                 ),
//               );
//             }
//             return MediaQuery(
//               data: MediaQuery.of(
//                 context,
//               ).copyWith(padding: const EdgeInsets.symmetric(vertical: 8)),
//               child: PrimaryScrollController(
//                 controller: _scrollController,
//                 child: Scrollbar(
//                   thumbVisibility: true,
//                   child: CustomScrollView(
//                     shrinkWrap: true,
//                     scrollBehavior: ScrollConfiguration.of(context).copyWith(
//                       scrollbars: false,
//                       overscroll: false,
//                       physics: const ClampingScrollPhysics(),
//                       platform: Theme.of(context).platform,
//                     ),
//                     slivers: [
//                       SliverPadding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         sliver: SliverList(
//                           delegate: SliverChildBuilderDelegate((
//                             context,
//                             index,
//                           ) {
//                             final item = widget.items.elementAt(index);
//                             return ListTile(
//                               tileColor:
//                                   item.value == widget.selectedItem?.value
//                                       ? colorScheme.primary
//                                       : colorScheme.onSurface,
//                               dense: true,
//                               horizontalTitleGap: 10,
//                               leading: item.icon,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                               ),
//                               iconColor:
//                               colorScheme.primary,
//                               title: CommonText.medium(
//                                 item.label,
//                                 size: 14,
//                                 color:
//                                     item.value == widget.selectedItem?.value
//                                         ? colorScheme.onSurface
//                                         : Get.find<ThemeController>().isDarkMode
//                                         ? AppColors.white
//                                         : AppColors.greyscale800,
//                               ),
//                               onTap:
//                                   () => Get.back(
//                                     result: item,
//                                   ), // Navigator.of(context).pop(item),
//                             );
//                           }, childCount: widget.items.length),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
