import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core//utils/form_validator.dart';
import '../../../../core//widgets/custom_progress_indicator.dart';
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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

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
                  Navigator.pushNamed(context, AppRoutes.dashboard);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 20,
                            ),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/jrmsu-logo.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    Spacing.vertical(size: AppSpacing.medium),
                                    Text(
                                      'JRMSU - KATIPUNAN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: AppFontSizes.xxxxLarge,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Text(
                                      'CLOUD-BASED VEHICLE MONITORING SYSTEM',
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: AppFontSizes.medium,
                                      ),
                                    ),
                                    Spacing.vertical(size: AppSpacing.small),
                                    Divider(
                                      color: AppColors.dividerColor,
                                      thickness: 0.8,
                                    ),
                                    Spacing.vertical(size: AppSpacing.small),
                                    Text(
                                      'ADMIN LOGIN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,

                                        fontSize: AppFontSizes.xxxLarge,

                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'Please login to continue',
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: AppFontSizes.medium,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacing.vertical(size: AppSpacing.large),
                                CustomTextField(
                                  controller: emailController,
                                  labelText: "Email",
                                  keyboardType: TextInputType.emailAddress,
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
                                  validator: FormValidator.validatePassword,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                Spacing.vertical(size: AppSpacing.medium),
                                CustomAuthLink(
                                  onKeepLoggedInChanged: (value) {
                                    //TODO: Add logic to handle keep logged in functionality
                                  },
                                  forgotPasswordRoute: AppRoutes.forgotPassword,
                                ),
                                Spacing.vertical(size: AppSpacing.large),
                                state is AuthLoading
                                    ? const CustomProgressIndicator()
                                    : CustomButton(
                                      text: 'Login',
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                          SignInEvent(
                                            emailController.text,
                                            passwordController.text,
                                          ),
                                        );
                                      },
                                    ),
                                Spacing.vertical(size: AppSpacing.medium),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?"),
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
      ],
    );
  }
}
