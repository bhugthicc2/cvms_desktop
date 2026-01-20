import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final String subTitle;
  const CustomAlertDialog({
    super.key,
    required this.child,
    required this.title,
    this.subTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shadowColor: AppColors.donutBlue.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.left,
            title,
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            textAlign: TextAlign.left,
            subTitle,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: AppColors.grey,
            ),
          ),
        ],
      ),

      content: SizedBox(height: 480, width: 530, child: child),
    );
  }
}
