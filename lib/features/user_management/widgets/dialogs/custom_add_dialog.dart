import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../bloc/user_management_bloc.dart';

class CustomAddDialog extends StatefulWidget {
  final String title;
  const CustomAddDialog({super.key, required this.title});

  @override
  State<CustomAddDialog> createState() => _CustomAddDialogState();
}

class _CustomAddDialogState extends State<CustomAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'security personnel';
  bool _isSubmitting = false;

  final List<String> _roles = ['security personnel', 'cdrrmsu admin'];

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });

      context.read<UserManagementBloc>().add(
        AddUserRequested(
          fullname: _fullnameController.text.trim(),
          email: _emailController.text.trim(),
          role: _selectedRole,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserManagementBloc, UserManagementState>(
      listener: (context, state) {
        if (state is UserManagementSuccess) {
          Navigator.of(context).pop(); // Close dialog on success
        } else if (state is UserManagementError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is UserManagementLoading) {
          if (!_isSubmitting) setState(() => _isSubmitting = true);
        }
      },
      child: CustomDialog(
        btnTxt: _isSubmitting ? 'Adding User...' : 'Add User',
        onSubmit: _isSubmitting ? null : _handleSubmit,
        title: widget.title,
        height: 580,
        icon: PhosphorIconsBold.user,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _fullnameController,
                  labelText: 'Full Name',
                  height: 55,
                  validator:
                      (value) =>
                          FormValidator.validateRequired(value, 'Full name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !_isSubmitting,
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !_isSubmitting,
                ),
                Spacing.vertical(size: AppIconSizes.medium),

                _buildRoleDropdown(),
                Spacing.vertical(size: AppIconSizes.medium),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  enableVisibilityToggle: true,
                  validator: FormValidator.validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !_isSubmitting,
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  obscureText: true,
                  enableVisibilityToggle: true,
                  validator:
                      (value) => FormValidator.validateConfirmPassword(
                        _passwordController.text,
                        value,
                      ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: !_isSubmitting,
                ),

                if (_isSubmitting) ...[
                  Spacing.vertical(size: AppIconSizes.medium),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Creating user account...',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: _isSubmitting ? Colors.grey.shade300 : Colors.grey,
          width: 1,
        ),
        color: _isSubmitting ? Colors.grey.shade50 : Colors.white,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedRole,
        decoration: const InputDecoration(
          labelText: 'Role',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        items:
            _roles.map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(
                  role,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: _isSubmitting ? Colors.grey : Colors.black,
                  ),
                ),
              );
            }).toList(),
        onChanged:
            _isSubmitting
                ? null
                : (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  }
                },
      ),
    );
  }
}
