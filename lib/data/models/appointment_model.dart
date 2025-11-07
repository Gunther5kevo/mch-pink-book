/// Appointment Model (Data Layer)
/// Handles JSON serialization/deserialization
library;

import '../../domain/entities/appointment_entity.dart';
import '../../core/constants/app_constants.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String? childId;
  final String? pregnancyId;
  final String type;
  final String scheduledAt;
  final int durationMinutes;
  final String? clinicId;
  final String? providerId;
  final String status;
  final bool reminderSent;
  final String? reminderSentAt;
  final bool smsSent;
  final String? smsSentAt;
  final String notificationType;
  final String? notes;
  final String? cancellationReason;
  final String createdAt;
  final String updatedAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    this.childId,
    this.pregnancyId,
    required this.type,
    required this.scheduledAt,
    required this.durationMinutes,
    this.clinicId,
    this.providerId,
    required this.status,
    required this.reminderSent,
    this.reminderSentAt,
    required this.smsSent,
    this.smsSentAt,
    required this.notificationType,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON (from Supabase)
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      childId: json['child_id'] as String?,
      pregnancyId: json['pregnancy_id'] as String?,
      type: json['type'] as String,
      scheduledAt: json['scheduled_at'] as String,
      durationMinutes: json['duration_minutes'] as int? ?? 30,
      clinicId: json['clinic_id'] as String?,
      providerId: json['provider_id'] as String?,
      status: json['status'] as String? ?? 'scheduled',
      reminderSent: json['reminder_sent'] as bool? ?? false,
      reminderSentAt: json['reminder_sent_at'] as String?,
      smsSent: json['sms_sent'] as bool? ?? false,
      smsSentAt: json['sms_sent_at'] as String?,
      notificationType: json['notification_type'] as String? ?? 'both',
      notes: json['notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'child_id': childId,
      'pregnancy_id': pregnancyId,
      'type': type,
      'scheduled_at': scheduledAt,
      'duration_minutes': durationMinutes,
      'clinic_id': clinicId,
      'provider_id': providerId,
      'status': status,
      'reminder_sent': reminderSent,
      'reminder_sent_at': reminderSentAt,
      'sms_sent': smsSent,
      'sms_sent_at': smsSentAt,
      'notification_type': notificationType,
      'notes': notes,
      'cancellation_reason': cancellationReason,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Convert to Entity
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      userId: userId,
      childId: childId,
      pregnancyId: pregnancyId,
      type: _parseVisitType(type),
      scheduledAt: DateTime.parse(scheduledAt),
      durationMinutes: durationMinutes,
      clinicId: clinicId,
      providerId: providerId,
      status: _parseAppointmentStatus(status),
      reminderSent: reminderSent,
      reminderSentAt: reminderSentAt != null 
          ? DateTime.parse(reminderSentAt!) 
          : null,
      smsSent: smsSent,
      smsSentAt: smsSentAt != null 
          ? DateTime.parse(smsSentAt!) 
          : null,
      notificationType: notificationType,
      notes: notes,
      cancellationReason: cancellationReason,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Create from Entity
  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      userId: entity.userId,
      childId: entity.childId,
      pregnancyId: entity.pregnancyId,
      type: entity.type.name,
      scheduledAt: entity.scheduledAt.toIso8601String(),
      durationMinutes: entity.durationMinutes,
      clinicId: entity.clinicId,
      providerId: entity.providerId,
      status: entity.status.name,
      reminderSent: entity.reminderSent,
      reminderSentAt: entity.reminderSentAt?.toIso8601String(),
      smsSent: entity.smsSent,
      smsSentAt: entity.smsSentAt?.toIso8601String(),
      notificationType: entity.notificationType,
      notes: entity.notes,
      cancellationReason: entity.cancellationReason,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  /// Parse visit type from string
  static VisitType _parseVisitType(String type) {
    switch (type.toLowerCase()) {
      case 'anc':
        return VisitType.anc;
      case 'immunization':
        return VisitType.immunization;
      case 'growth_monitoring':
        return VisitType.growth_monitoring;
      case 'postnatal':
        return VisitType.postnatal;
      case 'delivery':
        return VisitType.delivery;
      case 'general':
        return VisitType.general;
      case 'family_planning':
      case 'other':
        return VisitType.general;
      default:
        return VisitType.general;
    }
  }

  /// Parse appointment status from string
  static AppointmentStatus _parseAppointmentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'missed':
      case 'no_show':
        return AppointmentStatus.missed;
      case 'rescheduled':
        return AppointmentStatus.rescheduled;
      default:
        return AppointmentStatus.scheduled;
    }
  }

  /// Create a copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? childId,
    String? pregnancyId,
    String? type,
    String? scheduledAt,
    int? durationMinutes,
    String? clinicId,
    String? providerId,
    String? status,
    bool? reminderSent,
    String? reminderSentAt,
    bool? smsSent,
    String? smsSentAt,
    String? notificationType,
    String? notes,
    String? cancellationReason,
    String? createdAt,
    String? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      childId: childId ?? this.childId,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      clinicId: clinicId ?? this.clinicId,
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
      reminderSent: reminderSent ?? this.reminderSent,
      reminderSentAt: reminderSentAt ?? this.reminderSentAt,
      smsSent: smsSent ?? this.smsSent,
      smsSentAt: smsSentAt ?? this.smsSentAt,
      notificationType: notificationType ?? this.notificationType,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'AppointmentModel(id: $id, userId: $userId, type: $type, '
        'scheduledAt: $scheduledAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppointmentModel &&
      other.id == id &&
      other.userId == userId &&
      other.childId == childId &&
      other.pregnancyId == pregnancyId &&
      other.type == type &&
      other.scheduledAt == scheduledAt &&
      other.durationMinutes == durationMinutes &&
      other.clinicId == clinicId &&
      other.providerId == providerId &&
      other.status == status &&
      other.reminderSent == reminderSent &&
      other.reminderSentAt == reminderSentAt &&
      other.smsSent == smsSent &&
      other.smsSentAt == smsSentAt &&
      other.notificationType == notificationType &&
      other.notes == notes &&
      other.cancellationReason == cancellationReason &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      childId.hashCode ^
      pregnancyId.hashCode ^
      type.hashCode ^
      scheduledAt.hashCode ^
      durationMinutes.hashCode ^
      clinicId.hashCode ^
      providerId.hashCode ^
      status.hashCode ^
      reminderSent.hashCode ^
      reminderSentAt.hashCode ^
      smsSent.hashCode ^
      smsSentAt.hashCode ^
      notificationType.hashCode ^
      notes.hashCode ^
      cancellationReason.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}