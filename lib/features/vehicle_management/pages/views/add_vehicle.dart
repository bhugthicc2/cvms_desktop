import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/services/navigation_guard.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/widgets/buttons/custom_icon_button.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/stepper_controller.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/add_vehicle_controller.dart';
import 'package:cvms_desktop/features/vehicle_management/services/add_vehicle_service.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step1.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step2.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step3.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step4.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/add_vehicle/add_vehicle_step5.dart';
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
  late final AddVehicleController _controller;
  late final StepperController _stepperController;
  BuildContext? _builderContext;

  // GlobalKeys for step content validation
  final GlobalKey step1Key = GlobalKey();
  final GlobalKey step2Key = GlobalKey();
  final GlobalKey step3Key = GlobalKey();
  final GlobalKey step4Key = GlobalKey();

  // Service for external operations
  AddVehicleService? _addVehicleService;

  // Loading state for button
  bool _isSaving = false;

  // Track if form has unsaved changes
  bool _hasUnsavedChanges = false;
  final NavigationGuard _navigationGuard = NavigationGuard();

  @override
  void initState() {
    super.initState();
    _stepperController = StepperController(
      totalSteps: 5,
      onStepChanged: () => setState(() {}),
      onCompleted: widget.onNext,
    );
    _controller = AddVehicleController(stepperController: _stepperController);
  }

  @override
  void dispose() {
    _stepperController.dispose();
    _navigationGuard.unregisterUnsavedChanges();
    super.dispose();
  }

  /// Initialize service with cubit dependencies (called once)
  void _initializeService(BuildContext context) {
    _addVehicleService ??= AddVehicleService(
      formCubit: context.read<VehicleFormCubit>(),
      vehicleCubit: context.read<VehicleCubit>(),
    );

    // Listen to form changes to track unsaved state
    context.read<VehicleFormCubit>().stream.listen((_) {
      if (mounted && !_isSaving) {
        setState(() {
          _hasUnsavedChanges = true;
          _navigationGuard.registerUnsavedChanges(
            showDialogCallback: () => _showUnsavedChangesDialog(() {}),
          );
        });
      }
    });
  }

  /// Get step keys list for validation
  List<GlobalKey> get _stepKeys => [step1Key, step2Key, step3Key, step4Key];

  /// Handle back navigation through controller
  void _handleBack() {
    if (_hasUnsavedChanges) {
      _showUnsavedChangesDialog(() {
        final result = _controller.handleBack();
        if (result.shouldCancel) {
          widget.onCancel();
        }
      });
    } else {
      final result = _controller.handleBack();
      if (result.shouldCancel) {
        widget.onCancel();
      }
    }
  }

  /// Handle step navigation through controller
  void _handleStepNavigation(int targetStep) {
    _controller.navigateToStep(targetStep, _stepKeys);
  }

  /// Handle next action through controller and service
  Future<void> _handleNext() async {
    final canProceed = _controller.canProceedToNext(_stepKeys);
    if (!canProceed.canProceed) {
      return; // Validation failed, controller handles feedback
    }

    // Check if this is the last step (Review & Confirm)
    if (_stepperController.isLastStep) {
      final cubitContext = _builderContext;
      if (cubitContext != null && _addVehicleService != null) {
        // Set loading state
        setState(() {
          _isSaving = true;
        });

        try {
          // Use service to save vehicle
          await _addVehicleService!.saveVehicle(cubitContext);

          // Mark as saved after successful save
          if (mounted) {
            setState(() {
              _hasUnsavedChanges = false;
              _navigationGuard.unregisterUnsavedChanges();
            });
          }
        } finally {
          // Reset loading state
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }
        }
      }
    } else {
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

  /// Show confirmation dialog for unsaved changes
  void _showUnsavedChangesDialog(VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Unsaved Changes',
          icon: PhosphorIconsBold.warning,
          headerColor: AppColors.error,
          isAlert: true,
          width: 400,
          height: 200,
          btnTxt: 'Leave Anyway',
          onSubmit: () {
            Navigator.of(context).pop();
            _navigationGuard.confirmNavigation();
            onConfirm();
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Text(
              'Are you sure you want to leave? All entered data will be lost.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Handle will pop scope for navigation protection
  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final canNavigate = await _navigationGuard.checkUnsavedChanges();
      return canNavigate;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
        create: (_) => VehicleFormCubit(),
        child: Builder(
          builder: (context) {
            _builderContext = context;
            _initializeService(context);

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
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPadding,
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
                              minHeight:
                                  MediaQuery.of(context).size.height - 300,
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
                                          ? 'Save Vehicle'
                                          : 'Next',
                                  onPressed: _handleNext,
                                  isLoading:
                                      _stepperController.isLastStep &&
                                      _isSaving,
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
      ),
    );
  }
}
