import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/features/shell/models/nav_item.dart';
import 'package:cvms_desktop/features/shell/widgets/selected_tile.dart';
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        widget.hover();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Custom selected tile painter (only when selected)
            // Positioned to start 2 tiles above (to cover 3 tiles total)
            // Each tile is 42px, so we need to go up 84px (2 tiles)
            if (widget.isSelected)
              Positioned(
                top:
                    -63.0, // centered ( 2 tiles = 84, so 84 + 42 = 126, 3 tiles, 42 =  1 tile, 42 / 2 = 21, so to center it 42 + 21 =)
                left: 0,
                right: 0,
                height: 126.0, // Fixed height for 3 tiles (42 × 3)
                child: CustomPaint(
                  painter: SelectedTile(),
                  size: Size.infinite,
                ),
              ),
            // Content layer
            AnimatedContainer(
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
              child: HoverGrow(
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
                                          fontSize: AppFontSizes.small - 1,
                                          color:
                                              widget.isSelected
                                                  ? AppColors.primary
                                                  : (widget.labelColor ??
                                                      AppColors.white),
                                          fontWeight:
                                              widget.isSelected
                                                  ? FontWeight.w600
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
          ],
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
