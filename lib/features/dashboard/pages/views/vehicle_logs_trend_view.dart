import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_view_title.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/dashboard/extensions/time_range_extensions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleLogsTrendView extends StatelessWidget {
  const VehicleLogsTrendView({super.key});

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
              viewTitle: 'Vehicle Logs Trend',
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
                      child: LineChartWidget(
                        customWidget: CustomDropdown(
                          color: AppColors.donutBlue,
                          fontSize: 14,
                          verticalPadding: 0,
                          items: const ['7 days', 'Month', 'Year'],
                          initialValue: '7 days',
                          onChanged: (value) {},
                        ),
                        onViewTap: () {},
                        onLineChartPointTap: (details) {},
                        data: [],
                        title: 'Vehicle Logs for the last',
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

                  if (state.weeklyTrend.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vehicle logs trend data available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return LineChartWidget(
                    customWidget: CustomDropdown(
                      color: AppColors.donutBlue,
                      fontSize: 14,
                      verticalPadding: 0,
                      items: const ['7 days', 'Month', 'Year'],
                      initialValue: state.selectedTimeRange.displayName,
                      onChanged: (value) {
                        final timeRange = value.toTimeRange();
                        if (timeRange != null) {
                          context.read<DashboardCubit>().changeTimeRange(
                            timeRange,
                          );
                        }
                      },
                    ),
                    onViewTap: () {},
                    onLineChartPointTap: (details) {
                      CustomSnackBar.show(
                        context: context,
                        message:
                            'Line Chart Point Clicked: ${details.pointIndex}',
                        type: SnackBarType.success,
                        duration: const Duration(seconds: 3),
                      );
                    },
                    data: state.weeklyTrend,
                    title: 'Vehicle Logs for the last',
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
