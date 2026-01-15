import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:cvms_desktop/core/widgets/app/typeahead_search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/reports/bloc/reports/reports_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportHeaderSection extends StatefulWidget {
  final VoidCallback onExportPDF;
  final VoidCallback onExportCSV;
  final VoidCallback onDateFilter;
  final String dateSelected;
  final bool isGlobal;
  final VoidCallback onBackButtonClicked;
  const ReportHeaderSection({
    super.key,
    required this.onExportPDF,
    required this.onExportCSV,
    required this.onDateFilter,
    required this.dateSelected,
    required this.isGlobal,
    required this.onBackButtonClicked,
  });

  @override
  State<ReportHeaderSection> createState() => _ReportHeaderSectionState();
}

class _ReportHeaderSectionState extends State<ReportHeaderSection> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<String>> _getSuggestions(String query) async {
    if (query.isEmpty) return [];
    return context.read<ReportsCubit>().getVehicleSearchSuggestions(query);
  }

  void _onSuggestionSelected(String suggestion) {
    _searchController.text = suggestion;
    context.read<ReportsCubit>().selectVehicleFromSearch(suggestion);
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
          widget.isGlobal == false
              ? Row(
                children: [
                  CustomIconButton(
                    iconSize: 24,
                    onPressed: widget.onBackButtonClicked,
                    icon: PhosphorIconsBold.arrowLeft,
                    iconColor: AppColors.primary,
                  ),
                  Spacing.horizontal(size: AppSpacing.small),
                ],
              )
              : SizedBox(),
          Expanded(
            //search bar
            child: TypeaheadSearchField(
              hoverScale: 1,
              hintText: 'Search by plate no., owner, school ID or model',
              searchFieldHeight: 40,
              controller: _searchController,
              suggestionsCallback: _getSuggestions,
              onSuggestionSelected: _onSuggestionSelected,
            ),
          ),

          Spacing.horizontal(size: AppSpacing.medium),
          //report date filter
          HoverGrow(
            cursor: SystemMouseCursors.click,
            onTap: widget.onDateFilter,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.calendar,
                    color: AppColors.white,
                    size: 22,
                  ),
                  Spacing.horizontal(size: AppSpacing.small),
                  Text(
                    widget.dateSelected,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacing.horizontal(size: AppSpacing.medium),

          HoverGrow(
            cursor: SystemMouseCursors.click,
            onTap: widget.onExportPDF,
            child: Container(
              height: 40,

              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Text(
                    'GENERATE REPORT',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
