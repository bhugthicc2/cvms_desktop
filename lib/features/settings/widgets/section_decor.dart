import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

BoxDecoration sectionDecoration() {
  return BoxDecoration(
    border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.7)),
    color: AppColors.white,
    borderRadius: BorderRadius.circular(5),
  );
}
