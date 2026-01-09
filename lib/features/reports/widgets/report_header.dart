import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/app/typeahead_search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportHeader extends StatefulWidget {
  final VoidCallback onExportPDF;
  final VoidCallback onExportCSV;
  const ReportHeader({
    super.key,
    required this.onExportPDF,
    required this.onExportCSV,
  });

  @override
  State<ReportHeader> createState() => _ReportHeaderState();
}

class _ReportHeaderState extends State<ReportHeader> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data for suggestions - replace with actual data from your database ---TOBE REMOVED---
  Future<List<String>> _getSuggestions(String query) async {
    if (query.isEmpty) return [];

    // Mock vehicle data
    final mockData = [
      'WXY-9012 - Toyota Avanza - Mila Hernandez',
      'ABC-1234 - Honda Civic - John Doe',
      'XYZ-5678 - Mitsubishi Montero - Jane Smith',
      'DEF-9012 - Ford Ranger - Robert Johnson',
      'GHI-3456 - Toyota Vios - Maria Santos',
      'JKL-7890 - Nissan Sentra - Carlos Reyes',
      'MNO-2345 - Isuzu D-Max - Anna Cruz',
      'PQR-6789 - Hyundai Accent - David Lee',
      'STU-0123 - Kia Picanto - Sarah Kim',
      'VWX-4567 - Mazda 3 - Michael Brown',
    ];

    final suggestions =
        mockData
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return suggestions;
  }

  // ---TOBE REMOVED---

  void _onSuggestionSelected(String suggestion) {
    _searchController.text = suggestion;
    // TODO: Implement search functionality with selected suggestion
    print('Selected: $suggestion');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            //search bar
            child: TypeaheadSearchField(
              hoverScale: 1,
              hintText: 'Search by plate no., owner, or model',
              searchFieldHeight: 40,
              controller: _searchController,
              suggestionsCallback: _getSuggestions,
              onSuggestionSelected: _onSuggestionSelected,
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),

          HoverGrow(
            cursor: SystemMouseCursors.click,
            onTap: widget.onExportPDF,
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: cardDecoration(radii: 8),
              child: Center(
                child: Icon(
                  PhosphorIconsBold.filePdf,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),
          HoverGrow(
            cursor: SystemMouseCursors.click,
            onTap: widget.onExportCSV,
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: cardDecoration(radii: 8),
              child: Center(
                child: Icon(
                  PhosphorIconsBold.fileCsv,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
