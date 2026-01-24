import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/widgets/skeletons/table_skeleton.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/violation_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViolationManagementPage extends StatefulWidget {
  const ViolationManagementPage({super.key});

  @override
  State<ViolationManagementPage> createState() =>
      _ViolationManagementPageState();
}

class _ViolationManagementPageState extends State<ViolationManagementPage> {
  final TextEditingController violationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViolationCubit>().listenViolations();
    });

    violationController.addListener(() {
      context.read<ViolationCubit>().filterEntries(violationController.text);
    });
  }

  @override
  void dispose() {
    violationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: BlocConsumer<ViolationCubit, ViolationState>(
          listener: (context, state) {
            debugPrint("VIOLATION DEBUG: ${state.allEntries}");
            debugPrint("VIOLATION DEBUG: ${state.filteredEntries}");
            if (state.message != null) {
              CustomSnackBar.show(
                context: context,
                message: state.message!,
                type: state.messageType ?? SnackBarType.success,
              );

              context.read<ViolationCubit>().clearMessage();
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return Skeletonizer(
                enabled: state.isLoading,
                child: buildSkeletonTable(),
              );
            }

            return ViolationTable(
              title: "Violation Management",
              entries: state.filteredEntries,
              searchController: violationController,
            );
          },
        ),
      ),
    );
  }
}
