import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomWindowTitleBar {}

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
