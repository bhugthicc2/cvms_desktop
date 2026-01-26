import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double? iconSize;
  final Color iconColor;
  final Color? splashColor;
  final Color hoverColor;
  final double raddi;
  final String tooltip;
  final double dx;
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    required this.iconColor,
    this.splashColor,
    this.hoverColor = Colors.transparent,
    this.raddi = 6.0,
    this.tooltip = '',
    this.dx = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dx: dx,
      child: IconButton(
        tooltip: tooltip,
        splashColor: splashColor ?? iconColor.withValues(alpha: 0.2),
        splashRadius: 1,
        style: IconButton.styleFrom(
          hoverColor: hoverColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raddi),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize ?? 15),
        color: iconColor,
      ),
    );
  }
}
