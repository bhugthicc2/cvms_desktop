import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconColor = AppColors.black,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGrow(
      onTap: onTap,
      child: Center(child: Icon(icon, color: iconColor, size: iconSize)),
    );
  }
}
