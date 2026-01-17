import 'package:flutter/material.dart';

class AnimatedSwitcher extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Widget Function(Widget child, Animation<double> animation)?
  transitionBuilder;

  const AnimatedSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.transitionBuilder,
  });

  @override
  State<AnimatedSwitcher> createState() => _AnimatedSwitcherState();
}

class _AnimatedSwitcherState extends State<AnimatedSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AnimatedSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transitionBuilder != null) {
      return widget.transitionBuilder!(widget.child, _animation);
    }

    // Default slide transition from right to left
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Slide from right
        end: Offset.zero,
      ).animate(_animation),
      child: widget.child,
    );
  }
}
