import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double? iconSize;
  final Color iconColor;
  final Color? splashColor;
  final Color hoverColor;
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    required this.iconColor,
    this.splashColor,
    this.hoverColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      // hoverScale: 1.2,
      child: IconButton(
        splashColor: splashColor ?? iconColor.withValues(alpha: 0.2),
        splashRadius: 10,
        style: IconButton.styleFrom(
          hoverColor: hoverColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize ?? 15),
        color: iconColor,
      ),
    );
  }
}
