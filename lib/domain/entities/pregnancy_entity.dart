/// Pregnancy Entity (Domain Layer)
/// Represents a pregnancy record
library;

import 'package:equatable/equatable.dart';

class PregnancyEntity extends Equatable {
  final String id;
  final String motherId;
  final int pregnancyNumber;
  final DateTime startDate;
  final DateTime expectedDelivery;
  final DateTime? actualDelivery;
  final DateTime? lmp; // Last Menstrual Period
  final String? eddConfirmedBy; // ultrasound, lmp, etc
  final int? gravida; // Total pregnancies
  final int? parity; // Births after 28 weeks
  final List<String> riskFlags;
  final String? bloodGroup;
  final String? rhesus;
  final String? hivStatus;
  final String? syphilisStatus;
  final String? hepatitisB;
  final String? outcome; // ongoing, live_birth, stillbirth, miscarriage
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

  /// Calculate current gestational age in weeks
  int get gestationalAgeWeeks {
    if (lmp == null) return 0;
    final now = actualDelivery ?? DateTime.now();
    final days = now.difference(lmp!).inDays;
    return (days / 7).floor();
  }

  /// Calculate gestational age at a specific date
  int gestationalAgeAt(DateTime date) {
    if (lmp == null) return 0;
    final days = date.difference(lmp!).inDays;
    return (days / 7).floor();
  }

  /// Check if pregnancy is high risk
  bool get isHighRisk => riskFlags.isNotEmpty;

  /// Check if pregnancy is ongoing
  bool get isOngoing => outcome == null || outcome == 'ongoing';

  /// Check if pregnancy is completed
  bool get isCompleted => outcome != null && outcome != 'ongoing';

  /// Get trimester (1, 2, or 3)
  int get trimester {
    final weeks = gestationalAgeWeeks;
    if (weeks <= 13) return 1;
    if (weeks <= 26) return 2;
    return 3;
  }

  /// Days until expected delivery
  int get daysUntilDelivery {
    final now = DateTime.now();
    if (now.isAfter(expectedDelivery)) return 0;
    return expectedDelivery.difference(now).inDays;
  }

  /// Check if pregnancy is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(expectedDelivery) && isOngoing;
  }

  /// Get pregnancy status text
  String get statusText {
    if (!isOngoing) return outcome ?? 'Completed';
    if (isOverdue) return 'Overdue';
    return '$gestationalAgeWeeks weeks';
  }

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