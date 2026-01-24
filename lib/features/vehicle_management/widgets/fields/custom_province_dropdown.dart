import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

class CustomProvinceDropdown extends StatefulWidget {
  final Province? value;
  final List<Province> provinces;
  final String labelText;
  final void Function(Province?) onChanged;
  final String? Function(Province?)? validator;

  const CustomProvinceDropdown({
    super.key,
    required this.value,
    required this.provinces,
    required this.labelText,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomProvinceDropdown> createState() => _CustomProvinceDropdownState();
}

class _CustomProvinceDropdownState extends State<CustomProvinceDropdown> {
  bool _hasError = false;
  String? _errorMessage;

  void _validate(Province? value) {
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
                  fontFamily: 'Inter',
                ),
                floatingLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppFontSizes.large,
                  color: AppColors.grey,
                  fontFamily: 'Inter',
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
            child: PhilippineProvinceDropdownView(
              value: widget.value,
              provinces: widget.provinces,
              onChanged: (Province? value) {
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
                fontSize: AppFontSizes.small,
                color: AppColors.error,
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }
}
