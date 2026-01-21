import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReportLoadingAnim extends StatelessWidget {
  const ReportLoadingAnim({
    super.key,
    this.message = "Please wait while we prepare your report data.",
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greySurface.withValues(alpha: 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              renderCache: RenderCache.raster,
              'assets/anim/report_loadin_anim.json',
              width: 280,
            ),
          ),
          Spacing.vertical(size: AppSpacing.small),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.large,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.medium,
            ),
          ),
        ],
      ),
    );
  }
}
