import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
import 'package:cvms_desktop/features/auth/widgets/layout/auth_scaffold.dart';
import 'package:cvms_desktop/features/auth/widgets/layout/custom_form_header.dart';
import 'package:cvms_desktop/features/auth/widgets/text/form_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core//utils/form_validator.dart';
import '../../../core/widgets/layout/spacing.dart';
import '../widgets/buttons/custom_auth_link.dart';
import '../widgets/buttons/custom_text_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/widgets/app/custom_button.dart';
import '../../../core/widgets/app/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool keepLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadKeepLoggedInState();
  }

  Future<void> _loadKeepLoggedInState() async {
    final savedKeepLoggedIn = await AuthPersistence.getKeepLoggedIn();
    setState(() {
      keepLoggedIn = savedKeepLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushNamed(context, AppRoutes.shell);
              CustomSnackBar.show(
                context: context,
                message: state.message,
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
                            top: BorderSide(width: 7, color: AppColors.black),
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
                                    initialKeepLoggedIn: keepLoggedIn,
                                    onKeepLoggedInChanged: (value) {
                                      setState(() {
                                        keepLoggedIn = value;
                                      });
                                    },
                                    forgotPasswordRoute:
                                        AppRoutes.forgotPassword,
                                  ),
                                  Spacing.vertical(size: AppSpacing.large),
                                  CustomButton(
                                    text: 'Login',
                                    isLoading: state is AuthLoading,
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await AuthPersistence.setKeepLoggedIn(
                                          keepLoggedIn,
                                        );

                                        // ignore: use_build_context_synchronously
                                        context.read<AuthBloc>().add(
                                          SignInEvent(
                                            emailController.text,
                                            passwordController.text,
                                          ),
                                        );
                                      } else {
                                        CustomSnackBar.show(
                                          context: context,
                                          message: 'Please input the fields!',
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
    );
  }
}
