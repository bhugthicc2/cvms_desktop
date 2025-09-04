import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/theme/app_theme.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/pages/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
