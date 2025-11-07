/// lib/presentation/providers/appointments_provider.dart
///
/// Appointments Provider
/// State management for appointments (nurse + mother)
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/providers/providers.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../data/repositories/appointments_repository.dart';
import '../../core/constants/app_constants.dart';

/// ---------------------------------------------------
/// 1. Repository
/// ---------------------------------------------------
final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  // No clinicId passed here – the repo will fetch it from the logged-in user
  // (or you can pass one via AppointmentsRepository(clinicId: …) if you have it in auth)
  return AppointmentsRepository();
});

/// ---------------------------------------------------
/// 2. NURSE-SIDE (unchanged)
/// ---------------------------------------------------
final nurseAppointmentsProvider = FutureProvider<List<AppointmentEntity>>((ref) async {
  final repo = ref.watch(appointmentsRepositoryProvider);
  return repo.getClinicAppointments();
});

final appointmentProvider =
    FutureProvider.family<AppointmentEntity, String>((ref, id) async {
  final repo = ref.watch(appointmentsRepositoryProvider);
  return repo.getAppointmentById(id);
});

final todayAppointmentsCountProvider = FutureProvider<int>((ref) async {
  final list = await ref.watch(nurseAppointmentsProvider.future);
  return list.where((a) => a.isToday).length;
});

final upcomingAppointmentsCountProvider = FutureProvider<int>((ref) async {
  final list = await ref.watch(nurseAppointmentsProvider.future);
  return list.where((a) => a.isUpcoming && !a.isToday).length;
});

/// ---------------------------------------------------
/// 3. MOTHER-SIDE – filtered per-user
/// ---------------------------------------------------

enum MotherAppointmentFilter { upcoming, past, cancelled }

extension _MotherFilterX on MotherAppointmentFilter {
  bool matches(AppointmentEntity a) {
    final now = DateTime.now();
    return switch (this) {
      MotherAppointmentFilter.upcoming =>
        a.status == AppointmentStatus.scheduled && a.scheduledAt.isAfter(now),
      MotherAppointmentFilter.past =>
        a.status == AppointmentStatus.completed ||
        (a.status == AppointmentStatus.scheduled && a.scheduledAt.isBefore(now)),
      MotherAppointmentFilter.cancelled => a.status == AppointmentStatus.cancelled,
    };
  }
}

final motherAppointmentsProvider = FutureProvider.family<
    List<AppointmentEntity>,
    (String, MotherAppointmentFilter)>((ref, params) async {
  final (userId, filter) = params;
  final repo = ref.watch(appointmentsRepositoryProvider);
  final all = await repo.getPatientAppointments(userId);
  return all.where(filter.matches).toList()
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
});

/// Convenience – upcoming appointments for the current mother (used on Home)
final upcomingAppointmentsProvider = Provider<AsyncValue<List<AppointmentEntity>>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) => user == null
        ? const AsyncData([])
        : ref.watch(motherAppointmentsProvider((user.id, MotherAppointmentFilter.upcoming))),
    loading: () => const AsyncLoading(),
    error: (e, s) => AsyncError(e, s),
  );
});

/// ---------------------------------------------------
/// 4. Actions (mutations) – used by nurse only
/// ---------------------------------------------------
final appointmentActionsProvider = Provider<AppointmentActions>((ref) {
  final repo = ref.watch(appointmentsRepositoryProvider);
  return AppointmentActions(repo, ref);
});

class AppointmentActions {
  final AppointmentsRepository _repo;
  final Ref _ref;

  AppointmentActions(this._repo, this._ref);

  Future<void> markCompleted(String id) async {
    await _repo.updateAppointmentStatus(id, AppointmentStatus.completed);
    _invalidateAll();
  }

  Future<void> markMissed(String id) async {
    await _repo.updateAppointmentStatus(id, AppointmentStatus.missed);
    _invalidateAll();
  }

  Future<void> cancelAppointment(String id, String reason) async {
    await _repo.cancelAppointment(id, reason);
    _invalidateAll();
  }

  Future<void> rescheduleAppointment(String id, DateTime newDateTime) async {
    await _repo.rescheduleAppointment(id, newDateTime);
    _invalidateAll();
  }

  /// **NOTE:** `clinicId` is **no longer required** – the repo resolves it.
  Future<AppointmentEntity> createAppointment({
    required String userId,
    String? childId,
    String? pregnancyId,
    required VisitType type,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? providerId,
    String? notes,
    String notificationType = 'both',
  }) async {
    final appointment = await _repo.createAppointment(
      userId: userId,
      childId: childId,
      pregnancyId: pregnancyId,
      type: type,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      // clinicId: omitted – repo fetches it from the nurse's user row
      providerId: providerId,
      notes: notes,
      notificationType: notificationType,
    );
    _invalidateAll();
    return appointment;
  }

  Future<void> sendReminder(String id) async {
    await _repo.sendReminder(id);
    _ref.invalidate(appointmentProvider(id));
  }

  Future<void> markSmsSent(String id) async {
    await _repo.markSmsSent(id);
    _ref.invalidate(appointmentProvider(id));
  }

  // -------------------------------------------------
  // Invalidate every list that could be affected
  // -------------------------------------------------
  void _invalidateAll() {
    _ref
      ..invalidate(nurseAppointmentsProvider)
      ..invalidate(todayAppointmentsCountProvider)
      ..invalidate(upcomingAppointmentsCountProvider)
      ..invalidate(motherAppointmentsProvider)
      ..invalidate(upcomingAppointmentsProvider);
  }
}