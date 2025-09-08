import 'dart:math';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_cubit.dart';
import 'package:cvms_desktop/features/user_management/models/user_model.dart';
import 'package:cvms_desktop/features/user_management/widgets/tables/user_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController vehicleController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Mock data dawg
    final random = Random();
    final firstNames = ["John", "Maria", "Paolo", "Angela"];
    final lastNames = ["Reyes", "Cruz", "Patangan", "Medija"];

    String randomName() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";
    String randomPassword() =>
        "${firstNames[random.nextInt(firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";
    final allEntries = List.generate(
      200,
      (i) => UserEntry(
        name: randomName(),
        email: "gapol@ggmail.com",
        role: random.nextBool() ? "CDRRMSU Admin" : "Security Personnel",
        status: random.nextBool() ? "Active" : "Inactive",
        lastLogin: "12/12/34 00:34:00 AM",
        password: randomPassword(),
      ),
    );
    // Mock data dawg

    // Load entries into cubit
    context.read<UserCubit>().loadEntries(allEntries);

    // Listen to search controllers
    vehicleController.addListener(() {
      context.read<UserCubit>().filterEntries(vehicleController.text);
    });
  }

  @override
  void dispose() {
    vehicleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return UserTable(
              title: "User Management",
              entries: state.filteredEntries,
              searchController: vehicleController,
            );
          },
        ),
      ),
    );
  }
}
