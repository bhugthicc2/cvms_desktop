import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';

class ProfilePageHeader extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onButtonTap;

  const ProfilePageHeader({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onButtonTap,
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
        ProfilePageButton(text: buttonText, onTap: onButtonTap),
      ],
    );
  }
}

class ProfilePageButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProfilePageButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverSlide(
      dx: 0,
      dy: -0.1,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: _sectionDecoration(),
        child: Text(text),
      ),
    );
  }
}

BoxDecoration _sectionDecoration() {
  return BoxDecoration(
    border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.7)),
    color: AppColors.white,
    borderRadius: BorderRadius.circular(5),
  );
}
