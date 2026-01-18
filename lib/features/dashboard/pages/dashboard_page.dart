import 'package:cvms_desktop/features/dashboard/data/firestore_analytics_repository.dart';
import 'package:cvms_desktop/features/dashboard/pages/dashboard_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports/reports_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ReportsCubit(analyticsRepo: FirestoreAnalyticsRepository()),
      child: const DashboardPageContent(),
    );
  }
}
