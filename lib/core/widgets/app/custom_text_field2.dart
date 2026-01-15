import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final IconData? prefixIcon;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;

  const CustomTextField2({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.borderColor = Colors.blue,
    this.borderRadius = 5.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.fontSize = AppFontSizes.small,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.black.withValues(alpha: 0.9),
              ),
            ),
            Text(
              " * ",
              style: TextStyle(
                fontSize: fontSize + 2,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        Spacing.vertical(size: AppSpacing.small),
        TextFormField(
          cursorRadius: Radius.circular(5),
          cursorColor: AppColors.primary,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey, fontSize: fontSize),
            prefixIcon:
                prefixIcon != null
                    ? Icon(prefixIcon, color: Colors.grey)
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
          ),
        ),
      ],
    );
  }
}
