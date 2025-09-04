import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:flutter/material.dart';

class CustomFormHeader extends StatelessWidget {
  const CustomFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Image.asset('assets/images/jrmsu-logo.png', height: 100, width: 100),
          Spacing.vertical(size: AppSpacing.medium),
          Text(
            'JRMSU - KATIPUNAN',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Sora',
              fontSize: AppFontSizes.xxxxLarge,
              color: AppColors.black,
            ),
          ),
          Text(
            'CLOUD-BASED VEHICLE MONITORING SYSTEM',
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.small,
            ),
          ),
          Spacing.vertical(size: AppSpacing.small),
        ],
      ),
    );
  }
}
