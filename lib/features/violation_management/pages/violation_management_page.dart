import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_update_status_dialog.dart';
import 'package:cvms_desktop/features/violation_management/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/table_header.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/top_bar.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/violation_table.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tabs/violation_tab_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViolationManagementPage extends StatefulWidget {
  const ViolationManagementPage({super.key});

  @override
  State<ViolationManagementPage> createState() =>
      _ViolationManagementPageState();
}

class _ViolationManagementPageState extends State<ViolationManagementPage> {
  final TextEditingController violationController = TextEditingController();
  String? _lastShownMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViolationCubit>().listenViolations();
    });

    violationController.addListener(() {
      context.read<ViolationCubit>().filterEntries(violationController.text);
    });
  }

  @override
  void dispose() {
    violationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: BlocConsumer<ViolationCubit, ViolationState>(
          listener: (context, state) {
            if (state.message != null && state.message != _lastShownMessage) {
              _lastShownMessage = state.message;
              CustomSnackBar.show(
                context: context,
                message: state.message!,
                type: state.messageType ?? SnackBarType.success,
              );

              context.read<ViolationCubit>().clearMessage();
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return Skeletonizer(
                enabled: state.isLoading,
                child: buildSkeletonTable(),
              );
            }

            return Column(
              children: [
                TopBar(metrics: context.read<ViolationCubit>().getMetrics()),
                //Spacing.vertical(size: AppFontSizes.medium),
                Spacing.vertical(size: AppSpacing.small),
                const ViolationTabBar(),
                Spacing.vertical(size: AppSpacing.small),
                TableHeader(
                  vehicleController: TextEditingController(),
                  onVehicleSelected: (VehicleEntry vehicle) {},
                  getVehicleSuggestion: (VehicleEntry vehicle) {
                    return vehicle.academicYear; //todo
                  },
                  searchVehicles: (String search) {
                    return search; //todo
                  },
                  onSubmit: () {},
                  onSelectedStatusChange: (ViolationStatus? violationStatus) {},
                  onSelectedViolationTypeChange: (String? p1) {},
                  othersController: TextEditingController(),
                ),

                if (state.isBulkModeEnabled) ...[
                  Spacing.vertical(size: AppFontSizes.medium),
                  ToggleActions(
                    resetValue: state.selectedEntries.length.toString(),
                    exportValue: state.selectedEntries.length.toString(),
                    deleteValue: state.selectedEntries.length.toString(),
                    updateValue: state.selectedEntries.length.toString(),
                    onExport: () {
                      //todo Handle export QR codes
                      debugPrint(
                        'Exporting QR codes for ${state.selectedEntries.length} entries',
                      );
                    },
                    onUpdate: () {
                      //todo Handle update status
                      debugPrint(
                        'Updating status for ${state.selectedEntries.length} entries',
                      );
                    },
                    onDelete: () {
                      //todo Handle delete selected
                      debugPrint(
                        'Deleting ${state.selectedEntries.length} entries',
                      );
                    },
                    onReset: () {
                      //todo Handle delete selected
                      debugPrint(
                        'Resetting password for ${state.selectedEntries.length} entries',
                      );
                    },
                  ),
                ],
                Spacing.vertical(size: AppSpacing.medium),
                ViolationTable(
                  title: "Violation Management",
                  entries: state.filteredEntries,
                  searchController: violationController,
                  onDelete: () {
                    //todo show delete confirmation dialog
                  },
                  onEdit: (ViolationEntry entry) {
                    //todo show edit dialog
                  },
                  onUpdate: (ViolationEntry entry) {
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) {
                          return CustomUpdateStatusDialog(
                            currentStatus: entry.status,
                            onConfirm: (newStatus) async {
                              try {
                                // Close dialog first to prevent UI freezing
                                if (dialogContext.mounted) {
                                  Navigator.of(dialogContext).pop();
                                }

                                // Update violation status
                                await context
                                    .read<ViolationCubit>()
                                    .updateViolationStatus(
                                      violationId: entry.id,
                                      status: newStatus,
                                    );
                              } catch (e) {
                                // Close dialog if still open
                                if (dialogContext.mounted) {
                                  Navigator.of(dialogContext).pop();
                                }

                                // Show error message
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error updating violation: ${e.toString()}',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      );
                    } catch (e) {
                      // Show error message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error opening dialog: ${e.toString()}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },

                  onViewMore: (ViolationEntry entry) {
                    //show more info pop up
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
