/// Mother Home Screen
/// Main dashboard for mothers with real appointments
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/domain/entities/appointment_entity.dart';
import 'package:mch_pink_book/main.dart';
import 'package:mch_pink_book/presentation/providers/appointments_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../../providers/pregnancy_provider.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/welcome_card.dart';
import '../../shared/widgets/quick_action_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/clinic_info_card.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../widgets/pregnancy_card.dart';
import '../widgets/child_card.dart';
import '../widgets/profile_completion_prompt.dart';
import 'mother_profile_screen.dart';
import 'mother_pregnancy_screen.dart';
import 'mother_children_screen.dart';
import 'mother_appointments_screen.dart';

class MotherHomeScreen extends ConsumerWidget {
  const MotherHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MCH Pink Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showComingSoon(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showComingSoon(context),
          ),
        ],
      ),
      body: currentUser.when(
        data: (user) => user == null ? _noUser() : _content(context, ref, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _error(e, ref),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _noUser() => const Center(child: Text('No user data available'));

  Widget _error(Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(currentUserProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, UserEntity user) {
    final pregnancyAsync = ref.watch(currentPregnancyProvider);
    final appointmentsAsync = ref.watch(upcomingAppointmentsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentUserProvider);
        ref.invalidate(currentPregnancyProvider);
        ref.invalidate(upcomingAppointmentsProvider);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card – real upcoming count
            WelcomeCard(
              userName: user.fullName,
              stats: [
                WelcomeStat(
                  icon: Icons.child_care,
                  value: (user.metadata['number_of_children'] as int? ?? 0).toString(),
                  label: (user.metadata['number_of_children'] as int? ?? 0) == 1 ? 'Child' : 'Children',
                ),
                WelcomeStat(
                  icon: Icons.calendar_today,
                  value: appointmentsAsync.when(
                    data: (list) => list.length.toString(),
                    loading: () => '–',
                    error: (_, __) => '!',
                  ),
                  label: 'Upcoming',
                ),
              ],
              badge: pregnancyAsync.when(
                data: (pregnancy) => pregnancy != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.pregnant_woman, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Expecting', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )
                    : null,
                loading: () => null,
                error: (_, __) => null,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Completion
            if (!user.hasCompletedSetup) ...[
              ProfileCompletionPrompt(onComplete: () => _navigateToProfile(context)),
              const SizedBox(height: 24),
            ],

            // Pregnancy Card
            pregnancyAsync.when(
              data: (pregnancy) => pregnancy != null
                  ? Column(
                      children: [
                        PregnancyCard(expectedDeliveryDate: pregnancy.expectedDelivery, onTap: () => _navigateToPregnancy(context)),
                        const SizedBox(height: 24),
                      ],
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Quick Actions
            const Text('Quick Actions', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            QuickActionsGrid(
              actions: [
                QuickActionCard(icon: Icons.pregnant_woman, title: 'Pregnancy', subtitle: 'Track ANC visits', color: AppColors.primaryPink, onTap: () => _navigateToPregnancy(context)),
                QuickActionCard(icon: Icons.child_care, title: 'My Children', subtitle: 'View profiles', color: AppColors.accentBlue, onTap: () => _navigateToChildren(context)),
                QuickActionCard(icon: Icons.vaccines, title: 'Vaccines', subtitle: 'Immunization records', color: AppColors.accentGreen, onTap: () => _showComingSoon(context)),
                QuickActionCard(icon: Icons.show_chart, title: 'Growth', subtitle: 'Track development', color: AppColors.accentOrange, onTap: () => _showComingSoon(context)),
              ],
            ),
            const SizedBox(height: 24),

            // Preferred Clinic
            if (user.preferredClinic != null) ...[
              ClinicInfoCard(clinicName: user.preferredClinic!, lastVisitDate: user.lastVisitDate, onViewDetails: () => _showComingSoon(context)),
              const SizedBox(height: 24),
            ],

            // My Children (placeholder)
            _buildChildrenSection(context, user),
            const SizedBox(height: 24),

            // Upcoming Appointments – real data
            _buildAppointmentsSection(context, ref, appointmentsAsync),
            const SizedBox(height: 24),

            // Health Tips
            _buildHealthTipsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenSection(BuildContext context, UserEntity user) {
    final count = user.metadata['number_of_children'] as int? ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Children ${count > 0 ? '($count)' : ''}', style: AppTextStyles.h3),
            TextButton(onPressed: () => _navigateToChildren(context), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        if (count == 0)
          EmptyState(icon: Icons.child_care, title: 'No children added yet', actionLabel: 'Add Child', onAction: () => _navigateToChildren(context))
        else
          ChildCard(name: 'Child Profile', age: '6 months old', onTap: () => _navigateToChildren(context)),
      ],
    );
  }

  Widget _buildAppointmentsSection(BuildContext context, WidgetRef ref, AsyncValue<List<AppointmentEntity>> asyncAppointments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Upcoming Appointments', style: AppTextStyles.h3),
            TextButton(onPressed: () => _navigateToAppointments(context), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        asyncAppointments.when(
          data: (appointments) {
            if (appointments.isEmpty) {
              return EmptyState(
                icon: Icons.calendar_today,
                title: 'No upcoming appointments',
                subtitle: 'Your nurse will schedule visits',
                iconColor: AppColors.accentBlue,
              );
            }
            final display = appointments.take(3).toList();
            return Column(
              children: display.map((apt) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _appointmentCard(apt, ref.read(currentUserProvider).value!),
              )).toList(),
            );
          },
          loading: () => const LoadingShimmer(height: 80),
          error: (e, _) => Text('Error: $e', style: const TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }

  Widget _appointmentCard(AppointmentEntity apt, UserEntity user) {
    final color = apt.type.color;
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(apt.type.icon, color: color),
        ),
        title: Text(apt.type.displayName),
        subtitle: Text('${apt.formattedDate}\n${apt.clinicId ?? user.preferredClinic ?? 'Clinic'}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToAppointments(null),
      ),
    );
  }

  Widget _buildHealthTipsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Health Tips', style: AppTextStyles.h3),
            TextButton(onPressed: () => _showComingSoon(context), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.lightbulb_outline, color: AppColors.success),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Breastfeeding Benefits', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Exclusive breastfeeding for the first 6 months provides all the nutrients your baby needs...', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 12),
                TextButton(onPressed: () => _showComingSoon(context), child: const Text('Read More')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryPink,
      unselectedItemColor: AppColors.textLight,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.child_care), label: 'Children'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (i) => {
        1: _navigateToChildren,
        2: _navigateToAppointments,
        3: _showComingSoon,
        4: _navigateToProfile,
      }[i]?.call(context),
    );
  }

  void _navigateToProfile(BuildContext c) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => const MotherProfileScreen()));
  void _navigateToPregnancy(BuildContext c) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => const MotherPregnancyScreen()));
  void _navigateToChildren(BuildContext c) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => const MotherChildrenScreen()));
  void _navigateToAppointments(BuildContext? c) => Navigator.of(c ?? navigatorKey.currentContext!).push(MaterialPageRoute(builder: (_) => const MotherAppointmentsScreen()));
  void _showComingSoon(BuildContext c) => ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('Coming soon!'), behavior: SnackBarBehavior.floating));
}