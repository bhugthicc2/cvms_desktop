import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChartEmptyState extends StatelessWidget {
  const ChartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/anim/empty_state_anim.json', width: 220),

        const Text(
          'No data available',
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),

        Spacing.horizontal(size: AppSpacing.large),
        const Text(
          'There is no data to display at the moment',
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: FontWeight.w400,
            color: AppColors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
