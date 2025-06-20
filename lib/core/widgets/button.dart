import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final IconData? icon;

  const Button({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ],
              )
            : Text(
                title,
                style: TextStyle(
                  color: textColor,
                ),
              );

    return SizedBox(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: buttonChild,
      ),
    );
  }
}
