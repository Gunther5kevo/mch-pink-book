/// Nurse Appointment Card Widget
/// Displays appointment with status, actions, and reminder info
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/appointment_entity.dart';

class NurseAppointmentCard extends ConsumerWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAttendance;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const NurseAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onMarkAttendance,
    this.onReschedule,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusInfo = _getStatusInfo();
    final typeInfo = _getTypeInfo();

    // Fetch patient name once per card
    final patientNameAsync = ref.watch(_patientNameProvider(appointment.userId));

    return Card(
      elevation: appointment.isToday ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.circular(AppBorderRadius.lg),
        side: appointment.isToday
            ? BorderSide(color: AppColors.primaryPink, width: 2.5)
            : BorderSide(color: AppColors.divider, width: 1),
      ),
      child: InkWell(
        borderRadius: AppBorderRadius.circular(AppBorderRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status + Time
              Row(
                children: [
                  _buildStatusBadge(statusInfo),
                  const Spacer(),
                  _buildTimeDisplay(),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Patient + Type
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: typeInfo.color.withOpacity(0.15),
                    child: Icon(typeInfo.icon, color: typeInfo.color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Patient Name (or ID fallback)
                        patientNameAsync.when(
                          data: (name) => Text(
                            name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          loading: () => Text(
                            'Loading...',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                          error: (_, __) => Text(
                            'Patient: ${appointment.userId.substring(0, 8)}...',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(typeInfo.icon, size: 14, color: typeInfo.color),
                            const SizedBox(width: 4),
                            Text(
                              typeInfo.label,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '• ${appointment.durationMinutes} min',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Date (if not today)
              if (!appointment.isToday) ...[
                const SizedBox(height: AppSpacing.md),
                _buildDateChip(),
              ],

              // Notes
              if (appointment.notes?.isNotEmpty == true) ...[
                const SizedBox(height: AppSpacing.md),
                _buildNotesBox(),
              ],

              // Cancellation Reason
              if (appointment.status == AppointmentStatus.cancelled &&
                  appointment.cancellationReason?.isNotEmpty == true) ...[
                const SizedBox(height: AppSpacing.md),
                _buildCancellationBox(),
              ],

              // Reminder Status
              if (appointment.status == AppointmentStatus.scheduled) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildReminderStatus(),
              ],

              // Action Buttons
              if (appointment.status == AppointmentStatus.scheduled) ...[
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.sm),
                _buildActionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // UI Helpers (unchanged from your original)
  // -----------------------------------------------------------------
  Widget _buildStatusBadge(_StatusInfo info) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: info.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: info.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.icon, size: 13, color: info.color),
          const SizedBox(width: 4),
          Text(
            info.label,
            style: AppTextStyles.caption.copyWith(
              color: info.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 15, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          appointment.formattedTime,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDateChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 13, color: AppColors.textLight),
          const SizedBox(width: 4),
          Text(
            appointment.relativeTimeDisplay,
            style: AppTextStyles.caption.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryPinkLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryPinkLight),
      ),
      child: Row(
        children: [
          Icon(Icons.note, size: 15, color: AppColors.primaryPinkDark),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              appointment.notes!,
              style: AppTextStyles.caption.copyWith(color: AppColors.textDark),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel, size: 15, color: AppColors.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Cancelled: ${appointment.cancellationReason}',
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderStatus() {
    final push = appointment.reminderSent;
    final sms = appointment.smsSent;

    if (!push && !sms) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notification_important, size: 12, color: AppColors.warning),
            const SizedBox(width: 3),
            Text(
              'Reminder pending',
              style: AppTextStyles.caption.copyWith(color: AppColors.warning),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        if (push)
          _buildReminderChip(Icons.notifications_active, AppColors.success, 'Push sent'),
        if (sms)
          _buildReminderChip(Icons.sms, AppColors.accentBlue, 'SMS sent'),
      ],
    );
  }

  Widget _buildReminderChip(IconData icon, Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 2),
          Text(label, style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (appointment.isToday)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onMarkAttendance,
              icon: const Icon(Icons.check_circle, size: 16),
              label: const Text('Mark Done'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.success,
                side: BorderSide(color: AppColors.success),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        if (appointment.isToday) const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReschedule,
            icon: const Icon(Icons.calendar_today, size: 16),
            label: const Text('Reschedule'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentBlue,
              side: BorderSide(color: AppColors.accentBlue),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onCancel,
          icon: const Icon(Icons.cancel_outlined),
          color: AppColors.error,
          tooltip: 'Cancel Appointment',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.error.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  _StatusInfo _getStatusInfo() {
    if (appointment.status == AppointmentStatus.scheduled && appointment.isOverdue) {
      return _StatusInfo('Overdue', AppColors.warning, Icons.warning_amber);
    }

    return switch (appointment.status) {
      AppointmentStatus.scheduled => _StatusInfo('Scheduled', AppColors.info, Icons.schedule),
      AppointmentStatus.completed => _StatusInfo('Completed', AppColors.success, Icons.check_circle),
      AppointmentStatus.missed => _StatusInfo('Missed', AppColors.error, Icons.person_off),
      AppointmentStatus.cancelled => _StatusInfo('Cancelled', AppColors.textLight, Icons.cancel),
      AppointmentStatus.rescheduled => _StatusInfo('Rescheduled', AppColors.accentOrange, Icons.event_repeat),
    };
  }

  _TypeInfo _getTypeInfo() {
    return switch (appointment.type) {
      VisitType.anc => _TypeInfo('ANC Visit', AppColors.primaryPink, Icons.pregnant_woman),
      VisitType.delivery => _TypeInfo('Delivery', Colors.purple, Icons.local_hospital),
      VisitType.postnatal => _TypeInfo('Postnatal', AppColors.accentBlue, Icons.child_care),
      VisitType.immunization => _TypeInfo('Immunization', AppColors.accentGreen, Icons.vaccines),
      VisitType.growth_monitoring => _TypeInfo('Growth Check', AppColors.accentOrange, Icons.show_chart),
      VisitType.general => _TypeInfo('General Visit', AppColors.textLight, Icons.healing),
    };
  }
}

// -----------------------------------------------------------------
// Private Provider: Patient Name
// -----------------------------------------------------------------
final _patientNameProvider = FutureProvider.family<String, String>((ref, userId) async {
  try {
    final response = await Supabase.instance.client
        .from('users')
        .select('name')
        .eq('id', userId)
        .maybeSingle();

    return response?['name'] as String? ?? 'Unknown Patient';
  } catch (e) {
    return 'Patient: ${userId.substring(0, 8)}...';
  }
});

class _StatusInfo {
  final String label;
  final Color color;
  final IconData icon;
  _StatusInfo(this.label, this.color, this.icon);
}

class _TypeInfo {
  final String label;
  final Color color;
  final IconData icon;
  _TypeInfo(this.label, this.color, this.icon);
}