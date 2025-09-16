import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_edit_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_report_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_update_status_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/view_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/widgets/app/pop_up_menu_item.dart';

class VehicleActionsMenu extends StatelessWidget {
  final VehicleEntry vehicleEntry;
  final int rowIndex;
  final BuildContext context;

  const VehicleActionsMenu({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.vehicleEntry,
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
                iconColor: AppColors.primary,
                itemIcon: PhosphorIconsBold.notePencil,
                itemLabel: 'Edit Details',
                value: 'edit',
              ),
              CustomPopupMenuItem(
                iconColor: AppColors.black,
                itemIcon: PhosphorIconsBold.qrCode,
                itemLabel: 'View QR Code',
                value: 'qrcode',
              ),
              CustomPopupMenuItem(
                iconColor: AppColors.success,
                itemIcon: PhosphorIconsBold.arrowsClockwise,
                itemLabel: 'Update',
                value: 'update',
              ),
              CustomPopupMenuItem(
                iconColor: AppColors.error,
                itemIcon: PhosphorIconsBold.warning,
                itemLabel: 'Report',
                value: 'report',
              ),
              CustomPopupMenuItem(
                iconColor: AppColors.error,
                itemIcon: PhosphorIconsBold.trash,
                itemLabel: 'Delete',
                value: 'delete',
              ),
            ],
      ),
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'edit':
        _editVehicle(context);
      case 'qrcode':
        _viewQrCode(context);
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

  void _editVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => CustomEditDialog(
            vehicle: vehicleEntry,
            title: "Edit Vehicle Information",
            onSave: (updatedEntry) async {
              try {
                await context.read<VehicleCubit>().updateVehicle(
                  vehicleEntry.vehicleID,
                  updatedEntry.toMap(),
                );
                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: 'Vehicle details updated successfully.',
                    type: SnackBarType.success,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: 'Failed to update vehicle: $e',
                    type: SnackBarType.error,
                  );
                }
              }
            },
          ),
    );
  }

  void _viewQrCode(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: context.read<VehicleCubit>(),
            child: ViewQrCodeDialog(title: "Vehicle QR", vehicle: vehicleEntry),
          ),
    );
  }

  void _updateVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => CustomUpdateStatusDialog(
            vehicleID: vehicleEntry.vehicleID,
            currentStatus: vehicleEntry.status,
            onSave: (newStatus) async {
              try {
                await context.read<VehicleCubit>().updateVehicle(
                  vehicleEntry.vehicleID,
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
                if (context.mounted) {
                  CustomSnackBar.show(
                    context: context,
                    message: "Failed to update status: $e",
                    type: SnackBarType.error,
                  );
                }
              }
            },
          ),
    );
  }

  void _reportVehicle(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<VehicleCubit>(),
            child: CustomReportDialog(
              title: "Report Vehicle",
              vehicleEntry: vehicleEntry,
            ),
          ),
    );
    //todo
  }

  void _deleteVehicle(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder:
          (_) => CustomDeleteDialog(
            title: "Delete Vehicle",
            onDelete: () async {
              try {
                await context.read<VehicleCubit>().deleteVehicle(
                  vehicleEntry.vehicleID,
                );
                CustomSnackBar.show(
                  // ignore: use_build_context_synchronously
                  context: context,
                  message: "Vehicle deleted successfully!",
                  type: SnackBarType.success,
                );
              } catch (e) {
                CustomSnackBar.show(
                  // ignore: use_build_context_synchronously
                  context: context,
                  message: "Failed to delete vehicle: $e",
                  type: SnackBarType.error,
                );
              }
              // ignore: use_build_context_synchronously
            },
          ),
    );
  }
}
