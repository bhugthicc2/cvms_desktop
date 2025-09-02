import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/custom_window_titlebar.dart';
import 'package:cvms_desktop/features/auth/widgets/custom_form_header.dart';
import 'package:cvms_desktop/features/auth/widgets/form_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core//utils/form_validator.dart';
import '../../../../core//widgets/spacing.dart';
import '../../../features/auth/widgets/custom_auth_link.dart';
import '../../../features/auth/widgets/custom_text_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Stack(
      children: [
        Image.asset(
          "assets/images/bg.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  CustomSnackBar.show(
                    context: context,
                    message: 'Login successful!',
                    type: SnackBarType.success,
                  );
                  Navigator.pushNamed(context, AppRoutes.dashboard);
                } else if (state is AuthError) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.message,
                    type: SnackBarType.error,
                  );
                }
              },
              builder: (context, state) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border(
                                top: BorderSide(
                                  width: 7,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomFormHeader(),
                                Divider(
                                  color: AppColors.dividerColor,
                                  thickness: 0.8,
                                ),
                                Spacing.vertical(size: AppSpacing.small),
                                CustomFormTitle(
                                  title: 'ADMIN LOGIN',
                                  subtitle: 'Please login to continue',
                                ),
                                Spacing.vertical(size: AppSpacing.large),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: emailController,
                                        labelText: "Email",
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: FormValidator.validateEmail,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      Spacing.vertical(size: AppSpacing.medium),
                                      CustomTextField(
                                        controller: passwordController,
                                        labelText: 'Password',
                                        obscureText: true,
                                        enableVisibilityToggle: true,
                                        validator:
                                            FormValidator.validatePassword,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      Spacing.vertical(size: AppSpacing.medium),
                                      CustomAuthLink(
                                        onKeepLoggedInChanged: (value) {},
                                        forgotPasswordRoute:
                                            AppRoutes.forgotPassword,
                                      ),
                                      Spacing.vertical(size: AppSpacing.large),
                                      CustomButton(
                                        text: 'Login',
                                        isLoading: state is AuthLoading,
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                              SignInEvent(
                                                emailController.text,
                                                passwordController.text,
                                              ),
                                            );
                                          } else {
                                            CustomSnackBar.show(
                                              context: context,
                                              message:
                                                  'Please input the fields!',
                                              type: SnackBarType.error,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Spacing.vertical(size: AppSpacing.medium),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
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
                                          AppRoutes.signUp,
                                        );
                                      },
                                      text: 'Sign Up',
                                    ),
                                  ],
                                ),
                                Spacing.vertical(size: AppSpacing.small),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Positioned(top: 10, right: 10, child: CustomWindowTitleBar()),
      ],
    );
  }
}
