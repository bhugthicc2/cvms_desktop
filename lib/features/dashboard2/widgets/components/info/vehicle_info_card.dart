import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard2/services/vehicle_info_service.dart';
import 'package:cvms_desktop/features/dashboard/widgets/buttons/custom_view_button.dart';
import 'package:cvms_desktop/features/dashboard/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class VehicleInfoCard extends StatefulWidget {
  final String title;
  final String plateNumber;
  final String ownerName;
  final String vehicleType;
  final String department;
  final String status;
  final String vehicleModel;
  final DateTime createdAt;
  final DateTime expiryDate;
  // MVP Progress fields
  final double mvpProgress;
  final DateTime mvpRegisteredDate;
  final DateTime mvpExpiryDate;
  final String mvpStatusText;

  final VoidCallback onViewTap;

  const VehicleInfoCard({
    super.key,
    required this.onViewTap,
    this.title = "Vehicle Information",
    required this.plateNumber,
    required this.ownerName,
    required this.vehicleType,
    required this.department,
    required this.status,
    required this.vehicleModel,
    required this.createdAt,
    required this.expiryDate,
    required this.mvpProgress,
    required this.mvpRegisteredDate,
    required this.mvpExpiryDate,
    required this.mvpStatusText,
  });

  @override
  State<VehicleInfoCard> createState() => _VehicleInfoCardState();
}

class _VehicleInfoCardState extends State<VehicleInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(VehicleInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mvpProgress != widget.mvpProgress) {
      _progressController.reset();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _progressController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderSection(),
          const CustomDivider(direction: Axis.horizontal),
          Expanded(child: _buildInfoSection()),
          const CustomDivider(direction: Axis.horizontal),
          _buildMvpSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            VehicleInfoService.getVehicleTypeIcon(widget.vehicleType),
            width: 40,
            height: 40,
          ),
          Spacing.horizontal(size: AppSpacing.small),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: widget.vehicleModel,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              CustomText(text: widget.plateNumber),
            ],
          ),
          const Spacer(),
          CustomViewButton(onTap: widget.onViewTap),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(child: _buildLeftColumn()),
            Spacing.horizontal(size: AppSpacing.medium),
            const CustomDivider(direction: Axis.vertical, length: 70),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(child: _buildRightColumn()),
          ],
        ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem('Owner', widget.ownerName),
        const CustomDivider(direction: Axis.horizontal),
        _buildInfoItem('Type', widget.vehicleType),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem('Department', widget.department),
        const CustomDivider(direction: Axis.horizontal),
        _buildStatusItem(),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.xSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: label, fontSize: 12, color: AppColors.grey),
          CustomText(text: value, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildStatusItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.xSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: 'Status', fontSize: 12, color: AppColors.grey),
          Spacing.vertical(size: AppSpacing.xSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: VehicleInfoService.getStatusColor(widget.status),
              borderRadius: BorderRadius.circular(999),
            ),
            child: CustomText(
              text: widget.status.isEmpty ? 'No logs yet.' : widget.status,
              fontSize: 12,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMvpSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        0,
        AppSpacing.medium,
        AppSpacing.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.vertical(size: AppSpacing.xSmall),
          Row(
            children: [
              CustomText(
                text: 'MVP Validity Status',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              CustomText(
                text: widget.mvpStatusText,
                fontSize: 12,
                color: VehicleInfoService.getMvpStatusColor(
                  widget.mvpRegisteredDate,
                  widget.mvpExpiryDate,
                ),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Spacing.vertical(size: AppSpacing.small),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: widget.mvpProgress * _progressAnimation.value,
                minHeight: 6,
                borderRadius: BorderRadius.circular(6),
                backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  VehicleInfoService.getMvpProgressColor(
                    widget.mvpProgress,
                    widget.mvpRegisteredDate,
                    widget.mvpExpiryDate,
                  ),
                ),
              );
            },
          ),
          Spacing.vertical(size: AppSpacing.xSmall),
          Row(
            children: [
              CustomText(
                text: VehicleInfoService.formatDate(
                  widget.mvpRegisteredDate,
                  'Registered on ',
                ),
                fontSize: 11,
                color: AppColors.primary,
              ),
              const Spacer(),
              CustomText(
                text: VehicleInfoService.formatDate(
                  widget.mvpExpiryDate,
                  'Expires on ',
                ),
                fontSize: 11,
                color: AppColors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
