import 'package:flutter/material.dart';

class AppColors {
  //color feedback

  static const Color successLight = Color(0x664CAF50);
  static const Color neutral = Color(0xFF2196F3);
  static const Color neutralLight = Color(0x662196F3);
  static const Color errorLight = Color(0x66E57373);

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
  static const Color chartGreenv2 = Color(0xFF53C6BA);
  static const Color donutBlue = Color(0xFF2563EB);
  static const Color donutPurple = Color(0xFFC084FC);
  static const Color donutPink = Color(0xFFF285BA);

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
  //secondary gradients
  static const Gradient greenWhite = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xFF14B8A6), Color(0xFF53C6BA)],
  );

  static const Gradient yellowWhite = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xFFF6A318), Color(0xFFF8B951)],
  );

  static const Gradient blueWhite = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xFF1F5AF1), Color(0xFF5782F3)],
  );

  static const Gradient pinkWhite = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xFFEC4899), Color(0xFFF285BA)],
  );
}
