import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ViewQrCodeDialog extends StatelessWidget {
  final String title;
  const ViewQrCodeDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomDialog(
      icon: PhosphorIconsRegular.qrCode,
      width: 500,
      btnTxt: 'Export',
      onSave: () {},
      title: title,
      height: screenHeight * 0.9,
      isExpanded: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacing.vertical(size: AppSpacing.medium),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/profile.png'),
                ),
                border: Border.all(color: AppColors.primary, width: 2),
                color: AppColors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            Text(
              'Jesie Gapol',
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            Text(
              'Honda Beat',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: AppFontSizes.medium,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            Spacing.vertical(size: AppSpacing.xxxLarge),
            Text(
              'Modified AES- 128 Encrypted QR Code',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            CustomTextField(
              labelText: 'QR Code data',
              obscureText: true,
              enableVisibilityToggle: true,
              //todo display the encrypted(8 round aes 128 algorithm with lfsr-based mixed columns and dynamic shiftrows) qr code data here
            ),
            SizedBox(
              height: 280,
              width: 280,
              child: PrettyQrView.data(
                data: 'Sample', //todo cipher data here
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(color: AppColors.darkBlue),

                  image: PrettyQrDecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/jrmsu-logo.png'),
                  ),
                  quietZone: PrettyQrQuietZone.standart,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
