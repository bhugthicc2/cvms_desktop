import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsPageHeader extends StatelessWidget {
  final String title;

  const SettingsPageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
