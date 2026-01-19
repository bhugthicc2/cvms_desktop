import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/buttons/custom_view_button.dart';
import 'package:flutter/material.dart';

class DashboardTable extends StatelessWidget {
  const DashboardTable({
    super.key,
    required this.child,
    required this.tableTitle,
    required this.onClick,
  });

  final Widget child;
  final String tableTitle;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: cardDecoration(),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  tableTitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                CustomViewButton(onTap: onClick),
              ],
            ),
            Spacing.vertical(size: AppSpacing.small),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
