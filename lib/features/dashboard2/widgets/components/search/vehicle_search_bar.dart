import 'package:cvms_desktop/core/widgets/app/typeahead_search_field.dart';
import 'package:flutter/material.dart';

class VehicleSearchBar extends StatelessWidget {
  final String hintText;
  final Future<List<String>> Function(String) suggestionsCallback;
  final void Function(String) onSuggestionSelected;
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
    return TypeaheadSearchField(
      hoverScale: 1,
      hintText: hintText,
      searchFieldHeight: 40,
      controller: controller ?? TextEditingController(),
      suggestionsCallback: suggestionsCallback,
      onSuggestionSelected: onSuggestionSelected,
    );
  }
}
