import 'package:flutter/material.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/stepper_controller.dart';

/// Controller that handles all business logic for the Add Vehicle flow
/// Separated from UI to improve testability and maintainability
class AddVehicleController {
  final StepperController stepperController;

  AddVehicleController({required this.stepperController});

  /// Validates the current step based on the step keys
  bool validateCurrentStep(List<GlobalKey> stepKeys) {
    if (stepperController.isLastStep) {
      return true; // Review step doesn't need validation
    }

    final currentStepIndex = stepperController.currentStep;
    if (currentStepIndex >= stepKeys.length) {
      return true;
    }

    try {
      final stepState = stepKeys[currentStepIndex].currentState;
      if (stepState != null) {
        return (stepState as dynamic).validate() ?? false;
      }
    } catch (e) {
      // If validation fails, assume valid to not block navigation
      return true;
    }

    return false;
  }

  /// Validates all steps up to the target step for forward navigation
  bool validateStepsUpTo(int targetStep, List<GlobalKey> stepKeys) {
    for (int i = 0; i < targetStep && i < stepKeys.length; i++) {
      try {
        final stepState = stepKeys[i].currentState;
        if (stepState != null) {
          final isValid = (stepState as dynamic).validate() ?? false;
          if (!isValid) {
            return false;
          }
        }
      } catch (e) {
        // If validation fails, assume valid to not block navigation
        continue;
      }
    }
    return true;
  }

  /// Handles navigation to a specific step with validation
  StepNavigationResult navigateToStep(
    int targetStep,
    List<GlobalKey> stepKeys,
  ) {
    // Allow navigation backwards without validation
    if (targetStep < stepperController.currentStep) {
      stepperController.goToStep(targetStep);
      return StepNavigationResult.success();
    }

    // For forward navigation, validate all previous steps
    if (!validateStepsUpTo(targetStep, stepKeys)) {
      // Find the first invalid step and go back to it
      for (int i = 0; i < targetStep && i < stepKeys.length; i++) {
        try {
          final stepState = stepKeys[i].currentState;
          if (stepState != null) {
            final isValid = (stepState as dynamic).validate() ?? false;
            if (!isValid) {
              stepperController.goToStep(i);
              return StepNavigationResult.validationFailed(i);
            }
          }
        } catch (e) {
          continue;
        }
      }
    }

    // All previous steps are valid, proceed to target step
    stepperController.goToStep(targetStep);
    return StepNavigationResult.success();
  }

  /// Handles back navigation
  BackNavigationResult handleBack() {
    if (stepperController.isFirstStep) {
      return BackNavigationResult.shouldCancel();
    }
    stepperController.previousStep();
    return BackNavigationResult.success();
  }

  /// Determines if next action should proceed based on validation
  NextNavigationResult canProceedToNext(List<GlobalKey> stepKeys) {
    final isValid = validateCurrentStep(stepKeys);
    if (isValid) {
      return NextNavigationResult.canProceed();
    }
    return NextNavigationResult.validationFailed();
  }
}

/// Result types for better error handling and type safety
class StepNavigationResult {
  final bool success;
  final int? invalidStepIndex;

  StepNavigationResult._({required this.success, this.invalidStepIndex});

  factory StepNavigationResult.success() =>
      StepNavigationResult._(success: true);
  factory StepNavigationResult.validationFailed(int stepIndex) =>
      StepNavigationResult._(success: false, invalidStepIndex: stepIndex);
}

class BackNavigationResult {
  final bool success;
  final bool shouldCancel;

  BackNavigationResult._({required this.success, required this.shouldCancel});

  factory BackNavigationResult.success() =>
      BackNavigationResult._(success: true, shouldCancel: false);
  factory BackNavigationResult.shouldCancel() =>
      BackNavigationResult._(success: false, shouldCancel: true);
}

class NextNavigationResult {
  final bool canProceed;

  NextNavigationResult._({required this.canProceed});

  factory NextNavigationResult.canProceed() =>
      NextNavigationResult._(canProceed: true);
  factory NextNavigationResult.validationFailed() =>
      NextNavigationResult._(canProceed: false);
}
