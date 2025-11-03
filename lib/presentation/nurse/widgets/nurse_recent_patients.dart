/// Nurse Recent Patients Widget
/// Shows the 5 most recently completed appointments
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../providers/appointments_provider.dart';

class NurseRecentPatients extends ConsumerWidget {
  const NurseRecentPatients({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(nurseAppointmentsProvider);

    return appointmentsAsync.when(
      data: (appointments) {
        final recent = _getRecentCompleted(appointments);
        if (recent.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'Recent Patients',
                style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: recent.length,
              itemBuilder: (context, index) {
                final appt = recent[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _PatientCard(appointment: appt),
                );
              },
            ),
          ],
        );
      },
      loading: () => const _RecentPatientsSkeleton(),
      error: (err, _) => _buildErrorState(err),
    );
  }

  List<AppointmentEntity> _getRecentCompleted(List<AppointmentEntity> appointments) {
    return appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt)) // newest first
      ..take(5)
          .toList();
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 48, color: AppColors.textLight),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No recent patients',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load recent patients',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error.toString(),
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const _PatientCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final typeInfo = _getTypeInfo();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: typeInfo.color.withOpacity(0.15),
          child: Icon(
            typeInfo.icon,
            color: typeInfo.color,
            size: 20,
          ),
        ),
        title: Text(
          _getPatientName(),
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${appointment.userId} • ${typeInfo.label}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
            Text(
              _formatLastVisit(),
              style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.textLight,
          size: 20,
        ),
        onTap: () {
          // TODO: Navigate to patient profile
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('View patient profile - Coming soon!'),
              backgroundColor: AppColors.primaryPinkDark,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  String _getPatientName() {
    // TODO: Replace with real patient name from patient repository
    return appointment.userId.split('_').last.split('@').first;
  }

  String _formatLastVisit() {
    final now = DateTime.now();
    final date = appointment.scheduledAt;
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) {
      final time = appointment.formattedTime;
      return 'Today, $time';
    }

    final diff = now.difference(date).inDays;
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';

    return appointment.formattedDate;
  }

  _TypeInfo _getTypeInfo() {
    return switch (appointment.type) {
      VisitType.anc => _TypeInfo('ANC Visit', AppColors.primaryPink, Icons.pregnant_woman),
      VisitType.delivery => _TypeInfo('Delivery', Colors.purple, Icons.local_hospital),
      VisitType.postnatal => _TypeInfo('Postnatal', AppColors.accentBlue, Icons.child_care),
      VisitType.immunization => _TypeInfo('Immunization', AppColors.accentGreen, Icons.vaccines),
      VisitType.growthMonitoring => _TypeInfo('Growth Check', AppColors.accentOrange, Icons.show_chart),
      VisitType.general => _TypeInfo('General Visit', AppColors.textLight, Icons.healing),
    };
  }
}

class _TypeInfo {
  final String label;
  final Color color;
  final IconData icon;
  _TypeInfo(this.label, this.color, this.icon);
}

class _RecentPatientsSkeleton extends StatelessWidget {
  const _RecentPatientsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: List.generate(3, (_) => const _SkeletonCard()).toList(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.divider,
          child: Container(),
        ),
        title: Container(
          height: 16,
          color: AppColors.divider,
        ),
        subtitle: Column(
          children: [
            const SizedBox(height: 4),
            Container(height: 12, color: AppColors.divider),
            const SizedBox(height: 4),
            Container(height: 12, width: 100, color: AppColors.divider),
          ],
        ),
      ),
    );
  }
}