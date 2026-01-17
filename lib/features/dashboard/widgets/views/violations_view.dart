import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/violation_table.dart';
import 'package:cvms_desktop/features/violation_management/widgets/skeletons/table_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViolationsView extends StatefulWidget {
  const ViolationsView({super.key});

  @override
  State<ViolationsView> createState() => _ViolationsViewState();
}

class _ViolationsViewState extends State<ViolationsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize violations when the view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViolationCubit>().listenViolations();
    });
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Violations',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            Expanded(
              child: BlocBuilder<ViolationCubit, ViolationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: buildSkeletonTable(),
                    );
                  }

                  if (state.message != null) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state.filteredEntries.isEmpty) {
                    return const Center(
                      child: Text(
                        'No violations found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ViolationTable(
                    title: 'Violations',
                    entries: state.filteredEntries,
                    searchController: _searchController,
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
