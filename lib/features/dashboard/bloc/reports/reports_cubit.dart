import 'dart:async';
import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/bloc/dashboard/dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/data/report_repository.dart';
import 'package:cvms_desktop/features/dashboard/data/analytics_repository.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_profile.dart';
import 'package:cvms_desktop/features/dashboard/models/violation_history_model.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_logs_model.dart';
import 'package:cvms_desktop/features/dashboard/models/fleet_summary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportRepository _repo = ReportRepository();
  final AnalyticsRepository _analyticsRepo;

  final Map<String, String> _vehicleSuggestionToId = {};

  // Cache management to prevent unnecessary reloads
  FleetSummary? _cachedGlobalSummary;
  List<ChartDataModel>? _cachedVehicleDistribution;
  List<ChartDataModel>? _cachedYearLevelBreakdown;
  List<ChartDataModel>? _cachedCityBreakdown;
  List<ChartDataModel>? _cachedStudentWithMostViolations;

  // Operation cancellation to prevent StateError
  StreamSubscription? _currentOperation;

  ReportsCubit({required AnalyticsRepository analyticsRepo})
    : _analyticsRepo = analyticsRepo,
      super(const ReportsState(viewMode: ReportViewMode.global)) {
    _loadGlobalReportIfNeeded(); // Smart load - only if not cached
  }

  // Smart loading - only fetch if not cached
  Future<void> _loadGlobalReportIfNeeded() async {
    if (_cachedGlobalSummary != null && _cachedVehicleDistribution != null) {
      // Data already cached, just update view mode
      if (isClosed) return;
      emit(
        state.copyWith(
          fleetSummary: _cachedGlobalSummary,
          vehicleDistribution: _cachedVehicleDistribution,
          yearLevelBreakdown: _cachedYearLevelBreakdown,
          cityBreakdown: _cachedCityBreakdown,
          studentWithMostViolations: _cachedStudentWithMostViolations,
        ),
      );
      return;
    }

    await _loadGlobalReport();
  }

  // Internal loading method with cancellation support
  Future<void> _loadGlobalReport() async {
    if (isClosed) return;

    // Cancel any ongoing operation
    await _currentOperation?.cancel();

    emit(state.copyWith(loading: true, error: null));

    try {
      final summary = await _repo.fetchFleetSummary();

      // Check if closed after async operation
      if (isClosed) return;

      // Fetch real data for charts
      final vehicleDistribution =
          await _repo.fetchVehicleDistributionByCollege();
      if (isClosed) return;

      final yearLevelBreakdown = await _repo.fetchYearLevelBreakdown();
      if (isClosed) return;

      final cityBreakdown = await _repo.fetchCityBreakdown();
      if (isClosed) return;

      final studentWithMostViolations =
          await _repo.fetchStudentWithMostViolations();
      if (isClosed) return;

      final trendData = await _fetchTrendData(state.selectedTimeRange);
      if (isClosed) return;

      // Cache the data
      _cachedGlobalSummary = summary;
      _cachedVehicleDistribution = vehicleDistribution;
      _cachedYearLevelBreakdown = yearLevelBreakdown;
      _cachedCityBreakdown = cityBreakdown;
      _cachedStudentWithMostViolations = studentWithMostViolations;

      emit(
        state.copyWith(
          fleetSummary: summary,
          logsData: trendData,
          loading: false,
          vehicleDistribution: vehicleDistribution,
          yearLevelBreakdown: yearLevelBreakdown,
          cityBreakdown: cityBreakdown,
          studentWithMostViolations: studentWithMostViolations,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // Public method for external calls (backward compatibility)
  Future<void> loadGlobalReport() async {
    await _loadGlobalReport();
  }

  void setViewMode(ReportViewMode mode) {
    if (isClosed) return;
    emit(state.copyWith(viewMode: mode));
  }

  // Backward compatibility method
  void setGlobalMode(bool mode) {
    if (mode) {
      navigateToGlobal();
    } else {
      setViewMode(ReportViewMode.individual);
    }
  }

  // Backward compatibility getter
  //bool get showPdfPreview => state.viewMode == ReportViewMode.pdfPreview;

  void navigateToGlobal() {
    setViewMode(ReportViewMode.global);
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
    enterPdfPreview(
      vehicleDistributionChartBytes: vehicleDistributionChartBytes,
      yearLevelBreakdownChartBytes: yearLevelBreakdownChartBytes,
      studentwithMostViolationChartBytes: studentwithMostViolationChartBytes,
      cityBreakdownChartBytes: cityBreakdownChartBytes,
      vehicleLogsDistributionChartBytes: vehicleLogsDistributionChartBytes,
      violationDistributionPerCollegeChartBytes:
          violationDistributionPerCollegeChartBytes,
      top5ViolationByTypeChartBytes: top5ViolationByTypeChartBytes,
      fleetLogsChartBytes: fleetLogsChartBytes,
    );
  }

  void enterPdfPreview({
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
        viewMode: ReportViewMode.pdfPreview,
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
    emit(state.copyWith(viewMode: ReportViewMode.global));
  }

  /// Captures chart bytes from controllers and shows PDF preview
  Future<void> exportToPdf({
    required ScreenshotController vehicleDistributionController,
    required ScreenshotController yearLevelBreakdownController,
    required ScreenshotController studentWithMostViolationsController,
    required ScreenshotController cityBreakdownController,
    required ScreenshotController vehicleLogsDistributionController,
    required ScreenshotController violationDistributionPerCollegeController,
    required ScreenshotController top5ViolationByTypeController,
    required ScreenshotController fleetLogsController,
  }) async {
    if (isClosed) return;

    try {
      // Capture all charts with error handling
      Uint8List? vehicleDistributionChartBytes;
      Uint8List? yearLevelBreakdownChartBytes;
      Uint8List? studentwithMostViolationChartBytes;
      Uint8List? cityBreakdownChartBytes;
      Uint8List? vehicleLogsDistributionChartBytes;
      Uint8List? violationDistributionPerCollegeChartBytes;
      Uint8List? top5ViolationByTypeChartBytes;
      Uint8List? fleetLogsChartBytes;

      try {
        vehicleDistributionChartBytes =
            await vehicleDistributionController.capture();
      } catch (_) {
        vehicleDistributionChartBytes = null;
      }

      try {
        yearLevelBreakdownChartBytes =
            await yearLevelBreakdownController.capture();
      } catch (_) {
        yearLevelBreakdownChartBytes = null;
      }

      try {
        studentwithMostViolationChartBytes =
            await studentWithMostViolationsController.capture();
      } catch (_) {
        studentwithMostViolationChartBytes = null;
      }

      try {
        cityBreakdownChartBytes = await cityBreakdownController.capture();
      } catch (_) {
        cityBreakdownChartBytes = null;
      }

      try {
        vehicleLogsDistributionChartBytes =
            await vehicleLogsDistributionController.capture();
      } catch (_) {
        vehicleLogsDistributionChartBytes = null;
      }

      try {
        violationDistributionPerCollegeChartBytes =
            await violationDistributionPerCollegeController.capture();
      } catch (_) {
        violationDistributionPerCollegeChartBytes = null;
      }

      try {
        top5ViolationByTypeChartBytes =
            await top5ViolationByTypeController.capture();
      } catch (_) {
        top5ViolationByTypeChartBytes = null;
      }

      try {
        fleetLogsChartBytes = await fleetLogsController.capture();
      } catch (_) {
        fleetLogsChartBytes = null;
      }

      if (isClosed) return;

      showPdfPreview(
        vehicleDistributionChartBytes: vehicleDistributionChartBytes,
        yearLevelBreakdownChartBytes: yearLevelBreakdownChartBytes,
        studentwithMostViolationChartBytes: studentwithMostViolationChartBytes,
        cityBreakdownChartBytes: cityBreakdownChartBytes,
        vehicleLogsDistributionChartBytes: vehicleLogsDistributionChartBytes,
        violationDistributionPerCollegeChartBytes:
            violationDistributionPerCollegeChartBytes,
        top5ViolationByTypeChartBytes: top5ViolationByTypeChartBytes,
        fleetLogsChartBytes: fleetLogsChartBytes,
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(error: 'Failed to export PDF: ${e.toString()}'));
    }
  }

  void togglePdfPreview() {
    if (isClosed) return;
    final newMode =
        state.viewMode == ReportViewMode.pdfPreview
            ? ReportViewMode.global
            : ReportViewMode.pdfPreview;
    emit(state.copyWith(viewMode: newMode));
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

    // Cancel any ongoing operation
    await _currentOperation?.cancel();

    // Switch to individual mode and set loading
    emit(
      state.copyWith(
        viewMode: ReportViewMode.individual,
        loading: true,
        error: null,
      ),
    );

    try {
      final profile = await _repo.fetchVehicleBySearchKey(vehicleId);
      if (isClosed) return;

      if (profile == null) {
        emit(state.copyWith(loading: false, error: 'Vehicle not found'));
        return;
      }

      // Batch fetch all vehicle data with proper cancellation checks
      final results = await Future.wait([
        _repo.fetchPendingViolationsByVehicleId(vehicleId),
        _repo.fetchTotalViolationsByVehicleId(vehicleId),
        _repo.fetchVehicleLogsByVehicleId(vehicleId),
        _repo.fetchVehicleLogsByVehicleIdForLast7Days(vehicleId),
        _repo.fetchViolationsByTypeByVehicleId(vehicleId),
        _repo.fetchViolationHistoryByVehicleId(vehicleId),
      ]);

      if (isClosed) return;

      final pendingViolations = results[0] as List<ViolationHistoryEntry>;
      final totalViolations = results[1] as int;
      final totalEntriesExits = results[2] as List<VehicleLogsEntry>;
      final vehicleLogsForLast7Days = results[3] as List<ChartDataModel>;
      final violationsByType = results[4] as List<ChartDataModel>;
      final violationHistory = results[5] as List<ViolationHistoryEntry>;

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
          vehicleLogs: totalEntriesExits,
        ),
      );
    } catch (e) {
      if (isClosed) return;
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

  @override
  Future<void> close() {
    // Cancel any ongoing operations
    _currentOperation?.cancel();

    // Clear caches
    _vehicleSuggestionToId.clear();
    _cachedGlobalSummary = null;
    _cachedVehicleDistribution = null;
    _cachedYearLevelBreakdown = null;
    _cachedCityBreakdown = null;
    _cachedStudentWithMostViolations = null;

    return super.close();
  }
}
