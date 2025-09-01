import 'package:cvms_desktop/features/auth/pages/email_sent_page.dart';
import 'package:cvms_desktop/features/auth/pages/forgot_password_page.dart';
import 'package:flutter/material.dart';
import '../../features/auth/pages/signin_page.dart';
import '../../features/auth/pages/signup_page.dart';

class AppRoutes {
  // Route names as constants
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgotpassword';
  static const String dashboard = '/dashboard';
  static const String emailSent = '/emailsent';

  // Route map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      signIn: (context) => const SignInPage(),
      signUp: (context) => const SignUpPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      emailSent: (context) => const EmailSentPage(),
      dashboard:
          //TODO: implement soon
          (context) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Dashboard screen soon to implement')),
          ),
    };
  }
}
