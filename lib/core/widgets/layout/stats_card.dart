import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_rotate.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final bool isWhiteTheme;
  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final Gradient? gradient;
  final Color? iconColor;
  final double angle;
  final bool addSideBorder;
  final bool lineDesign;
  final double height;

  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.gradient,
    required this.iconColor,
    this.angle = 0.03,
    this.isWhiteTheme = true,
    this.addSideBorder = true,
    this.lineDesign = false,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return HoverRotate(
      angle: angle,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: height,
        decoration: BoxDecoration(
          color: isWhiteTheme ? AppColors.white : null,
          gradient:
              isWhiteTheme
                  ? null
                  : gradient ??
                      LinearGradient(
                        colors: [color.withValues(alpha: 0.9), color],
                      ),
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
            if (addSideBorder)
              Container(
                height: height,
                width: 4,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: iconColor!.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient:
                      isWhiteTheme
                          ? gradient
                          : LinearGradient(
                            colors: [color.withValues(alpha: 0.9), color],
                          ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient:
                            isWhiteTheme
                                ? gradient
                                : LinearGradient(
                                  colors: [color.withValues(alpha: 0.9), color],
                                ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor!.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color:
                            isWhiteTheme
                                ? AppColors.white
                                : iconColor ?? AppColors.white,
                        weight: 5,
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$value",
                          style: TextStyle(
                            fontSize: AppFontSizes.xLarge,
                            fontWeight: FontWeight.bold,
                            color: isWhiteTheme ? AppColors.black : color,
                          ),
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color:
                                isWhiteTheme
                                    ? AppColors.grey.withValues(alpha: 0.9)
                                    : AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
