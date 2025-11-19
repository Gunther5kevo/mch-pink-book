/// Mother Home Screen - Enhanced with Immunizations & Pregnancy Details
/// Shows real child immunization data and detailed pregnancy tracking
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/domain/entities/appointment_entity.dart';
import 'package:mch_pink_book/main.dart';
import 'package:mch_pink_book/presentation/providers/appointments_provider.dart';
import 'package:mch_pink_book/presentation/providers/immunization_providers.dart';
import 'package:mch_pink_book/presentation/providers/mother_children_provider.dart';
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
            // Welcome Card with real stats
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

            // Enhanced Pregnancy Card with Details
            _buildEnhancedPregnancySection(context, ref, pregnancyAsync),

            // Quick Actions
            const Text('Quick Actions', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            QuickActionsGrid(
              actions: [
                QuickActionCard(
                  icon: Icons.pregnant_woman,
                  title: 'Pregnancy',
                  subtitle: 'Track ANC visits',
                  color: AppColors.primaryPink,
                  onTap: () => _navigateToPregnancy(context),
                ),
                QuickActionCard(
                  icon: Icons.child_care,
                  title: 'My Children',
                  subtitle: 'View profiles',
                  color: AppColors.accentBlue,
                  onTap: () => _navigateToChildren(context),
                ),
                QuickActionCard(
                  icon: Icons.vaccines,
                  title: 'Vaccines',
                  subtitle: 'Immunization records',
                  color: AppColors.accentGreen,
                  onTap: () => _showComingSoon(context),
                ),
                QuickActionCard(
                  icon: Icons.show_chart,
                  title: 'Growth',
                  subtitle: 'Track development',
                  color: AppColors.accentOrange,
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Preferred Clinic
            if (user.clinic != null) ...[
              ClinicInfoCard(
                clinicName: user.clinic!.name,
                lastVisitDate: user.lastVisitDate,
                onViewDetails: () => _showComingSoon(context),
              ),
              const SizedBox(height: 24),
            ] else if (user.preferredClinic != null) ...[
              ClinicInfoCard(
                clinicName: user.preferredClinic!,
                lastVisitDate: user.lastVisitDate,
                onViewDetails: () => _showComingSoon(context),
              ),
              const SizedBox(height: 24),
            ],

            // My Children with Immunizations
            _buildChildrenWithImmunizationsSection(context, ref, user),
            const SizedBox(height: 24),

            // Upcoming Appointments
            _buildAppointmentsSection(context, ref, appointmentsAsync),
            const SizedBox(height: 24),

            // Health Tips
            _buildHealthTipsSection(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Enhanced Pregnancy Section with Detailed Info
  // ═══════════════════════════════════════════════════════════════════════
  // Replace your _buildEnhancedPregnancySection method with this fixed version

Widget _buildEnhancedPregnancySection(
  BuildContext context,
  WidgetRef ref,
  AsyncValue pregnancyAsync,
) {
  return pregnancyAsync.when(
    data: (pregnancy) {
      if (pregnancy == null) return const SizedBox.shrink();

      // Safe calculation of pregnancy metrics
      final now = DateTime.now();
      
      // Calculate start date with multiple fallbacks
      DateTime startDate;
      if (pregnancy.startDate != null) {
        startDate = pregnancy.startDate!;
      } else if (pregnancy.lmp != null) {
        startDate = pregnancy.lmp!;
      } else {
        // Fallback: calculate from expected delivery (280 days pregnancy)
        startDate = pregnancy.expectedDelivery.subtract(const Duration(days: 280));
      }
      
      final daysSinceStart = now.difference(startDate).inDays.clamp(0, 280);
      final weeksPregnant = (daysSinceStart / 7).floor();
      final daysInWeek = daysSinceStart % 7;
      
      final daysUntilDelivery = pregnancy.expectedDelivery.difference(now).inDays.clamp(0, 280);
      final trimester = weeksPregnant < 13 ? 1 : (weeksPregnant < 27 ? 2 : 3);
      final isHighRisk = (pregnancy.riskFlags != null && pregnancy.riskFlags!.isNotEmpty);

      return Column(
        children: [
          // Main Pregnancy Card
          Card(
            elevation: 2,
            child: InkWell(
              onTap: () => _navigateToPregnancy(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.pregnant_woman,
                            color: AppColors.primaryPink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Pregnancy',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Week $weeksPregnant+$daysInWeek • Trimester $trimester',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isHighRisk)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.warning.withOpacity(0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 14,
                                  color: AppColors.warning,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'High Risk',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Expected Delivery Date
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: AppColors.accentBlue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expected Delivery',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(pregnancy.expectedDelivery),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              daysUntilDelivery > 0 
                                  ? '$daysUntilDelivery days' 
                                  : 'Due today',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Progress Indicator
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pregnancy Progress',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                            Text(
                              '${((weeksPregnant / 40) * 100).clamp(0, 100).toInt()}%',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (weeksPregnant / 40).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: AppColors.primaryPink.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryPink,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    
                    // View Details Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _navigateToPregnancy(context),
                          icon: const Text('View Details'),
                          label: const Icon(Icons.chevron_right, size: 20),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    },
    loading: () => const LoadingShimmer(height: 200),
    error: (_, __) => const SizedBox.shrink(),
  );
}

  // ═══════════════════════════════════════════════════════════════════════
  // Children Section with Recent Immunizations
  // ═══════════════════════════════════════════════════════════════════════
  // Replace your _buildChildrenWithImmunizationsSection method with this:

Widget _buildChildrenWithImmunizationsSection(
  BuildContext context,
  WidgetRef ref,
  UserEntity user,
) {
  final childrenAsync = ref.watch(motherChildrenProvider);
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          childrenAsync.when(
            data: (children) => Text(
              'My Children ${children.isNotEmpty ? '(${children.length})' : ''}',
              style: AppTextStyles.h3,
            ),
            loading: () => const Text('My Children', style: AppTextStyles.h3),
            error: (_, __) => const Text('My Children', style: AppTextStyles.h3),
          ),
          TextButton(
            onPressed: () => _navigateToChildren(context),
            child: const Text('View All'),
          ),
        ],
      ),
      const SizedBox(height: 12),
      
      childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return EmptyState(
              icon: Icons.child_care,
              title: 'No children added yet',
              actionLabel: 'Add Child',
              onAction: () => _navigateToChildren(context),
            );
          }
          
          // Show up to 3 children on home screen
          final displayChildren = children.take(3).toList();
          
          return Column(
            children: displayChildren.map((child) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildChildImmunizationCard(
                  context,
                  ref,
                  child: child,
                ),
              );
            }).toList(),
          );
        },
        loading: () => const LoadingShimmer(height: 120),
        error: (error, _) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Failed to load children',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(motherChildrenProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

// Updated child card that uses MotherChildStatus
Widget _buildChildImmunizationCard(
  BuildContext context,
  WidgetRef ref, {
  required MotherChildStatus child,
}) {
  // Determine status color
  Color statusColor;
  IconData statusIcon;
  
  if (child.overdueVaccines.isNotEmpty) {
    statusColor = AppColors.error;
    statusIcon = Icons.warning_amber_rounded;
  } else if (child.dueVaccines.isNotEmpty) {
    statusColor = AppColors.warning;
    statusIcon = Icons.schedule;
  } else if (child.isFullyImmunized) {
    statusColor = AppColors.success;
    statusIcon = Icons.check_circle;
  } else {
    statusColor = AppColors.accentGreen;
    statusIcon = Icons.check_circle_outline;
  }

  return Card(
    child: InkWell(
      onTap: () => _navigateToChildren(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Child Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      child.gender?.toLowerCase() == 'male' 
                          ? Icons.boy 
                          : child.gender?.toLowerCase() == 'female'
                              ? Icons.girl
                              : Icons.child_care,
                      color: AppColors.accentBlue,
                      size: 28,
                    ),
                  ),
                  // Status indicator
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        statusIcon,
                        size: 14,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Child Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child.ageDisplay,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Immunization Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.vaccines,
                          size: 12,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            child.immunizationStatus,
                            style: TextStyle(
                              fontSize: 11,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Next vaccine info if available
                  if (child.nextVaccine != null && child.nextVaccineDate != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Next: ${child.nextVaccine} on ${_formatDate(child.nextVaccineDate!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    ),
  );
}

  

  // ═══════════════════════════════════════════════════════════════════════
  // Appointments Section
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildAppointmentsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<AppointmentEntity>> asyncAppointments,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Upcoming Appointments', style: AppTextStyles.h3),
            TextButton(
              onPressed: () => _navigateToAppointments(context),
              child: const Text('View All'),
            ),
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
              children: display
                  .map((apt) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _appointmentCard(
                          apt,
                          ref.read(currentUserProvider).value!,
                        ),
                      ))
                  .toList(),
            );
          },
          loading: () => const LoadingShimmer(height: 80),
          error: (e, _) => Text(
            'Error: $e',
            style: const TextStyle(color: AppColors.error),
          ),
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
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(apt.type.icon, color: color),
        ),
        title: Text(apt.type.displayName),
        subtitle: Text(
          '${apt.formattedDate}\n${apt.clinicId ?? user.clinic?.name ?? user.preferredClinic ?? 'Clinic'}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToAppointments(null),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Health Tips Section
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildHealthTipsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Health Tips', style: AppTextStyles.h3),
            TextButton(
              onPressed: () => _showComingSoon(context),
              child: const Text('View All'),
            ),
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
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Breastfeeding Benefits',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Exclusive breastfeeding for the first 6 months provides all the nutrients your baby needs...',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _showComingSoon(context),
                  child: const Text('Read More'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Bottom Navigation
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryPink,
      unselectedItemColor: AppColors.textLight,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.child_care), label: 'Children'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Appointments'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learn'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (i) => {
        1: _navigateToChildren,
        2: _navigateToAppointments,
        3: _showComingSoon,
        4: _navigateToProfile,
      }[i]
          ?.call(context),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Helper Methods
  // ═══════════════════════════════════════════════════════════════════════
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _navigateToProfile(BuildContext c) => Navigator.of(c).push(
      MaterialPageRoute(builder: (_) => const MotherProfileScreen()));
  void _navigateToPregnancy(BuildContext c) => Navigator.of(c).push(
      MaterialPageRoute(builder: (_) => const MotherPregnancyScreen()));
  void _navigateToChildren(BuildContext c) => Navigator.of(c).push(
      MaterialPageRoute(builder: (_) => const MotherChildrenScreen()));
  void _navigateToAppointments(BuildContext? c) => Navigator.of(
          c ?? navigatorKey.currentContext!)
      .push(MaterialPageRoute(builder: (_) => const MotherAppointmentsScreen()));
  void _showComingSoon(BuildContext c) => ScaffoldMessenger.of(c).showSnackBar(
      const SnackBar(
          content: Text('Coming soon!'), behavior: SnackBarBehavior.floating));
}