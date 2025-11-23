import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/dialogs/custom_update_dialog.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/dialogs/custom_view_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/widgets/app/pop_up_menu_item.dart';

class VehicleLogsActionsMenu extends StatelessWidget {
  final VehicleLogModel vehicleLog;
  final int rowIndex;
  final BuildContext context;

  const VehicleLogsActionsMenu({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.vehicleLog,
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
                itemLabel: 'Edit Log',
                value: 'edit',
              ),
              CustomPopupMenuItem(
                iconColor: AppColors.success,
                itemIcon: PhosphorIconsBold.arrowsClockwise,
                itemLabel: 'Update',
                value: 'update',
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

      case 'update':
        _updateVehicle(context, vehicleLog.vehicleID, vehicleLog.toMap());
        break;

      case 'delete':
        _deleteVehicle(context);
        break;
    }
  }

  void _editVehicle(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder:
          (_) => CustomViewDialog(vehicleId: 'todo', title: "Delete Vehicle"),
    );
  }

  void _updateVehicle(
    BuildContext context,
    String vehicleID,
    Map<String, dynamic> vehicleInfo,
  ) {
    final cubit = context.read<VehicleLogsCubit>();

    showDialog(
      context: context,
      builder:
          (_) => CustomUpdateDialog(
            onUpdate: (status) async {
              final authRepo = AuthRepository();
              final userRepo = UserRepository();
              final uid = authRepo.uid;
              final updatedBy =
                  uid != null
                      ? (await userRepo.getUserFullname(uid)) ?? "Unknown"
                      : "Unknown";

              if (status == "onsite") {
                await cubit.startSession(vehicleID, updatedBy, vehicleInfo);
              } else if (status == "offsite") {
                await cubit.endSession(vehicleID, updatedBy);
              }

              if (context.mounted) {
                CustomSnackBar.show(
                  context: context,
                  message: "Vehicle updated successfully",
                  type: SnackBarType.success,
                );
              }
            },
          ),
    );
  }

  void _deleteVehicle(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder:
          (_) => CustomDeleteDialog(
            title: "Delete Vehicle",
            message:
                "Are you sure you want to delete Name's vehicle plateNumber?",
            onConfirm: () {
              //todo
            },
          ),
    );
  }
}
