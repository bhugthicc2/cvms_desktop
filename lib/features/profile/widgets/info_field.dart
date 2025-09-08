import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  const InfoField({
    super.key,
    required this.label,
    this.controller,
    this.value,
    required this.icon,
    required this.enabled,
  });

  final String label;
  final TextEditingController? controller;
  final String? value;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        Spacing.vertical(size: AppSpacing.xSmall),
        CustomTextField(
          controller: controller ?? TextEditingController(text: value ?? ''),
          enabled: enabled,
          prefixIcon: icon,
          fillColor: enabled ? AppColors.white : AppColors.greySurface,
          borderColor: enabled ? AppColors.grey : AppColors.dividerColor,
        ),
      ],
    );
  }
}
