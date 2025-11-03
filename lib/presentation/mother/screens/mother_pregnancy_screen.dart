/// Mother Pregnancy Screen - Fixed
/// Track pregnancy and ANC visits
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/providers/pregnancy_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/pregnancy_entity.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/empty_state.dart';
import '../widgets/pregnancy_card.dart';

class MotherPregnancyScreen extends ConsumerStatefulWidget {
  const MotherPregnancyScreen({super.key});

  @override
  ConsumerState<MotherPregnancyScreen> createState() =>
      _MotherPregnancyScreenState();
}

class _MotherPregnancyScreenState extends ConsumerState<MotherPregnancyScreen> {
  @override
  Widget build(BuildContext context) {
    final pregnancyAsync = ref.watch(currentPregnancyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pregnancy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showPregnancyInfo,
          ),
        ],
      ),
      body: pregnancyAsync.when(
        data: (pregnancy) {
          if (pregnancy == null) {
            return _buildNotPregnantState();
          }
          return _buildContent(pregnancy);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(currentPregnancyProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: pregnancyAsync.value != null ? _buildFAB() : null,
    );
  }

  Widget _buildContent(PregnancyEntity pregnancy) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentPregnancyProvider);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pregnancy Overview Card
            _buildPregnancyOverview(pregnancy),
            const SizedBox(height: 24),

            // Week by Week Progress
            _buildWeekProgress(pregnancy),
            const SizedBox(height: 24),

            // ANC Visits Section
            const Text('ANC Visit Schedule', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildANCVisits(pregnancy),
            const SizedBox(height: 24),

            // Health Tips
            const Text('Pregnancy Tips', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildPregnancyTips(pregnancy),
            const SizedBox(height: 24),

            // Important Contacts
            const Text('Important Contacts', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildImportantContacts(pregnancy),
          ],
        ),
      ),
    );
  }

  Widget _buildNotPregnantState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: EmptyState(
          icon: Icons.pregnant_woman,
          title: 'Not Currently Pregnant',
          subtitle: 'Mark yourself as pregnant to start tracking your journey',
          actionLabel: 'Mark as Pregnant',
          onAction: _showMarkPregnantDialog,
          iconColor: AppColors.primaryPink,
        ),
      ),
    );
  }

  Widget _buildPregnancyOverview(PregnancyEntity pregnancy) {
    // FIXED: using expectedDelivery instead of expectedDeliveryDate
    return PregnancyCard(
      expectedDeliveryDate: pregnancy.expectedDelivery,
      onTap: () => _showEditDeliveryDate(pregnancy),
    );
  }

  Widget _buildWeekProgress(PregnancyEntity pregnancy) {
    final totalDays = 280; // 40 weeks
    // FIXED: using expectedDelivery
    final daysRemaining =
        pregnancy.expectedDelivery.difference(DateTime.now()).inDays;
    final daysPassed = totalDays - daysRemaining;
    final weeksPassed = (daysPassed / 7).floor();
    final progress = daysPassed / totalDays;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pregnancy Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Week ${weeksPassed.clamp(0, 42)}',
                    style: const TextStyle(
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: AppColors.primaryPinkLight.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPink,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You are in your ${_getTrimester(weeksPassed)} trimester',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (pregnancy.notes != null && pregnancy.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                pregnancy.notes!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildANCVisits(PregnancyEntity pregnancy) {
    // For now, show mock visits until we implement appointments
    final ancVisits = _getMockANCVisits();

    return Column(
      children: [
        ...ancVisits.map((visit) => _buildANCVisitCard(visit)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _showScheduleANCDialog,
          icon: const Icon(Icons.add),
          label: const Text('Schedule ANC Visit'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryPink,
            side: const BorderSide(color: AppColors.primaryPink),
          ),
        ),
      ],
    );
  }

  Widget _buildANCVisitCard(Map<String, dynamic> visit) {
    final isCompleted = visit['completed'] as bool;
    final date = DateTime.parse(visit['date'] as String);
    final isPast = date.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.success.withOpacity(0.1)
                : isPast
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isCompleted
                ? Icons.check_circle
                : isPast
                    ? Icons.warning
                    : Icons.calendar_today,
            color: isCompleted
                ? AppColors.success
                : isPast
                    ? AppColors.error
                    : AppColors.info,
          ),
        ),
        title: Text(visit['title'] as String),
        subtitle: Text(
          '${_formatDate(date)}${isCompleted ? ' • Completed' : isPast ? ' • Missed' : ''}',
        ),
        trailing: isCompleted
            ? null
            : IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showVisitOptions(visit),
              ),
        onTap: () => _showVisitDetails(visit),
      ),
    );
  }

  Widget _buildPregnancyTips(PregnancyEntity pregnancy) {
    final tips = _getPregnancyTips(pregnancy);

    return Column(
      children: tips.map((tip) => _buildTipCard(tip)).toList(),
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (tip['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                tip['icon'] as IconData,
                color: tip['color'] as Color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip['description'] as String,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantContacts(PregnancyEntity pregnancy) {
    final currentUser = ref.watch(currentUserProvider).value;
    final clinicName = currentUser?.preferredClinic ?? 'Your Clinic';

    return Column(
      children: [
        _buildContactCard(
          icon: Icons.local_hospital,
          title: clinicName,
          subtitle: 'Preferred health facility',
          onTap: () => _showComingSoon('View clinic details'),
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.phone,
          title: 'Emergency Hotline',
          subtitle: '999 / 112',
          onTap: _callEmergency,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryPink),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _showScheduleANCDialog,
      icon: const Icon(Icons.calendar_today),
      label: const Text('Book Visit'),
      backgroundColor: AppColors.primaryPink,
    );
  }

  // Helper Methods
  String _getTrimester(int weeks) {
    if (weeks <= 13) return 'first';
    if (weeks <= 26) return 'second';
    return 'third';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  List<Map<String, dynamic>> _getMockANCVisits() {
    return [
      {
        'title': 'First ANC Visit',
        'date':
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'completed': true,
      },
      {
        'title': 'Second ANC Visit',
        'date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'completed': false,
      },
      {
        'title': 'Third ANC Visit',
        'date': DateTime.now().add(const Duration(days: 45)).toIso8601String(),
        'completed': false,
      },
    ];
  }

  List<Map<String, dynamic>> _getPregnancyTips(PregnancyEntity pregnancy) {
    return [
      {
        'icon': Icons.restaurant,
        'color': AppColors.accentOrange,
        'title': 'Healthy Nutrition',
        'description':
            'Eat a balanced diet rich in iron, calcium, and folic acid.',
      },
      {
        'icon': Icons.water_drop,
        'color': AppColors.accentBlue,
        'title': 'Stay Hydrated',
        'description': 'Drink at least 8-10 glasses of water daily.',
      },
      {
        'icon': Icons.bedtime,
        'color': AppColors.accentGreen,
        'title': 'Rest Well',
        'description':
            'Get 7-9 hours of sleep and take rest breaks during the day.',
      },
    ];
  }

  void _showPregnancyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pregnancy Tracking'),
        content: const Text(
          'Track your pregnancy journey, schedule ANC visits, and get personalized health tips.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showMarkPregnantDialog() {
    DateTime? selectedDate;
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Mark as Pregnant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('When is your expected delivery date?'),
              const SizedBox(height: 16),
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
            ],
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
                              motherId: ref.read(currentUserProvider).value!.id,
                              expectedDelivery: selectedDate!,
                            );

                        if (mounted) {
                          Navigator.pop(context);
                          ref.invalidate(currentPregnancyProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Pregnancy record created successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDeliveryDate(PregnancyEntity pregnancy) {
  DateTime? selectedDate = pregnancy.expectedDelivery;
  final dateController =
      TextEditingController(text: _formatDate(selectedDate));

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Update Delivery Date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select new expected delivery date:'),
            const SizedBox(height: 16),
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Create updated pregnancy entity
                final updatedPregnancy = PregnancyEntity(
                  id: pregnancy.id,
                  motherId: pregnancy.motherId,
                  pregnancyNumber: pregnancy.pregnancyNumber,
                  startDate: pregnancy.startDate,
                  expectedDelivery: selectedDate!,
                  actualDelivery: pregnancy.actualDelivery,
                  lmp: pregnancy.lmp,
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

                // Update pregnancy record with the entity
                await ref.read(pregnancyServiceProvider).updatePregnancy(
                      pregnancy.id,
                      updatedPregnancy,
                    );

                if (mounted) {
                  Navigator.pop(context);
                  ref.invalidate(currentPregnancyProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delivery date updated successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
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

  void _showScheduleANCDialog() {
    _showComingSoon('Schedule ANC visit - Coming soon!');
  }

  void _showVisitOptions(Map<String, dynamic> visit) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Mark as Completed'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Mark visit as completed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Reschedule'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Reschedule visit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Cancel Visit'),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Cancel visit');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVisitDetails(Map<String, dynamic> visit) {
    _showComingSoon('Visit details');
  }

  void _callEmergency() {
    _showComingSoon('Calling emergency hotline - Feature coming soon');
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
