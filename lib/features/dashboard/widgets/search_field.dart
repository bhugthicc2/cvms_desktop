import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController;

  const SearchField({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search here...",
        hintStyle: TextStyle(fontSize: AppFontSizes.medium),
        suffixIcon: Icon(PhosphorIconsRegular.magnifyingGlass),
      ),
    );
  }
}
