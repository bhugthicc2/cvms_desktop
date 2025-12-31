import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SelectedTile extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Original design dimensions (235x126 for 3 tiles)
    final originalWidth = 235.0;
    final originalHeight = 126.0;

    // Only scale width, keep height at 126 (3 tiles)
    final scaleX = size.width / originalWidth;
    // Don't scale height - we want it to always be 126 (3 tiles tall)

    // Scale the canvas only on X axis
    canvas.save();
    canvas.scale(scaleX, 1.0);

    // Background is transparent - only draw the path shape
    // Path updated to use 126 height (3 tiles × 42)
    Path path_1 = Path();
    path_1.moveTo(originalWidth, originalHeight);
    path_1.cubicTo(
      originalWidth,
      originalHeight - 12.598,
      225.598,
      originalHeight - 22,
      214,
      originalHeight - 22,
    );
    path_1.lineTo(22, originalHeight - 22);
    path_1.cubicTo(
      10.402,
      originalHeight - 22,
      1,
      originalHeight - 31.402,
      1,
      originalHeight - 43,
    );
    path_1.cubicTo(
      1,
      originalHeight - 54.598,
      10.402,
      originalHeight - 64,
      22,
      originalHeight - 64,
    );
    path_1.lineTo(214, originalHeight - 64);
    path_1.cubicTo(
      225.263,
      originalHeight - 64,
      234.454,
      originalHeight - 72.8664,
      234.976,
      originalHeight - 84,
    );
    path_1.lineTo(originalWidth, originalHeight - 84);
    path_1.lineTo(originalWidth, originalHeight);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = AppColors.greySurface.withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
