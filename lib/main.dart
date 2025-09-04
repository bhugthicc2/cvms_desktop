import 'package:cvms_desktop/core/theme/app_theme.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/utils/custom_window_titlebar.dart';
import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CVMSApp());
  initializeWindowProperties(
    initialSize: const Size(1280, 720),
    minSize: const Size(1280, 720),
    alignment: Alignment.center,
  );
}

class CVMSApp extends StatelessWidget {
  const CVMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        theme: AppTheme.lightTheme,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  String _initialRoute = AppRoutes.signIn;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      await FirebaseAuth.instance.authStateChanges().first;
      final keepLoggedIn = await AuthPersistence.getKeepLoggedIn();
      final user = FirebaseAuth.instance.currentUser;
      final savedSession = await AuthPersistence.getSavedUserSession();
      final hasValidSession =
          (user != null) ||
          (keepLoggedIn &&
              savedSession['email'] != null &&
              savedSession['uid'] != null);
      setState(() {
        _initialRoute = hasValidSession ? AppRoutes.shell : AppRoutes.signIn;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _initialRoute = AppRoutes.signIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Navigator(
      initialRoute: _initialRoute,
      onGenerateRoute: (settings) {
        final routeName = settings.name ?? AppRoutes.signIn;
        final routeBuilder = AppRoutes.getRoutes()[routeName];

        if (routeBuilder != null) {
          return MaterialPageRoute(builder: routeBuilder, settings: settings);
        }

        return MaterialPageRoute(
          builder:
              (context) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
      },
    );
  }
}
