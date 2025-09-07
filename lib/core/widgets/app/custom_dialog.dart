import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;
  final VoidCallback onSave;
  final String btnTxt;
  final double width;
  final double height;
  final bool? isExpanded;
  final double? mainContentPadding;
  final bool? isAlert;
  final Color? headerColor;

  const CustomDialog({
    super.key,
    required this.title,
    required this.child,
    this.width = 700,
    this.height = 800,
    required this.onSave,
    required this.btnTxt,
    this.icon = PhosphorIconsBold.info,
    this.isExpanded = false,
    this.mainContentPadding,
    this.headerColor,
    this.isAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.all(40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerColor ?? AppColors.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.white),
                  Spacing.horizontal(size: AppSpacing.small),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppIconSizes.small,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(PhosphorIconsBold.x, color: AppColors.white),
                  ),
                ],
              ),
            ),

            // Conditional content rendering
            if (isAlert == true)
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.small),
                    child: child,
                  ),
                ),
              )
            else
              //main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(mainContentPadding ?? 16),
                  child: child,
                ),
              ), //main content

            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button with conditional expansion
                  isExpanded == true
                      ? Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey.withValues(
                              alpha: 0.2,
                            ),
                            foregroundColor: AppColors.grey,
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      )
                      : TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grey.withValues(
                            alpha: 0.2,
                          ),
                          foregroundColor: AppColors.grey,
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),

                  Spacing.horizontal(size: AppSpacing.medium),

                  // Save button with conditional expansion
                  isExpanded == true
                      ? Expanded(
                        child: ElevatedButton(
                          onPressed: onSave,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: headerColor ?? AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            btnTxt,
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      : ElevatedButton(
                        onPressed: onSave,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          backgroundColor: headerColor ?? AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          btnTxt,
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
