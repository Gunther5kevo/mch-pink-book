// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../helpers/navigation_helpers.dart';

class DefaulterSection extends ConsumerWidget {
  const DefaulterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultersAsync = ref.watch(defaultersProvider);

    return defaultersAsync.when(
      data: (defaulters) => Card(
        elevation: 2,
        color: Colors.orange.shade50,
        child: InkWell(
          onTap: () => NavigationHelpers.navigateToDefaulters(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_off,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '📍 Defaulters (Missed >7 days)',
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        defaulters.length.toString(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Mothers who have missed scheduled visits and need follow-up contact via phone, SMS, or CHW tracing.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
                if (defaulters.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Most overdue: ${defaulters.first.motherName} (${defaulters.first.daysOverdue} days)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Start Tracing',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                  ],
                ),
              ],
            ),
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