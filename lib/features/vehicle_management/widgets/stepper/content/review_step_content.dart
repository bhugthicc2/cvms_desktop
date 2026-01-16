import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class ReviewStepContent extends StatelessWidget {
  final double horizontalPadding;

  // Owner Information
  final String? ownerName;
  final String? college;
  final String? contact;
  final String? yearLevel;
  final String? schoolId;
  final String? block;
  final String? gender;

  // Vehicle Information
  final String? plateNumber;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehicleType;

  // Legal Details
  final String? licenseNumber;
  final String? orNumber;
  final String? crNumber;

  // Address Information
  final String? region;
  final String? province;
  final String? municipality;
  final String? barangay;
  final String? purokStreet;

  const ReviewStepContent({
    super.key,
    required this.horizontalPadding,
    this.ownerName,
    this.college,
    this.contact,
    this.yearLevel,
    this.schoolId,
    this.block,
    this.gender,
    this.plateNumber,
    this.vehicleModel,
    this.vehicleColor,
    this.vehicleType,
    this.licenseNumber,
    this.orNumber,
    this.crNumber,
    this.region,
    this.province,
    this.municipality,
    this.barangay,
    this.purokStreet,
  });

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.large),
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greySurface, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getIconForSection(title),

              const Spacing.horizontal(size: AppSpacing.small),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacing.vertical(size: AppSpacing.medium),
          CustomDivider(direction: Axis.horizontal, thickness: 1),
          const Spacing.vertical(size: AppSpacing.medium),
          ...children,
        ],
      ),
    );
  }

  Image _getIconForSection(String title) {
    switch (title) {
      case 'Owner Information':
        return Image.asset(
          'assets/icons/stencil/person.png',
          width: 20,
          height: 20,
        );
      case 'Vehicle Information':
        return Image.asset(
          'assets/icons/stencil/vehicle.png',
          width: 20,
          height: 20,
        );
      case 'Legal Details':
        return Image.asset(
          'assets/icons/stencil/doc.png',
          width: 20,
          height: 20,
        );
      case 'Address Information':
        return Image.asset(
          'assets/icons/stencil/location.png',
          width: 20,
          height: 20,
        );
      default:
        return Image.asset(
          'assets/icons/stencil/info.png',
          width: 20,
          height: 20,
        );
    }
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          const Spacing.horizontal(size: AppSpacing.small),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.bold,
                color: value != null ? AppColors.black : AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Confirm',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            'Please review all information before submitting',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: AppColors.grey,
            ),
          ),
          const Spacing.vertical(size: AppSpacing.large),

          // Two Column Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                child: Column(
                  children: [
                    // Owner Information Section
                    _buildSection('Owner Information', [
                      _buildInfoRow('Owner Name', ownerName),
                      _buildInfoRow('Gender', gender),
                      _buildInfoRow('College', college),
                      _buildInfoRow('Year Level', yearLevel),
                      _buildInfoRow('Contact', contact),
                      _buildInfoRow('School ID', schoolId),
                      _buildInfoRow('Block', block),
                    ]),

                    // Legal Details Section
                    _buildSection('Legal Details', [
                      _buildInfoRow('License Number', licenseNumber),
                      _buildInfoRow('OR Number', orNumber),
                      _buildInfoRow('CR Number', crNumber),
                    ]),
                  ],
                ),
              ),

              const Spacing.horizontal(size: AppSpacing.large),

              // Right Column
              Expanded(
                child: Column(
                  children: [
                    // Vehicle Information Section
                    _buildSection('Vehicle Information', [
                      _buildInfoRow('Plate Number', plateNumber),
                      _buildInfoRow('Vehicle Model', vehicleModel),
                      _buildInfoRow('Vehicle Color', vehicleColor),
                      _buildInfoRow('Vehicle Type', vehicleType),
                    ]),

                    // Address Information Section
                    _buildSection('Address Information', [
                      _buildInfoRow('Region', region),
                      _buildInfoRow('Province', province),
                      _buildInfoRow('Municipality', municipality),
                      _buildInfoRow('Barangay', barangay),
                      _buildInfoRow('Purok/Street', purokStreet),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
