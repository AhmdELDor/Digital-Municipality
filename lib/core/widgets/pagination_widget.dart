import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.lastPage,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    // Flipped the arrow directions as requested
    final previousIcon = isRTL ? Icons.chevron_left : Icons.chevron_right;
    final nextIcon = isRTL ? Icons.chevron_right : Icons.chevron_left;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(theme.brightness == Brightness.dark ? 0.12 : 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              _circleIconButton(
                context,
                icon: previousIcon,
                enabled: currentPage > 1,
                tooltip: 'السابق',
                onTap: currentPage > 1 ? onPrevious : null,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                child: Center(
                  child: Text(
                    '$lastPage-$currentPage',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _circleIconButton(
                context,
                icon: nextIcon,
                enabled: currentPage < lastPage,
                tooltip: 'التالي',
                onTap: currentPage < lastPage ? onNext : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleIconButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required String tooltip,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withOpacity(0.08);
    final iconColor = enabled
        ? theme.colorScheme.onSurface
        : theme.disabledColor;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: baseColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}