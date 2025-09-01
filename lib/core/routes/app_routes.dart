import 'package:flutter/material.dart';
import '../../features/auth/pages/signin_page.dart';
import '../../features/auth/pages/signup_page.dart';

class AppRoutes {
  // Route names as constants
  static const String signIn = '/signin';

  static const String signUp = '/signup';
  static const String forgotPassword = '/forgotpassword';
  static const String dashboard = '/dashboard';

  // Route map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      signIn: (context) => const SignInPage(),
      signUp: (context) => const SignUpPage(),
      forgotPassword:
          (context) =>
          //TODO
          const Scaffold(body: Center(child: Text('ForgotPassword'))),
      dashboard:
          //TODO
          (context) => const Scaffold(body: Center(child: Text('Dashboard'))),
    };
  }
}
