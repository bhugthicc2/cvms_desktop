import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    TextEditingController? searchController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Search...",
        hintStyle: TextStyle(fontSize: AppFontSizes.medium),
        suffixIcon: Icon(PhosphorIconsRegular.magnifyingGlass),
      ),
    );
  }
}
