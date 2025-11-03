/// Nurse Home Screen
/// Dashboard for healthcare providers – 100% real data, using shared StatCard
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/nurse/screens/search_patient_screen.dart';

import '../../../core/constants/app_constants.dart';
import '../../shared/widgets/stat_card.dart';
import '../../providers/appointments_provider.dart';
import '../../providers/auth_notifier.dart'; // <-- ADDED
import '../widgets/nurse_recent_patients.dart';
import 'nurse_appointments_screen.dart';

class NurseHomeScreen extends ConsumerWidget {
  const NurseHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayCount = ref.watch(todayAppointmentsCountProvider);
    final upcomingCount = ref.watch(upcomingAppointmentsCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        title: Text('Welcome, Nurse', style: AppTextStyles.h2),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showComingSoon(context, 'Notifications'),
          ),
          // SIGN OUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              final confirmed = await _showSignOutDialog(context);
              if (confirmed && context.mounted) {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (_) => false);
                }
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..refresh(nurseAppointmentsProvider)
            ..refresh(todayAppointmentsCountProvider)
            ..refresh(upcomingAppointmentsCountProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid using shared StatCard
              StatCardsGrid(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                cards: [
                  StatCard(
                    icon: Icons.today,
                    label: 'Today',
                    value: todayCount.when(
                      data: (c) => c.toString(),
                      loading: () => '—',
                      error: (_, __) => '!',
                    ),
                    color: AppColors.primaryPink,
                    onTap: () =>
                        _goToAppointments(context, AppointmentFilterType.today),
                  ),
                  StatCard(
                    icon: Icons.calendar_month,
                    label: 'Upcoming',
                    value: upcomingCount.when(
                      data: (c) => c.toString(),
                      loading: () => '—',
                      error: (_, __) => '!',
                    ),
                    color: AppColors.accentBlue,
                    onTap: () => _goToAppointments(
                        context, AppointmentFilterType.upcoming),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Recent Patients
              Text(
                'Recent Patients',
                style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
              ),
              const SizedBox(height: AppSpacing.md),
              const NurseRecentPatients(),
              const SizedBox(height: AppSpacing.xl),

              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildQuickActions(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToAppointments(context, null),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.calendar_today),
        label: Text('All Appointments', style: AppTextStyles.button),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Navigation
  // -----------------------------------------------------------------------
  void _goToAppointments(BuildContext context, AppointmentFilterType? filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NurseAppointmentsScreen(initialFilter: filter),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // UI Helpers
  // -----------------------------------------------------------------------
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon!'),
        backgroundColor: AppColors.primaryPinkDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Sign Out Confirmation Dialog
  // -----------------------------------------------------------------------
  Future<bool> _showSignOutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Sign out?'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // -----------------------------------------------------------------------
  // Quick Actions Grid
  // -----------------------------------------------------------------------
  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 3,
      children: [
        _QuickActionButton(
          icon: Icons.search,
          label: 'Search Patient',
          color: AppColors.accentBlue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchPatientScreen(),
            ),
          ),
        ),
        _QuickActionButton(
          icon: Icons.add_circle,
          label: 'Record Visit',
          color: AppColors.accentGreen,
          onTap: () => _showComingSoon(context, 'Record visit'),
        ),
        _QuickActionButton(
          icon: Icons.vaccines,
          label: 'Immunization',
          color: AppColors.accentOrange,
          onTap: () => _showComingSoon(context, 'Immunization record'),
        ),
        _QuickActionButton(
          icon: Icons.bar_chart,
          label: 'Clinic Stats',
          color: AppColors.secondary,
          onTap: () => _showComingSoon(context, 'Clinic stats'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Quick Action Button Widget
// ---------------------------------------------------------------------------
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md)),
      child: InkWell(
        borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
