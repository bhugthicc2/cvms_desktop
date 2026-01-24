import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DateFilterButton extends StatelessWidget {
  final String dateText;
  final VoidCallback onPressed;

  const DateFilterButton({
    super.key,
    required this.dateText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dy: -0.04,
      dx: 0,
      cursor: SystemMouseCursors.click,
      onTap: onPressed,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              PhosphorIconsRegular.calendar,
              color: AppColors.white,
              size: 22,
            ),
            Spacing.horizontal(size: AppSpacing.small),
            Text(
              dateText,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExportReportButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const ExportReportButton({
    super.key,
    this.text = 'GENERATE REPORT',
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dy: -0.04,
      dx: 0,
      cursor:
          isLoading ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color:
              isLoading
                  ? AppColors.lineColor.withValues(alpha: 0.4)
                  : AppColors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            children: [
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              else
                Icon(
                  PhosphorIconsRegular.fileArrowDown,
                  color: AppColors.white,
                  size: 20,
                ),
              const Spacing.horizontal(size: AppSpacing.small),
              Text(
                isLoading ? 'GENERATING...' : text,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
