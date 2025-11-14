// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../helpers/navigation_helpers.dart';
import './pregnancy_card_widget.dart';
import './filter_chip_widget.dart';

class ActivePregnanciesSection extends ConsumerWidget {
  final PregnancyFilter selectedFilter;
  final Function(PregnancyFilter) onFilterChanged;

  const ActivePregnanciesSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregnanciesAsync = ref.watch(activePregnanciesProvider(selectedFilter));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Pregnancies',
              style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
            ),
            TextButton.icon(
              onPressed: () => NavigationHelpers.navigateToPregnanciesList(context),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: PregnancyFilter.values.map((filter) {
              return FilterChipWidget(
                label: _getFilterLabel(filter),
                selected: selectedFilter == filter,
                onTap: () => onFilterChanged(filter),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        pregnanciesAsync.when(
          data: (pregnancies) {
            if (pregnancies.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.pregnant_woman,
                            size: 48, color: AppColors.textLight),
                        const SizedBox(height: 8),
                        Text(
                          'No pregnancies found',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: pregnancies
                  .take(5) // Show first 5
                  .map((p) => PregnancyCardWidget(pregnancy: p))
                  .toList(),
            );
          },
          loading: () => const LoadingShimmer(count: 3),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Error loading pregnancies: $error'),
                  TextButton(
                    onPressed: () => ref.refresh(
                      activePregnanciesProvider(selectedFilter),
                    ),
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

  String _getFilterLabel(PregnancyFilter filter) {
    switch (filter) {
      case PregnancyFilter.all:
        return 'All';
      case PregnancyFilter.firstTrimester:
        return '1st Trimester';
      case PregnancyFilter.secondTrimester:
        return '2nd Trimester';
      case PregnancyFilter.thirdTrimester:
        return '3rd Trimester';
      case PregnancyFilter.overdue:
        return 'Overdue';
      case PregnancyFilter.highRisk:
        return 'High Risk';
      case PregnancyFilter.todayVisits:
        return 'Today';
      case PregnancyFilter.upcomingWeek:
        return 'This Week';
    }
  }
}