import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';

class ProfilePageHeader extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onButtonTap;
  final Color btnColor;

  const ProfilePageHeader({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onButtonTap,
    this.btnColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        ProfilePageButton(
          text: buttonText,
          onTap: onButtonTap,
          btnColor: btnColor,
        ),
      ],
    );
  }
}

class ProfilePageButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color btnColor;

  const ProfilePageButton({
    super.key,
    required this.text,
    required this.onTap,
    this.btnColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dx: 0,
      dy: -0.1,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: _sectionDecoration(color: btnColor),
        child: Text(
          text,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

BoxDecoration _sectionDecoration({required final Color color}) {
  return BoxDecoration(color: color, borderRadius: BorderRadius.circular(5));
}
