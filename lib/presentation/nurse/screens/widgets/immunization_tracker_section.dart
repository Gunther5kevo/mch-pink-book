// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../helpers/immunization_helpers.dart';

class ImmunizationTrackerSection extends ConsumerWidget {
  const ImmunizationTrackerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immunizationsAsync = ref.watch(immunizationsDueSummaryProvider);

    return immunizationsAsync.when(
      data: (immunizations) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.vaccines, color: AppColors.accentOrange),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '💉 Immunization Tracker',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _ImmunizationStat(
                      label: 'Overdue',
                      count: immunizations.overdue.toString(),
                      color: Colors.red,
                      icon: Icons.warning,
                    ),
                  ),
                  Expanded(
                    child: _ImmunizationStat(
                      label: 'Due This Week',
                      count: immunizations.dueThisWeek.toString(),
                      color: Colors.orange,
                      icon: Icons.schedule,
                    ),
                  ),
                  Expanded(
                    child: _ImmunizationStat(
                      label: 'Fully Immunized',
                      count: immunizations.fullyImmunized.toString(),
                      color: AppColors.accentGreen,
                      icon: Icons.check_circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => ImmunizationHelpers.openImmunizationFlow(context, ref),
                icon: const Icon(Icons.vaccines),
                label: const Text('Record Immunization'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentOrange,
                  side: const BorderSide(color: AppColors.accentOrange),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: LoadingShimmer(count: 1),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

class _ImmunizationStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final IconData icon;

  const _ImmunizationStat({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          count,
          style: AppTextStyles.h3.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}