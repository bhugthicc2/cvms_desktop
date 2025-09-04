import 'package:cvms_desktop/features/auth/pages/auth_session_service.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';

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
    _loadInitialRoute();
  }

  Future<void> _loadInitialRoute() async {
    final authSessionService = AuthSessionService();
    final route = await authSessionService.getInitialRoute();
    setState(() {
      _initialRoute = route;
      _isLoading = false;
    });
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
