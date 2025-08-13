import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../common_widgets/widgets/button.dart';

class PermissionAppDialog extends StatelessWidget {
  final String title;
  final String? subTitle;
  final TextStyle? textStyle;
  final AppDialogButton? positiveButton;
  final AppDialogButton? negativeButton;

  const PermissionAppDialog({
    super.key,
    required this.title,
    this.subTitle,
    this.textStyle,
    this.positiveButton,
    this.negativeButton,
  });

  @override
  Widget build(BuildContext context) {
    var dialogTheme = context.theme.dialogTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: dialogTheme.titleTextStyle, textAlign: TextAlign.center),
            const Gap(12),
            if (subTitle != null)
              Text(
                subTitle!,
                style: textStyle ?? dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
            const Gap(20),
            Row(
              children: [
                if (positiveButton != null)
                  Expanded(
                    child: PrimaryButton(
                      onPressed: positiveButton!.onPressed ??
                          () => Navigator.of(context).pop(true),
                      label: positiveButton!.label,
                    ),
                  ),
                if (positiveButton != null && negativeButton != null)
                  const Gap(12),
                if (negativeButton != null)
                  Expanded(
                    child: OutlineButton(
                      onPressed: negativeButton!.onPressed ??
                          () => Navigator.of(context).pop(false),
                      label: negativeButton!.label,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppDialogButton {
  final String label;
  final VoidCallback? onPressed;

  const AppDialogButton({
    required this.label,
    required this.onPressed,
  });
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  AppDialogButton? positiveButton,
  AppDialogButton? negativeButton,
  bool barrierDismissible = true,
  RouteSettings? routeSettings,
}) {
  return showDialog<T>(
    context: context,
    routeSettings: routeSettings,
    barrierDismissible: barrierDismissible,
    builder: (context) => PermissionAppDialog(
      title: title,
      subTitle: content,
      positiveButton: positiveButton,
      negativeButton: negativeButton,
    ),
  );
}
