import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class AddVehicleView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onCancel;
  const AddVehicleView({
    super.key,
    required this.onNext,
    required this.onCancel,
  });

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _currentStep => _tabController.index;

  void _handleBack() {
    if (_currentStep == 0) {
      widget.onCancel();
      return;
    }
    _tabController.animateTo(_currentStep - 1);
  }

  void _handleNext() {
    if (_currentStep < 4) {
      _tabController.animateTo(_currentStep + 1);
      return;
    }
    widget.onNext();
  }

  Widget _buildStepIndicator(int step, String title, String supportText) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Expanded(
      child: InkWell(
        onTap: () => _tabController.animateTo(step),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Step track with centered circle and connecting lines
            LayoutBuilder(
              builder: (context, constraints) {
                final slotWidth = constraints.maxWidth;
                final halfLineWidth = slotWidth / 2 - 20;
                final lineColorBefore =
                    (_currentStep >= step)
                        ? AppColors.primary
                        : AppColors.grey.withValues(alpha: 0.3);
                final lineColorAfter =
                    isCompleted
                        ? AppColors.primary
                        : AppColors.grey.withValues(alpha: 0.3);
                final verticalLineOffset = (40 - 3) / 2;

                return SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Stack(
                    children: [
                      // Before line (right half of previous connection)
                      if (step > 0 && halfLineWidth > 0)
                        Positioned(
                          left: 0,
                          top: verticalLineOffset,
                          child: SizedBox(
                            width: halfLineWidth,
                            height: 3,
                            child: Container(
                              decoration: BoxDecoration(color: lineColorBefore),
                            ),
                          ),
                        ),
                      // After line (left half of next connection)
                      if (step < 4 && halfLineWidth > 0)
                        Positioned(
                          left: slotWidth / 2 + 20,
                          top: verticalLineOffset,
                          child: SizedBox(
                            width: halfLineWidth,
                            height: 3,
                            child: Container(
                              decoration: BoxDecoration(color: lineColorAfter),
                            ),
                          ),
                        ),

                      // Centered step circle
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isCompleted || isActive
                                          ? AppColors.primary.withValues(
                                            alpha: 0.4,
                                          )
                                          : AppColors.grey.withValues(
                                            alpha: 0.2,
                                          ),
                                  width: 6,
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color:
                                    isCompleted
                                        ? AppColors.primary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isCompleted || isActive
                                          ? AppColors.primary
                                          : AppColors.grey.withValues(
                                            alpha: 0.2,
                                          ),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child:
                                    isCompleted
                                        ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                        : Text(
                                          '${step + 1}'.padLeft(2, '0'),
                                          style: TextStyle(
                                            color:
                                                isActive
                                                    ? AppColors.primary
                                                    : AppColors.grey.withValues(
                                                      alpha: 0.7,
                                                    ),
                                            fontSize: AppFontSizes.small,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Spacing.vertical(size: AppSpacing.small),
            // Title and support text
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color:
                        isCompleted || isActive
                            ? AppColors.primary
                            : AppColors.grey.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  supportText,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: AppColors.grey.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Owner Information',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Please provide the vehicle owner\'s personal details',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: AppColors.grey,
            ),
          ),
          Spacing.vertical(size: AppSpacing.large),
        ],
      ),
    );
  }

  Widget _buildVehicleContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Information',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Enter the vehicle details and specifications',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: AppColors.grey,
            ),
          ),
          Spacing.vertical(size: AppSpacing.large),
        ],
      ),
    );
  }

  Widget _buildLegalContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legal Details',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Provide license, registration, and other legal documents',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: AppColors.grey,
            ),
          ),
          Spacing.vertical(size: AppSpacing.large),
        ],
      ),
    );
  }

  Widget _buildAddressContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Information',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Enter the complete address details',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: AppColors.grey,
            ),
          ),
          Spacing.vertical(size: AppSpacing.large),
          Center(
            child: Icon(
              Icons.location_on_outlined,
              size: 120,
              color: AppColors.grey.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
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
          Spacing.vertical(size: AppSpacing.large),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.small,
        ),
        height: double.infinity,
        decoration: cardDecoration(radii: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.medium,
              ),
              child: Text(
                'Add New Vehicle Record',
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            CustomDivider(
              color: AppColors.greySurface,
              direction: Axis.horizontal,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.medium,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive step indicators
                  if (constraints.maxWidth < 800) {
                    // Compact layout for smaller screens
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStepIndicator(
                            0,
                            'Owner Information',
                            'Business type',
                          ),
                          _buildStepIndicator(
                            1,
                            'Vehicle Information',
                            'Business details',
                          ),
                          _buildStepIndicator(
                            2,
                            'Legal Details',
                            'Your details',
                          ),
                          _buildStepIndicator(
                            3,
                            'Address Information',
                            'Bank details',
                          ),
                          _buildStepIndicator(
                            4,
                            'Review & Confirm',
                            'Statement',
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Full layout for larger screens
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepIndicator(
                          0,
                          'Owner Information',
                          'Support text',
                        ),
                        _buildStepIndicator(
                          1,
                          'Vehicle Information',
                          'Business details',
                        ),
                        _buildStepIndicator(2, 'Legal Details', 'Your details'),
                        _buildStepIndicator(
                          3,
                          'Address Information',
                          'Bank details',
                        ),
                        _buildStepIndicator(4, 'Review & Confirm', 'Statement'),
                      ],
                    );
                  }
                },
              ),
            ),
            CustomDivider(
              color: AppColors.greySurface,
              direction: Axis.horizontal,
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildOwnerContent(),
                  _buildVehicleContent(),
                  _buildLegalContent(),
                  _buildAddressContent(),
                  _buildReviewContent(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Expanded(
                      child: CustomButton(
                        btnSubmitColor: AppColors.greySurface,
                        btnSubmitTxtColor: AppColors.grey,
                        text: 'Back',
                        onPressed: _handleBack,
                      ),
                    ),
                    Spacing.horizontal(size: AppFontSizes.medium),
                    Expanded(
                      child: CustomButton(
                        text: _currentStep == 4 ? 'Finish' : 'Next',
                        onPressed: _handleNext,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
