import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: AppColors.primary);
  }
}
