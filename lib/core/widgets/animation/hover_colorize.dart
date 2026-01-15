import 'package:flutter/material.dart';

class HoverOpacity extends StatefulWidget {
  final Widget child;
  final double hoverOpacity;
  final Duration duration;
  final VoidCallback? onTap;
  final MouseCursor? cursor;

  const HoverOpacity({
    super.key,
    required this.child,
    this.hoverOpacity = 0.5,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
    this.cursor,
  });

  @override
  State<HoverOpacity> createState() => _HoverOpacityState();
}

class _HoverOpacityState extends State<HoverOpacity> {
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
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: _isHovered ? widget.hoverOpacity : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}
