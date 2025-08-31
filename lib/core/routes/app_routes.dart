import 'package:flutter/material.dart';
// import '../../features/auth/pages/sign_in_page.dart';
// import '../../features/auth/pages/sign_up_page.dart';

class AppRoutes {
  // Route names as constants
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String dashboard = '/dashboard';

  // Route map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // signIn: (context) => const SignInPage(),
      // signUp: (context) => const SignUpPage(),
      dashboard:
          (context) => const Scaffold(body: Center(child: Text('Dashboard'))),
    };
  }
}
