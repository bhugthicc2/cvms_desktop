import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomWindowTitleBar extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;
  final bool adaptiveIconContrast;

  const CustomWindowTitleBar({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = AppColors.white,
    this.leading,
    this.actions,
    this.height = 38.0,
    this.adaptiveIconContrast = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackground =
        backgroundColor.opacity > 0
            ? backgroundColor
            : Theme.of(context).scaffoldBackgroundColor;

    final bool isLightBg =
        ThemeData.estimateBrightnessForColor(effectiveBackground) ==
        Brightness.light;
    final Color adaptiveIconColor =
        isLightBg ? AppColors.black : AppColors.white;
    final Color effectiveIconColor =
        adaptiveIconContrast ? adaptiveIconColor : textColor;

    final Color hoverOverlay =
        isLightBg
            ? AppColors.black.withValues(alpha: 0.06)
            : AppColors.white.withValues(alpha: 0.08);
    final Color pressOverlay =
        isLightBg
            ? AppColors.black.withValues(alpha: 0.12)
            : AppColors.white.withValues(alpha: 0.16);

    final windowButtonColors = WindowButtonColors(
      iconNormal: effectiveIconColor,
      iconMouseOver: adaptiveIconColor,
      iconMouseDown: adaptiveIconColor,
      normal: Colors.transparent,
      mouseOver: hoverOverlay,
      mouseDown: pressOverlay,
    );

    final closeButtonColors = WindowButtonColors(
      iconNormal: effectiveIconColor,
      iconMouseOver: AppColors.white,
      iconMouseDown: AppColors.white,
      normal: Colors.transparent,
      mouseOver:
          isLightBg
              ? Colors.red.withValues(alpha: 0.85)
              : Colors.red.withValues(alpha: 0.70),
      mouseDown: Colors.red,
    );

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
            MinimizeWindowButton(colors: windowButtonColors),
            MaximizeWindowButton(colors: windowButtonColors),
            CloseWindowButton(colors: closeButtonColors),
          ],
        ),
      ),
    );
  }
}

void initializeWindowProperties({
  Size initialSize = const Size(1020, 800),
  Size? minSize,
  Size? maxSize,
  Alignment alignment = Alignment.center,
}) {
  doWhenWindowReady(() {
    final win = appWindow;
    win.size = initialSize;
    if (minSize != null) win.minSize = minSize;
    if (maxSize != null) win.maxSize = maxSize;
    win.alignment = alignment;
    win.show();
  });
}
