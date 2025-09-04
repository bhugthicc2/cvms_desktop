import 'package:cvms_desktop/core/theme/app_theme.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/utils/custom_window_titlebar.dart';
// import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final keepLoggedIn = await AuthPersistence.getKeepLoggedIn();
  // final user = FirebaseAuth.instance.currentUser;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    CVMSApp(
      // keepLoggedIn: keepLoggedIn, user: user
    ),
  );
  initializeWindowProperties(
    initialSize: const Size(1280, 720),
    minSize: const Size(1280, 720),
    alignment: Alignment.center,
  );
}

class CVMSApp extends StatelessWidget {
  // final bool keepLoggedIn;
  // final User? user;

  const CVMSApp({
    super.key,
    // required this.keepLoggedIn, required this.user
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:
            // (user != null && keepLoggedIn) ? AppRoutes.shell :
            AppRoutes.signIn,
        theme: AppTheme.lightTheme,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
