import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class ContentTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const ContentTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        Text(
          subtitle,
          style: TextStyle(fontSize: AppFontSizes.small, color: AppColors.grey),
        ),
      ],
    );
  }
}
