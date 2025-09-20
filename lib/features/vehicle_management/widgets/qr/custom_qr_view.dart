import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrView extends StatelessWidget {
  final String qrData;
  final String? qrImage;
  final ImageProvider<Object>? embeddedImage;
  final double? size;
  const CustomQrView({
    super.key,
    required this.qrData,
    this.qrImage,
    this.embeddedImage,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      padding: EdgeInsets.all(AppSpacing.large),
      data: qrData,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.circle,
        color: AppColors.darkBlue,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: AppColors.darkBlue,
      ),
      version: QrVersions.auto,
      size: size ?? 300,
      embeddedImage:
          embeddedImage ?? (qrImage != null ? AssetImage(qrImage!) : null),
      embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(30, 30)),
    );
  }
}
