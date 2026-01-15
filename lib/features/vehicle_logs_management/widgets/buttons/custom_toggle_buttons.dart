import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';

class CustomToggleButtons extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final Color? color;
  const CustomToggleButtons({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dx: 0,
      dy: -0.1,
      child: SizedBox(
        height: 40,

        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              color: color ?? AppColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  '$title ($value)',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: AppColors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
