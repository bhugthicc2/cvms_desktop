import 'package:flutter/material.dart';

class HoverShine extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const HoverShine({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.onTap,
  });

  @override
  State<HoverShine> createState() => _HoverShineState();
}

class _HoverShineState extends State<HoverShine> {
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
        child: Stack(
          children: [
            widget.child,

            // Shine layer
            AnimatedPositioned(
              duration: widget.duration,
              left: _isHovered ? MediaQuery.of(context).size.width : -200,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
