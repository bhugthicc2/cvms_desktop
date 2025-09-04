import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/custom_appbar.dart';
import 'package:cvms_desktop/core/widgets/custom_button.dart';
import 'package:cvms_desktop/core/widgets/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_event.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_state.dart';
import 'package:cvms_desktop/features/auth/widgets/auth_scaffold.dart';

import 'package:cvms_desktop/features/auth/widgets/custom_illustration.dart';
import 'package:cvms_desktop/features/auth/widgets/custom_text_button.dart';
import 'package:cvms_desktop/features/auth/widgets/text_heading.dart';
import 'package:cvms_desktop/features/auth/widgets/text_subheading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        title: 'Back to login',
      ),

      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            Navigator.pushNamed(context, AppRoutes.emailSent);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextHeading(text: 'Forgot password?'),
                  Spacing.vertical(size: AppSpacing.medium),
                  const TextSubHeading(
                    text:
                        'Enter your registered email to receive password reset link',
                  ),
                  Spacing.vertical(size: AppSpacing.medium),
                  const CustomIllustration(
                    path: 'assets/images/forgot_pass_illustration.svg',
                  ),
                  Spacing.vertical(size: AppSpacing.large),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: FormValidator.validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enabled: !isLoading,
                        ),
                        Spacing.vertical(size: AppSpacing.medium),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Remember password?',
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            CustomTextButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.signIn,
                                        );
                                      },
                              text: 'Sign In',
                            ),
                          ],
                        ),
                        Spacing.vertical(size: AppSpacing.medium),
                        CustomButton(
                          text: 'Send',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                ResetPasswordEvent(emailController.text),
                              );
                            } else {
                              CustomSnackBar.show(
                                context: context,
                                message: 'Please input your email!',
                                type: SnackBarType.error,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
