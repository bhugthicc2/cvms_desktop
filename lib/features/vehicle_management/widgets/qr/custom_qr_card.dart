import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/qr/custom_qr_view.dart';
import 'package:flutter/material.dart';

class CustomQrCard extends StatelessWidget {
  final String plateNumber;
  final String qrData;
  final ImageProvider<Object>? embeddedImage;

  const CustomQrCard({
    super.key,
    required this.plateNumber,
    required this.qrData,
    this.embeddedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bg.jpg'),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(AppSpacing.medium),
      height: 230,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Vehicle',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.xxxLarge + 3,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      'Pass',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.xxxLarge + 3,
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ),
                Text(
                  'JRMSU | KATIPUNAN',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppFontSizes.medium,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                Text(
                  plateNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSizes.large,
                    fontStyle: FontStyle.italic,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  '*This sticker will be valid until March 2026. Please renew before the expiration. Thank you.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppFontSizes.xSmall,
                    color: AppColors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          // QR view
          Container(
            height: 190,
            width: 190,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomQrView(qrData: qrData, embeddedImage: embeddedImage),
          ),
        ],
      ),
    );
  }
}
