import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/violation_cubit.dart';
import '../../models/violation_tab.dart';
import '../../../../core/theme/app_colors.dart';

class ViolationTabBar extends StatefulWidget {
  const ViolationTabBar({super.key});

  @override
  State<ViolationTabBar> createState() => _ViolationTabBarState();
}

class _ViolationTabBarState extends State<ViolationTabBar>
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
          ViolationTab.all,
          ViolationTab.pending,
          ViolationTab.confirmed,
          ViolationTab.dismissed,
          ViolationTab.sanctioned,
        ];
        context.read<ViolationCubit>().changeTab(tabs[_tabController.index]);
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
      final state = context.read<ViolationCubit>().state;
      final tabIndex = [
        ViolationTab.all,
        ViolationTab.pending,
        ViolationTab.confirmed,
        ViolationTab.dismissed,
        ViolationTab.sanctioned,
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
        Tab(text: 'Pending', height: 30),
        Tab(text: 'Confirmed', height: 30),
        Tab(text: 'Dismissed', height: 30),
        Tab(text: 'Sanctioned', height: 30),
      ],
    );
  }
}
