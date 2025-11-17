// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/nurse/screens/nurse_appointments_screen.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../helpers/navigation_helpers.dart';

class ClinicStatsSection extends ConsumerWidget {
  const ClinicStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicStatsAsync = ref.watch(clinicStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clinic Overview',
          style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
        ),
        const SizedBox(height: AppSpacing.sm),
        clinicStatsAsync.when(
          data: (stats) => Column(
            children: [
              StatCardsGrid(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                cards: [
                  StatCard(
                    icon: Icons.pregnant_woman,
                    label: 'Active\nPregnancies',
                    value: stats.activePregnancies.toString(),
                    color: AppColors.primaryPink,
                    onTap: () => NavigationHelpers.navigateToPregnanciesList(context),
                  ),
                  StatCard(
                    icon: Icons.baby_changing_station,
                    label: 'Newborns\n<42 days',
                    value: stats.newborns.toString(),
                    color: AppColors.accentBlue,
                    onTap: () => NavigationHelpers.navigateToNewbornsList(context),
                  ),
                  StatCard(
                    icon: Icons.warning_amber_rounded,
                    label: 'High Risk\nMothers',
                    value: stats.highRiskCount.toString(),
                    color: Colors.red,
                    onTap: () => NavigationHelpers.navigateToHighRiskList(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              StatCardsGrid(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                cards: [
                  StatCard(
                    icon: Icons.today,
                    label: 'Today\'s\nAppointments',
                    value: stats.todayAppointments.toString(),
                    color: AppColors.accentGreen,
                    onTap: () => NavigationHelpers.goToAppointments(
                      context,
                      AppointmentFilterType.today,
                    ),
                  ),
                  StatCard(
                    icon: Icons.vaccines,
                    label: 'Immunizations\nDue Today',
                    value: stats.immunizationsDueToday.toString(),
                    color: AppColors.accentOrange,
                    onTap: () => NavigationHelpers.navigateToImmunizationsDue(context),
                  ),
                  StatCard(
                    icon: Icons.people,
                    label: 'Registered\nMothers',
                    value: stats.registeredMothers.toString(),
                    color: AppColors.secondary,
                    onTap: () => NavigationHelpers.navigateToMothersList(context),
                  ),
                ],
              ),
            ],
          ),
          loading: () => const LoadingShimmer(count: 2, compact: true),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load clinic stats',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => ref.refresh(clinicStatsProvider),
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
}