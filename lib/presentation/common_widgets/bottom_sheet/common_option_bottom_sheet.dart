import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';


import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import '../widgets/common_divider.dart';
import '../widgets/image.dart';
import '../widgets/text.dart';

Future<T?> showOptionSelectorBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> values,
  required T selectedValue,
  required String Function(T) labelBuilder,
}) {
  final bool isDarkMode = Get.find<ThemeController>().isDarkMode;

  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: false,
    backgroundColor: Theme.of(context).colorScheme.surface,
    // isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.bold(
                    title,
                    size: 20,
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: SvgImageFromAsset(
                      'AppCommonIcon.closeIcon',
                      colorFilter: ColorFilter.mode(
                        isDarkMode ? AppColors.white :  AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(15),
              const CommonDivider(),
        
              // Options List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    final value = values[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: CommonText.semiBold(
                        labelBuilder(value),
                        size: 14,
                        color: isDarkMode
                            ?Colors.red
                            : Colors.green,
                      ),
                      trailing: value == selectedValue
                          ? const Icon(Icons.check, color: AppColors.primary500)
                          : null,
                      onTap: () => Navigator.pop(context, value),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

