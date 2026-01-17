import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class SettingsDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const SettingsDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppColors.grey),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsSectionTitle(title: title),
        Container(
          decoration: _sectionDecoration(),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.vertical(size: AppSpacing.medium),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        CustomDivider(
          direction: Axis.horizontal,
          thickness: 1,
          color: AppColors.dividerColor.withValues(alpha: 0.4),
        ),
        Spacing.vertical(size: AppSpacing.medium),
      ],
    );
  }
}

BoxDecoration _sectionDecoration() {
  return BoxDecoration(
    border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.7)),
    color: AppColors.white,
    borderRadius: BorderRadius.circular(5),
  );
}
