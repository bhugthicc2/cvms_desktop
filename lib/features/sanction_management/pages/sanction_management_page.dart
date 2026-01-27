import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/tables/sanction_table.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/tables/table_header.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/tables/top_bar.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/tabs/sanction_tab_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SanctionManagementPage extends StatefulWidget {
  final Sanction? sanctionEntry;
  const SanctionManagementPage({super.key, this.sanctionEntry});

  @override
  State<SanctionManagementPage> createState() => _SanctionManagementPageState();
}

class _SanctionManagementPageState extends State<SanctionManagementPage> {
  final TextEditingController sanctionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<SanctionCubit>().listenSanctions();
    // });

    // sanctionController.addListener(() {
    //   context.read<SanctionCubit>().filterEntries(sanctionController.text);
    // });
    //TODO
  }

  @override
  void dispose() {
    sanctionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            TopBar(metrics: context.read<SanctionCubit>().getMetrics()),
            Spacing.vertical(size: AppSpacing.small),
            const SanctionTabBar(),
            Spacing.vertical(size: AppSpacing.small),
            //table header with violation search field
            TableHeader(sanctionController: sanctionController),

            Spacing.vertical(size: AppSpacing.medium),
            SanctionTable(
              title: "Sanction Management",
              entries: [],
              searchController: sanctionController,
              onView: () {
                //show sanction details
              },
            ),
          ],
        ),
      ),
    );
  }
}
