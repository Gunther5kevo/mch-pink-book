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
      error: (err, stack) {
        // Enhanced error display with stack trace for debugging
        debugPrint('❌ Pregnancy Tab Error: $err');
        debugPrint('Stack: $stack');
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading pregnancy', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Retry by invalidating the provider
                    ref.invalidate(activePregnancyProvider(motherId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      data: (pregnancy) {
        debugPrint('✅ Pregnancy data received: ${pregnancy?.id ?? "null"}');
        
        if (pregnancy == null) {
          return _EmptyPregnancyState(motherId: motherId, ref: ref);
        }
        return _PregnancyDetailCard(pregnancy: pregnancy, motherId: motherId, ref: ref);
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// Loading shimmer
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
          const LoadingShimmer(
            count: 1,
            height: 180,
            width: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          const SizedBox(height: AppSpacing.lg),
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
  final WidgetRef ref;
  
  const _EmptyPregnancyState({
    required this.motherId,
    required this.ref,
  });

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
              onPressed: () => _showCreatePregnancyDialog(context, motherId, ref),
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

  void _showCreatePregnancyDialog(BuildContext context, String motherId, WidgetRef ref) {
    DateTime? selectedDate;
    DateTime? lmpDate;
    final dateController = TextEditingController();
    final lmpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Start New Pregnancy'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Expected Delivery Date:'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 180)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                        dateController.text = _formatDate(date);
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate == null ? 'Select Date' : dateController.text,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Last Menstrual Period (Optional):'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 90)),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        lmpDate = date;
                        lmpController.text = _formatDate(date);
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    lmpDate == null ? 'Select LMP Date' : lmpController.text,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedDate == null
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(pregnancyServiceProvider)
                            .createPregnancy(
                              motherId: motherId,
                              expectedDelivery: selectedDate!,
                              lmp: lmpDate,
                            );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ref.invalidate(activePregnancyProvider(motherId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pregnancy record created successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// ---------------------------------------------------------------------------
/// Pregnancy detail card – shows key pregnancy data
/// ---------------------------------------------------------------------------
class _PregnancyDetailCard extends StatelessWidget {
  final PregnancyEntity pregnancy;
  final String motherId;
  final WidgetRef ref;
  
  const _PregnancyDetailCard({
    required this.pregnancy,
    required this.motherId,
    required this.ref,
  });

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
              _DetailRow('Pregnancy Number', '#${pregnancy.pregnancyNumber}'),
              _DetailRow('Trimester', trimester.toString()),
              _DetailRow('Gestation', '${pregnancy.gestationWeeks}w ${pregnancy.gestationDays % 7}d'),
              _DetailRow('Expected Delivery', pregnancy.expectedDeliveryFormatted),
              _DetailRow('Days Remaining', '$daysRemaining days'),
              if (pregnancy.lmp != null)
                _DetailRow('LMP', _formatDate(pregnancy.lmp!)),
              _DetailRow('Gravida', pregnancy.gravida?.toString() ?? 'N/A'),
              _DetailRow('Parity', pregnancy.parity?.toString() ?? 'N/A'),
              _DetailRow('Blood Group', pregnancy.bloodGroup ?? 'Unknown'),
              _DetailRow('Rhesus', pregnancy.rhesus ?? 'Unknown'),
              _DetailRow('HIV Status', pregnancy.hivStatus ?? 'Not recorded'),
              
              if (pregnancy.riskFlags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Risk Flags', style: AppTextStyles.h4),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pregnancy.riskFlags.map((flag) => Chip(
                    label: Text(flag),
                    backgroundColor: Colors.red.shade50,
                    labelStyle: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  )).toList(),
                ),
              ],
              
              if (pregnancy.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                Text('Notes', style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(pregnancy.notes!, style: AppTextStyles.bodySmall),
              ],

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showEditPregnancyDialog(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryPink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to full pregnancy details
                      debugPrint('View details for pregnancy: ${pregnancy.id}');
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Full Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPregnancyDialog(BuildContext context) {
    DateTime? selectedDate = pregnancy.expectedDelivery;
    DateTime? lmpDate = pregnancy.lmp;
    final dateController = TextEditingController(text: _formatDate(selectedDate));
    final lmpController = TextEditingController(
      text: lmpDate != null ? _formatDate(lmpDate) : ''
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update Pregnancy'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Expected Delivery Date:'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                        dateController.text = _formatDate(date);
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(dateController.text),
                ),
                const SizedBox(height: 16),
                const Text('Last Menstrual Period:'),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: lmpDate ?? DateTime.now().subtract(const Duration(days: 90)),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        lmpDate = date;
                        lmpController.text = _formatDate(date);
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    lmpDate == null ? 'Set LMP Date' : lmpController.text,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updatedPregnancy = PregnancyEntity(
                    id: pregnancy.id,
                    motherId: pregnancy.motherId,
                    pregnancyNumber: pregnancy.pregnancyNumber,
                    startDate: pregnancy.startDate,
                    expectedDelivery: selectedDate!,
                    actualDelivery: pregnancy.actualDelivery,
                    lmp: lmpDate,
                    eddConfirmedBy: pregnancy.eddConfirmedBy,
                    gravida: pregnancy.gravida,
                    parity: pregnancy.parity,
                    riskFlags: pregnancy.riskFlags,
                    bloodGroup: pregnancy.bloodGroup,
                    rhesus: pregnancy.rhesus,
                    hivStatus: pregnancy.hivStatus,
                    syphilisStatus: pregnancy.syphilisStatus,
                    hepatitisB: pregnancy.hepatitisB,
                    outcome: pregnancy.outcome,
                    outcomeDate: pregnancy.outcomeDate,
                    deliveryPlace: pregnancy.deliveryPlace,
                    notes: pregnancy.notes,
                    isActive: pregnancy.isActive,
                    version: pregnancy.version,
                    lastUpdatedAt: pregnancy.lastUpdatedAt,
                    createdAt: pregnancy.createdAt,
                    updatedAt: pregnancy.updatedAt,
                  );

                  await ref.read(pregnancyServiceProvider).updatePregnancy(
                        pregnancy.id,
                        updatedPregnancy,
                      );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.invalidate(activePregnancyProvider(motherId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pregnancy updated successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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