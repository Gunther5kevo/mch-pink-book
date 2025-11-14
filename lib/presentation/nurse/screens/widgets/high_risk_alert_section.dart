// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../helpers/navigation_helpers.dart';

class HighRiskAlertSection extends ConsumerWidget {
  const HighRiskAlertSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highRiskAsync = ref.watch(highRiskMothersProvider);
    final breakdownAsync = ref.watch(highRiskBreakdownProvider);

    return highRiskAsync.when(
      data: (highRiskList) => Card(
        elevation: 3,
        color: Colors.red.shade50,
        child: InkWell(
          onTap: () => NavigationHelpers.navigateToHighRiskList(context),
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
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '⚠️ High-Risk Mothers',
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.red.shade900,
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
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        highRiskList.length.toString(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                breakdownAsync.when(
                  data: (breakdown) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: breakdown.entries
                        .map((entry) => _buildRiskChip(
                              _formatRiskFlag(entry.key),
                              entry.value.toString(),
                            ))
                        .toList(),
                  ),
                  loading: () => const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Text('Error loading breakdown'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'View All',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.red.shade700,
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

  String _formatRiskFlag(String flag) {
    return flag.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Widget _buildRiskChip(String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        '$label ($count)',
        style: AppTextStyles.caption.copyWith(
          color: Colors.red.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}