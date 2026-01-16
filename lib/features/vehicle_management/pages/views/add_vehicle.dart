import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/buttons/custom_icon_button.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/stepper_controller.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step1.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step2.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step3.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step4.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step5.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/indicator/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddVehicleView extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onCancel;
  final double horizontalPadding;
  const AddVehicleView({
    super.key,
    required this.onNext,
    required this.onCancel,
    double? horizontalPadding,
  }) : horizontalPadding = horizontalPadding ?? 0;

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  late final StepperController _stepperController;

  // GlobalKeys for step content validation
  final GlobalKey step1Key = GlobalKey();
  final GlobalKey step2Key = GlobalKey();
  final GlobalKey step3Key = GlobalKey();
  final GlobalKey step4Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _stepperController = StepperController(
      totalSteps: 5,
      onStepChanged: () => setState(() {}),
      onCompleted: widget.onNext,
    );
  }

  @override
  void dispose() {
    _stepperController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_stepperController.isFirstStep) {
      widget.onCancel();
      return;
    }
    _stepperController.previousStep();
  }

  bool _validateCurrentStep() {
    bool isValid = false;

    try {
      switch (_stepperController.currentStep) {
        case 0:
          final step1State = step1Key.currentState;
          if (step1State != null) {
            isValid = (step1State as dynamic).validate();
          }
          break;
        case 1:
          final step2State = step2Key.currentState;
          if (step2State != null) {
            isValid = (step2State as dynamic).validate();
          }
          break;
        case 2:
          final step3State = step3Key.currentState;
          if (step3State != null) {
            isValid = (step3State as dynamic).validate();
          }
          break;
        case 3:
          final step4State = step4Key.currentState;
          if (step4State != null) {
            isValid = (step4State as dynamic).validate();
          }
          break;
        case 4:
          // Review step doesn't need validation
          isValid = true;
          break;
      }
    } catch (e) {
      // If validation fails, assume valid to not block navigation
      isValid = true;
    }

    return isValid;
  }

  void _handleStepNavigation(int targetStep) {
    // Allow navigation backwards without validation
    if (targetStep < _stepperController.currentStep) {
      _stepperController.goToStep(targetStep);
      return;
    }

    // For forward navigation, validate all previous steps
    for (int i = 0; i < targetStep; i++) {
      bool isValid = false;
      switch (i) {
        case 0:
          final step1State = step1Key.currentState;
          if (step1State != null) {
            isValid = (step1State as dynamic).validate();
          }
          break;
        case 1:
          final step2State = step2Key.currentState;
          if (step2State != null) {
            isValid = (step2State as dynamic).validate();
          }
          break;
        case 2:
          final step3State = step3Key.currentState;
          if (step3State != null) {
            isValid = (step3State as dynamic).validate();
          }
          break;
        case 3:
          final step4State = step4Key.currentState;
          if (step4State != null) {
            isValid = (step4State as dynamic).validate();
          }
          break;
      }

      if (!isValid) {
        // If any step is invalid, go back to that step and stop navigation
        _stepperController.goToStep(i);
        return;
      }
    }

    // All previous steps are valid, proceed to target step
    _stepperController.goToStep(targetStep);
  }

  void _handleNext() {
    if (_validateCurrentStep()) {
      _stepperController.nextStep();
    }
  }

  List<Widget> _buildStepContent(double horizontalPadding) {
    return [
      OwnerStepContent(key: step1Key, horizontalPadding: horizontalPadding),
      VehicleStepContent(key: step2Key, horizontalPadding: horizontalPadding),
      LegalStepContent(key: step3Key, horizontalPadding: horizontalPadding),
      AddressStepContent(key: step4Key, horizontalPadding: horizontalPadding),
      ReviewStepContent(horizontalPadding: horizontalPadding),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleFormCubit(),
      child: Builder(
        builder: (context) {
          // Calculate 5% of screen width for horizontal padding
          final screenWidth = MediaQuery.of(context).size.width;
          final calculatedPadding = screenWidth * 0.05;

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
                                onTap: () => _handleStepNavigation(0),
                              ),
                              StepIndicator(
                                step: 1,
                                title: 'Vehicle Information',
                                supportText: 'Vehicle details',
                                currentStep: _stepperController.currentStep,
                                onTap: () => _handleStepNavigation(1),
                              ),
                              StepIndicator(
                                step: 2,
                                title: 'Legal Details',
                                supportText: 'Vehicle legal details',
                                currentStep: _stepperController.currentStep,
                                onTap: () => _handleStepNavigation(2),
                              ),
                              StepIndicator(
                                step: 3,
                                title: 'Address Information',
                                supportText: 'Owner address',
                                currentStep: _stepperController.currentStep,
                                onTap: () => _handleStepNavigation(3),
                              ),
                              StepIndicator(
                                step: 4,
                                title: 'Review & Confirm',
                                supportText: 'entry review',
                                currentStep: _stepperController.currentStep,
                                onTap: () => _handleStepNavigation(4),
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
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 300,
                          ),
                          child:
                              _buildStepContent(
                                calculatedPadding,
                              )[_stepperController.currentStep],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: calculatedPadding,
                        vertical: AppSpacing.small,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            const Spacer(flex: 4),

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
                                    _stepperController.isLastStep
                                        ? 'Save'
                                        : 'Next',
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
        },
      ),
    );
  }
}
