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
  final String icon;
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsSectionTitle(icon: icon, title: title),
        Container(
          decoration: _sectionDecoration(),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String icon;
  final String title;

  const SettingsSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.vertical(size: AppSpacing.medium),
        Row(
          children: [
            Image.asset(
              'assets/icons/windows/$icon.png',
              width: 24,
              height: 24,
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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

class SettingsActionRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const SettingsActionRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class SettingsToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
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
          Expanded(
            child: Text(
              value ? 'Enabled' : 'Disabled',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class SettingsDropdownRow<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const SettingsDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
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
          Expanded(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsInputRow extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool readOnly;

  const SettingsInputRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.readOnly = false,
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
          Expanded(
            child: TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              readOnly: readOnly,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: readOnly ? InputBorder.none : OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
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
