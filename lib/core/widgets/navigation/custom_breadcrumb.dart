import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
    this.isActive = false,
  });
}

class CustomBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final String separator;

  const CustomBreadcrumb({
    super.key,
    required this.items,
    this.separator = '/',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildBreadcrumbItems(),
    );
  }

  List<Widget> _buildBreadcrumbItems() {
    final List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // Add breadcrumb item
      widgets.add(
        MouseRegion(
          cursor:
              item.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            onTap: item.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color:
                      item.isActive
                          ? AppColors.primary
                          : (item.onTap != null
                              ? AppColors.black
                              : AppColors.grey),
                  fontWeight: item.isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );

      // Add separator (except for last item)
      if (i < items.length - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              separator,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
