import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleState.initial());

  void loadEntries(List<VehicleEntry> entries) {
    emit(state.copyWith(allEntries: entries, filteredEntries: entries));
  }

  void filterEntries(String query) {
    final filtered =
        state.allEntries
            .where(
              (e) =>
                  (e.name.toLowerCase().contains(query.toLowerCase()) ||
                      e.vehicle.toLowerCase().contains(query.toLowerCase()) ||
                      e.schoolID.toLowerCase().contains(query.toLowerCase()) ||
                      e.plateNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      e.vehicleModel.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      e.vehicleType.toLowerCase().contains(
                        query.toLowerCase(),
                      )) ||
                  e.status.toLowerCase().contains(query.toLowerCase()) ||
                  e.vehicleColor.toLowerCase().contains(query.toLowerCase()) ||
                  e.violationStatus.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    emit(state.copyWith(filteredEntries: filtered));
  }
}
