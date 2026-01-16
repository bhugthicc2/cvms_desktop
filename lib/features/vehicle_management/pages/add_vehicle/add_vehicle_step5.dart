import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_state.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewStepContent extends StatelessWidget {
  final double horizontalPadding;
  const ReviewStepContent({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleFormCubit, VehicleFormState>(
      builder: (context, state) {
        final formData = state.formData;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.large,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentTitle(
                title: 'Review & Confirm',
                subtitle: 'Please review all information before submitting',
              ),

              const Spacing.vertical(size: AppSpacing.medium),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Owner Information Section
                  Expanded(
                    child: Column(
                      children: [
                        _buildSection('Owner Information', [
                          _buildInfoRow('Owner Name', formData.ownerName),
                          _buildInfoRow('Gender', formData.gender),
                          _buildInfoRow('College', formData.department),
                          _buildInfoRow('Contact', formData.contact),
                          _buildInfoRow('Year Level', formData.yearLevel),
                          _buildInfoRow('School ID', formData.schoolId),
                          _buildInfoRow('Block', formData.block),
                        ]),
                        const Spacing.vertical(size: AppSpacing.large),
                        // Address Information Section
                        _buildSection('Address Information', [
                          _buildInfoRow('Region', formData.region),
                          _buildInfoRow('Province', formData.province),
                          _buildInfoRow('Municipality', formData.municipality),
                          _buildInfoRow('Barangay', formData.barangay),
                          _buildInfoRow('Purok/Street', formData.purokStreet),
                        ]),
                      ],
                    ),
                  ),

                  const Spacing.horizontal(size: AppSpacing.large),

                  // Vehicle Information Section
                  Expanded(
                    child: Column(
                      children: [
                        _buildSection('Vehicle Information', [
                          _buildInfoRow('Plate Number', formData.plateNumber),
                          _buildInfoRow('Vehicle Model', formData.vehicleModel),
                          _buildInfoRow('Vehicle Color', formData.vehicleColor),
                          _buildInfoRow('Vehicle Type', formData.vehicleType),
                        ]),

                        const Spacing.vertical(size: AppSpacing.large),

                        // Legal Details Section
                        _buildSection('Legal Details', [
                          _buildInfoRow('OR Number', formData.orNumber),
                          _buildInfoRow('CR Number', formData.crNumber),
                          _buildInfoRow('Plate Number', formData.plateNumber),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacing.vertical(size: AppSpacing.large),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greySurface),
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
                  color: AppColors.black.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const Spacing.vertical(size: AppSpacing.small),
          CustomDivider(
            color: AppColors.greySurface,
            direction: Axis.horizontal,
          ),
          const Spacing.vertical(size: AppSpacing.small),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
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
                color: AppColors.black.withValues(alpha: 0.8),
              ),
            ),
          ),
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
}
