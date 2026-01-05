import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

BoxDecoration cardDecoration() => BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: AppColors.grey.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ],
);
