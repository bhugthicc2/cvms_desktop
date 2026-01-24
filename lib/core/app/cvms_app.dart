import 'package:cvms_desktop/core/bloc/theme_cubit.dart';
import 'package:cvms_desktop/core/bloc/theme_state.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/services/connectivity/connectivity_service.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_theme.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/pages/auth_wrapper.dart';
import 'package:cvms_desktop/features/shell/bloc/connectivity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CVMSApp extends StatefulWidget {
  const CVMSApp({super.key});

  @override
  State<CVMSApp> createState() => _CVMSAppState();
}

class _CVMSAppState extends State<CVMSApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // We'll access ConnectivityCubit through the builder context
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
          create: (context) => ConnectivityCubit(ConnectivityService()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            // themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            home: BlocListener<ConnectivityCubit, InternetStatus>(
              listener: (context, status) async {
                if (status == InternetStatus.disconnected) {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) => AlertDialog(
                          backgroundColor: AppColors.white,
                          title: const Text('No Internet Connection'),
                          content: const Text('Please check your connection.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                              child: const Text('OK'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.donutBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<ConnectivityCubit>().refresh();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                  );
                } else if (status == InternetStatus.connected) {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                  CustomSnackBar.showSuccess(
                    context,
                    'Internet connection restored.',
                  ); //todo only show this if the previous connectivity status is disconnected
                }
              },
              child: const AuthWrapper(),
            ),

            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme,
            routes: AppRoutes.getRoutes(),
          );
        },
      ),
    );
  }
}
