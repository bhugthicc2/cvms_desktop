import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

class CustomMunicipalityDropdown extends StatefulWidget {
  final Municipality? value;
  final List<Municipality> municipalities;
  final String labelText;
  final void Function(Municipality?) onChanged;
  final String? Function(Municipality?)? validator;

  const CustomMunicipalityDropdown({
    super.key,
    required this.value,
    required this.municipalities,
    required this.labelText,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomMunicipalityDropdown> createState() =>
      _CustomMunicipalityDropdownState();
}

class _CustomMunicipalityDropdownState
    extends State<CustomMunicipalityDropdown> {
  bool _hasError = false;
  String? _errorMessage;

  void _validate(Municipality? value) {
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
                ),
                floatingLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppFontSizes.large,
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
            child: PhilippineMunicipalityDropdownView(
              value: widget.value,
              municipalities: widget.municipalities,
              onChanged: (Municipality? value) {
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
              ),
            ),
          ),
      ],
    );
  }
}
