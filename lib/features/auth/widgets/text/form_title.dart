import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomFormTitle extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const CustomFormTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title ?? 'ADMIN LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: AppFontSizes.xxxLarge,
              color: AppColors.primary,
            ),
          ),
          Text(
            subtitle ?? 'Please login to continue',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: AppFontSizes.medium,
            ),
          ),
        ],
      ),
    );
  }
}
