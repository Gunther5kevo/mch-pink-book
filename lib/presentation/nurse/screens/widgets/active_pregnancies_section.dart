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
    // Debug: Log filter selection
    debugPrint('🔍 ActivePregnanciesSection - Filter: $selectedFilter');
    
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
              onPressed: () {
                debugPrint('📱 Navigating to full pregnancies list');
                NavigationHelpers.navigateToPregnanciesList(context);
              },
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
                onTap: () {
                  debugPrint('🎯 Filter changed to: ${_getFilterLabel(filter)}');
                  onFilterChanged(filter);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Pregnancies List
        pregnanciesAsync.when(
          data: (pregnancies) {
            debugPrint('✅ Pregnancies loaded: ${pregnancies.length} items');
            
            // Debug: Log each pregnancy
            for (var i = 0; i < pregnancies.length && i < 5; i++) {
              final p = pregnancies[i];
              debugPrint('   [$i] ${p.motherName} - ${p.statusText} (${p.gestationalAgeText})');
            }
            
            if (pregnancies.isEmpty) {
              debugPrint('ℹ️ No pregnancies found for filter: $selectedFilter');
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
                        const SizedBox(height: 4),
                        Text(
                          'Filter: ${_getFilterLabel(selectedFilter)}',
                          style: AppTextStyles.caption.copyWith(
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
          loading: () {
            debugPrint('⏳ Loading pregnancies for filter: $selectedFilter');
            return const LoadingShimmer(count: 3);
          },
          error: (error, stack) {
            debugPrint('❌ Error loading pregnancies');
            debugPrint('   Error: $error');
            debugPrint('   Filter: $selectedFilter');
            debugPrint('   Stack: $stack');
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Error loading pregnancies',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Filter: ${_getFilterLabel(selectedFilter)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            debugPrint('🔄 Retrying pregnancy fetch for filter: $selectedFilter');
                            ref.refresh(activePregnanciesProvider(selectedFilter));
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            debugPrint('🔄 Resetting to "All" filter');
                            onFilterChanged(PregnancyFilter.all);
                          },
                          icon: const Icon(Icons.filter_list_off),
                          label: const Text('Clear Filter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
