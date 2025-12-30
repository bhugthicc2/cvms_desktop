import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final Gradient? gradient;
  final Color? iconColor;

  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.gradient,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGrow(
      hoverScale: 1.03,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium - 2),
        decoration: BoxDecoration(
          gradient:
              gradient ??
              LinearGradient(colors: [color.withValues(alpha: 0.9), color]),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.white,
                weight: 5,
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$value",
                  style: TextStyle(
                    fontSize: AppFontSizes.xLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
