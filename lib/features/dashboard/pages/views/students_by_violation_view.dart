import 'package:cvms_desktop/core/widgets/app/custom_view_title.dart';
import 'package:cvms_desktop/core/widgets/charts/stacked_bar_widget.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/global/global_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/utils/chart_data_sorter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/skeletons/table_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentsByViolationView extends StatefulWidget {
  final VoidCallback onBackPressed;
  const StudentsByViolationView({super.key, required this.onBackPressed});

  @override
  State<StudentsByViolationView> createState() =>
      _StudentsByViolationViewState();
}

class _StudentsByViolationViewState extends State<StudentsByViolationView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize violation by student view
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomViewTitle(
                viewTitle: 'Students by Violation',
                onBackPressed: widget.onBackPressed,
              ),
              const SizedBox(height: AppSpacing.medium),
              Expanded(
                child: BlocBuilder<GlobalDashboardCubit, GlobalDashboardState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return Skeletonizer(
                        enabled: true,
                        child: buildSkeletonTable(),
                      );
                    }

                    return Expanded(
                      child: _buildStackedChart(
                        'Students by Violation Share',
                        state.allStudentsWithMostViolations,
                        () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackedChart(
    String title,
    List<ChartDataModel> data,
    VoidCallback? onViewTap,
  ) {
    // Sort data by value in descending order for highlighting
    final sortedData = ChartDataSorter.sortByValueDescending(data);

    return StackedBarWidget(
      data: sortedData,

      onStackBarPointTapped: (details) {},
      highlightHighestIndex: sortedData.isNotEmpty ? 0 : null,
    );
  }
}
