/// lib/presentation/nurse/screens/tabs/pregnancy_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/pregnancy_entity.dart';
import '../../../providers/pregnancy_provider.dart';
import '../../../shared/widgets/loading_shimmer.dart';

/// ---------------------------------------------------------------------------
/// PregnancyTab – Displays active pregnancy for a mother (or none if inactive)
/// ---------------------------------------------------------------------------
class PregnancyTab extends ConsumerWidget {
  final String motherId;
  const PregnancyTab({super.key, required this.motherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pregnancyAsync = ref.watch(activePregnancyProvider(motherId));

    return pregnancyAsync.when(
      loading: () => const _PregnancyLoading(),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading pregnancy',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (pregnancy) {
        if (pregnancy == null) {
          return _EmptyPregnancyState(motherId: motherId);
        }
        return _PregnancyDetailCard(pregnancy: pregnancy);
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// Loading shimmer - FIXED: Proper use of LoadingShimmer widget
/// ---------------------------------------------------------------------------
class _PregnancyLoading extends StatelessWidget {
  const _PregnancyLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main pregnancy card shimmer
          const LoadingShimmer(
            count: 1,
            height: 180,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Detail rows shimmer - using compact mode
          const LoadingShimmer(
            count: 3,
            height: 60,
            compact: true,
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Empty state – when no pregnancy is active
/// ---------------------------------------------------------------------------
class _EmptyPregnancyState extends StatelessWidget {
  final String motherId;
  const _EmptyPregnancyState({required this.motherId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pregnant_woman, size: 72, color: AppColors.primaryPink),
            const SizedBox(height: 12),
            Text('No Active Pregnancy', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'You can start a new pregnancy record for this mother.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to create pregnancy form
              },
              icon: const Icon(Icons.add),
              label: const Text('Start New Pregnancy'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Pregnancy detail card – shows key pregnancy data
/// ---------------------------------------------------------------------------
class _PregnancyDetailCard extends StatelessWidget {
  final PregnancyEntity pregnancy;
  const _PregnancyDetailCard({required this.pregnancy});

  @override
  Widget build(BuildContext context) {
    final daysRemaining = pregnancy.daysUntilDelivery;
    final trimester = pregnancy.trimester;
    final isHighRisk = pregnancy.isHighRisk;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1.5,
        shadowColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.pregnant_woman, size: 36, color: AppColors.primaryPink),
                  const SizedBox(width: 12),
                  Text(
                    'Active Pregnancy',
                    style: AppTextStyles.h2.copyWith(color: AppColors.primaryPink),
                  ),
                  const Spacer(),
                  if (isHighRisk)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'High Risk',
                        style: AppTextStyles.caption.copyWith(color: Colors.red.shade700),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Main details
              _DetailRow('Trimester', trimester.toString()),
              _DetailRow('Expected Delivery', pregnancy.expectedDeliveryFormatted),
              _DetailRow('Days Remaining', '$daysRemaining days'),
              _DetailRow('Gravida', pregnancy.gravida?.toString() ?? 'N/A'),
              _DetailRow('Parity', pregnancy.parity?.toString() ?? 'N/A'),
              _DetailRow('Blood Group', pregnancy.bloodGroup ?? 'Unknown'),
              _DetailRow('Rhesus', pregnancy.rhesus ?? 'Unknown'),
              _DetailRow('HIV Status', pregnancy.hivStatus ?? 'Not recorded'),
              if (pregnancy.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                Text('Notes', style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(pregnancy.notes!, style: AppTextStyles.bodySmall),
              ],

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to full pregnancy details
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Simple row for displaying a label/value pair
/// ---------------------------------------------------------------------------
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}