/// Comprehensive Nurse MCH Dashboard - Main Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/auth_notifier.dart';
import '../../providers/clinic_dashboard_providers.dart';
import '../../providers/appointments_provider.dart';
import './widgets/search_bar_widget.dart';
import './widgets/clinic_stats_section.dart';
import './widgets/today_tasks_section.dart';
import './widgets/high_risk_alert_section.dart';
import './widgets/active_pregnancies_section.dart';
import './widgets/defaulter_section.dart';
import './widgets/immunization_tracker_section.dart';
import './widgets/quick_action_fab.dart';
import './helpers/dialog_helpers.dart';

class NurseHomeScreen extends ConsumerStatefulWidget {
  const NurseHomeScreen({super.key});

  @override
  ConsumerState<NurseHomeScreen> createState() => _NurseHomeScreenState();
}

class _NurseHomeScreenState extends ConsumerState<NurseHomeScreen> {
  PregnancyFilter _selectedFilter = PregnancyFilter.all;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.mapOrNull(
      authenticated: (state) => state.user,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, user),
      body: RefreshIndicator(
        onRefresh: () => _refreshAllData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchBarWidget(),
              const SizedBox(height: AppSpacing.lg),
              const ClinicStatsSection(),
              const SizedBox(height: AppSpacing.lg),
              const TodayTasksSection(),
              const SizedBox(height: AppSpacing.lg),
              const HighRiskAlertSection(),
              const SizedBox(height: AppSpacing.lg),
              ActivePregnanciesSection(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const DefaulterSection(),
              const SizedBox(height: AppSpacing.lg),
              const ImmunizationTrackerSection(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
      floatingActionButton: const QuickActionFAB(),
    );
  }

PreferredSizeWidget _buildAppBar(BuildContext context, dynamic user) {
  return AppBar(
    backgroundColor: AppColors.primaryPink,
    foregroundColor: Colors.white,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Welcome message with user's name
        Text(
          user?.fullName != null ? 'Welcome ${user!.fullName}' : 'MCH Dashboard',
          style: AppTextStyles.h2.copyWith(fontSize: 18),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (user?.clinic?.name != null) ...[
          const SizedBox(height: 1),
          // Show clinic name
          Text(
            user.clinic.name,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ] else if (user?.effectiveFacilityName != null) ...[
          const SizedBox(height: 1),
          // Fallback to legacy facility name
          Text(
            user.effectiveFacilityName!,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    ),
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () => DialogHelpers.showFiltersDialog(context),
      ),
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () =>
            DialogHelpers.showComingSoon(context, 'Notifications'),
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) => _handleMenuAction(context, value),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'sync',
            child: Row(
              children: [
                Icon(Icons.sync, size: 18),
                SizedBox(width: 8),
                Text('Sync Status'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Sign Out', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

  Future<void> _handleMenuAction(BuildContext context, String value) async {
    if (value == 'logout') {
      final confirmed = await DialogHelpers.showSignOutDialog(context);
      if (confirmed && context.mounted) {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
        }
      }
    } else if (value == 'sync') {
      DialogHelpers.showComingSoon(context, 'Sync Status');
    }
  }

  Future<void> _refreshAllData() async {
    ref
      ..refresh(clinicStatsProvider)
      ..refresh(activePregnanciesProvider(_selectedFilter))
      ..refresh(highRiskMothersProvider)
      ..refresh(highRiskBreakdownProvider)
      ..refresh(defaultersProvider)
      ..refresh(todayTasksProvider)
      ..refresh(immunizationsDueSummaryProvider)
      ..refresh(nurseAppointmentsProvider)
      ..refresh(todayAppointmentsCountProvider)
      ..refresh(upcomingAppointmentsCountProvider);
  }
}