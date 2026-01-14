import 'package:flutter/material.dart';

class HoverSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;
  final MouseCursor? cursor;
  final double dx;
  final double dy;

  const HoverSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
    this.cursor,
    this.dx = 0.1,
    this.dy = 0.0,
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
          offset: _isHovered ? Offset(widget.dx, widget.dy) : Offset(0, 0),
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
