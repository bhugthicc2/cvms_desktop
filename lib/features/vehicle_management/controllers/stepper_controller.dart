import 'package:flutter/material.dart';

class StepperController extends ChangeNotifier {
  final int totalSteps;
  final VoidCallback? onStepChanged;
  final VoidCallback? onCompleted;

  int _currentStep = 0;

  StepperController({
    required this.totalSteps,
    this.onStepChanged,
    this.onCompleted,
  });

  int get currentStep => _currentStep;
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == totalSteps - 1;
  double get progress => (_currentStep + 1) / totalSteps;

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps && step != _currentStep) {
      _currentStep = step;
      onStepChanged?.call();
      notifyListeners();
    }
  }

  void nextStep() {
    if (!isLastStep) {
      _currentStep++;
      onStepChanged?.call();
      notifyListeners();
    } else {
      onCompleted?.call();
    }
  }

  void previousStep() {
    if (!isFirstStep) {
      _currentStep--;
      onStepChanged?.call();
      notifyListeners();
    }
  }

  void reset() {
    _currentStep = 0;
    onStepChanged?.call();
    notifyListeners();
  }
}
