import 'package:cvms_desktop/features/vehicle_management/models/vehicle_form_data.dart';
import 'package:equatable/equatable.dart';

abstract class VehicleFormState extends Equatable {
  final VehicleFormData formData;

  const VehicleFormState({required this.formData});

  @override
  List<Object?> get props => [formData];
}

class VehicleFormInitial extends VehicleFormState {
  const VehicleFormInitial() : super(formData: const VehicleFormData());
}

class VehicleFormUpdated extends VehicleFormState {
  const VehicleFormUpdated({required super.formData});
}
