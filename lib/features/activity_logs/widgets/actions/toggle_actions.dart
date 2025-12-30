import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import '../buttons/custom_toggle_buttons.dart';

class ToggleActions extends StatelessWidget {
  final String exportValue;
  final String updateValue;
  final String deleteValue;
  final String resetValue;
  final VoidCallback onExport;
  final VoidCallback onUpdate;
  final VoidCallback onReset;
  final VoidCallback onDelete;

  const ToggleActions({
    super.key,
    required this.exportValue,
    required this.deleteValue,
    required this.updateValue,
    required this.resetValue,
    required this.onExport,
    required this.onUpdate,
    required this.onDelete,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Toggle actions:',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
        ),
        Spacing.horizontal(size: AppFontSizes.medium),
        CustomToggleButtons(
          title: 'Update Status',
          value: updateValue,
          color: AppColors.success,
          onTap: onUpdate,
        ),
        Spacing.horizontal(size: AppFontSizes.medium),
        CustomToggleButtons(
          title: 'Reset Password',
          value: resetValue,
          color: AppColors.error,
          onTap: onReset,
        ),
        Spacing.horizontal(size: AppFontSizes.medium),
        CustomToggleButtons(
          title: 'Delete Selected',
          value: deleteValue,
          color: AppColors.error,
          onTap: onDelete,
        ),
      ],
    );
  }
}
