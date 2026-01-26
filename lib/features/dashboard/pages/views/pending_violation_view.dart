//todo

import 'package:cvms_desktop/core/widgets/app/custom_view_title.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/violation_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/skeletons/table_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PendingViolationView extends StatefulWidget {
  final VoidCallback onBackPressed;
  const PendingViolationView({super.key, required this.onBackPressed});

  @override
  State<PendingViolationView> createState() => _PendingViolationViewState();
}

class _PendingViolationViewState extends State<PendingViolationView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize vehicle logs when the view is created
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
            CustomViewTitle(
              viewTitle: 'Pending Violations',
              onBackPressed: widget.onBackPressed,
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

                  if (state.allEntries.isEmpty) {
                    return const Center(
                      child: Text(
                        'No violations found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ViolationTable(
                    title: 'Pending Violations',
                    searchController: _searchController,
                    entries: state.allEntries,
                    onDelete: () {},
                    onEdit: (ViolationEntry entry) {},
                    onUpdate: (ViolationEntry entry) {},
                    onViewMore: (ViolationEntry entry) {},
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
