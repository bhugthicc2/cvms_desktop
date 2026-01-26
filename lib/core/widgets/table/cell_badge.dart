import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';

class CellBadge extends StatelessWidget {
  final Color badgeBg;
  final Color textColor;
  final String statusStr;
  final double? fontSize;
  final FontWeight fontWeight;
  final double? horizontalPadding;
  const CellBadge({
    super.key,
    required this.badgeBg,
    required this.textColor,
    required this.statusStr,
    this.fontSize,
    this.horizontalPadding,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: horizontalPadding ?? 13,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: badgeBg,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Center(
          child: Text(
            statusStr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontFamily: 'Inter',
              fontSize: fontSize ?? AppFontSizes.small,
            ),
          ),
        ),
      ),
    );
  }
}
