import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLoadingScreen extends StatelessWidget {
  final String title;
  final String message;
  final String svgAsset;

  const CustomLoadingScreen({
    super.key,
    required this.title,
    required this.message,
    required this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgAsset, height: 250),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppFontSizes.elarge,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: AppFontSizes.medium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
