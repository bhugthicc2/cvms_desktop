import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomWindowTitleBar extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;

  const CustomWindowTitleBar({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = AppColors.white,
    this.leading,
    this.actions,
    this.height = 38.0,
  });

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        height: height,
        decoration: BoxDecoration(color: backgroundColor),
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(
              child: MoveWindow(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                ),
              ),
            ),
            if (actions != null) ...actions!,
            MinimizeWindowButton(),
            MaximizeWindowButton(),
            CloseWindowButton(),
          ],
        ),
      ),
    );
  }
}

void initializeWindowProperties({
  required String title,
  Size initialSize = const Size(800, 600),
  Size? minSize,
  Size? maxSize,
  Alignment alignment = Alignment.center,
}) {
  doWhenWindowReady(() {
    final win = appWindow;
    win.title = title;
    win.size = initialSize;
    if (minSize != null) win.minSize = minSize;
    if (maxSize != null) win.maxSize = maxSize;
    win.alignment = alignment;
    win.show();
  });
}
