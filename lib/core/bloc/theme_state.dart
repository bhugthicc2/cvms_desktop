import 'package:flutter/material.dart';

@immutable
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  bool get isDark => themeMode == ThemeMode.dark;
}
