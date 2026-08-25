import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    final buttonWidget = switch (type) {
      ButtonType.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        ),
      ButtonType.secondary => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        ),
      ButtonType.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        ),
    };

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: buttonWidget,
    );
  }
}

enum ButtonType {
  primary,
  secondary,
  text,
}
