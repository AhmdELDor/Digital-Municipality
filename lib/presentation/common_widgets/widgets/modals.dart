import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import 'button.dart';
import 'text.dart';

class ModalButton {
  final String label;
  final VoidCallback? onPressed;

  const ModalButton({required this.label, required this.onPressed});
}

class ErrorSheet extends StatelessWidget {
  final String title;
  final String content;
  final ModalButton button;

  const ErrorSheet({
    super.key,
    required this.title,
    required this.content,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: ShapeBorderRadius.medium,
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                child: CommonText.bold(title, size: 16),
              ),
              Flexible(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CommonText.medium(
                      content,
                      size: 12,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ErrorButton(
                  onPressed:
                      button.onPressed ??
                      () => Navigator.of(
                        context,
                      ).removeRoute(ModalRoute.of(context)!),
                  label: button.label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const DialogHeader({super.key, required this.title, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CommonText.semiBold(title, size: 16),
              ),
            ),
            CloseButton(onPressed: onClose),
          ],
        ),
      ),
    );
  }
}

class AppDialog extends StatelessWidget {
  final String title;
  final String content;
  final Widget? icon;
  final ModalButton? positiveButton;
  final ModalButton? negativeButton;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.positiveButton,
    this.negativeButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialogHeader(title: title),
          if (icon != null) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 84, maxHeight: 84),
              child: icon!,
            ),
          ],
          Flexible(
            child: IntrinsicHeight(
              child: Container(
                constraints: const BoxConstraints(minHeight: 84),
                alignment: Alignment.center,
                child: CommonText.medium(
                  content,
                  size: 14,
                  color:
                      AppColors.headingsColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const Gap(10),
          const Divider(),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                if (negativeButton != null)
                  Expanded(
                    child: OutlineButton(
                      onPressed:
                          negativeButton!.onPressed ??
                          () => Navigator.of(context).pop(false),
                      label: negativeButton!.label,
                    ),
                  ),
                if (positiveButton != null && negativeButton != null)
                  const Gap(16),
                if (positiveButton != null)
                  Expanded(
                    child: PrimaryButton(
                      onPressed:
                          positiveButton!.onPressed ??
                          () => Navigator.of(context).pop(true),
                      label: positiveButton!.label,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
