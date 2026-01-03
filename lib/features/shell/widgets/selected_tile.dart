import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SelectedTile extends CustomPainter {
  final bool isExpanded;

  SelectedTile({required this.isExpanded});

  @override
  void paint(Canvas canvas, Size size) {
    // Use current size.width directly for smooth transitions
    // Height remains fixed at 126 (3 tiles)
    final double w = size.width;
    final double h =
        size.height; // Use size.height for flexibility, assuming it's 126

    // Fixed offsets derived from original design (to maintain curve shapes)
    final double leftStraightX = 22.0;
    final double leftMinX = 1.0;
    final double rightOffset = 21.0;
    final double bottomCurveDY = 22.0;
    final double bottomControl1DY = 12.598;
    final double bottomControl2DX = 9.402; // Offset from right edge
    final double leftControl1DX = 11.598; // 22 - 10.402
    final double leftControl2DY = 9.402; // 31.402 - 22
    final double leftCurveDY = 21.0; // 43 - 22
    final double secondLeftControl1DY = 11.598; // 54.598 - 43
    final double secondLeftControl2DX = 9.402; // 10.402 - 1
    final double secondLeftCurveDY = 21.0; // 64 - 43
    final double midHorizontalDY =
        64.0; // bottomCurveDY + leftCurveDY + secondLeftCurveDY
    final double topCurveDY = 20.0; // 84 - 64
    final double topCurveTotalDY =
        bottomCurveDY + 2 * leftCurveDY + topCurveDY; // 84
    final double topControl1DX = 11.263; // 225.263 - 214
    final double topControl2DX = 20.454; // 234.454 - 214
    final double topEndDX = 20.976; // 234.976 - 214
    final double topControl2DY = 8.8664; // 72.8664 - 64

    // Ensure minimum width to avoid overlaps (optional safeguard)
    final double effectiveW =
        (w > leftStraightX + rightOffset) ? w : leftStraightX + rightOffset;

    Path path_1 = Path();
    double rightStraightX = effectiveW - rightOffset;
    double bottomCurveY = h - bottomCurveDY;
    double bottomC1Y = h - bottomControl1DY;
    double bottomC2X = effectiveW - bottomControl2DX;

    path_1.moveTo(effectiveW, h);
    // Bottom right curve (offsets relative to bottom-right corner)
    path_1.cubicTo(
      effectiveW, // c1x (same as start)
      bottomC1Y, // c1y
      bottomC2X, // c2x
      bottomCurveY, // c2y
      rightStraightX, // end x
      bottomCurveY, // end y
    );
    // Line left to start of left curves
    path_1.lineTo(leftStraightX, bottomCurveY);
    // First left curve (offsets relative to its "corner" at (leftStraightX, bottomCurveY))
    double l1StartY = bottomCurveY;
    double l1C1X = leftStraightX - leftControl1DX;
    double l1C1Y = l1StartY;
    double l1C2X = leftMinX;
    double l1C2Y = l1StartY - leftControl2DY;
    double l1EndY = l1StartY - leftCurveDY;
    path_1.cubicTo(
      l1C1X,
      l1C1Y,
      l1C2X,
      l1C2Y,
      leftMinX, // end x
      l1EndY, // end y
    );
    // Second left curve (offsets relative to its "corner" at (leftMinX, l1EndY))
    double l2StartY = l1EndY;
    double l2C1Y = l2StartY - secondLeftControl1DY;
    double l2C2X = leftMinX + secondLeftControl2DX;
    double l2C2Y = l2StartY - secondLeftCurveDY;
    double l2EndY = l2StartY - secondLeftCurveDY;
    path_1.cubicTo(
      leftMinX, // c1x (same as start)
      l2C1Y, // c1y
      l2C2X, // c2x
      l2C2Y, // c2y
      leftStraightX, // end x
      l2EndY, // end y
    );
    // Line right to start of top right curve
    double topStraightY = h - midHorizontalDY;
    path_1.lineTo(rightStraightX, topStraightY);
    // Top right curve (offsets relative to its start "corner" at (rightStraightX, topStraightY))
    double topCurveY = h - topCurveTotalDY;
    double topC1X = rightStraightX + topControl1DX;
    double topC1Y = topStraightY;
    double topC2X = rightStraightX + topControl2DX;
    double topC2Y = topStraightY - topControl2DY;
    double topEndX = rightStraightX + topEndDX;
    path_1.cubicTo(topC1X, topC1Y, topC2X, topC2Y, topEndX, topCurveY);
    // Line right to top-right corner, then down to close
    path_1.lineTo(effectiveW, topCurveY);
    path_1.lineTo(effectiveW, h);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = AppColors.greySurface.withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
