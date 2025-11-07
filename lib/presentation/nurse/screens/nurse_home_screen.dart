/// Nurse Home Screen
/// Dashboard for healthcare providers – now with live Immunization access
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/nurse/screens/search_patient_screen.dart';
import './immunization_screen.dart';
import '../../providers/child_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../providers/appointments_provider.dart';
import '../../providers/auth_notifier.dart';
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
            // ignore: unused_result
            ..refresh(nurseAppointmentsProvider)
            // ignore: unused_result
            ..refresh(todayAppointmentsCountProvider)
            // ignore: unused_result
            ..refresh(upcomingAppointmentsCountProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid
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
              _buildQuickActions(context, ref),
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
  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
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
            MaterialPageRoute(builder: (_) => const SearchPatientScreen()),
          ),
        ),
        _QuickActionButton(
          icon: Icons.note_add,
          label: 'Record Visit',
          color: AppColors.accentGreen,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPatientScreen()),
          ),
        ),
        _QuickActionButton(
          icon: Icons.vaccines,
          label: 'Immunization',
          color: AppColors.accentOrange,
          onTap: () => _openImmunizationFlow(context, ref),
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

  // -----------------------------------------------------------------------
  // Immunization Flow: Select Child → View Immunizations
  // -----------------------------------------------------------------------
  void _openImmunizationFlow(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) {
          return Consumer(
            builder: (context, ref, _) {
              final childrenState = ref.watch(allChildrenProvider);

              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.vaccines, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Select Child for Immunization',
                          style:
                              AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Expanded(
                    child: childrenState.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: LoadingShimmer(count: 5, compact: true),
                          )
                        : childrenState.error != null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(height: 8),
                                    Text('Error: ${childrenState.error}'),
                                    TextButton(
                                      onPressed: () =>
                                          ref.refresh(allChildrenProvider),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : childrenState.children.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Text(
                                        'No children registered in the clinic.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: scrollController,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: childrenState.children.length,
                                    itemBuilder: (ctx, i) {
                                      final child = childrenState.children[i];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: AppColors
                                                .primaryPink
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.2),
                                            child: Text(
                                              child.fullName.isNotEmpty
                                                  ? child.fullName[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryPink,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            child.fullName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'DOB: ${child.dateOfBirth.toLocal().toString().split(' ')[0]}',
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ImmunizationScreen(
                                                        childId: child.id),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick Action Button Widget (Defined OUTSIDE the class but in same file)
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
                  // ignore: deprecated_member_use
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