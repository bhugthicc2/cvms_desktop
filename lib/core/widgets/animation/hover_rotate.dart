import 'package:flutter/material.dart';

class HoverRotate extends StatefulWidget {
  final Widget child;
  final double angle; // rotation in radians
  final Duration duration;
  final VoidCallback? onTap;

  const HoverRotate({
    super.key,
    required this.child,
    this.angle = 0.05, // ~3 degrees
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
  });

  @override
  State<HoverRotate> createState() => _HoverRotateState();
}

class _HoverRotateState extends State<HoverRotate> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedRotation(
          turns: _isHovered ? widget.angle / (2 * 3.1415926535) : 0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
