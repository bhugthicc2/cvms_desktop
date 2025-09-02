import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:flutter/material.dart';

class CustomSidebarTile extends StatelessWidget {
  final NavItem item;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomSidebarTile({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color:
            isSelected
                ? AppColors.white.withValues(alpha: 0.2)
                : Colors.transparent,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(item.icon, color: AppColors.white),
            if (isExpanded) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
