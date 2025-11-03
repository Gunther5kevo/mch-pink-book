/// domain/entities/appointment_entity.dart
library;

import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String userId;
  final String? childId;
  final String? pregnancyId;
  final VisitType type;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String? clinicId;
  final String? providerId;
  final AppointmentStatus status;
  final bool reminderSent;
  final DateTime? reminderSentAt;
  final bool smsSent;
  final DateTime? smsSentAt;
  final String notificationType; // push, sms, both
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppointmentEntity({
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

  // -----------------------------------------------------------------------
  //  JSON Serialization
  // -----------------------------------------------------------------------
  factory AppointmentEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      childId: json['child_id'] as String?,
      pregnancyId: json['pregnancy_id'] as String?,
      type: VisitType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => VisitType.general, // Fixed: use existing enum value
      ),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: json['duration_minutes'] as int,
      clinicId: json['clinic_id'] as String?,
      providerId: json['provider_id'] as String?,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      reminderSent: (json['reminder_sent'] as bool?) ?? false,
      reminderSentAt: json['reminder_sent_at'] != null
          ? DateTime.parse(json['reminder_sent_at'] as String)
          : null,
      smsSent: (json['sms_sent'] as bool?) ?? false,
      smsSentAt: json['sms_sent_at'] != null
          ? DateTime.parse(json['sms_sent_at'] as String)
          : null,
      notificationType: (json['notification_type'] as String?) ?? 'both',
      notes: json['notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'child_id': childId,
      'pregnancy_id': pregnancyId,
      'type': type.name,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'clinic_id': clinicId,
      'provider_id': providerId,
      'status': status.name,
      'reminder_sent': reminderSent,
      'reminder_sent_at': reminderSentAt?.toIso8601String(),
      'sms_sent': smsSent,
      'sms_sent_at': smsSentAt?.toIso8601String(),
      'notification_type': notificationType,
      'notes': notes,
      'cancellation_reason': cancellationReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // -----------------------------------------------------------------------
  //  Convenience Getters
  // -----------------------------------------------------------------------
  bool get isUpcoming {
    return status == AppointmentStatus.scheduled && scheduledAt.isAfter(DateTime.now());
  }

  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
           scheduledAt.month == now.month &&
           scheduledAt.day == now.day;
  }

  bool get isOverdue {
    return status == AppointmentStatus.scheduled && scheduledAt.isBefore(DateTime.now());
  }

  Duration get timeUntil => scheduledAt.difference(DateTime.now());
  int get daysUntil => timeUntil.inDays;
  int get hoursUntil => timeUntil.inHours;

  bool get shouldSendReminder {
    if (reminderSent) return false;
    if (status != AppointmentStatus.scheduled) return false;
    final hoursUntil = timeUntil.inHours;
    return hoursUntil <= 72 && hoursUntil > 0;
  }

  String get formattedDate => '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year}';
  String get formattedTime {
    final hour = scheduledAt.hour.toString().padLeft(2, '0');
    final minute = scheduledAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDateTime => '$formattedDate at $formattedTime';

  String get relativeTimeDisplay {
    if (isToday) return 'Today at $formattedTime';
    final days = daysUntil;
    if (days == 1) return 'Tomorrow at $formattedTime';
    if (days == -1) return 'Yesterday';
    if (days > 0 && days <= 7) return 'In $days days';
    if (days < 0) return '${-days} days ago';
    return formattedDateTime;
  }

  // -----------------------------------------------------------------------
  //  copyWith
  // -----------------------------------------------------------------------
  AppointmentEntity copyWith({
    String? id,
    String? userId,
    String? childId,
    String? pregnancyId,
    VisitType? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? clinicId,
    String? providerId,
    AppointmentStatus? status,
    bool? reminderSent,
    DateTime? reminderSentAt,
    bool? smsSent,
    DateTime? smsSentAt,
    String? notificationType,
    String? notes,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentEntity(
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
  List<Object?> get props => [
        id,
        userId,
        childId,
        pregnancyId,
        type,
        scheduledAt,
        durationMinutes,
        clinicId,
        providerId,
        status,
        reminderSent,
        reminderSentAt,
        smsSent,
        smsSentAt,
        notificationType,
        notes,
        cancellationReason,
        createdAt,
        updatedAt,
      ];
}