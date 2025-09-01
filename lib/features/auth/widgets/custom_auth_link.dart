import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/custom_checkbox.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:cvms_desktop/features/auth/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class CustomAuthLink extends StatefulWidget {
  final bool initialKeepLoggedIn;
  final ValueChanged<bool>? onKeepLoggedInChanged;
  final VoidCallback? onForgotPasswordPressed;
  final String forgotPasswordRoute;

  const CustomAuthLink({
    super.key,
    this.initialKeepLoggedIn = false,
    this.onKeepLoggedInChanged,
    this.onForgotPasswordPressed,
    this.forgotPasswordRoute = '/forgot-password',
  });

  @override
  State<CustomAuthLink> createState() => _CustomAuthLinkState();
}

class _CustomAuthLinkState extends State<CustomAuthLink> {
  late bool _keepLoggedIn;

  @override
  void initState() {
    super.initState();
    _keepLoggedIn = widget.initialKeepLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomCheckbox(
              value: _keepLoggedIn,
              onChanged: (value) {
                setState(() {
                  _keepLoggedIn = value ?? false;
                });
                widget.onKeepLoggedInChanged?.call(_keepLoggedIn);
              },
            ),
            const Spacing.horizontal(size: AppFontSizes.small),
            const Text(
              'Keep me logged in',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.w800,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        CustomTextButton(
          onPressed: () {
            widget.onForgotPasswordPressed?.call();
            Navigator.pushNamed(context, widget.forgotPasswordRoute);
          },
          text: 'Forgot password?',
          textColor: AppColors.grey,
        ),
      ],
    );
  }
}
