import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: Text('TODO: Reports Page Content')),
        ),
      ),
    );
  }
}
