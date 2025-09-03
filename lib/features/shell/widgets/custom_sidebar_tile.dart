import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:flutter/material.dart';

class CustomSidebarTile extends StatelessWidget {
  final NavItem item;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const CustomSidebarTile({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        color:
            isSelected
                ? AppColors.white.withValues(alpha: 0.2)
                : Colors.transparent,
        child: Row(
          children: [
            Icon(item.icon, color: iconColor ?? AppColors.white, size: 24),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isExpanded ? 1.0 : 0.0,
                child:
                    isExpanded
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 15.0),
                            Flexible(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  color: labelColor ?? AppColors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
