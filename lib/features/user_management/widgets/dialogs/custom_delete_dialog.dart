import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../bloc/user_management_bloc.dart';

class CustomDeleteDialog extends StatefulWidget {
  final String title;
  final String email;
  final String uid;
  final String fullname;

  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.email,
    required this.uid,
    required this.fullname,
  });

  @override
  State<CustomDeleteDialog> createState() => _CustomDeleteDialogState();
}

class _CustomDeleteDialogState extends State<CustomDeleteDialog> {
  bool _isDeleting = false;

  void _handleDelete() {
    if (!_isDeleting) {
      setState(() {
        _isDeleting = true;
      });

      context.read<UserManagementBloc>().add(
        DeleteUserRequested(uid: widget.uid, fullname: widget.fullname),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserManagementBloc, UserManagementState>(
      listener: (context, state) {
        if (state is UserManagementSuccess &&
            state.operation == UserOperation.delete) {
          Navigator.of(context).pop();
        } else if (state is UserManagementError) {
          setState(() {
            _isDeleting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is UserManagementLoading) {
          if (!_isDeleting) {
            setState(() {
              _isDeleting = true;
            });
          }
        }
      },
      child: CustomDialog(
        isAlert: true,
        headerColor: AppColors.error,
        icon: PhosphorIconsRegular.trash,
        width: 500,
        btnTxt: _isDeleting ? 'Deleting...' : 'Yes, Delete',
        onSubmit: _isDeleting ? null : _handleDelete,
        title: widget.title,
        height: 300,
        isExpanded: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete user:',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.email})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            if (_isDeleting) ...[
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Deleting user...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
