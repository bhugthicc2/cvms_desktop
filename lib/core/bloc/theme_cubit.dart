import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.light));

  void toggleTheme() {
    emit(
      state.themeMode == ThemeMode.dark
          ? const ThemeState(ThemeMode.light)
          : const ThemeState(ThemeMode.dark),
    );
  }

  void setDark() => emit(const ThemeState(ThemeMode.dark));
  void setLight() => emit(const ThemeState(ThemeMode.light));
  void setSystem() => emit(const ThemeState(ThemeMode.system));
}
