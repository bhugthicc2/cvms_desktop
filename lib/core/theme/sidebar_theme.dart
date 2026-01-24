import 'package:cvms_desktop/core/bloc/sidebar_theme_cubit.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Professional sidebar theme system supporting light and dark modes
class SidebarTheme {
  final bool isDark;

  const SidebarTheme({required this.isDark});

  static const light = SidebarTheme(isDark: false);
  static const dark = SidebarTheme(isDark: true);

  // ================= BACKGROUNDS =================

  Color get background => isDark ? AppColors.tableHeaderColor : AppColors.white;

  Color get headerBackground =>
      isDark ? AppColors.darkBlue : const Color(0xFF0A0347);

  Color get selectedTileBackground =>
      isDark
          ? AppColors.white.withValues(alpha: 0.15)
          : AppColors.grey.withValues(alpha: 0.1);

  Color get hoverTileBackground =>
      isDark
          ? AppColors.white.withValues(alpha: 0.08)
          : AppColors.white.withValues(alpha: 0.12);

  // ================= BORDERS & DIVIDERS =================

  Color get headerBorder =>
      isDark
          ? AppColors.dividerColor.withValues(alpha: 0.5)
          : AppColors.dividerColor;

  Color get dividerColor =>
      isDark ? AppColors.grey : const Color(0xFFBEC8ED).withValues(alpha: 0.4);

  Color get activeIndicator => AppColors.chartOrange;

  // ================= TEXT =================

  Color get primaryText => isDark ? AppColors.white : AppColors.black;

  Color get secondaryText =>
      isDark
          ? AppColors.white.withValues(alpha: 0.8)
          : AppColors.white.withValues(alpha: 0.7);

  Color get selectedText => AppColors.chartOrange.withValues(alpha: 0.9);

  Color get headerText => isDark ? AppColors.white : AppColors.darkBlue;

  Color get logoAccent => AppColors.yellow;

  Color get logoutText => AppColors.error;

  // ================= ICONS =================

  Color get defaultIcon => isDark ? AppColors.white : AppColors.black;

  Color get selectedIcon => AppColors.chartOrange;

  Color get logoutIcon => AppColors.error;

  double get unselectedIconOpacity => 0.8;

  // ================= VISUAL =================

  double get tileBorderRadius => 5.0;
  double get activeIndicatorWidth => 3.0;

  List<BoxShadow> get sidebarShadow => [
    BoxShadow(
      color: AppColors.black.withValues(alpha: isDark ? 0.3 : 0.1),
      blurRadius: isDark ? 10 : 8,
      offset: const Offset(2, 0),
    ),
  ];

  // ================= ANIMATIONS =================

  Duration get tileAnimationDuration => const Duration(milliseconds: 200);

  Duration get expansionAnimationDuration => const Duration(milliseconds: 300);

  Duration get opacityAnimationDuration => const Duration(milliseconds: 200);

  // ================= GRADIENT =================

  LinearGradient? get backgroundGradient =>
      isDark
          ? null
          : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.darkBlue, AppColors.darkBlue],
            stops: [0.0, 1.0],
          );

  // ================= TYPOGRAPHY =================

  TextStyle get labelTextStyle =>
      TextStyle(fontFamily: 'Inter', fontSize: 14, color: primaryText);

  TextStyle get selectedLabelTextStyle => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: selectedText,
    fontWeight: FontWeight.w600,
  );

  TextStyle get logoutLabelTextStyle => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: logoutText,
    fontWeight: FontWeight.w600,
  );

  TextStyle get headerTextStyle => TextStyle(
    fontFamily: 'Groote',
    fontSize: 14,
    color: headerText,
    fontWeight: FontWeight.bold,
  );

  TextStyle get logoTextStyle => TextStyle(
    fontFamily: 'Groote',
    fontSize: 14,
    color: logoAccent,
    fontWeight: FontWeight.bold,
  );

  // ================= SPACING =================

  double get tileHorizontalPadding => 8.0;
  double get tileVerticalPadding => 11.0;
  double get iconTextSpacing => 15.0;
  double get headerPadding => 9.0;

  // ================= UTILITIES =================

  factory SidebarTheme.fromCubit(BuildContext context) {
    final isDark = context.select(
      (SidebarThemeCubit cubit) => cubit.state.isDark,
    );
    return SidebarTheme(isDark: isDark);
  }

  factory SidebarTheme.fromBrightness(Brightness brightness) {
    return SidebarTheme(isDark: brightness == Brightness.dark);
  }

  factory SidebarTheme.of(BuildContext context) {
    return SidebarTheme.fromBrightness(Theme.of(context).brightness);
  }

  Map<String, dynamic> toMap() => {
    'isDark': isDark,
    'background': background.r,
    'headerBackground': headerBackground.r,
    'selectedTileBackground': selectedTileBackground.r,
    'primaryText': primaryText.r,
    'selectedText': selectedText.r,
    'activeIndicator': activeIndicator.r,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SidebarTheme && other.isDark == isDark;

  @override
  int get hashCode => isDark.hashCode;

  @override
  String toString() => 'SidebarTheme(isDark: $isDark)';
}
