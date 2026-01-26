import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomTxtFieldLabel extends StatelessWidget {
  final bool isRequired;
  final String labelText;
  final double fontSize;
  const CustomTxtFieldLabel({
    super.key,
    required this.isRequired,
    required this.labelText,
    this.fontSize = AppFontSizes.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.black.withValues(alpha: 0.9),
          ),
        ),
        if (isRequired)
          Text(
            " * ",
            style: TextStyle(
              fontSize: fontSize + 2,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }
}
