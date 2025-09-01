import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? routeName;
  final TextStyle? textStyle;
  final Color? textColor;
  final double? fontSize;
  final double? fontWeight;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.routeName,
    this.textStyle,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed?.call();
        if (routeName != null) {
          Navigator.pushNamed(context, routeName!);
        }
      },
      child: Text(
        text,
        style:
            textStyle ??
            TextStyle(
              fontSize: fontSize ?? AppFontSizes.small,
              color: textColor ?? AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
