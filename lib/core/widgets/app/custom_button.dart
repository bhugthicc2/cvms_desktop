import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? btnSubmitColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.btnSubmitColor,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dx: 0,
      dy: -0.1,
      child: SizedBox(
        height: 55,
        width: double.infinity,

        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            foregroundColor: AppColors.white,
            backgroundColor: btnSubmitColor ?? AppColors.primary,
            elevation: 0,
          ),
          child:
              isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: AppFontSizes.medium,
                      letterSpacing: 0.8,

                      color: AppColors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
