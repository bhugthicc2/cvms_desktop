import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:flutter/material.dart';

class CustomSidebarTile extends StatelessWidget {
  final NavItem item;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showActiveBorder;
  final Color? iconColor;
  final Color labelColor;
  final bool isStencil;

  const CustomSidebarTile({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
    required this.showActiveBorder,
    this.iconColor,
    required this.labelColor,
    this.isStencil = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        decoration: BoxDecoration(
          color:
              isSelected && showActiveBorder
                  ? AppColors.white.withValues(alpha: 0.2)
                  : Colors.transparent,
          border: Border(
            left: BorderSide(
              width: 6,
              color:
                  isSelected && showActiveBorder
                      ? AppColors.primary
                      : Colors.transparent,
            ),
          ),
        ),
        child: HoverSlide(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50 * 0.160,
              vertical: 11,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Image.asset(
                    isStencil
                        ? "assets/icons/stencil/${item.icon}"
                        : "assets/icons/${item.icon}",
                    height: 20,
                    width: 20,

                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
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
                                      fontFamily: 'Poppins',
                                      fontSize: AppFontSizes.small - 1,
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : labelColor,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
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
        ),
      ),
    );
  }
}
