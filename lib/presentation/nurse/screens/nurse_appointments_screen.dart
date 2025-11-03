/// Nurse Appointments Screen
/// View and manage all appointments
library;

import 'dart:core'; // Required for DateTime extension

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../widgets/nurse_appointment_card.dart';
import '../widgets/nurse_appointment_filters.dart';
import '../../providers/appointments_provider.dart';
import 'create_appointment_screen.dart';

enum AppointmentFilterType { today, upcoming, completed, cancelled, all }

class NurseAppointmentsScreen extends ConsumerStatefulWidget {
  final AppointmentFilterType? initialFilter;

  const NurseAppointmentsScreen({
    super.key,
    this.initialFilter,
  });

  @override
  ConsumerState<NurseAppointmentsScreen> createState() =>
      _NurseAppointmentsScreenState();
}

class _NurseAppointmentsScreenState
    extends ConsumerState<NurseAppointmentsScreen> {
  late AppointmentFilterType _currentFilter;
  String _searchQuery = '';
  final TextEditingController _cancellationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter ?? AppointmentFilterType.today;
  }

  @override
  void dispose() {
    _cancellationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(nurseAppointmentsProvider);
    final actions = ref.read(appointmentActionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _showCalendarView,
            tooltip: 'Calendar View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(nurseAppointmentsProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by patient ID or notes...',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textLight),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: AppBorderRadius.circular(AppBorderRadius.lg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              style: AppTextStyles.bodyMedium,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Filter Chips
          NurseAppointmentFilters(
            currentFilter: _currentFilter,
            onFilterChanged: (filter) =>
                setState(() => _currentFilter = filter),
          ),

          // Appointments List
          Expanded(
            child: appointmentsAsync.when(
              data: (appointments) {
                final filtered = _filterAppointments(appointments);
                if (filtered.isEmpty) return _buildEmptyState(actions);

                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(nurseAppointmentsProvider),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final appointment = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: NurseAppointmentCard(
                          appointment: appointment,
                          onTap: () => _viewAppointmentDetails(appointment),
                          onMarkAttendance: () =>
                              _markAttendance(appointment, actions),
                          onReschedule: () =>
                              _rescheduleAppointment(appointment, actions),
                          onCancel: () =>
                              _cancelAppointment(appointment, actions),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              ),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewAppointment(actions),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('New Appointment', style: AppTextStyles.button),
      ),
    );
  }

  List<AppointmentEntity> _filterAppointments(
      List<AppointmentEntity> appointments) {
    var filtered = appointments;

    filtered = switch (_currentFilter) {
      AppointmentFilterType.today => filtered.where((a) => a.isToday).toList(),
      AppointmentFilterType.upcoming =>
        filtered.where((a) => a.isUpcoming).toList(),
      AppointmentFilterType.completed =>
        filtered.where((a) => a.status == AppointmentStatus.completed).toList(),
      AppointmentFilterType.cancelled =>
        filtered.where((a) => a.status == AppointmentStatus.cancelled).toList(),
      AppointmentFilterType.all => filtered,
    };

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((a) {
        return a.id.toLowerCase().contains(query) ||
            (a.notes?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    filtered.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return filtered;
  }

  Widget _buildEmptyState(AppointmentActions actions) {
    final (message, icon) = switch (_currentFilter) {
      AppointmentFilterType.today => (
          'No appointments today',
          Icons.event_available
        ),
      AppointmentFilterType.upcoming => (
          'No upcoming appointments',
          Icons.event_note
        ),
      AppointmentFilterType.completed => (
          'No completed appointments',
          Icons.check_circle_outline
        ),
      AppointmentFilterType.cancelled => (
          'No cancelled appointments',
          Icons.cancel_outlined
        ),
      AppointmentFilterType.all => ('No appointments found', Icons.event_busy),
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: AppColors.textLight),
          const SizedBox(height: AppSpacing.lg),
          Text(message,
              style: AppTextStyles.h3.copyWith(color: AppColors.textLight)),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: () => _createNewAppointment(actions),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPink,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text('Create Appointment',
                style: AppTextStyles.button.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load appointments',
                style: AppTextStyles.h3.copyWith(color: AppColors.error)),
            const SizedBox(height: AppSpacing.sm),
            Text(error.toString(),
                style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(nurseAppointmentsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendarView() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Calendar view coming soon!'),
        backgroundColor: AppColors.primaryPinkDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewAppointmentDetails(AppointmentEntity appointment) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Appointment Details', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('ID', appointment.id),
            _detailRow('Type', appointment.type.displayName),
            _detailRow('Time', appointment.scheduledAt.formattedDateTime), // Fixed
            _detailRow('Status', appointment.status.displayName,
                color: appointment.status.color),
            if (appointment.notes != null)
              _detailRow('Notes', appointment.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  void _markAttendance(
      AppointmentEntity appointment, AppointmentActions actions) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Mark Attendance', style: AppTextStyles.h3),
        content: const Text('Mark this appointment as completed?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performAction(
                () => actions.markCompleted(appointment.id),
                'Appointment completed!',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _rescheduleAppointment(
      AppointmentEntity appointment, AppointmentActions actions) {
    DateTime? newDateTime;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reschedule Appointment', style: AppTextStyles.h3),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current: ${appointment.scheduledAt.formattedDateTime}',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  newDateTime == null
                      ? 'Pick New Time'
                      : newDateTime!.formattedDateTime,
                  style: AppTextStyles.bodyMedium,
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: appointment.scheduledAt,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null) return;

                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(appointment.scheduledAt),
                  );
                  if (time == null) return;

                  setStateDialog(() {
                    newDateTime = DateTime(date.year, date.month, date.day,
                        time.hour, time.minute);
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: newDateTime == null
                ? null
                : () async {
                    Navigator.pop(context);
                    await _performAction(
                      () => actions.rescheduleAppointment(
                          appointment.id, newDateTime!),
                      'Appointment rescheduled!',
                    );
                  },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(
      AppointmentEntity appointment, AppointmentActions actions) {
    _cancellationController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Appointment', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This action cannot be undone.'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _cancellationController,
              decoration: InputDecoration(
                labelText: 'Reason (required)',
                border: const OutlineInputBorder(),
                errorText:
                    _cancellationController.text.isEmpty ? 'Required' : null,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back')),
          ElevatedButton(
            onPressed: () async {
              final reason = _cancellationController.text.trim();
              if (reason.isEmpty) return;

              Navigator.pop(context);
              await _performAction(
                () => actions.cancelAppointment(appointment.id, reason),
                'Appointment cancelled',
                backgroundColor: AppColors.error,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }

  Future<void> _performAction(
      Future<void> Function() action, String successMessage,
      {Color? backgroundColor}) async {
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: backgroundColor ?? AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _createNewAppointment(AppointmentActions actions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAppointmentScreen(),
      ),
    );
  }
}


extension DateTimeX on DateTime {
  String get formattedDateTime {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$day/$month/$year at $hour:$minute';
  }
}