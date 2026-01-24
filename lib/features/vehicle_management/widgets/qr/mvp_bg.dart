import 'package:flutter/material.dart';

/// Motor Vehicle Pass background shape
class MotorVehiclePassBackground extends CustomPainter {
  static const Color _backgroundColor = Color(0xFF2B0096);
  static const double _cornerRadius = 35;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = _backgroundColor;

    final path = Path();

    // Start (right-middle notch)
    path.moveTo(size.width - 48.51, size.height / 2);

    // Top-right inner curve
    path.arcToPoint(
      Offset(size.width - 13.27, size.height / 2 - 35.24),
      radius: const Radius.circular(_cornerRadius),
      clockwise: true,
    );

    // Top-right corner
    path.lineTo(size.width - 13.27, 48.26);
    path.arcToPoint(
      const Offset(48.26, 13.26),
      radius: const Radius.circular(_cornerRadius),
      clockwise: false,
    );

    // Top-left corner
    path.lineTo(48.26, 13.26);
    path.arcToPoint(
      const Offset(13.26, 48.26),
      radius: const Radius.circular(_cornerRadius),
      clockwise: false,
    );

    // Left notch
    path.lineTo(13.26, size.height / 2 - 35.24);
    path.arcToPoint(
      Offset(13.26, size.height / 2 + 35.24),
      radius: const Radius.circular(_cornerRadius),
      clockwise: true,
    );

    // Bottom-left corner
    path.lineTo(13.26, size.height - 48.25);
    path.arcToPoint(
      Offset(48.26, size.height - 13.26),
      radius: const Radius.circular(_cornerRadius),
      clockwise: false,
    );

    // Bottom-right corner
    path.lineTo(size.width - 48.26, size.height - 13.26);
    path.arcToPoint(
      Offset(size.width - 13.26, size.height - 48.26),
      radius: const Radius.circular(_cornerRadius),
      clockwise: false,
    );

    // Right notch
    path.lineTo(size.width - 13.26, size.height / 2 + 35.24);
    path.arcToPoint(
      Offset(size.width - 48.51, size.height / 2),
      radius: const Radius.circular(_cornerRadius),
      clockwise: true,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
