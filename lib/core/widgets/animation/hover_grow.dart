import 'package:flutter/material.dart';

class HoverGrow extends StatefulWidget {
  final Widget child;
  final double hoverScale;
  final Duration duration;
  final VoidCallback? onTap;
  final MouseCursor? cursor;

  const HoverGrow({
    super.key,
    required this.child,
    this.hoverScale = 1.05,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
    this.cursor,
  });

  @override
  State<HoverGrow> createState() => _HoverGrowState();
}

class _HoverGrowState extends State<HoverGrow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.cursor ??
          (widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic),
      opaque: true,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.hoverScale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
