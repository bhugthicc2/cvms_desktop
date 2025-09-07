import 'dart:math';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/violation_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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

    // Mock data dawg
    final random = Random();
    final firstNames = ["John", "Maria", "Paolo", "Angela"];
    final lastNames = ["Reyes", "Cruz", "Patangan", "Medija"];

    String randomName() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";

    final allEntries = List.generate(
      200,
      (i) => ViolationEntry(
        dateTime: '09-23-2025 12:00 PM',
        reportedBy: randomName(),
        plateNumber: '2342524',
        owner: randomName(),
        violation: 'Improper parking',
        status: random.nextBool() ? "pending" : "resolved",
      ),
    );
    // Mock data dawg

    // Load entries into cubit
    context.read<ViolationCubit>().loadEntries(allEntries);

    // Listen to search controllers
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
        child: BlocBuilder<ViolationCubit, ViolationState>(
          builder: (context, state) {
            //todo
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
