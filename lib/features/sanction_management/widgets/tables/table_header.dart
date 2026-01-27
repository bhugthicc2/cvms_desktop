import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_state.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/buttons/custom_sanction_button.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/widgets/buttons/custom_violation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController sanctionController;

  const TableHeader({super.key, required this.sanctionController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SanctionCubit, SanctionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 40,
                child: SearchField(
                  hoverScale: 1,
                  controller: sanctionController,
                ),
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: [
                          'All',
                          '12-23-2024',
                          '12-23-2025',
                        ], //todo implement proper date filtering function
                        initialValue: 'All',
                        onChanged: (value) {
                          // todo
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomSanctionButton(
                        textColor:
                            state.isBulkModeEnabled
                                ? AppColors.white
                                : AppColors.black,
                        label:
                            state.isBulkModeEnabled
                                ? "Exit Bulk Mode"
                                : "Bulk Mode",
                        backgroundColor:
                            state.isBulkModeEnabled
                                ? AppColors.warning
                                : AppColors.white,
                        onPressed: () {
                          context.read<SanctionCubit>().toggleBulkMode();
                        },
                      ),
                    ),
                    //Spacing.horizontal(size: AppSpacing.medium),
                    // Expanded(
                    //   child: CustomSanctionButton(
                    //     label: "Add Sanction",
                    //     onPressed: () {
                    //       //todo
                    //     },
                    //   ),
                    // ),
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
