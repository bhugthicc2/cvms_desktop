import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_view_title.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/core/widgets/charts/donut_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleDistributionView extends StatelessWidget {
  const VehicleDistributionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomViewTitle(
              viewTitle: 'Vehicle Distribution per College',
              onBackClick: () {
                context.read<DashboardCubit>().showOverview();
              },
            ),
            const SizedBox(height: AppSpacing.medium),
            Expanded(
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state.loading) {
                    return Skeletonizer(
                      enabled: true,
                      child: DonutChartWidget(
                        onViewTap: () {},
                        data: [],
                        onDonutChartPointTap: (details) {},
                        title: 'Vehicle Distribution per College',
                      ),
                    );
                  }

                  if (state.error != null) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state.vehicleDistribution.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vehicle distribution data available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return DonutChartWidget(
                    onViewTap: () {},
                    radius: '70%',
                    innerRadius: '60%',
                    explode: true,
                    data: state.vehicleDistribution,
                    onDonutChartPointTap: (details) {
                      CustomSnackBar.show(
                        context: context,
                        message:
                            'Donut Chart Point Clicked: ${details.pointIndex}',
                        type: SnackBarType.success,
                        duration: const Duration(seconds: 3),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
