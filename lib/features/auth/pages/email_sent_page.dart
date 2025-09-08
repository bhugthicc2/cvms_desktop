import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_appbar.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/auth/widgets/layout/auth_scaffold.dart';
import 'package:cvms_desktop/features/auth/widgets/visuals/custom_illustration.dart';
import 'package:cvms_desktop/features/auth/widgets/buttons/custom_text_button.dart';
import 'package:cvms_desktop/features/auth/widgets/text/text_heading.dart';
import 'package:cvms_desktop/features/auth/widgets/text/text_subheading.dart';
import 'package:flutter/material.dart';

class EmailSentPage extends StatelessWidget {
  const EmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        title: 'Back to forgot password page',
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextHeading(text: 'Email has been sent'),
            Spacing.vertical(size: AppSpacing.medium),
            TextSubHeading(
              text:
                  'Please check your inbox and click in the received link to reset your pasword',
            ),
            Spacing.vertical(size: AppSpacing.large),
            CustomIllustration(
              path: 'assets/images/email_sent_illustration.svg',
            ),
            Spacing.vertical(size: AppSpacing.large),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signIn);
                    },
                  ),
                  Spacing.vertical(size: AppSpacing.medium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive link?",
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      CustomTextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPassword,
                          );
                        },
                        text: 'Resend',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
