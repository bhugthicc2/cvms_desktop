import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/button/custom_view_button.dart';
import 'package:cvms_desktop/features/reports/utils/vehicle_info_helpers.dart';
import 'package:flutter/material.dart';

class VehicleInfoSection extends StatefulWidget {
  final String title;
  final VoidCallback onViewTap;

  // Vehicle
  final String vehicleModel;
  final String plateNumber;
  final String vehicleType;

  // Owner
  final String ownerName;
  final String department;
  final String status;

  // MVP
  final double mvpProgress; // 0.0 - 1.0
  final DateTime? mvpRegisteredDate;
  final DateTime? mvpExpiryDate;

  const VehicleInfoSection({
    super.key,
    required this.onViewTap,
    this.title = "Vehicle Information",
    required this.vehicleModel,
    required this.plateNumber,
    required this.vehicleType,
    required this.ownerName,
    required this.department,
    required this.status,
    required this.mvpProgress,
    this.mvpRegisteredDate,
    this.mvpExpiryDate,
  });

  @override
  State<VehicleInfoSection> createState() => _VehicleInfoSectionState();
}

class _VehicleInfoSectionState extends State<VehicleInfoSection>
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

    // Start animation after a brief delay for visual effect
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(VehicleInfoSection oldWidget) {
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
          // Top section
          Padding(
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
                  "assets/images/four_wheeled.png",
                  width: 40,
                  height: 40,
                ),
                Spacing.horizontal(size: AppSpacing.small),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.vehicleModel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.plateNumber,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                CustomViewButton(onTap: widget.onViewTap),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.xSmall,
            ),
            child: const CustomDivider(direction: Axis.horizontal),
          ),
          //Mid section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //owner
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.xSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Owner',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),

                                Text(
                                  widget.ownerName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.small,
                            ),
                            child: const CustomDivider(
                              direction: Axis.horizontal,
                            ),
                          ),
                          //vehicle type
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.xSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),

                                Text(
                                  widget.vehicleType,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //type
                        ],
                      ),
                    ),

                    Spacing.horizontal(size: AppSpacing.medium),
                    const CustomDivider(direction: Axis.vertical, length: 70),
                    Spacing.horizontal(size: AppSpacing.medium),

                    // RIGHT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //owner
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.xSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Department',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),

                                Text(
                                  widget.department,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.small,
                            ),
                            child: const CustomDivider(
                              direction: Axis.horizontal,
                            ),
                          ),
                          //vehicle type
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                              vertical: AppSpacing.xSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                                Spacing.vertical(size: AppSpacing.xSmall),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.medium,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.chartOrange,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    widget.status,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //type
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.xSmall,
            ),
            child: const CustomDivider(direction: Axis.horizontal),
          ),
          // Bottom section
          Padding(
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
                    const Text(
                      "MVP Validity Status",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      VehicleInfoHelpers.getMvpStatusText(
                        widget.mvpRegisteredDate,
                        widget.mvpExpiryDate,
                      ),
                      style: TextStyle(
                        color: VehicleInfoHelpers.getMvpStatusColor(
                          widget.mvpRegisteredDate,
                          widget.mvpExpiryDate,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
                        VehicleInfoHelpers.getMvpProgressColor(
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
                    Text(
                      VehicleInfoHelpers.formatDate(
                        widget.mvpRegisteredDate,
                        'Registered on ',
                      ),
                      style: TextStyle(fontSize: 11, color: AppColors.primary),
                    ),
                    Spacer(),
                    Text(
                      VehicleInfoHelpers.formatDate(
                        widget.mvpExpiryDate,
                        'Expires on ',
                      ),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
