import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GlassIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const GlassIcon({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.25)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
