import 'package:flutter_bloc/flutter_bloc.dart';
import 'sidebar_theme_state.dart';

class SidebarThemeCubit extends Cubit<SidebarThemeState> {
  SidebarThemeCubit() : super(const SidebarThemeState(isDark: true));

  void toggle() {
    emit(SidebarThemeState(isDark: !state.isDark));
  }

  void setDark() => emit(const SidebarThemeState(isDark: true));
  void setLight() => emit(const SidebarThemeState(isDark: false));
}
