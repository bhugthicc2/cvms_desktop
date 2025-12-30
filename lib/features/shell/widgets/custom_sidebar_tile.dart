import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
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

  const CustomSidebarTile({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    required this.hover,
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
      child: HoverGrow(
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

          child: Row(
            children: [
              Image.asset(widget.item.icon, height: 24, width: 24),
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
                                    color: widget.labelColor ?? AppColors.white,
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
    if (widget.isSelected) {
      return AppColors.white.withValues(alpha: 0.2);
    } else if (_isHovered) {
      return AppColors.white.withValues(alpha: 0.1);
    } else {
      return Colors.transparent;
    }
  }
}
