import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Axis direction;
  final double thickness;
  final double length;
  final Color? color;

  const CustomDivider({
    super.key,
    this.direction = Axis.horizontal,
    this.thickness = 1,
    this.length = double.infinity,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.vertical ? thickness : length,
      height: direction == Axis.horizontal ? thickness : length,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? AppColors.greySurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
