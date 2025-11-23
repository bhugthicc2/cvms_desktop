import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/qr/custom_qr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
//crypto
import 'package:cvms_desktop/core/services/cyrpto_service.dart';

class ViewQrCodeDialog extends StatefulWidget {
  final String title;
  final VehicleEntry vehicle;

  const ViewQrCodeDialog({
    super.key,
    required this.title,
    required this.vehicle,
  });

  @override
  State<ViewQrCodeDialog> createState() => _ViewQrCodeDialogState();
}

class _ViewQrCodeDialogState extends State<ViewQrCodeDialog> {
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // -----------encryption----------
    final rawVehicleId = widget.vehicle.vehicleID;
    final qrData = CryptoService.withDefaultKey().encryptVehicleId(
      rawVehicleId,
    );
    // -------end of encryption----------

    final screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<VehicleCubit, VehicleState>(
      listener: (context, state) {
        if (state.exportedFilePath != null) {
          CustomSnackBar.showSuccess(
            context,
            'MVP Sticker saved to ${state.exportedFilePath}',
          );
          Navigator.of(context).pop(); // Close dialog on success
        }
        if (state.error != null) {
          CustomSnackBar.showError(context, 'Error: ${state.error}');
          Navigator.of(context).pop(); // Close dialog on error
        }
      },
      builder: (context, state) {
        return CustomDialog(
          icon: PhosphorIconsRegular.qrCode,
          width: 500,
          btnTxt: 'Export',
          onSubmit:
              () => context.read<VehicleCubit>().exportCardAsImage(
                _cardKey,
                widget.vehicle.ownerName,
              ),
          title: widget.title,
          height: screenHeight * 0.9,
          isExpanded: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacing.vertical(size: AppSpacing.medium),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 4),
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                      ),
                    ),
                  ),
                ),

                Spacing.vertical(size: AppSpacing.medium),
                //OWNER NAME
                Text(
                  widget.vehicle.ownerName,
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: AppFontSizes.xLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                // VEHICLE MODEL AND TYPE
                Text(
                  '${widget.vehicle.vehicleModel} (${widget.vehicle.vehicleType})',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),

                Spacing.vertical(size: AppSpacing.xxLarge),

                Text(
                  'Modified AES-128 Encrypted QR Code',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: AppFontSizes.small,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey.withValues(alpha: 0.5),
                  ),
                ),

                Spacing.vertical(size: AppSpacing.medium),
                CustomTextField(
                  labelText: 'QR Code Data',
                  controller: TextEditingController(text: qrData),
                  obscureText: true,
                  enableVisibilityToggle: true,
                  enabled: true,
                ),
                Spacing.vertical(size: AppSpacing.large),
                RepaintBoundary(
                  key: _cardKey,
                  child: CustomQrCard(
                    plateNumber: widget.vehicle.plateNumber,
                    qrData: qrData,
                    embeddedImage: const AssetImage(
                      'assets/images/jrmsu-logo.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
