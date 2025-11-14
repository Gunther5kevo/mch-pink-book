// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/nurse/screens/nurse_appointments_screen.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../../../providers/appointments_provider.dart';
import '../helpers/navigation_helpers.dart';
import './task_item_widget.dart';

class TodayTasksSection extends ConsumerWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasksAsync = ref.watch(todayTasksProvider);

    return todayTasksAsync.when(
      data: (tasks) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.assignment, color: AppColors.primaryPink),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '📝 Today\'s Tasks',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${tasks.totalTasks} Total',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TaskItemWidget(
                icon: Icons.event,
                label: 'Scheduled Visits',
                count: tasks.scheduledVisits.toString(),
                onTap: () => NavigationHelpers.goToAppointments(
                  context,
                  AppointmentFilterType.today,
                ),
              ),
              TaskItemWidget(
                icon: Icons.vaccines,
                label: 'Immunizations Due',
                count: tasks.immunizationsDue.toString(),
                onTap: () => NavigationHelpers.navigateToImmunizationsDue(context),
              ),
              TaskItemWidget(
                icon: Icons.follow_the_signs,
                label: 'Follow-up Reminders',
                count: tasks.followUps.toString(),
                onTap: () => NavigationHelpers.navigateToFollowUps(context),
              ),
              TaskItemWidget(
                icon: Icons.phone_callback,
                label: 'Defaulters to Trace',
                count: tasks.defaultersToTrace.toString(),
                color: Colors.orange,
                onTap: () => NavigationHelpers.navigateToDefaulters(context),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: LoadingShimmer(count: 4, compact: true),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text('Error loading tasks: $error'),
        ),
      ),
    );
  }
}