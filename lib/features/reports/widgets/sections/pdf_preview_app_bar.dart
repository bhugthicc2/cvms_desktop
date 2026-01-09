import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';

class PdfPreviewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onDownLoadPressed;
  final VoidCallback onPrintPressed;
  final double kToolbarHeight;
  final String title;
  const PdfPreviewAppBar({
    super.key,
    required this.onBackPressed,
    required this.title,
    required this.onDownLoadPressed,
    required this.onPrintPressed,
    this.kToolbarHeight = 35,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      toolbarHeight: kToolbarHeight,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),

      leading: CustomIconButton(onTap: onBackPressed, icon: Icons.chevron_left),

      actions: [
        CustomIconButton(onTap: onDownLoadPressed, icon: Icons.download),

        const SizedBox(width: AppSpacing.medium),
        CustomIconButton(onTap: onPrintPressed, icon: Icons.print),
        const SizedBox(width: AppSpacing.medium),
      ],
    );
  }
}
