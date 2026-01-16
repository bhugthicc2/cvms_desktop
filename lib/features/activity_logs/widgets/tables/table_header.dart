//ACTIVITY LOG 12
//REFACTORED DB REFERENCE

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_state.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/buttons/custom_activitylogs_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app/search_field.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (searchController != null)
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 40,
                  child: SearchField(
                    hintText: 'Search activity logs...',
                    controller: searchController!,
                  ),
                ),
              ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    //ACTIVITY LOG STATUS FILTER
                    Expanded(
                      child: CustomDropdown(
                        backgroundColor: AppColors.white,
                        color: AppColors.black,
                        items: [
                          'All',
                          'User Actions',
                          'Vehicle Actions',
                          'Violation Actions',
                          'System',
                        ],
                        initialValue: state.statusFilter,
                        onChanged: (value) {
                          context.read<ActivityLogsCubit>().filterByStatus(
                            value,
                          );
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //REFRESH BUTTON
                    Expanded(
                      child: CustomActivityLogsButton(
                        label: "Refresh",
                        onPressed: () {
                          context.read<ActivityLogsCubit>().refreshLogs();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
