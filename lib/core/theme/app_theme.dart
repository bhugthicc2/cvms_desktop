import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: GoogleFonts.interTextTheme(),
    elevatedButtonTheme: _elevatedButtonTheme(
      background: AppColors.primary,
      foreground: AppColors.white,
    ),
    scrollbarTheme: _scrollbarTheme(
      thumb: AppColors.primary.withValues(alpha: 0.7),
      track: AppColors.grey.withValues(alpha: 0.5),
    ),
    inputDecorationTheme: _inputTheme(
      borderColor: AppColors.grey,
      focusedColor: AppColors.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBlue,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    elevatedButtonTheme: _elevatedButtonTheme(
      background: AppColors.primary,
      foreground: AppColors.white,
    ),
    scrollbarTheme: _scrollbarTheme(
      thumb: AppColors.primary.withValues(alpha: 0.6),
      track: AppColors.black.withValues(alpha: 0.4),
    ),
    inputDecorationTheme: _inputTheme(
      borderColor: AppColors.grey.withValues(alpha: 0.6),
      focusedColor: AppColors.primary,
    ),
  );

  // ===== Shared builders (keeps things DRY) =====

  static ElevatedButtonThemeData _elevatedButtonTheme({
    required Color background,
    required Color foreground,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: AppFontSizes.medium,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static ScrollbarThemeData _scrollbarTheme({
    required Color thumb,
    required Color track,
  }) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(thumb),
      trackColor: WidgetStateProperty.all(track),
      radius: const Radius.circular(999),
      thickness: WidgetStateProperty.all(8),
      interactive: true,
    );
  }

  static InputDecorationTheme _inputTheme({
    required Color borderColor,
    required Color focusedColor,
  }) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: focusedColor, width: 1),
      ),
    );
  }
}
