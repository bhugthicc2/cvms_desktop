import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double? iconSize;
  final Color iconColor;
  final Color? splashColor;
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    required this.iconColor,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: splashColor ?? iconColor.withValues(alpha: 0.2),
      splashRadius: 10,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize ?? 15),
      color: iconColor,
    );
  }
}
