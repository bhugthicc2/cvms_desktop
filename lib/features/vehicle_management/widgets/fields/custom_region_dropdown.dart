//todo test and clean dawg

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

/// Custom styled wrapper for PhilippineRegionDropdownView
class CustomRegionDropdown extends StatefulWidget {
  final Region? value;
  final String labelText;
  final void Function(Region?) onChanged;
  final String? Function(Region?)? validator;

  const CustomRegionDropdown({
    super.key,
    required this.value,
    required this.labelText,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomRegionDropdown> createState() => _CustomRegionDropdownState();
}

class _CustomRegionDropdownState extends State<CustomRegionDropdown> {
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_updateState);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_updateState);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _validate(Region? value) {
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
    final borderColor =
        _hasError
            ? AppColors.error
            : _focusNode.hasFocus
            ? AppColors.primary
            : AppColors.grey;

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
          child: Focus(
            focusNode: _focusNode,
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
              child: PhilippineRegionDropdownView(
                value: widget.value,
                onChanged: (Region? value) {
                  widget.onChanged(value);
                  _validate(value);
                },
              ),
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
