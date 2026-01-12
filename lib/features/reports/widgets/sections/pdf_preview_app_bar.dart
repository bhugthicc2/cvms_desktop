import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/navigation/custom_breadcrumb.dart';
import 'package:cvms_desktop/features/reports/widgets/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PdfPreviewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onDownLoadPressed;
  final VoidCallback onPrintPressed;
  final VoidCallback onEditPressed;
  final VoidCallback toggleFitMode;
  final bool isFitToWidth;
  final double kToolbarHeight;
  final String title;
  final List<BreadcrumbItem> breadcrumbs;

  const PdfPreviewAppBar({
    super.key,
    required this.onBackPressed,
    required this.title,
    required this.onDownLoadPressed,
    required this.onPrintPressed,
    this.kToolbarHeight = 35,
    required this.onEditPressed,
    required this.toggleFitMode,
    this.breadcrumbs = const [],
    required this.isFitToWidth,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      toolbarHeight: kToolbarHeight,
      titleSpacing: 0,
      title:
          breadcrumbs.isNotEmpty
              ? CustomBreadcrumb(items: breadcrumbs)
              : Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

      leading: CustomIconButton(onTap: onBackPressed, icon: Icons.chevron_left),

      actions: [
        CustomIconButton(
          onTap: toggleFitMode,
          icon:
              isFitToWidth
                  ? PhosphorIconsRegular.arrowsOut
                  : PhosphorIconsRegular.arrowsIn,
        ),
        const SizedBox(width: AppSpacing.medium),
        CustomIconButton(
          onTap: onEditPressed,
          icon: PhosphorIconsRegular.penNib,
        ),
        const SizedBox(width: AppSpacing.medium),
        CustomIconButton(
          onTap: onDownLoadPressed,
          icon: PhosphorIconsRegular.download,
        ),

        const SizedBox(width: AppSpacing.medium),
        CustomIconButton(
          onTap: onPrintPressed,
          icon: PhosphorIconsRegular.printer,
        ),
        const SizedBox(width: AppSpacing.medium),
      ],
    );
  }
}
