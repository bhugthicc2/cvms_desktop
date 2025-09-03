import 'package:cvms_desktop/features/dashboard/pages/dashboard_page.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final List<Widget> _pages = [DashboardPage()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShellCubit(),
      child: BlocBuilder<ShellCubit, ShellState>(
        builder: (context, state) {
          return Scaffold(
            body: Row(
              children: [
                CustomSidebar(
                  isExpanded: state.isExpanded,
                  selectedIndex: state.selectedIndex,
                  onItemSelected:
                      (index) => context.read<ShellCubit>().selectPage(index),
                  onToggle: () => context.read<ShellCubit>().toggleSidebar(),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomHeader(
                        title: "Dashboard",
                        onMenuPressed:
                            () => context.read<ShellCubit>().toggleSidebar(),
                      ),
                      Expanded(child: _pages[state.selectedIndex]),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
