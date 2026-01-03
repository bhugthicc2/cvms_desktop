import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class VehicleSection extends StatelessWidget {
  final Widget? child;
  final double height;
  const VehicleSection({super.key, this.height = 250, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
