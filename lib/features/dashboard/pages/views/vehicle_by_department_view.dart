import 'package:cvms_desktop/core/widgets/app/custom_view_title.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';

class VehicleByDepartmentView extends StatefulWidget {
  final VoidCallback onBackPressed;
  const VehicleByDepartmentView({super.key, required this.onBackPressed});

  @override
  State<VehicleByDepartmentView> createState() =>
      _VehicleByDepartmentViewState();
}

class _VehicleByDepartmentViewState extends State<VehicleByDepartmentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomViewTitle(
              viewTitle: 'Vehicle Distribution by Department',
              onBackPressed: widget.onBackPressed,
            ),

            const SizedBox(height: AppSpacing.medium),
            Expanded(child: Center(child: Text('TODO'))),
          ],
        ),
      ),
    );
  }
}
