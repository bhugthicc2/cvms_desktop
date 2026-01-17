import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CustomViewTitle extends StatelessWidget {
  final String viewTitle;
  final VoidCallback onBackClick;

  const CustomViewTitle({
    super.key,
    required this.viewTitle,
    required this.onBackClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(onTap: onBackClick, icon: Icons.arrow_back),
        Spacing.horizontal(size: AppSpacing.medium),
        Text(
          viewTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
