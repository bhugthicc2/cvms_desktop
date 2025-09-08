import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool enableVisibilityToggle;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final AutovalidateMode autovalidateMode;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enableVisibilityToggle = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.fillColor,
    this.textStyle,
    this.width,
    this.height,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isObscured = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode.addListener(_updateState);
    if (widget.autovalidateMode == AutovalidateMode.always) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validate(widget.controller?.text);
      });
    }
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _isObscured = widget.obscureText;
    }
    if (oldWidget.controller != widget.controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validate(widget.controller?.text);
      });
    }
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

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

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
    final borderColor =
        _hasError
            ? (widget.errorBorderColor ?? AppColors.error)
            : _focusNode.hasFocus
            ? (widget.focusedBorderColor ?? AppColors.primary)
            : (widget.borderColor ?? AppColors.grey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          padding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor, width: 1),
            color: widget.fillColor ?? AppColors.white,
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: (value) {
              widget.onChanged?.call(value);
              if (widget.autovalidateMode ==
                  AutovalidateMode.onUserInteraction) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _validate(value);
                });
              }
            },
            autovalidateMode: widget.autovalidateMode,
            obscuringCharacter: '*',
            obscureText: _isObscured,
            cursorColor: AppColors.primary,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            focusNode: _focusNode,
            style:
                widget.textStyle ??
                const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                  fontSize: AppFontSizes.medium,
                ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefixIcon:
                  widget.prefixIcon != null
                      ? Icon(widget.prefixIcon, color: AppColors.grey, size: 20)
                      : null,
              suffixIcon: _buildSuffixIcon(),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
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
              errorStyle: const TextStyle(fontSize: 0),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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

  Widget? _buildSuffixIcon() {
    if (widget.enableVisibilityToggle) {
      return IconButton(
        icon: Icon(
          _isObscured
              ? PhosphorIconsRegular.eyeSlash
              : PhosphorIconsRegular.eye,
          color: AppColors.grey,
          size: 20,
        ),
        onPressed: _toggleVisibility,
      );
    } else if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, color: AppColors.grey, size: 20);
    }
    return null;
  }
}
