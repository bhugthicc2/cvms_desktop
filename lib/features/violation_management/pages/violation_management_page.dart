import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/vehicle_search_suggestion.dart';
import 'package:cvms_desktop/features/dashboard/repositories/dashboard/vehicle_search_repository.dart';
import 'package:cvms_desktop/features/dashboard/services/vehicle_search_service.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/violation_management/bloc/add_violation_cubit.dart';
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
  final VehicleEntry? vehicleEntry;
  const ViolationManagementPage({super.key, this.vehicleEntry});

  @override
  State<ViolationManagementPage> createState() =>
      _ViolationManagementPageState();
}

class _ViolationManagementPageState extends State<ViolationManagementPage> {
  final TextEditingController violationController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController othersController = TextEditingController();

  ViolationStatus? selectedStatus;
  String? selectedViolationType;
  String? _lastShownMessage;
  String? _selectedVehicleId;

  // List of common violation types
  static const List<String> violationTypes = [
    'Over Speeding',
    'Reckless Driving',
    'Improper Parking',
    'Expired MVP Registration',
    'Other',
  ];

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
    vehicleController.dispose();
    othersController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: BlocProvider(
          create: (context) => AddViolationCubit(AuthRepository()),
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
                  Spacing.vertical(size: AppSpacing.small),
                  const ViolationTabBar(),
                  Spacing.vertical(size: AppSpacing.small),
                  //table header with violation search field
                  TableHeader(
                    vehicleController: vehicleController,
                    violationController: violationController,
                    onSearchSuggestions: (query) async {
                      final searchService = VehicleSearchService(
                        VehicleSearchRepository(FirebaseFirestore.instance),
                      );
                      final suggestions = await searchService.getSuggestions(
                        query,
                      );
                      return suggestions;
                    },
                    onVehicleSelected: (VehicleSearchSuggestion suggestion) {
                      //get the vehicle id for the selected vehicle
                      debugPrint(
                        'Selected vehicle ID: ${suggestion.vehicleId}',
                      );

                      // Store just the vehicle ID
                      setState(() {
                        _selectedVehicleId = suggestion.vehicleId;
                      });
                    },
                    onSubmit: () async {
                      await context.read<AddViolationCubit>().reportViolation(
                        vehicleId:
                            _selectedVehicleId ??
                            widget.vehicleEntry?.vehicleId,
                        violationType: selectedViolationType ?? '',
                        reason:
                            selectedViolationType == 'Other'
                                ? othersController.text.trim()
                                : null,
                      );

                      if (context.mounted && mounted) {
                        CustomSnackBar.show(
                          context: context,
                          message: 'Violation report successfully submitted!',
                          type: SnackBarType.success,
                        );
                      }
                    },
                    onSelectedStatusChange: (ViolationStatus? violationStatus) {
                      selectedStatus = violationStatus;
                    },
                    onSelectedViolationTypeChange: (String? violationType) {
                      selectedViolationType = violationType;
                    },
                    othersController: othersController,
                    selectedStatus: selectedStatus,
                    selectedViolationType: selectedViolationType,
                    violationTypeItems:
                        violationTypes
                            .map(
                              (type) => DropdownItem<String>(
                                value: type,
                                label: type,
                              ),
                            )
                            .toList(),
                    violationStatusItems:
                        ViolationStatus.values
                            .map(
                              (status) => DropdownItem<ViolationStatus>(
                                value: status,
                                label: status.label,
                              ),
                            )
                            .toList(),
                  ),
                  //bullk mode actions
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
      ),
    );
  }
}
