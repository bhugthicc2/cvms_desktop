import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

/// Custom styled wrapper for PhilippineBarangayDropdownView
class CustomBarangayDropdown extends StatefulWidget {
  final String? value;
  final List<String> barangays;
  final String labelText;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomBarangayDropdown({
    super.key,
    required this.value,
    required this.barangays,
    required this.labelText,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomBarangayDropdown> createState() => _CustomBarangayDropdownState();
}

class _CustomBarangayDropdownState extends State<CustomBarangayDropdown> {
  bool _hasError = false;
  String? _errorMessage;

  void _validate(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (_hasError != (error != null) || _errorMessage != error) {
        setState(() {
          _hasError = error != null;
          _errorMessage = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasError ? AppColors.error : AppColors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor, width: 1),
            color: AppColors.white,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: AppFontSizes.medium,
                  color: AppColors.grey,
                  fontFamily: 'Poppins',
                ),
                floatingLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppFontSizes.large,
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: const TextStyle(fontSize: 0),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            child: PhilippineBarangayDropdownView(
              value:
                  (widget.value != null &&
                          widget.barangays.any(
                            (b) =>
                                b.toLowerCase() == widget.value!.toLowerCase(),
                          ))
                      ? widget.value
                      : null,
              barangays: widget.barangays,
              onChanged: (String? value) {
                widget.onChanged(value);
                _validate(value);
              },
            ),
          ),
        ),
        if (_hasError && _errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: AppFontSizes.small,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
