import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  final String text;
  const TextHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: AppFontSizes.xxxLarge,
      ),
    );
  }
}
