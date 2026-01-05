import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/reports/widgets/button/custom_view_button.dart';
import 'package:flutter/material.dart';

class CustomChartTitle extends StatelessWidget {
  final VoidCallback onViewTap;
  final String title;
  const CustomChartTitle({
    super.key,
    required this.title,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.medium,

            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        CustomViewButton(onTap: onViewTap),
      ],
    );
  }
}
