import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:flutter/material.dart';

class CustomSidebarTile extends StatefulWidget {
  final NavItem item;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback hover;
  final bool isStencil;

  const CustomSidebarTile({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    required this.hover,
    this.isStencil = true,
  });

  @override
  State<CustomSidebarTile> createState() => _CustomSidebarTileState();
}

class _CustomSidebarTileState extends State<CustomSidebarTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(999),
            bottomLeft: Radius.circular(999),
          ),
        ),
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 50 * 0.25,
          vertical: 11,
        ),
        child: HoverSlide(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: [
              Image.asset(
                widget.isStencil
                    ? "assets/icons/stencil/${widget.item.icon}"
                    : "assets/icons/${widget.item.icon}",
                height: 20,
                width: 20,
                color: widget.isSelected ? AppColors.primary : null,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: widget.isExpanded ? 1.0 : 0.0,
                  child:
                      widget.isExpanded
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 15.0),
                              Flexible(
                                child: Text(
                                  widget.item.label,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: AppFontSizes.small - 1,
                                    color:
                                        widget.isSelected
                                            ? AppColors.primary
                                            : (widget.labelColor ??
                                                AppColors.white),
                                    fontWeight:
                                        widget.isSelected
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
    );
  }

  Color _getBackgroundColor() {
    // Don't show background color when selected (custom painter handles it)
    if (widget.isSelected) {
      return Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }
}
