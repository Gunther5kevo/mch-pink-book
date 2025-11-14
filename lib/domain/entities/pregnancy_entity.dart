/// Pregnancy Entity (Domain Layer)
/// Represents a pregnancy record
library;

import 'package:equatable/equatable.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';

class PregnancyEntity extends Equatable {
  final String id;
  final String motherId;
  final int pregnancyNumber;
  final DateTime startDate;
  final DateTime expectedDelivery;
  final DateTime? actualDelivery;
  final DateTime? lmp;
  final String? eddConfirmedBy;
  final int? gravida;
  final int? parity;
  final List<String> riskFlags;
  final String? bloodGroup;
  final String? rhesus;
  final String? hivStatus;
  final String? syphilisStatus;
  final String? hepatitisB;
  final String? outcome;
  final DateTime? outcomeDate;
  final String? deliveryPlace;
  final String? notes;
  final bool isActive;
  final int version;
  final DateTime lastUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PregnancyEntity({
    required this.id,
    required this.motherId,
    required this.pregnancyNumber,
    required this.startDate,
    required this.expectedDelivery,
    this.actualDelivery,
    this.lmp,
    this.eddConfirmedBy,
    this.gravida,
    this.parity,
    required this.riskFlags,
    this.bloodGroup,
    this.rhesus,
    this.hivStatus,
    this.syphilisStatus,
    this.hepatitisB,
    this.outcome,
    this.outcomeDate,
    this.deliveryPlace,
    this.notes,
    required this.isActive,
    required this.version,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ───────────────────────────────────────────────────────────────────────
  // FORMATTED DATE GETTERS (Non-nullable!)
  // ───────────────────────────────────────────────────────────────────────
  String get expectedDeliveryFormatted {
    return expectedDelivery.formattedDate; // uses your DateTimeX extension
  }

  String get lmpFormatted {
    return lmp?.formattedDate ?? '—';
  }

  String get actualDeliveryFormatted {
    return actualDelivery?.formattedDate ?? '—';
  }

  // ───────────────────────────────────────────────────────────────────────
  // CALCULATED VALUES
  // ───────────────────────────────────────────────────────────────────────
  
  /// Total gestational age in days from LMP to now (or actual delivery)
  int get gestationDays {
    if (lmp == null) return 0;
    final referenceDate = actualDelivery ?? DateTime.now();
    return referenceDate.difference(lmp!).inDays;
  }

  /// Gestational age in complete weeks
  int get gestationWeeks {
    return (gestationDays / 7).floor();
  }

  /// Legacy getter for backward compatibility
  int get gestationalAgeWeeks => gestationWeeks;

  /// Calculate gestational age at a specific date
  int gestationalAgeAt(DateTime date) {
    if (lmp == null) return 0;
    final days = date.difference(lmp!).inDays;
    return (days / 7).floor();
  }

  /// Calculate gestational days at a specific date
  int gestationalDaysAt(DateTime date) {
    if (lmp == null) return 0;
    return date.difference(lmp!).inDays;
  }

  bool get isHighRisk => riskFlags.isNotEmpty;

  bool get isOngoing => outcome == null || outcome == 'ongoing';

  bool get isCompleted => outcome != null && outcome != 'ongoing';

  int get trimester {
    final weeks = gestationWeeks;
    if (weeks <= 13) return 1;
    if (weeks <= 26) return 2;
    return 3;
  }

  int get daysUntilDelivery {
    final now = DateTime.now();
    if (now.isAfter(expectedDelivery)) return 0;
    return expectedDelivery.difference(now).inDays;
  }

  bool get isOverdue {
    return DateTime.now().isAfter(expectedDelivery) && isOngoing;
  }

  String get statusText {
    if (!isOngoing) return outcome ?? 'Completed';
    if (isOverdue) return 'Overdue';
    return '$gestationWeeks weeks';
  }

  /// Formatted gestational age string (e.g., "32 weeks 4 days")
  String get gestationalAgeFormatted {
    if (lmp == null) return 'Unknown';
    final weeks = gestationWeeks;
    final days = gestationDays % 7;
    if (days > 0) {
      return '$weeks weeks $days ${days == 1 ? "day" : "days"}';
    }
    return '$weeks weeks';
  }

  // ───────────────────────────────────────────────────────────────────────
  // COPY WITH
  // ───────────────────────────────────────────────────────────────────────
  PregnancyEntity copyWith({
    String? id,
    String? motherId,
    int? pregnancyNumber,
    DateTime? startDate,
    DateTime? expectedDelivery,
    DateTime? actualDelivery,
    DateTime? lmp,
    String? eddConfirmedBy,
    int? gravida,
    int? parity,
    List<String>? riskFlags,
    String? bloodGroup,
    String? rhesus,
    String? hivStatus,
    String? syphilisStatus,
    String? hepatitisB,
    String? outcome,
    DateTime? outcomeDate,
    String? deliveryPlace,
    String? notes,
    bool? isActive,
    int? version,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PregnancyEntity(
      id: id ?? this.id,
      motherId: motherId ?? this.motherId,
      pregnancyNumber: pregnancyNumber ?? this.pregnancyNumber,
      startDate: startDate ?? this.startDate,
      expectedDelivery: expectedDelivery ?? this.expectedDelivery,
      actualDelivery: actualDelivery ?? this.actualDelivery,
      lmp: lmp ?? this.lmp,
      eddConfirmedBy: eddConfirmedBy ?? this.eddConfirmedBy,
      gravida: gravida ?? this.gravida,
      parity: parity ?? this.parity,
      riskFlags: riskFlags ?? this.riskFlags,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      rhesus: rhesus ?? this.rhesus,
      hivStatus: hivStatus ?? this.hivStatus,
      syphilisStatus: syphilisStatus ?? this.syphilisStatus,
      hepatitisB: hepatitisB ?? this.hepatitisB,
      outcome: outcome ?? this.outcome,
      outcomeDate: outcomeDate ?? this.outcomeDate,
      deliveryPlace: deliveryPlace ?? this.deliveryPlace,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        motherId,
        pregnancyNumber,
        startDate,
        expectedDelivery,
        actualDelivery,
        lmp,
        eddConfirmedBy,
        gravida,
        parity,
        riskFlags,
        bloodGroup,
        rhesus,
        hivStatus,
        syphilisStatus,
        hepatitisB,
        outcome,
        outcomeDate,
        deliveryPlace,
        notes,
        isActive,
        version,
        lastUpdatedAt,
        createdAt,
        updatedAt,
      ];
}