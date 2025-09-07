import 'package:flutter/material.dart';

class AppColors {
  // Primary proj colors
  static const Color primary = Color(0xFF1F5AF1);
  static const Color secondary = Color(0xFF1E1E1E);
  static const Color greySurface = Color(0xFFF2F4FA);

  // neutral proj colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1E1E1E);
  static const Color grey = Color(0XFF7E818D);
  static const Color dividerColor = Color(0xFFBEC8ED);
  static const Color yellow = Color(0xFFF7D22F);
  static const Color orange = Color(0xFFEF4126);

  // Feedback colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  //Others
  static const Color darkBlue = Color(0xFF050132);
  static const Color sidebarheaderSub = Color(0xFFD9D9D9);
  static const Color lineColor = Color(0xFFB5B5B5);
  static const Color tableHeaderColor = Color(0xFF0D046D);

  //chart colors
  static const Color chartOrange = Color(0xFFFB923C);
  static const Color chartGreen = Color(0xFF22C55E);
  static const Color donutBlue = Color(0xFF2563EB);
  static const Color donutPurple = Color(0xFFC084FC);

  //gradients
  static const LinearGradient blueViolet = LinearGradient(
    colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightBlue = LinearGradient(
    colors: [Color(0xFF274898), Color(0xFF00AEEF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yellowOrange = LinearGradient(
    colors: [Color(0xFFEF4126), Color(0xFFFBB040)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleBlue = LinearGradient(
    colors: [Color(0xFFFF00D4), Color(0xFF00DDFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
