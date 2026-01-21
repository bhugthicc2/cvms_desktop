import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/vehicle_search_suggestion.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/search/vehicle_search_bar.dart';
import 'package:cvms_desktop/features/dashboard/widgets/navigation/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardControlsSection extends StatelessWidget {
  final TextEditingController? searchController;
  final Future<List<VehicleSearchSuggestion>> Function(String)
  onSearchSuggestions;
  final void Function(VehicleSearchSuggestion) onVehicleSelected;
  final String dateFilterText;
  final VoidCallback onExportPressed;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final bool isLoading;

  const DashboardControlsSection({
    super.key,
    this.searchController,
    required this.onSearchSuggestions,
    required this.onVehicleSelected,
    required this.dateFilterText,
    required this.onExportPressed,
    this.showBackButton = false,
    this.onBackButtonPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            CustomIconButton(
              iconSize: 24,
              onPressed: onBackButtonPressed ?? () {},
              icon: PhosphorIconsBold.arrowLeft,
              iconColor: AppColors.primary,
            ),
            Spacing.horizontal(size: AppSpacing.small),
          ],
          // Search Bar
          Expanded(
            child: VehicleSearchBar(
              controller: searchController,
              suggestionsCallback: onSearchSuggestions,
              onSuggestionSelected: onVehicleSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),

          // Export Button
          ExportReportButton(onPressed: onExportPressed, isLoading: isLoading),
        ],
      ),
    );
  }
}
