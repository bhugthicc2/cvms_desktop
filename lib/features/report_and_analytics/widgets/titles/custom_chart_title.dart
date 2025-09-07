import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomChartTitle extends StatelessWidget {
  final String title;
  const CustomChartTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppFontSizes.medium,
        fontFamily: 'Sora',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
