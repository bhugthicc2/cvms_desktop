import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int step;
  final String title;
  final String supportText;
  final int currentStep;
  final VoidCallback onTap;

  const StepIndicator({
    super.key,
    required this.step,
    required this.title,
    required this.supportText,
    required this.currentStep,
    required this.onTap,
  });

  bool get isActive => currentStep == step;
  bool get isCompleted => currentStep > step;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Step track with centered circle and connecting lines
            LayoutBuilder(
              builder: (context, constraints) {
                final slotWidth = constraints.maxWidth;
                final halfLineWidth = slotWidth / 2 - 20;
                final lineColorBefore =
                    (currentStep >= step)
                        ? AppColors.primary
                        : AppColors.grey.withValues(alpha: 0.3);
                final lineColorAfter =
                    isCompleted
                        ? AppColors.primary
                        : AppColors.grey.withValues(alpha: 0.3);
                final verticalLineOffset = (40 - 3) / 2;

                return SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Stack(
                    children: [
                      // Before line (right half of previous connection)
                      if (step > 0 && halfLineWidth > 0)
                        Positioned(
                          left: 0,
                          top: verticalLineOffset,
                          child: SizedBox(
                            width: halfLineWidth,
                            height: 3,
                            child: Container(
                              decoration: BoxDecoration(color: lineColorBefore),
                            ),
                          ),
                        ),
                      // After line (left half of next connection)
                      if (step < 4 && halfLineWidth > 0)
                        Positioned(
                          left: slotWidth / 2 + 20,
                          top: verticalLineOffset,
                          child: SizedBox(
                            width: halfLineWidth,
                            height: 3,
                            child: Container(
                              decoration: BoxDecoration(color: lineColorAfter),
                            ),
                          ),
                        ),

                      // Centered step circle
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isCompleted || isActive
                                          ? AppColors.primary.withValues(
                                            alpha: 0.4,
                                          )
                                          : AppColors.grey.withValues(
                                            alpha: 0.2,
                                          ),
                                  width: 6,
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color:
                                    isCompleted
                                        ? AppColors.primary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isCompleted || isActive
                                          ? AppColors.primary
                                          : AppColors.grey.withValues(
                                            alpha: 0.2,
                                          ),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child:
                                    isCompleted
                                        ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                        : Text(
                                          '${step + 1}'.padLeft(2, '0'),
                                          style: TextStyle(
                                            color:
                                                isActive
                                                    ? AppColors.primary
                                                    : AppColors.grey.withValues(
                                                      alpha: 0.7,
                                                    ),
                                            fontSize: AppFontSizes.small,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Title and support text
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color:
                        isCompleted || isActive
                            ? AppColors.primary
                            : AppColors.grey.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  supportText,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: AppColors.grey.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
