import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';

class AlertMessage extends SnackBar {
  AlertMessage({
    super.key,
    required String title,
    required String? description,
    required super.backgroundColor,
    required Color? foregroundColor,
    Widget? icon,
    super.shape,
    super.duration,
    super.width,
    super.animation,
    super.elevation,
    super.dismissDirection = DismissDirection.horizontal,
    super.onVisible,
    super.clipBehavior = Clip.hardEdge,
  }) : super(
          content: _AlertMessageContent(
            key: UniqueKey(),
            title: title,
            description: description,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            icon: icon,
          ),
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: EdgeInsets.zero,
          behavior: SnackBarBehavior.floating,
        );
}

class _AlertMessageContent extends StatelessWidget {
  final String title;
  final String? description;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? icon;

  const _AlertMessageContent({
    super.key,
    required this.title,
    required this.description,
    required this.foregroundColor,
    required this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final snackBarTheme = theme.snackBarTheme;
    final foregroundColor = this.foregroundColor ?? snackBarTheme.contentTextStyle?.color ?? colorScheme.onSurface;

    Widget alertMessage = Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white),
                    ),
                    if (description != null && description!.isNotEmpty)
                      Text(
                        description!,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (icon == null) {
      return alertMessage;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        alertMessage,
        PositionedDirectional(
          end: 8,
          top: -16,
          child: SizedBox.square(dimension: 32, child: icon),
        ),
      ],
    );
  }
}
