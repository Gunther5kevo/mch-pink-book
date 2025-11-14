/// lib/presentation/providers/clinic_dashboard_providers.dart
/// 
/// Aggregate providers for the Nurse MCH Dashboard
/// Combines data from multiple sources for clinic-wide statistics
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/network/supabase_client.dart';
import '../../domain/entities/pregnancy_entity.dart';
import '../../core/constants/app_constants.dart';
import 'auth_notifier.dart';
import 'appointments_provider.dart';
import 'pregnancy_provider.dart';
import 'immunization_providers.dart'; 

part 'clinic_dashboard_providers.g.dart';

/// ═══════════════════════════════════════════════════════════════════════
/// 📊 CLINIC STATS MODEL
/// ═══════════════════════════════════════════════════════════════════════
class ClinicStats {
  final int registeredMothers;
  final int activePregnancies;
  final int newborns;
  final int highRiskCount;
  final int todayAppointments;
  final int immunizationsDueToday;

  const ClinicStats({
    required this.registeredMothers,
    required this.activePregnancies,
    required this.newborns,
    required this.highRiskCount,
    required this.todayAppointments,
    required this.immunizationsDueToday,
  });

  const ClinicStats.empty()
      : registeredMothers = 0,
        activePregnancies = 0,
        newborns = 0,
        highRiskCount = 0,
        todayAppointments = 0,
        immunizationsDueToday = 0;
}

/// ═══════════════════════════════════════════════════════════════════════
/// 📊 MAIN CLINIC STATS PROVIDER
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<ClinicStats> clinicStats(ClinicStatsRef ref) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user?.clinicId == null) {
    return const ClinicStats.empty();
  }

  final clinicId = user!.clinicId!;

  try {
    // Run queries in parallel for better performance
    final results = await Future.wait([
      _getRegisteredMothersCount(supabase, clinicId),
      _getActivePregnanciesCount(supabase, clinicId),
      _getNewbornsCount(supabase, clinicId),
      _getHighRiskCount(supabase, clinicId),
      ref.watch(todayAppointmentsCountProvider.future),
      _getImmunizationsDueTodayCount(supabase, clinicId),
    ]);

    return ClinicStats(
      registeredMothers: results[0] as int,
      activePregnancies: results[1] as int,
      newborns: results[2] as int,
      highRiskCount: results[3] as int,
      todayAppointments: results[4] as int,
      immunizationsDueToday: results[5] as int,
    );
  } catch (e) {
    throw Exception('Failed to load clinic stats: $e');
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Helper queries - FIXED: Removed FetchOptions usage
// ─────────────────────────────────────────────────────────────────────────
Future<int> _getRegisteredMothersCount(SupabaseClient supabase, String clinicId) async {
  final response = await supabase
      .from('users')
      .select('id')
      .eq('role', 'mother')
      .eq('clinic_id', clinicId)
      .eq('is_active', true)
      .count(CountOption.exact);
  return response.count;
}

Future<int> _getActivePregnanciesCount(SupabaseClient supabase, String clinicId) async {
  final response = await supabase
      .from('pregnancies')
      .select('id')
      .eq('clinic_id', clinicId)
      .eq('is_active', true)
      .count(CountOption.exact);
  return response.count;
}

Future<int> _getNewbornsCount(SupabaseClient supabase, String clinicId) async {
  final now = DateTime.now();
  final fortyTwoDaysAgo = now.subtract(const Duration(days: 42));
  
  final response = await supabase
      .from('children')
      .select('id')
      .eq('clinic_id', clinicId)
      .gte('date_of_birth', fortyTwoDaysAgo.toIso8601String())
      .count(CountOption.exact);
  return response.count;
}

Future<int> _getHighRiskCount(SupabaseClient supabase, String clinicId) async {
  // Count pregnancies with non-empty risk_flags array
  final response = await supabase
      .from('pregnancies')
      .select('risk_flags')
      .eq('clinic_id', clinicId)
      .eq('is_active', true);
  
  if (response is! List) return 0;
  
  return response.where((row) {
    final flags = row['risk_flags'];
    return flags != null && flags is List && flags.isNotEmpty;
  }).length;
}

Future<int> _getImmunizationsDueTodayCount(SupabaseClient supabase, String clinicId) async {
  // This would need a more complex query based on your immunization schedule logic
  // For now, returning 0 - implement based on your business rules
  // You might need to:
  // 1. Get all children in clinic
  // 2. Calculate which vaccines are due today based on DOB and immunization history
  // 3. Count missing vaccines
  return 0;
}

/// ═══════════════════════════════════════════════════════════════════════
/// 🤰 ACTIVE PREGNANCIES WITH ENHANCED DATA
/// ═══════════════════════════════════════════════════════════════════════
class PregnancyWithMother {
  final PregnancyEntity pregnancy;
  final String motherName;
  final String? motherPhone;
  final String? ancNumber;
  final DateTime? nextVisitDate;
  final int? daysOverdue;

  const PregnancyWithMother({
    required this.pregnancy,
    required this.motherName,
    this.motherPhone,
    this.ancNumber,
    this.nextVisitDate,
    this.daysOverdue,
  });

  String get statusText {
    if (pregnancy.isHighRisk) return 'High Risk';
    if (daysOverdue != null && daysOverdue! > 0) return 'Overdue';
    return 'On Track';
  }

  String get gestationalAgeText {
    final weeks = pregnancy.gestationWeeks;
    final days = pregnancy.gestationDays % 7;
    return '$weeks weeks ${days > 0 ? "$days days" : ""}';
  }
}

enum PregnancyFilter {
  all,
  firstTrimester,
  secondTrimester,
  thirdTrimester,
  overdue,
  highRisk,
  todayVisits,
  upcomingWeek,
}

@riverpod
Future<List<PregnancyWithMother>> activePregnancies(
  ActivePregnanciesRef ref,
  PregnancyFilter filter,
) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user?.clinicId == null) return [];

  final clinicId = user!.clinicId!;

  // Fetch pregnancies with mother info and next visit dates
  final response = await supabase
      .from('pregnancies')
      .select('''
        *,
        mother:users!mother_id(full_name, phone_e164),
        next_visit:appointments(scheduled_at)
      ''')
      .eq('clinic_id', clinicId)
      .eq('is_active', true)
      .order('expected_delivery', ascending: true);

  if (response is! List) return [];

  final pregnancies = response.map((row) {
    final pregnancy = _mapToPregnancyEntity(row);
    final mother = row['mother'] as Map<String, dynamic>?;
    final nextVisit = row['next_visit'] as List?;
    
    DateTime? nextVisitDate;
    if (nextVisit != null && nextVisit.isNotEmpty) {
      nextVisitDate = DateTime.parse(nextVisit.first['scheduled_at'] as String);
    }

    // Calculate days overdue (simple logic - enhance based on your visit schedule)
    int? daysOverdue;
    if (nextVisitDate != null && nextVisitDate.isBefore(DateTime.now())) {
      daysOverdue = DateTime.now().difference(nextVisitDate).inDays;
    }

    return PregnancyWithMother(
      pregnancy: pregnancy,
      motherName: mother?['full_name'] ?? 'Unknown',
      motherPhone: mother?['phone_e164'],
      ancNumber: 'ANC-${pregnancy.pregnancyNumber.toString().padLeft(4, '0')}',
      nextVisitDate: nextVisitDate,
      daysOverdue: daysOverdue,
    );
  }).toList();

  // Apply filters
  return pregnancies.where((p) => _matchesFilter(p, filter)).toList();
}

bool _matchesFilter(PregnancyWithMother p, PregnancyFilter filter) {
  switch (filter) {
    case PregnancyFilter.all:
      return true;
    case PregnancyFilter.firstTrimester:
      return p.pregnancy.trimester == 1;
    case PregnancyFilter.secondTrimester:
      return p.pregnancy.trimester == 2;
    case PregnancyFilter.thirdTrimester:
      return p.pregnancy.trimester == 3;
    case PregnancyFilter.overdue:
      return p.daysOverdue != null && p.daysOverdue! > 0;
    case PregnancyFilter.highRisk:
      return p.pregnancy.isHighRisk;
    case PregnancyFilter.todayVisits:
      if (p.nextVisitDate == null) return false;
      final today = DateTime.now();
      return p.nextVisitDate!.year == today.year &&
             p.nextVisitDate!.month == today.month &&
             p.nextVisitDate!.day == today.day;
    case PregnancyFilter.upcomingWeek:
      if (p.nextVisitDate == null) return false;
      final weekFromNow = DateTime.now().add(const Duration(days: 7));
      return p.nextVisitDate!.isBefore(weekFromNow) &&
             p.nextVisitDate!.isAfter(DateTime.now());
  }
}

/// ═══════════════════════════════════════════════════════════════════════
/// ⚠️ HIGH-RISK MOTHERS
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<List<PregnancyWithMother>> highRiskMothers(HighRiskMothersRef ref) async {
  return ref.watch(activePregnanciesProvider(PregnancyFilter.highRisk).future);
}

@riverpod
Future<Map<String, int>> highRiskBreakdown(HighRiskBreakdownRef ref) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user?.clinicId == null) return {};

  final clinicId = user!.clinicId!;

  final response = await supabase
      .from('pregnancies')
      .select('risk_flags')
      .eq('clinic_id', clinicId)
      .eq('is_active', true);

  if (response is! List) return {};

  // Count each risk flag
  final breakdown = <String, int>{};
  for (final row in response) {
    final flags = row['risk_flags'];
    if (flags != null && flags is List) {
      for (final flag in flags) {
        breakdown[flag.toString()] = (breakdown[flag.toString()] ?? 0) + 1;
      }
    }
  }

  return breakdown;
}

/// ═══════════════════════════════════════════════════════════════════════
/// 📍 DEFAULTERS (Missed visits >7 days)
/// ═══════════════════════════════════════════════════════════════════════
class Defaulter {
  final String motherId;
  final String motherName;
  final String? phone;
  final String? ancNumber;
  final DateTime lastVisitDate;
  final int daysOverdue;
  final int? gestationWeeks;

  const Defaulter({
    required this.motherId,
    required this.motherName,
    this.phone,
    this.ancNumber,
    required this.lastVisitDate,
    required this.daysOverdue,
    this.gestationWeeks,
  });
}

@riverpod
Future<List<Defaulter>> defaulters(DefaultersRef ref) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user?.clinicId == null) return [];

  final clinicId = user!.clinicId!;
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

  // Find mothers with missed appointments or overdue visits
  final response = await supabase
      .from('appointments')
      .select('''
        *,
        user:users!user_id(id, full_name, phone_e164),
        pregnancy:pregnancies!pregnancy_id(pregnancy_number, expected_delivery, lmp)
      ''')
      .eq('clinic_id', clinicId)
      .eq('status', 'scheduled')
      .lt('scheduled_at', sevenDaysAgo.toIso8601String())
      .order('scheduled_at', ascending: true);

  if (response is! List) return [];

  final defaulters = <Defaulter>[];
  for (final row in response) {
    final user = row['user'] as Map<String, dynamic>?;
    final pregnancy = row['pregnancy'] as Map<String, dynamic>?;
    
    if (user == null) continue;

    final scheduledAt = DateTime.parse(row['scheduled_at'] as String);
    final daysOverdue = DateTime.now().difference(scheduledAt).inDays;

    int? gestationWeeks;
    if (pregnancy != null) {
      final lmp = pregnancy['lmp'] != null 
          ? DateTime.parse(pregnancy['lmp'] as String)
          : null;
      if (lmp != null) {
        gestationWeeks = DateTime.now().difference(lmp).inDays ~/ 7;
      }
    }

    defaulters.add(Defaulter(
      motherId: user['id'] as String,
      motherName: user['full_name'] as String,
      phone: user['phone_e164'] as String?,
      ancNumber: pregnancy != null 
          ? 'ANC-${(pregnancy['pregnancy_number'] as int).toString().padLeft(4, '0')}'
          : null,
      lastVisitDate: scheduledAt,
      daysOverdue: daysOverdue,
      gestationWeeks: gestationWeeks,
    ));
  }

  return defaulters;
}

/// ═══════════════════════════════════════════════════════════════════════
/// 📝 TODAY'S TASKS
/// ═══════════════════════════════════════════════════════════════════════
class TodayTasks {
  final int scheduledVisits;
  final int immunizationsDue;
  final int followUps;
  final int defaultersToTrace;

  const TodayTasks({
    required this.scheduledVisits,
    required this.immunizationsDue,
    required this.followUps,
    required this.defaultersToTrace,
  });

  int get totalTasks => scheduledVisits + immunizationsDue + followUps + defaultersToTrace;
}

@riverpod
Future<TodayTasks> todayTasks(TodayTasksRef ref) async {
  final results = await Future.wait([
    ref.watch(todayAppointmentsCountProvider.future),
    _getImmunizationsDueTodayCount(
      SupabaseClientManager.client,
      ref.watch(authNotifierProvider).maybeWhen(
        authenticated: (u) => u.clinicId ?? '',
        orElse: () => '',
      ),
    ),
    _getFollowUpsCount(ref),
    ref.watch(defaultersProvider.future).then((list) => list.length),
  ]);

  return TodayTasks(
    scheduledVisits: results[0] as int,
    immunizationsDue: results[1] as int,
    followUps: results[2] as int,
    defaultersToTrace: results[3] as int,
  );
}

Future<int> _getFollowUpsCount(Ref ref) async {
  // Logic for follow-ups (e.g., post-natal checks, test results pending)
  // Implement based on your business rules
  return 0;
}

/// ═══════════════════════════════════════════════════════════════════════
/// 💉 IMMUNIZATIONS DUE
/// ═══════════════════════════════════════════════════════════════════════
class ImmunizationsDueSummary {
  final int overdue;
  final int dueThisWeek;
  final int fullyImmunized;

  const ImmunizationsDueSummary({
    required this.overdue,
    required this.dueThisWeek,
    required this.fullyImmunized,
  });
}

@riverpod
Future<ImmunizationsDueSummary> immunizationsDueSummary(
  ImmunizationsDueSummaryRef ref,
) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user?.clinicId == null) {
    return const ImmunizationsDueSummary(
      overdue: 0,
      dueThisWeek: 0,
      fullyImmunized: 0,
    );
  }

  // This is a simplified version - enhance based on your immunization schedule logic
  // You'll need to:
  // 1. Get all children in clinic
  // 2. Check their immunization records
  // 3. Calculate due dates based on DOB and schedule
  // 4. Categorize as overdue/due this week/fully immunized

  final clinicId = user!.clinicId!;

  final children = await supabase
      .from('children')
      .select('id, date_of_birth')
      .eq('clinic_id', clinicId);

  if (children is! List) {
    return const ImmunizationsDueSummary(
      overdue: 0,
      dueThisWeek: 0,
      fullyImmunized: 0,
    );
  }

  // TODO: Implement full logic based on Kenyan immunization schedule
  // For now returning placeholder
  return ImmunizationsDueSummary(
    overdue: (children.length * 0.1).round(),
    dueThisWeek: (children.length * 0.2).round(),
    fullyImmunized: (children.length * 0.7).round(),
  );
}

/// ═══════════════════════════════════════════════════════════════════════
/// HELPER: Map database row to PregnancyEntity
/// ═══════════════════════════════════════════════════════════════════════
PregnancyEntity _mapToPregnancyEntity(Map<String, dynamic> json) {
  List<String> riskFlags = [];
  if (json['risk_flags'] != null) {
    if (json['risk_flags'] is List) {
      riskFlags = (json['risk_flags'] as List).cast<String>();
    }
  }

  return PregnancyEntity(
    id: json['id'] as String,
    motherId: json['mother_id'] as String,
    pregnancyNumber: json['pregnancy_number'] as int,
    startDate: DateTime.parse(json['start_date'] as String),
    expectedDelivery: DateTime.parse(json['expected_delivery'] as String),
    actualDelivery: json['actual_delivery'] != null
        ? DateTime.parse(json['actual_delivery'] as String)
        : null,
    lmp: json['lmp'] != null ? DateTime.parse(json['lmp'] as String) : null,
    eddConfirmedBy: json['edd_confirmed_by'] as String?,
    gravida: json['gravida'] as int?,
    parity: json['parity'] as int?,
    riskFlags: riskFlags,
    bloodGroup: json['blood_group'] as String?,
    rhesus: json['rhesus'] as String?,
    hivStatus: json['hiv_status'] as String?,
    syphilisStatus: json['syphilis_status'] as String?,
    hepatitisB: json['hepatitis_b'] as String?,
    outcome: json['outcome'] as String?,
    outcomeDate: json['outcome_date'] != null
        ? DateTime.parse(json['outcome_date'] as String)
        : null,
    deliveryPlace: json['delivery_place'] as String?,
    notes: json['notes'] as String?,
    isActive: json['is_active'] as bool,
    version: json['version'] as int,
    lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}