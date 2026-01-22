part of 'global_dashboard_cubit.dart';

enum DashboardViewMode {
  global, // Root dashboard
  individual, // Individual vehicle report
  pdfPreview, // PDF preview view
  violationView,
  pendingViolationView,
  allVehiclesView,
  vehicleLogsView,
}

class GlobalDashboardState extends Equatable {
  final DashboardViewMode viewMode;
  final bool loading;
  final String? error;
  final IndividualVehicleInfo? selectedVehicle;
  final DashboardViewMode? previousViewMode;
  // ----GLOBAL-----
  final int totalEntriesExits; //realtime implementation step 2
  final int totalVehicles;
  final int totalViolations;
  final int
  totalPendingViolations; //realtime data retrieval based on collection field step 2
  final List<ChartDataModel>
  vehicleDistribution; //real time grouped aggregation impl step 2
  final List<ChartDataModel> yearLevelBreakdown; // realtime step 9
  final List<ChartDataModel> topStudentsWithMostViolations; // step 7
  final List<ChartDataModel> cityBreakdown; // realtime step 9
  final List<ChartDataModel> vehicleLogsDistributionPerCollege; // step 7
  final List<ChartDataModel> violationDistributionPerCollege; // step 7
  final List<ChartDataModel> violationTypeDistribution; // step 10
  final List<ChartDataModel> fleetLogsData;
  final List<ChartDataModel> violationTrendData;
  final String currentTimeRange;
  final bool initialized;
  //indi vehicle report
  final String? currentVehicleId;

  //PDF
  final Uint8List? pdfBytes;

  const GlobalDashboardState({
    this.viewMode = DashboardViewMode.global,
    this.loading = false,
    this.error,
    this.selectedVehicle,
    this.previousViewMode,
    this.initialized = false,
    // ----GLOBAL-----
    this.totalEntriesExits = 0, //realtime implementation step 3
    this.totalVehicles = 0,
    this.totalViolations = 0,
    this.totalPendingViolations =
        0, //realtime data retrieval based on collection field step 3
    this.vehicleDistribution =
        const [], //real time grouped aggregation impl step 3
    this.yearLevelBreakdown = const [], // realtime step 10
    this.topStudentsWithMostViolations = const [], // step 8
    this.cityBreakdown = const [], // realtime step 10
    this.vehicleLogsDistributionPerCollege = const [], // step 8
    this.violationDistributionPerCollege = const [], // step 8
    this.violationTypeDistribution = const [], // step 11
    this.fleetLogsData = const [],
    this.violationTrendData = const [],
    this.currentTimeRange = '7 days',

    //indi vehicle report
    this.currentVehicleId,
    //pdf
    this.pdfBytes,
  });

  GlobalDashboardState copyWith({
    DashboardViewMode? viewMode,
    bool? loading,
    String? error,
    IndividualVehicleInfo? selectedVehicle,
    DashboardViewMode? previousViewMode,
    // ----GLOBAL-----
    int? totalEntriesExits, //realtime implementation step 4
    int? totalVehicles,
    int? totalViolations,
    int?
    totalPendingViolations, //realtime data retrieval based on collection field step 5
    List<ChartDataModel>?
    vehicleDistribution, //real time grouped aggregation impl step 4
    List<ChartDataModel>? yearLevelBreakdown, // realtime step 11
    List<ChartDataModel>? topStudentsWithMostViolations, // step 9
    List<ChartDataModel>? cityBreakdown, // realtime step 11
    List<ChartDataModel>? vehicleLogsDistributionPerCollege, // step 9
    List<ChartDataModel>? violationDistributionPerCollege, // step 9
    List<ChartDataModel>? violationTypeDistribution, // step 12
    List<ChartDataModel>? fleetLogsData,
    List<ChartDataModel>? violationTrendData,
    String? currentTimeRange,
    bool? initialized,

    //indi
    String? currentVehicleId,
    //pdf
    Uint8List? pdfBytes,
    bool clearPdf = false,
  }) {
    return GlobalDashboardState(
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      previousViewMode: previousViewMode ?? this.previousViewMode,
      initialized: initialized ?? this.initialized,
      // ----GLOBAL-----
      totalEntriesExits:
          totalEntriesExits ??
          this.totalEntriesExits, //realtime implementation step 5
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalViolations: totalViolations ?? this.totalViolations,
      totalPendingViolations:
          totalPendingViolations ??
          this.totalPendingViolations, //realtime data retrieval based on collection field step 6
      vehicleDistribution:
          vehicleDistribution ??
          this.vehicleDistribution, //real time grouped aggregation impl step 5
      yearLevelBreakdown:
          yearLevelBreakdown ?? this.yearLevelBreakdown, // step 12
      topStudentsWithMostViolations:
          topStudentsWithMostViolations ??
          this.topStudentsWithMostViolations, // step 10
      cityBreakdown: cityBreakdown ?? this.cityBreakdown, // step 12
      vehicleLogsDistributionPerCollege:
          vehicleLogsDistributionPerCollege ??
          this.vehicleLogsDistributionPerCollege, // step 10
      violationDistributionPerCollege:
          violationDistributionPerCollege ??
          this.violationDistributionPerCollege, // step 10
      violationTypeDistribution:
          violationTypeDistribution ??
          this.violationTypeDistribution, // step 13
      fleetLogsData: fleetLogsData ?? this.fleetLogsData,
      violationTrendData: violationTrendData ?? this.violationTrendData,
      currentTimeRange: currentTimeRange ?? this.currentTimeRange,
      //indi vehicle report
      currentVehicleId: currentVehicleId ?? this.currentVehicleId,

      //pdf
      pdfBytes: clearPdf ? null : pdfBytes ?? this.pdfBytes,
    );
  }

  @override
  List<Object?> get props => [
    viewMode,
    loading,
    error,
    selectedVehicle,
    previousViewMode,
    // ----GLOBAL-----
    totalEntriesExits, // realtime implementation step 5:
    totalVehicles,
    totalViolations,
    totalPendingViolations, //realtime data retrieval based on collection field step 7
    vehicleDistribution, //real time grouped aggregation impl step 6
    yearLevelBreakdown, // realtime step 13
    topStudentsWithMostViolations, // step 11
    cityBreakdown, // realtime step 13
    vehicleLogsDistributionPerCollege, // step 11
    violationDistributionPerCollege, // step 11
    violationTypeDistribution, // step 13
    fleetLogsData,
    violationTrendData,
    currentTimeRange,
    initialized,
    //indi vehicle report
    currentVehicleId,

    //pdf
    pdfBytes,
  ];
}
