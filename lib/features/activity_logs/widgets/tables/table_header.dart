import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/buttons/custom_activity_button.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Field
              if (searchController != null)
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: SearchField(
                      controller: searchController!,
                      onChanged: (value) {
                        context.read<ActivityLogsCubit>().setSearchQuery(value);
                      },
                    ),
                  ),
                ),

              if (searchController != null)
                const SizedBox(width: AppSpacing.medium),

              // Activity Type Filter
              _buildFilterDropdown(
                context,
                items: [
                  'All',
                  'Vehicle',
                  'User',
                  'Violation',
                  'Authentication',
                ],
                hint: 'Filter by Type',
                onChanged: (value) {
                  context.read<ActivityLogsCubit>().setTypeFilter(value);
                },
              ),

              const SizedBox(width: AppSpacing.medium),

              // Status Filter
              _buildFilterDropdown(
                context,
                items: [
                  'All',
                  'Created',
                  'Updated',
                  'Deleted',
                  'Logged In',
                  'Logged Out',
                ],
                hint: 'Filter by Status',
                onChanged: (value) {
                  context.read<ActivityLogsCubit>().setStatusFilter(value);
                },
              ),

              const Spacer(),

              // Bulk Actions
              if (state.isBulkModeEnabled) ...[
                CustomActivityButton(
                  onPressed: () {
                    context.read<ActivityLogsCubit>().deleteSelectedLogs();
                  },
                  label: 'Delete Selected',
                  icon: Icons.delete_outline,
                  backgroundColor: AppColors.error,
                  textColor: AppColors.white,
                ),
                const SizedBox(width: AppSpacing.medium),
              ],

              // Toggle Bulk Mode
              CustomActivityButton(
                onPressed: () {
                  //todo context.read<ActivityLogsCubit>().toggleBulkMode();
                },
                label: state.isBulkModeEnabled ? 'Exit Bulk Mode' : 'Bulk Mode',
                icon:
                    state.isBulkModeEnabled
                        ? Icons.cancel_outlined
                        : Icons.select_all,
                backgroundColor:
                    state.isBulkModeEnabled
                        ? AppColors.warning
                        : AppColors.white,
                textColor:
                    state.isBulkModeEnabled ? AppColors.white : AppColors.black,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context, {
    required List<String> items,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Container(
      height: 40,
      width: 180,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: null,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                hint,
                style: const TextStyle(fontSize: 14, color: AppColors.grey),
              ),
            ),
            icon: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_drop_down, color: AppColors.grey),
            ),
            isExpanded: true,
            items:
                items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ),
    );
  }
}
