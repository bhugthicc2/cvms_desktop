import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:cvms_desktop/core/widgets/navigation/custom_breadcrumb.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PdfPreviewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onDownLoadPressed;
  final VoidCallback onPrintPressed;
  final VoidCallback onEditPressed;
  final VoidCallback toggleFitMode;
  final VoidCallback? toggleChartTableMode;
  final bool isFitToWidth;
  final bool isChart;
  final double kToolbarHeight;
  final String? title;
  final List<BreadcrumbItem> breadcrumbs;

  const PdfPreviewAppBar({
    super.key,
    required this.onBackPressed,
    this.title,
    required this.onDownLoadPressed,
    required this.onPrintPressed,
    this.kToolbarHeight = 35,
    required this.onEditPressed,
    required this.toggleFitMode,
    this.toggleChartTableMode,
    this.breadcrumbs = const [],
    required this.isFitToWidth,
    required this.isChart,
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
                title ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

      leading: CustomIconButton(onTap: onBackPressed, icon: Icons.chevron_left),

      actions: [
        if (toggleChartTableMode != null) ...[
          Tooltip(
            message: isChart ? 'Switch to Table View' : 'Switch to Chart View',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIconsRegular.chartBar,
                    size: 20,
                    color: isChart ? AppColors.primary : AppColors.grey,
                  ),
                  const SizedBox(width: 4),
                  Transform.scale(
                    scaleY: 0.7, // reduce height
                    scaleX: 0.7, // optional: keep proportions
                    child: Switch(
                      trackColor: WidgetStatePropertyAll(AppColors.greySurface),
                      thumbColor: WidgetStatePropertyAll(AppColors.primary),
                      trackOutlineColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      value: isChart,
                      onChanged: (_) => toggleChartTableMode!(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    PhosphorIconsRegular.table,
                    size: 20,
                    color: !isChart ? AppColors.primary : AppColors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
        ],
        Tooltip(
          message: 'Toggle fit to width',
          child: CustomIconButton(
            onTap: toggleFitMode,
            icon:
                isFitToWidth
                    ? PhosphorIconsRegular.arrowsOut
                    : PhosphorIconsRegular.arrowsIn,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Tooltip(
          message: 'Edit PDF Report Templte',
          child: CustomIconButton(
            onTap: onEditPressed,
            icon: PhosphorIconsRegular.penNib,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Tooltip(
          message: 'Save/Download report',
          child: CustomIconButton(
            onTap: onDownLoadPressed,
            icon: PhosphorIconsRegular.download,
          ),
        ),

        const SizedBox(width: AppSpacing.medium),
        Tooltip(
          message: 'Print report',
          child: CustomIconButton(
            onTap: onPrintPressed,
            icon: PhosphorIconsRegular.printer,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
      ],
    );
  }
}
