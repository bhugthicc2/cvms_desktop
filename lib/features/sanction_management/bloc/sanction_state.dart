import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_tab.dart';
import 'package:equatable/equatable.dart';

class SanctionState extends Equatable {
  final bool isLoading;
  final List<Sanction> sanctions;
  final SanctionTab selectedTab;
  final String searchQuery;
  final String? errorMessage;
  final SanctionTab activeTab;
  final List<Sanction> selectedEntries;
  final bool isBulkModeEnabled;
  final List<Sanction> filteredEntries;
  final List<Sanction> allEntries;

  const SanctionState({
    required this.isLoading,
    required this.sanctions,
    required this.selectedTab,
    required this.searchQuery,
    this.errorMessage,
    this.activeTab = SanctionTab.all,
    this.selectedEntries = const [],
    this.isBulkModeEnabled = false,
    this.filteredEntries = const [],
    required this.allEntries,
  });

  factory SanctionState.initial() {
    return const SanctionState(
      isLoading: false,
      sanctions: [],
      selectedTab: SanctionTab.all,
      searchQuery: '',
      errorMessage: null,
      activeTab: SanctionTab.all,
      selectedEntries: [],
      isBulkModeEnabled: false,
      filteredEntries: [],
      allEntries: [],
    );
  }

  SanctionState copyWith({
    bool? isLoading,
    List<Sanction>? sanctions,
    SanctionTab? selectedTab,
    String? searchQuery,
    String? errorMessage,
    SanctionTab? activeTab,
    List<Sanction>? selectedEntries,
    bool? isBulkModeEnabled,
    List<Sanction>? filteredEntries,
    List<Sanction>? allEntries,
  }) {
    return SanctionState(
      isLoading: isLoading ?? this.isLoading,
      sanctions: sanctions ?? this.sanctions,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      activeTab: activeTab ?? this.activeTab,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      allEntries: allEntries ?? this.allEntries,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    sanctions,
    selectedTab,
    searchQuery,
    errorMessage,
    activeTab,
    selectedEntries,
    isBulkModeEnabled,
    filteredEntries,
    allEntries,
  ];
}
