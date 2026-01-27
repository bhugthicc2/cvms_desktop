import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';

class SanctionTabBar extends StatefulWidget {
  const SanctionTabBar({super.key});

  @override
  State<SanctionTabBar> createState() => _SanctionTabBarState();
}

class _SanctionTabBarState extends State<SanctionTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Listen to tab changes and update cubit
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final tabs = [
          SanctionTab.all,
          SanctionTab.active,
          SanctionTab.suspended,
          SanctionTab.revoked,
          SanctionTab.expired,
        ];
        context.read<SanctionCubit>().changeTab(tabs[_tabController.index]);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Add a small delay to avoid interfering with initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Sync TabController with cubit state
      final state = context.read<SanctionCubit>().state;
      final tabIndex = [
        SanctionTab.all,
        SanctionTab.active,
        SanctionTab.suspended,
        SanctionTab.revoked,
        SanctionTab.expired,
      ].indexOf(state.activeTab);

      if (tabIndex != _tabController.index && !_tabController.indexIsChanging) {
        _tabController.animateTo(tabIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      physics: const BouncingScrollPhysics(),
      controller: _tabController,
      isScrollable: true,
      dividerHeight: 1,
      dividerColor: Colors.transparent,
      indicatorColor: AppColors.primary,
      indicatorWeight: 1,

      indicatorPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppColors.primary,
      tabAlignment: TabAlignment.start,
      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      unselectedLabelColor: AppColors.grey,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      tabs: const [
        Tab(text: ' All ', height: 30),
        Tab(text: 'Active', height: 30),
        Tab(text: 'Suspended', height: 30),
        Tab(text: 'Revoked', height: 30),
        Tab(text: 'Expired', height: 30),
      ],
    );
  }
}
