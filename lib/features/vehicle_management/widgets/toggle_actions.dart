import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'custom_toggle_buttons.dart';

class ToggleActions extends StatelessWidget {
  final String exportValue;
  final String reportValue;
  final String updateValue;
  final String deleteValue;
  final VoidCallback onExport;
  final VoidCallback onUpdate;
  final VoidCallback onReport;
  final VoidCallback onDelete;

  const ToggleActions({
    super.key,
    required this.exportValue,
    required this.reportValue,
    required this.deleteValue,
    required this.updateValue,
    required this.onExport,
    required this.onUpdate,
    required this.onReport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Toggle actions:',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.horizontal(size: AppFontSizes.medium),
        CustomToggleButtons(
          title: 'Export QR Codes',
          value: exportValue,
          color: AppColors.primary,
          onTap: onExport,
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
          title: 'Report Selected',
          value: reportValue,
          color: AppColors.error,
          onTap: onReport,
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
