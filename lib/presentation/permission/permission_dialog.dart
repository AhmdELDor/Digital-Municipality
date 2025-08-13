import 'package:flutter/material.dart';
import '/utils/extensions/context_extensions.dart';

import '../../core/themes/app_size.dart';
import '../common_widgets/widgets/text.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const PermissionDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      shape:
          const RoundedRectangleBorder(borderRadius: ShapeBorderRadius.large),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: context.colorScheme.primary,
              borderRadius:
                  const BorderRadius.vertical(top: ShapeRadius.large),
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                child:
                    Icon(icon, size: 48, color: context.colorScheme.onPrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: CommonText.medium(description, size: 12, height: 1.3),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: context.colorScheme.error),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Not Now"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> showPermissionDialog<T>(
    {required BuildContext context,
    required String description,
    required String title,
    required IconData icon}) {
  return showGeneralDialog<T>(
    context: context,
    routeSettings: const RouteSettings(name: "/permission_dialog"),
    barrierDismissible: false,
    barrierLabel: "permission_dialog",
    pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
      child:
          PermissionDialog(title: title, icon: icon, description: description),
    ),
    transitionDuration: const Duration(milliseconds: 100),
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
