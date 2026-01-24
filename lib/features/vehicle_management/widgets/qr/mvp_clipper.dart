import 'package:flutter/material.dart';

class MotorVehiclePassClipper extends CustomClipper<Path> {
  MotorVehiclePassClipper({this.cornerRadiusFactor = 1.0});

  /// 1.0 = original
  /// < 1.0 = sharper corners
  /// > 1.0 = rounder corners
  final double cornerRadiusFactor;

  static const double _designWidth = 977.36;
  static const double _designHeight = 523.91;

  @override
  Path getClip(Size size) {
    final scaleX = size.width / _designWidth;
    final scaleY = size.height / _designHeight;

    double r(double value) => value * cornerRadiusFactor * scaleX;

    return Path()
      ..moveTo(924.51 * scaleX, 262 * scaleY)
      ..arcToPoint(
        Offset(967.33 * scaleX, 217.57 * scaleY),
        radius: Radius.circular(r(44.47)),
        clockwise: true,
      )
      ..lineTo(967.33 * scaleX, 90.27 * scaleY)
      ..arcToPoint(
        Offset(885.41 * scaleX, 8.34 * scaleY),
        radius: Radius.circular(r(81.93)),
        clockwise: false,
      )
      ..lineTo(92 * scaleX, 8.34 * scaleY)
      ..arcToPoint(
        Offset(10 * scaleX, 90.27 * scaleY),
        radius: Radius.circular(r(81.93)),
        clockwise: false,
      )
      ..lineTo(10 * scaleX, 217.53 * scaleY)
      ..arcToPoint(
        Offset(10 * scaleX, 306.38 * scaleY),
        radius: Radius.circular(r(44.46)),
        clockwise: true,
      )
      ..lineTo(10 * scaleX, 433.65 * scaleY)
      ..arcToPoint(
        Offset(92 * scaleX, 515.57 * scaleY),
        radius: Radius.circular(r(81.92)),
        clockwise: false,
      )
      ..lineTo(885.41 * scaleX, 515.57 * scaleY)
      ..arcToPoint(
        Offset(967.33 * scaleX, 433.65 * scaleY),
        radius: Radius.circular(r(81.92)),
        clockwise: false,
      )
      ..lineTo(967.33 * scaleX, 306.38 * scaleY)
      ..arcToPoint(
        Offset(924.51 * scaleX, 262 * scaleY),
        radius: Radius.circular(r(44.45)),
        clockwise: true,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant MotorVehiclePassClipper oldClipper) {
    return oldClipper.cornerRadiusFactor != cornerRadiusFactor;
  }
}
