import 'package:cvms_desktop/core/theme/sidebar_theme.dart';
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
  final bool isLogoutTile;
  final bool isStencil;
  final double dx;

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
    this.isLogoutTile = false,
    this.dx = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = SidebarTheme.fromCubit(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5.0, top: 5),
        child: AnimatedContainer(
          duration: sidebarTheme.tileAnimationDuration,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sidebarTheme.tileBorderRadius),
            color:
                isSelected && showActiveBorder
                    ? sidebarTheme.selectedTileBackground
                    : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: sidebarTheme.activeIndicatorWidth,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? sidebarTheme.activeIndicator
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    sidebarTheme.tileBorderRadius,
                  ),
                ),
              ),
              Expanded(
                child: HoverSlide(
                  dx: dx,
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50 * 0.160,
                      vertical: sidebarTheme.tileVerticalPadding,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Opacity(
                            opacity:
                                isSelected
                                    ? 1.0
                                    : sidebarTheme.unselectedIconOpacity,
                            child: Image.asset(
                              isStencil
                                  ? "assets/icons/stencil/${item.icon}"
                                  : "assets/icons/${item.icon}",
                              height: 20,
                              width: 20,
                              color:
                                  isSelected
                                      ? sidebarTheme.selectedIcon
                                      : (isLogoutTile
                                          ? sidebarTheme.logoutIcon
                                          : sidebarTheme.defaultIcon),
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: sidebarTheme.expansionAnimationDuration,
                          child: AnimatedOpacity(
                            duration: sidebarTheme.opacityAnimationDuration,
                            opacity: isExpanded ? 1.0 : 0.0,
                            child:
                                isExpanded
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: sidebarTheme.iconTextSpacing,
                                        ),
                                        Flexible(
                                          child: Text(
                                            item.label,
                                            style:
                                                isLogoutTile
                                                    ? sidebarTheme
                                                        .logoutLabelTextStyle
                                                    : sidebarTheme
                                                        .labelTextStyle
                                                        .copyWith(
                                                          color:
                                                              isSelected
                                                                  ? sidebarTheme
                                                                      .selectedText
                                                                  : sidebarTheme
                                                                      .primaryText
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                          fontWeight:
                                                              isLogoutTile ||
                                                                      isSelected
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
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
            ],
          ),
        ),
      ),
    );
  }
}
