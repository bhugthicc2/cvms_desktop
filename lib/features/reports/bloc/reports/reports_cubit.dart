import 'package:cvms_desktop/features/reports/data/report_repository.dart';
import 'package:cvms_desktop/features/dashboard/data/analytics_repository.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/features/reports/models/vehicle_profile.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportRepository _repo = ReportRepository();
  final AnalyticsRepository _analyticsRepo;

  final Map<String, String> _vehicleSuggestionToId = {};

  ReportsCubit({required AnalyticsRepository analyticsRepo})
    : _analyticsRepo = analyticsRepo,
      super(const ReportsState(isGlobalMode: true)) {
    loadGlobalReport(); // Auto-load on init
  }

  Future<void> loadGlobalReport() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));
    try {
      final summary = await _repo.fetchFleetSummary();

      // Fetch real data for charts
      final vehicleDistribution =
          await _repo.fetchVehicleDistributionByCollege();
      final yearLevelBreakdown = await _repo.fetchYearLevelBreakdown();
      final cityBreakdown = await _repo.fetchCityBreakdown();
      final studentWithMostViolations =
          await _repo.fetchStudentWithMostViolations();

      final trendData = await _fetchTrendData(state.selectedTimeRange);

      emit(
        state.copyWith(
          fleetSummary: summary,
          logsData: trendData,
          loading: false,
          isGlobalMode: true, // Ensure global on load
          vehicleDistribution: vehicleDistribution,
          yearLevelBreakdown: yearLevelBreakdown,
          cityBreakdown: cityBreakdown,
          studentWithMostViolations: studentWithMostViolations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void setGlobalMode(bool mode) {
    if (isClosed) return;
    emit(state.copyWith(isGlobalMode: mode));
    if (mode) loadGlobalReport(); // Reload data on global enter
  }

  void showPdfPreview({
    Uint8List? vehicleDistributionChartBytes,
    Uint8List? yearLevelBreakdownChartBytes,
    Uint8List? studentwithMostViolationChartBytes,
    Uint8List? cityBreakdownChartBytes,
    Uint8List? vehicleLogsDistributionChartBytes,
    Uint8List? violationDistributionPerCollegeChartBytes,
    Uint8List? top5ViolationByTypeChartBytes,
    Uint8List? fleetLogsChartBytes,
  }) {
    if (isClosed) return;
    emit(
      state.copyWith(
        showPdfPreview: true,
        vehicleDistributionChartBytes: vehicleDistributionChartBytes,
        yearLevelBreakdownChartBytes: yearLevelBreakdownChartBytes,
        studentwithMostViolationChartBytes: studentwithMostViolationChartBytes,
        cityBreakdownChartBytes: cityBreakdownChartBytes,
        vehicleLogsDistributionChartBytes: vehicleLogsDistributionChartBytes,
        violationDistributionPerCollegeChartBytes:
            violationDistributionPerCollegeChartBytes,
        top5ViolationByTypeChartBytes: top5ViolationByTypeChartBytes,
        fleetLogsChartBytes: fleetLogsChartBytes,
      ),
    );
  }

  void hidePdfPreview() {
    if (isClosed) return;
    emit(state.copyWith(showPdfPreview: false));
  }

  void togglePdfPreview() {
    if (isClosed) return;
    emit(state.copyWith(showPdfPreview: !state.showPdfPreview));
  }

  void setLoading(bool loading) {
    if (isClosed) return;
    emit(state.copyWith(loading: loading));
  }

  void setError(String? error) {
    if (isClosed) return;
    emit(state.copyWith(error: error));
  }

  void clearError() {
    if (isClosed) return;
    emit(state.copyWith(error: null));
  }

  Future<List<String>> getVehicleSearchSuggestions(String query) async {
    final results = await _repo.searchVehicles(query: query, limit: 10);
    _vehicleSuggestionToId.clear();

    final suggestions = <String>[];
    for (final r in results) {
      final owner = r.ownerName.trim();
      final schoolId = r.schoolID.trim();
      final plate = r.plateNumber.trim();
      final model = r.model.trim();

      final label = [
        if (schoolId.isNotEmpty) schoolId,
        if (owner.isNotEmpty) owner,
        if (plate.isNotEmpty) plate,
        if (model.isNotEmpty) model,
      ].join(' - ');

      if (label.isEmpty) continue;
      suggestions.add(label);
      _vehicleSuggestionToId[label] = r.vehicleId;
    }

    return suggestions;
  }

  Future<void> selectVehicleFromSearch(String suggestion) async {
    final vehicleId = _vehicleSuggestionToId[suggestion];
    if (vehicleId == null || vehicleId.isEmpty) return;

    // Switch the UI to individual mode and set loading
    emit(state.copyWith(isGlobalMode: false, loading: true, error: null));

    try {
      final profile = await _repo.fetchVehicleBySearchKey(vehicleId);
      if (profile == null) {
        emit(state.copyWith(loading: false, error: 'Vehicle not found'));
        return;
      }

      final pendingViolations = await _repo.fetchPendingViolationsByVehicleId(
        vehicleId,
      );

      final totalViolations = await _repo.fetchTotalViolationsByVehicleId(
        vehicleId,
      );

      final totalEntriesExits = await _repo.fetchVehicleLogsByVehicleId(
        vehicleId,
      );

      final vehicleLogsForLast7Days = await _repo
          .fetchVehicleLogsByVehicleIdForLast7Days(vehicleId);

      final vehicleLogs = await _repo.fetchVehicleLogsByVehicleId(vehicleId);

      final violationsByType = await _repo.fetchViolationsByTypeByVehicleId(
        vehicleId,
      );

      final violationHistory = await _repo.fetchViolationHistoryByVehicleId(
        vehicleId,
      );

      final updatedProfile = VehicleProfile(
        vehicleId: profile.vehicleId,
        plateNumber: profile.plateNumber,
        ownerName: profile.ownerName,
        model: profile.model,
        vehicleType: profile.vehicleType,
        department: profile.department,
        status: profile.status,
        registeredDate: profile.registeredDate,
        createdAt: profile.createdAt,
        expiryDate: profile.expiryDate,
        activeViolations: pendingViolations.length,
        totalViolations: totalViolations,
        totalEntriesExits: totalEntriesExits.length,
      );

      emit(
        state.copyWith(
          loading: false,
          selectedVehicleProfile: updatedProfile,
          pendingViolations: pendingViolations,
          violationsByType: violationsByType,
          vehicleLogsForLast7Days: vehicleLogsForLast7Days,
          violationHistory: violationHistory,
          vehicleLogs: vehicleLogs,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> changeTimeRange(TimeRange timeRange) async {
    if (state.selectedTimeRange == timeRange) return;

    emit(state.copyWith(selectedTimeRange: timeRange, loading: true));

    try {
      final trendData = await _fetchTrendData(timeRange);
      if (isClosed) return;
      emit(state.copyWith(loading: false, logsData: trendData));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<List<ChartDataModel>> _fetchTrendData(TimeRange timeRange) async {
    switch (timeRange) {
      case TimeRange.days7:
        return await _analyticsRepo.fetchWeeklyTrend();
      case TimeRange.month:
        return await _analyticsRepo.fetchMonthlyTrend();
      case TimeRange.year:
        return await _analyticsRepo.fetchYearlyTrend();
    }
  }
}
