library;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../core/constants/app_constants.dart';

/// Supabase-backed appointments repository (SDK-compatible, avoids builder type issues)
class AppointmentsRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final _uuid = const Uuid();

  /// Optional clinic id (pass real clinic UUID from auth/provider)
  final String? currentClinicId;

  AppointmentsRepository({this.currentClinicId});

  // -----------------------------------------------------------------------
  //  READ
  // -----------------------------------------------------------------------

  Future<List<AppointmentEntity>> getClinicAppointments() async {
    try {
      final response = await _client.from('appointments').select();

      final List<dynamic> raw = response as List<dynamic>;
      final all = raw
          .map((e) => AppointmentEntity.fromJson(e as Map<String, dynamic>))
          .toList();

      final filtered = (currentClinicId == null || !_isValidUuid(currentClinicId!))
          ? all
          : all.where((a) => a.clinicId == currentClinicId || a.clinicId == null).toList();

      filtered.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      return filtered;
    } on PostgrestException catch (e) {
      _logPostgrestError('getClinicAppointments', e);
      throw _handlePostgrestError(e);
    } catch (e) {
      print('❌ Unexpected error in getClinicAppointments: $e');
      throw Exception('Failed to load clinic appointments: $e');
    }
  }

  Future<AppointmentEntity> getAppointmentById(String id) async {
    try {
      final response = await _client.from('appointments').select();
      final List<dynamic> raw = response as List<dynamic>;
      final all = raw
          .map((e) => AppointmentEntity.fromJson(e as Map<String, dynamic>))
          .toList();

      final appointment = all.firstWhere((a) => a.id == id,
          orElse: () => throw Exception('Appointment not found'));
      return appointment;
    } on PostgrestException catch (e) {
      _logPostgrestError('getAppointmentById', e);
      throw _handlePostgrestError(e);
    }
  }

  Future<List<AppointmentEntity>> getPatientAppointments(String userId) async {
    try {
      final response = await _client.from('appointments').select();
      final List<dynamic> raw = response as List<dynamic>;
      final all = raw
          .map((e) => AppointmentEntity.fromJson(e as Map<String, dynamic>))
          .toList();

      final filtered = all.where((a) => a.userId == userId).toList();
      filtered.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      return filtered;
    } on PostgrestException catch (e) {
      _logPostgrestError('getPatientAppointments', e);
      throw _handlePostgrestError(e);
    } catch (e) {
      print('❌ Unexpected error in getPatientAppointments: $e');
      throw Exception('Failed to load patient appointments: $e');
    }
  }

  // -----------------------------------------------------------------------
  //  UPDATE
  // -----------------------------------------------------------------------

  Future<void> updateAppointmentStatus(String id, AppointmentStatus status) async {
    try {
      await _client.from('appointments').update({
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      _logPostgrestError('updateAppointmentStatus', e);
      throw _handlePostgrestError(e);
    }
  }

  Future<void> cancelAppointment(String id, String reason) async {
    try {
      await _client.from('appointments').update({
        'status': AppointmentStatus.cancelled.name,
        'cancellation_reason': reason,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      _logPostgrestError('cancelAppointment', e);
      throw _handlePostgrestError(e);
    }
  }

  Future<void> rescheduleAppointment(String id, DateTime newDateTime) async {
    try {
      await _client.from('appointments').update({
        'scheduled_at': newDateTime.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      _logPostgrestError('rescheduleAppointment', e);
      throw _handlePostgrestError(e);
    }
  }

  // -----------------------------------------------------------------------
  //  CREATE
  // -----------------------------------------------------------------------

  Future<AppointmentEntity> createAppointment({
    required String userId,
    String? childId,
    String? pregnancyId,
    required VisitType type,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? clinicId,
    String? providerId,
    String? notes,
    String notificationType = 'both',
  }) async {
    try {
      final now = DateTime.now();
      final id = _uuid.v4();

      final payload = {
        'id': id,
        'user_id': userId,
        if (childId != null && _isValidUuid(childId)) 'child_id': childId,
        if (pregnancyId != null && _isValidUuid(pregnancyId))
          'pregnancy_id': pregnancyId,
        'type': type.name,
        'scheduled_at': scheduledAt.toIso8601String(),
        'duration_minutes': durationMinutes,
        if (clinicId != null && _isValidUuid(clinicId))
          'clinic_id': clinicId
        else if (currentClinicId != null && _isValidUuid(currentClinicId!))
          'clinic_id': currentClinicId,
        if (providerId != null && _isValidUuid(providerId))
          'provider_id': providerId,
        'status': AppointmentStatus.scheduled.name,
        'reminder_sent': false,
        'sms_sent': false,
        'notification_type': notificationType,
        'notes': notes,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      print('🟢 Creating appointment with payload: $payload');

      final response =
          await _client.from('appointments').insert(payload).select().single();

      print('✅ Appointment created: $response');
      return AppointmentEntity.fromJson(response);
    } on PostgrestException catch (e) {
      _logPostgrestError('createAppointment', e);
      throw _handlePostgrestError(e);
    } catch (e) {
      print('❌ Unexpected error in createAppointment: $e');
      throw Exception('Failed to create appointment: $e');
    }
  }

  // -----------------------------------------------------------------------
  //  NOTIFICATIONS
  // -----------------------------------------------------------------------

  Future<void> sendReminder(String id) async {
    try {
      await _client.from('appointments').update({
        'reminder_sent': true,
        'reminder_sent_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      _logPostgrestError('sendReminder', e);
      throw _handlePostgrestError(e);
    }
  }

  Future<void> markSmsSent(String id) async {
    try {
      await _client.from('appointments').update({
        'sms_sent': true,
        'sms_sent_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } on PostgrestException catch (e) {
      _logPostgrestError('markSmsSent', e);
      throw _handlePostgrestError(e);
    }
  }

  // -----------------------------------------------------------------------
  //  HELPERS
  // -----------------------------------------------------------------------

  bool _isValidUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }

  /// Centralized error printer for debug
  void _logPostgrestError(String context, PostgrestException e) {
    print('🚨 Supabase Error in $context');
    print('Message: ${e.message}');
    print('Code: ${e.code}');
    print('Details: ${e.details}');
    print('Hint: ${e.hint}');
  }

  Exception _handlePostgrestError(PostgrestException e) {
    if (e.code == '22P02') {
      return Exception('Invalid UUID format. Check clinic_id, user_id, etc.');
    }
    if (e.code == '23503') {
      final hint = e.details ?? 'Missing related record (user, clinic, or provider)';
      return Exception('Foreign key violation: $hint');
    }
    return Exception('Database error: ${e.message}');
  }
}
