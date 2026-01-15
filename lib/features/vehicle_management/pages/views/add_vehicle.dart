import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/buttons/custom_icon_button.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/stepper_controller.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/content/owner_step_content.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/content/vehicle_step_content.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/content/legal_step_content.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/content/address_step_content.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/content/review_step_content.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/indicator/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
  late final StepperController _stepperController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _stepperController = StepperController(
      totalSteps: 5,
      onStepChanged: () => setState(() {}),
      onCompleted: widget.onNext,
    );

    _tabController.addListener(() {
      _stepperController.goToStep(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _stepperController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_stepperController.isFirstStep) {
      widget.onCancel();
      return;
    }
    _stepperController.previousStep();
    _tabController.animateTo(_stepperController.currentStep);
  }

  void _handleNext() {
    _stepperController.nextStep();
    if (!_stepperController.isLastStep) {
      _tabController.animateTo(_stepperController.currentStep);
    }
  }

  List<Widget> _buildStepContent() {
    return [
      const OwnerStepContent(),
      const VehicleStepContent(),
      const LegalStepContent(),
      const AddressStepContent(),
      const ReviewStepContent(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                child: Row(
                  children: [
                    CustomIconButton(
                      iconSize: 24,
                      onTap: () {
                        _handleBack();
                      },
                      icon: PhosphorIconsBold.arrowLeft,
                      iconColor: AppColors.primary,
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Text(
                      'Add New Vehicle Record',
                      style: TextStyle(
                        fontSize: AppFontSizes.large,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StepIndicator(
                          step: 0,
                          title: 'Owner Information',
                          supportText: 'Vehicle owner info',
                          currentStep: _stepperController.currentStep,
                          onTap: () => _stepperController.goToStep(0),
                        ),
                        StepIndicator(
                          step: 1,
                          title: 'Vehicle Information',
                          supportText: 'Vehicle details',
                          currentStep: _stepperController.currentStep,
                          onTap: () => _stepperController.goToStep(1),
                        ),
                        StepIndicator(
                          step: 2,
                          title: 'Legal Details',
                          supportText: 'Vehicle legal details',
                          currentStep: _stepperController.currentStep,
                          onTap: () => _stepperController.goToStep(2),
                        ),
                        StepIndicator(
                          step: 3,
                          title: 'Address Information',
                          supportText: 'Owner address',
                          currentStep: _stepperController.currentStep,
                          onTap: () => _stepperController.goToStep(3),
                        ),
                        StepIndicator(
                          step: 4,
                          title: 'Review & Confirm',
                          supportText: 'entry review',
                          currentStep: _stepperController.currentStep,
                          onTap: () => _stepperController.goToStep(4),
                        ),
                      ],
                    );
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
                  children:
                      _buildStepContent().map((stepContent) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 300,
                            ),
                            child: stepContent,
                          ),
                        );
                      }).toList(),
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
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
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
                          text:
                              _stepperController.isLastStep ? 'Finish' : 'Next',
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
      ),
    );
  }
}
