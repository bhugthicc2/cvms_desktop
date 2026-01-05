import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/models/vehicle_entry.dart';
import 'package:cvms_desktop/core/widgets/app/pop_up_menu_item.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/models/violation_model.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/dialogs/custom_delete_dialog.dart'
    show CustomDeleteDialog;
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/dialogs/report_vehicle_dialog.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/dialogs/custom_update_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VehicleActionsMenu extends StatelessWidget {
  final VehicleEntry vehicleEntry;
  final int rowIndex;
  final BuildContext context;

  const VehicleActionsMenu({
    super.key,
    required this.vehicleEntry,
    required this.rowIndex,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: InkRipple.splashFactory,
        highlightColor: AppColors.primary.withValues(alpha: 0.1),
        splashColor: AppColors.primary.withValues(alpha: 0.2),
      ),
      child: PopupMenuButton<String>(
        color: AppColors.white,
        icon: const Icon(Icons.more_horiz, color: AppColors.grey, size: 20),
        splashRadius: 10,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onSelected: (String value) {
          _handleMenuAction(value, context);
        },
        itemBuilder:
            (BuildContext context) => [
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.arrowsClockwise,
                itemLabel: 'Update',
                value: 'update',
                iconColor: AppColors.success,
              ),
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.warning,
                itemLabel: 'Report',
                value: 'report',
                iconColor: AppColors.error,
              ),
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.trash,
                itemLabel: 'Delete',
                value: 'delete',
                iconColor: AppColors.error,
                textColor: AppColors.error,
              ),
            ],
      ),
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'update':
        _updateVehicle(context);
        break;
      case 'report':
        _reportVehicle(context);
        break;
      case 'delete':
        _deleteVehicle(context);
        break;
    }
  }

  void _updateVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => CustomUpdateDialog(
            onSave: (newStatus) async {
              try {
                await context.read<DashboardCubit>().updateVehicle(
                  vehicleEntry.vehicleId,
                  {'status': newStatus},
                );

                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: "Vehicle status updated to $newStatus",
                    type: SnackBarType.success,
                  );
                }
              } catch (e) {
                debugPrint('error: $e');
                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: "Failed to update status: $e",
                    type: SnackBarType.error,
                  );
                }
              }
            },
            vehicleId: vehicleEntry.vehicleId,
            currentStatus: vehicleEntry.status,
          ),
    );
  }

  void _reportVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: context.read<DashboardCubit>(),
            child: ReportVehicleDialog(
              title: "Report Vehicle",
              vehicleId: vehicleEntry.vehicleId,
              plateNumber: vehicleEntry.plateNumber,
              ownerName: vehicleEntry.ownerName,
              onSubmit: (violationType) async {
                try {
                  final violation = ViolationModel(
                    violationID: '',
                    dateTime: Timestamp.now(),
                    reportedBy: 'CDRRMSU Admin',
                    plateNumber: vehicleEntry.plateNumber,
                    vehicleID: vehicleEntry.vehicleId,
                    owner: vehicleEntry.ownerName,
                    violation: violationType,
                    status: 'pending',
                  );

                  await context.read<DashboardCubit>().reportViolation(
                    violation,
                  );

                  if (context.mounted) {
                    CustomSnackBar.show(
                      context: context,
                      message: "Violation reported successfully.",
                      type: SnackBarType.success,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomSnackBar.show(
                      context: context,
                      message: "Failed to report violation: $e",
                      type: SnackBarType.error,
                    );
                  }
                }
              },
            ),
          ),
    );
  }

  void _deleteVehicle(BuildContext innerContext) {
    showDialog(
      context: innerContext,
      builder:
          (_) => CustomDeleteDialog(
            title: "Delete Vehicle",
            message:
                "Are you sure you want to delete ${vehicleEntry.ownerName}'s vehicle (${vehicleEntry.plateNumber})?",
            onConfirm: () async {
              try {
                await innerContext.read<DashboardCubit>().deleteVehicleLog(
                  vehicleEntry.docId,
                );

                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: "Vehicle deleted successfully.",
                    type: SnackBarType.success,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: "Failed to delete vehicle: $e",
                    type: SnackBarType.error,
                  );
                }
              }
            },
          ),
    );
  }
}
