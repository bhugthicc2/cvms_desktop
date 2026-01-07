import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double height;
  const CustomDivider({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1.5, height: height, color: AppColors.greySurface);
  }
}
