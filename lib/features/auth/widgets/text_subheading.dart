import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class TextSubHeading extends StatelessWidget {
  final String text;
  const TextSubHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Sora',
        color: AppColors.grey,
        fontWeight: FontWeight.w400,
        fontSize: AppFontSizes.small,
      ),
    );
  }
}
