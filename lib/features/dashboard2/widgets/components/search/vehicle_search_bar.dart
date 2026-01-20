import 'package:cvms_desktop/core/widgets/app/typeahead_search_field.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/vehicle_search_suggestion.dart';
import 'package:flutter/material.dart';

class VehicleSearchBar extends StatelessWidget {
  final String hintText;
  final Future<List<VehicleSearchSuggestion>> Function(String)
  suggestionsCallback;
  final void Function(VehicleSearchSuggestion) onSuggestionSelected;
  final TextEditingController? controller;

  const VehicleSearchBar({
    super.key,
    this.hintText = 'Search by plate no., owner, school ID or model',
    required this.suggestionsCallback,
    required this.onSuggestionSelected,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TypeaheadSearchField<VehicleSearchSuggestion>(
      hoverScale: 1,
      hintText: hintText,
      searchFieldHeight: 40,
      controller: controller ?? TextEditingController(),
      suggestionsCallback: suggestionsCallback,
      getSuggestionText:
          (suggestion) => '${suggestion.plateNumber} - ${suggestion.ownerName}',
      onSuggestionSelected: onSuggestionSelected,
    );
  }
}
