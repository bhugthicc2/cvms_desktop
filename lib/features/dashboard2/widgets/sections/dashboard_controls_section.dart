import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/buttons/custom_icon_button.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/search/vehicle_search_bar.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/navigation/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardControlsSection extends StatelessWidget {
  final TextEditingController? searchController;
  final Future<List<String>> Function(String) onSearchSuggestions;
  final void Function(String) onVehicleSelected;
  final String dateFilterText;
  final VoidCallback onDateFilterPressed;
  final VoidCallback onExportPressed;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;

  const DashboardControlsSection({
    super.key,
    this.searchController,
    required this.onSearchSuggestions,
    required this.onVehicleSelected,
    required this.dateFilterText,
    required this.onDateFilterPressed,
    required this.onExportPressed,
    this.showBackButton = false,
    this.onBackButtonPressed,
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
              onTap: onBackButtonPressed ?? () {},
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

          // Date Filter Button
          DateFilterButton(
            dateText: dateFilterText,
            onPressed: onDateFilterPressed,
          ),
          const SizedBox(width: AppSpacing.medium),

          // Export Button
          ExportReportButton(onPressed: onExportPressed),
        ],
      ),
    );
  }
}
