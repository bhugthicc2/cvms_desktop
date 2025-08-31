import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

abstract class TextFieldBehavior {
  bool validate(String? value);
  void onTextChanged(String value);
  String? getValidationMessage(String? value);
}

class DefaultTextFieldBehavior implements TextFieldBehavior {
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  DefaultTextFieldBehavior({this.validator, this.onChanged});

  @override
  bool validate(String? value) {
    return validator?.call(value) == null;
  }

  @override
  void onTextChanged(String value) {
    onChanged?.call(value);
  }

  @override
  String? getValidationMessage(String? value) {
    return validator?.call(value);
  }
}

class BlocTextFieldBehavior implements TextFieldBehavior {
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool Function(String?)? customValidation;

  BlocTextFieldBehavior({
    this.validator,
    this.onChanged,
    this.customValidation,
  });

  @override
  bool validate(String? value) {
    if (customValidation != null) {
      return customValidation!(value);
    }
    return validator?.call(value) == null;
  }

  @override
  void onTextChanged(String value) {
    onChanged?.call(value);
  }

  @override
  String? getValidationMessage(String? value) {
    return validator?.call(value);
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool enableVisibilityToggle;
  final TextInputType? keyboardType;
  final TextFieldBehavior? behavior;
  final bool enabled;
  final int? maxLines;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final bool autoValidate;

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
    this.behavior,
    this.enabled = true,
    this.maxLines = 1,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.fillColor,
    this.textStyle,
    this.width,
    this.height,
    this.contentPadding,
    this.autoValidate = false,
  });

  factory CustomTextField.withCallbacks({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool obscureText = false,
    bool enableVisibilityToggle = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    int? maxLines = 1,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    Color? fillColor,
    TextStyle? textStyle,
    double? width,
    double? height,
    EdgeInsets? contentPadding,
    bool autoValidate = false,
  }) {
    return CustomTextField(
      key: key,
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      obscureText: obscureText,
      enableVisibilityToggle: enableVisibilityToggle,
      keyboardType: keyboardType,
      behavior: DefaultTextFieldBehavior(
        validator: validator,
        onChanged: onChanged,
      ),
      enabled: enabled,
      maxLines: maxLines,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      errorBorderColor: errorBorderColor,
      fillColor: fillColor,
      textStyle: textStyle,
      width: width,
      height: height,
      contentPadding: contentPadding,
      autoValidate: autoValidate,
    );
  }

  factory CustomTextField.withBloc({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool obscureText = false,
    bool enableVisibilityToggle = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool Function(String?)? customValidation,
    bool enabled = true,
    int? maxLines = 1,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    Color? fillColor,
    TextStyle? textStyle,
    double? width,
    double? height,
    EdgeInsets? contentPadding,
    bool autoValidate = false,
  }) {
    return CustomTextField(
      key: key,
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      obscureText: obscureText,
      enableVisibilityToggle: enableVisibilityToggle,
      keyboardType: keyboardType,
      behavior: BlocTextFieldBehavior(
        validator: validator,
        onChanged: onChanged,
        customValidation: customValidation,
      ),
      enabled: enabled,
      maxLines: maxLines,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      errorBorderColor: errorBorderColor,
      fillColor: fillColor,
      textStyle: textStyle,
      width: width,
      height: height,
      contentPadding: contentPadding,
      autoValidate: autoValidate,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  bool _isObscured = false;
  String? _currentError;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _isObscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _isObscured = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _validateAndUpdateError(String? value) {
    if (widget.behavior != null) {
      final error = widget.behavior!.getValidationMessage(value);
      setState(() {
        _hasError = error != null;
        _currentError = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color currentBorderColor = AppColors.grey;
    if (_hasError) {
      currentBorderColor = widget.errorBorderColor ?? AppColors.error;
    } else if (_focusNode.hasFocus) {
      currentBorderColor = widget.focusedBorderColor ?? AppColors.primary;
    } else {
      currentBorderColor = widget.borderColor ?? AppColors.grey;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: currentBorderColor, width: 1),
        color: widget.fillColor,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        validator: (value) {
          _validateAndUpdateError(value);
          return _currentError;
        },
        onChanged: (value) {
          if (widget.behavior != null) {
            widget.behavior!.onTextChanged(value);
          }
          if (widget.autoValidate) {
            _validateAndUpdateError(value);
          }
        },
        obscuringCharacter: '*',
        cursorColor: AppColors.primary,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        focusNode: _focusNode,
        style:
            widget.textStyle ??
            TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontSize: 12,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon:
              widget.prefixIcon != null
                  ? Icon(
                    widget.prefixIcon,
                    color: Theme.of(context).iconTheme.color?.withAlpha(153),
                  )
                  : null,
          suffixIcon: _buildSuffixIcon(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          floatingLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.enableVisibilityToggle) {
      return IconButton(
        iconSize: 24,
        icon: Icon(
          _isObscured
              ? PhosphorIconsRegular.eyeSlash
              : PhosphorIconsRegular.eye,
          color: AppColors.grey,
        ),
        onPressed: _toggleVisibility,
      );
    } else if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, color: AppColors.primary);
    }
    return null;
  }
}
