import 'package:flutter/material.dart';

class HoverSlide extends StatefulWidget {
  final Widget child;
  final double hoverScale;
  final Duration duration;
  final VoidCallback? onTap;
  final MouseCursor? cursor;

  const HoverSlide({
    super.key,
    required this.child,
    this.hoverScale = 1.05,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
    this.cursor,
  });

  @override
  State<HoverSlide> createState() => _HoverSlideState();
}

class _HoverSlideState extends State<HoverSlide> {
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
        child: AnimatedSlide(
          offset: _isHovered ? Offset(0.1, 0) : Offset(0, 0),
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
