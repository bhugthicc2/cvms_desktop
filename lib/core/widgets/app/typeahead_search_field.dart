import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TypeaheadSearchField<T> extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<T>? onSuggestionSelected;
  final Future<List<T>> Function(String) suggestionsCallback;
  final String hintText;
  final double contentPaddingX;
  final double contentPaddingY;
  final double cursorHeight;
  final double hintFontSize;
  final double txtFontSize;
  final double searchFieldHeight;
  final double searchFieldWidth;
  final double hoverScale;
  final String Function(T) getSuggestionText;

  const TypeaheadSearchField({
    super.key,
    required this.controller,
    required this.suggestionsCallback,
    required this.getSuggestionText,
    this.onChanged,
    this.onSuggestionSelected,
    this.hintText = "Search name, plate number, etc...",
    this.contentPaddingX = 10,
    this.contentPaddingY = 0,
    this.cursorHeight = 20,
    this.hintFontSize = AppFontSizes.medium,
    this.txtFontSize = AppFontSizes.medium,
    this.searchFieldHeight = 0,
    this.searchFieldWidth = 0,
    this.hoverScale = 1.02,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGrow(
      hoverScale: hoverScale,
      child: Container(
        width: searchFieldWidth,
        height: searchFieldHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TypeAheadField<T>(
          controller: controller,
          suggestionsCallback: suggestionsCallback,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(fontSize: txtFontSize),
              cursorHeight: cursorHeight,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.primary,
              onChanged: onChanged,
              decoration: InputDecoration(
                maintainHintSize: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.grey.withValues(alpha: 0.0),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: hintFontSize,
                  color: AppColors.grey,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: contentPaddingX,
                  vertical: contentPaddingY,
                ),
                suffixIcon: Icon(
                  PhosphorIconsRegular.magnifyingGlass,
                  size: 20,
                  color: AppColors.grey,
                ),
              ),
            );
          },
          decorationBuilder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: child,
            );
          },
          itemBuilder: (context, suggestion) {
            final baseStyle = TextStyle(
              color: AppColors.black,
              fontSize: 13,
              fontFamily: 'Inter',
            );

            final query = controller.text.trim();
            final suggestionText = getSuggestionText(suggestion);

            final spans = <TextSpan>[];
            if (query.isEmpty) {
              spans.add(TextSpan(text: suggestionText));
            } else {
              final lowerSuggestion = suggestionText.toLowerCase();
              final lowerQuery = query.toLowerCase();

              var start = 0;
              while (true) {
                final matchIndex = lowerSuggestion.indexOf(lowerQuery, start);
                if (matchIndex < 0) {
                  if (start < suggestionText.length) {
                    spans.add(TextSpan(text: suggestionText.substring(start)));
                  }
                  break;
                }

                if (matchIndex > start) {
                  spans.add(
                    TextSpan(text: suggestionText.substring(start, matchIndex)),
                  );
                }

                spans.add(
                  TextSpan(
                    text: suggestionText.substring(
                      matchIndex,
                      matchIndex + query.length,
                    ),
                    style: baseStyle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );

                start = matchIndex + query.length;
                if (start >= suggestionText.length) break;
              }
            }

            return HoverSlide(
              cursor: SystemMouseCursors.click,
              dx: 0.03,
              dy: 0,
              child: ListTile(
                hoverColor: AppColors.grey,
                title: RichText(
                  text: TextSpan(style: baseStyle, children: spans),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Icon(
                  PhosphorIconsRegular.magnifyingGlass,
                  size: 16,
                  color: AppColors.grey,
                ),
              ),
            );
          },
          onSelected: onSuggestionSelected,
          emptyBuilder: (context) {
            return ListTile(
              title: Text(
                'No results found',
                style: TextStyle(color: AppColors.grey),
              ),
              leading: Icon(
                PhosphorIconsRegular.magnifyingGlass,
                size: 16,
                color: AppColors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
