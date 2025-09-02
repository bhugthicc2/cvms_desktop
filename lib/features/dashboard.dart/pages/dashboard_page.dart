import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(child: Text('Dashboard')),
    );
  }
}
