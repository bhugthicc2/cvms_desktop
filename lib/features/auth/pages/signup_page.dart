import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/custom_button.dart';
import 'package:cvms_desktop/core/widgets/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/custom_text_field.dart';
import 'package:cvms_desktop/core/utils/custom_window_titlebar.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:cvms_desktop/features/auth/widgets/auth_window_titlebar.dart';
import 'package:cvms_desktop/features/auth/widgets/custom_form_header.dart';
import 'package:cvms_desktop/features/auth/widgets/custom_text_button.dart';
import 'package:cvms_desktop/features/auth/widgets/form_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    message: 'Signup successful!',
                    type: SnackBarType.success,
                  );
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
                      key: _formKey,
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomFormHeader(),
                                    Spacing.vertical(size: AppSpacing.small),
                                    Divider(
                                      color: AppColors.dividerColor,
                                      thickness: 0.8,
                                    ),
                                    Spacing.vertical(size: AppSpacing.small),
                                    CustomFormTitle(
                                      title: 'ADMIN REGISTRATION',
                                      subtitle: 'Please register to continue',
                                    ),
                                  ],
                                ),
                                Spacing.vertical(size: AppSpacing.large),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: fullnameController,
                                        labelText: 'Full Name',
                                        validator:
                                            (value) =>
                                                FormValidator.validateRequired(
                                                  value,
                                                  'Full Name',
                                                ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      Spacing.vertical(size: AppSpacing.medium),
                                      CustomTextField(
                                        controller: emailController,
                                        labelText: 'Email',

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
                                      CustomTextField(
                                        controller: confirmPasswordController,
                                        labelText: 'Confirm Password',
                                        obscureText: true,
                                        enableVisibilityToggle: true,
                                        validator:
                                            (value) =>
                                                FormValidator.validateConfirmPassword(
                                                  passwordController.text,
                                                  value,
                                                ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                      Spacing.vertical(size: AppSpacing.large),

                                      CustomButton(
                                        text: 'Sign Up',
                                        isLoading: state is AuthLoading,
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                              SignUpEvent(
                                                emailController.text,
                                                passwordController.text,
                                                fullnameController.text,
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
                                      'Already have an account?',
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
                                          AppRoutes.signIn,
                                        );
                                      },
                                      text: 'Sign In',
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
        AuthWindowTitlebar(),
      ],
    );
  }
}
