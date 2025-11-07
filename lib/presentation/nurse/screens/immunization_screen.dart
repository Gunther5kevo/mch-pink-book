// lib/presentation/screens/immunization_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/domain/entities/immunization_entity.dart';
import 'package:mch_pink_book/presentation/providers/child_provider.dart';
import 'package:mch_pink_book/presentation/providers/clinic_provider.dart';
import '../../providers/immunization_providers.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/loading_shimmer.dart';

class ImmunizationScreen extends ConsumerWidget {
  final String childId;
  const ImmunizationScreen({required this.childId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childProvider(childId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        title: const Text('Immunization Card'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showComingSoon(context, 'Share Card'),
          ),
        ],
      ),
      body: childAsync.when(
        data: (child) {
          if (child == null) {
            return const Center(child: Text('Child not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === CHILD HEADER CARD ===
                _ChildHeaderCard(child: child),

                const SizedBox(height: AppSpacing.md),

                // === IMMUNIZATION LIST ===
                _ImmunizationList(childId: childId),
              ],
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: LoadingShimmer(count: 4),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(childProvider(childId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddImmunizationDialog(context, ref, childId),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.vaccines),
        label: Text('Record Dose', style: AppTextStyles.button),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon!'),
        backgroundColor: AppColors.primaryPinkDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Add Immunization Dialog (Modern + Nurse-Friendly)
  // -----------------------------------------------------------------------
  void _showAddImmunizationDialog(BuildContext context, WidgetRef ref, String childId) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final batchCtrl = TextEditingController();
    final siteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.vaccines, color: AppColors.primaryPink, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Record New Dose', style: AppTextStyles.h3),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                _buildTextField(
                  controller: codeCtrl,
                  label: 'Vaccine Code',
                  hint: 'e.g. BCG, OPV-0',
                  isRequired: true,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: nameCtrl,
                  label: 'Vaccine Name',
                  hint: 'e.g. Bacille Calmette-Guérin',
                  isRequired: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: batchCtrl,
                  label: 'Batch Number (Optional)',
                  hint: 'e.g. LOT-2025-01',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: siteCtrl,
                  label: 'Site (Optional)',
                  hint: 'e.g. Left Thigh',
                  textCapitalization: TextCapitalization.words,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final userAsync = ref.read(currentUserProvider);
                final clinicAsync = ref.read(currentClinicProvider);

                final userId = userAsync.when(data: (u) => u?.id, loading: () => null, error: (_, __) => null);
                final clinicId = clinicAsync.when(data: (c) => c?.id, loading: () => null, error: (_, __) => null);

                if (userId == null || clinicId == null) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('User or clinic not loaded.')),
                    );
                  }
                  return;
                }

                final immunization = ImmunizationEntity(
                  id: '',
                  childId: childId,
                  vaccineCode: codeCtrl.text.trim(),
                  vaccineName: nameCtrl.text.trim(),
                  administeredDate: DateTime.now(),
                  batchNumber: batchCtrl.text.trim().isEmpty ? null : batchCtrl.text.trim(),
                  site: siteCtrl.text.trim().isEmpty ? null : siteCtrl.text.trim(),
                  administeredBy: userId,
                  clinicId: clinicId,
                  version: 1,
                  lastUpdatedAt: DateTime.now(),
                  createdAt: DateTime.now(),
                );

                await ref.read(immunizationNotifierProvider.notifier).addImmunization(immunization);

                codeCtrl.clear();
                nameCtrl.clear();
                batchCtrl.clear();
                siteCtrl.clear();

                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save Dose'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: isRequired
          ? (v) => v?.trim().isEmpty ?? true ? 'Required' : null
          : null,
    );
  }
}

// ===========================================================================
// CHILD HEADER CARD (Modern + Visual)
// ===========================================================================
class _ChildHeaderCard extends StatelessWidget {
  final dynamic child; // Replace with actual ChildEntity
  const _ChildHeaderCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryPink.withOpacity(0.15), AppColors.primaryPink.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryPink.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryPink.withOpacity(0.2),
            child: Text(
              child.fullName.isNotEmpty ? child.fullName[0].toUpperCase() : '?',
              style: AppTextStyles.h2.copyWith(color: AppColors.primaryPink),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.fullName,
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'DOB: ${child.dateOfBirth.toLocal().toString().split(' ')[0]}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMedium),
                ),
                const SizedBox(height: 4),
                _StatusChip(
                  label: 'Up to date',
                  color: AppColors.accentGreen,
                  icon: Icons.check_circle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// STATUS CHIP (Reusable)
// ===========================================================================
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ===========================================================================
// IMMUNIZATION LIST (Async + Shimmer)
// ===========================================================================
class _ImmunizationList extends ConsumerWidget {
  final String childId;
  const _ImmunizationList({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immunizationsAsync = ref.watch(immunizationsProvider(childId));

    return immunizationsAsync.when(
      data: (immunizations) {
        final given = immunizations
            .where((i) => i.administeredDate.isBefore(DateTime.now()))
            .toList();
        final upcoming = immunizations
            .where((i) => i.scheduledDate != null && i.scheduledDate!.isAfter(DateTime.now()))
            .toList();

        if (given.isEmpty && upcoming.isEmpty) {
          return _EmptyState();
        }

        return Column(
          children: [
            _SectionHeader(title: 'Given Vaccines', icon: Icons.check_circle, color: AppColors.accentGreen),
            ...given.map((i) => ModernImmunizationCard(immunization: i)),
            _SectionHeader(title: 'Upcoming Vaccines', icon: Icons.schedule, color: AppColors.accentOrange),
            ...upcoming.map((i) => ModernImmunizationCard(immunization: i, isUpcoming: true)),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LoadingShimmer(count: 5),
      ),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Failed to load', style: AppTextStyles.bodyMedium),
            Text('$e', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(immunizationsProvider(childId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION HEADER (With Icon & Color)
// ===========================================================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

// ===========================================================================
// EMPTY STATE
// ===========================================================================
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.vaccines, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              'No doses recorded yet',
              style: AppTextStyles.h4.copyWith(color: AppColors.textMedium),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to record the first immunization',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMedium),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// MODERN IMMUNIZATION CARD (Beautiful + Scannable)
// ===========================================================================
class ModernImmunizationCard extends StatelessWidget {
  final ImmunizationEntity immunization;
  final bool isUpcoming;

  const ModernImmunizationCard({
    required this.immunization,
    this.isUpcoming = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final date = isUpcoming ? immunization.scheduledDate : immunization.administeredDate;
    final statusColor = isUpcoming ? AppColors.accentOrange : AppColors.accentGreen;
    final statusIcon = isUpcoming ? Icons.schedule : Icons.check_circle;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: statusColor.withOpacity(0.15),
          child: Icon(statusIcon, color: statusColor, size: 22),
        ),
        title: Row(
          children: [
            Text(
              immunization.vaccineCode,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            _StatusChip(
              label: isUpcoming ? 'Scheduled' : 'Given',
              color: statusColor,
              icon: statusIcon,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              immunization.vaccineName,
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${isUpcoming ? "Due" : "On"}: ${date?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 13),
            ),
            if (immunization.batchNumber != null || immunization.site != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    if (immunization.batchNumber != null)
                      _InfoTag(label: 'Batch: ${immunization.batchNumber}', icon: Icons.qr_code),
                    if (immunization.site != null)
                      _InfoTag(label: immunization.site!, icon: Icons.location_on_outlined),
                  ],
                ),
              ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
      ),
    );
  }
}

// ===========================================================================
// INFO TAG (Small Pill)
// ===========================================================================
class _InfoTag extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoTag({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textMedium),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
        ],
      ),
    );
  }
}