/// lib/presentation/providers/immunization_providers.dart
/// 
/// ENHANCED: Added clinic-wide immunization tracking for dashboard
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/immunization_entity.dart';
import '../../data/repositories/immunization_repository.dart';
import '../../core/network/supabase_client.dart';
import 'auth_notifier.dart';

part 'immunization_providers.g.dart';

/// ═══════════════════════════════════════════════════════════════════════
/// EXISTING: Per-child immunization tracking
/// ═══════════════════════════════════════════════════════════════════════

@riverpod
Future<List<ImmunizationEntity>> immunizations(
    ImmunizationsRef ref, String childId) {
  return ref.watch(immunizationRepositoryProvider).getByChildId(childId);
}

@riverpod
class ImmunizationNotifier extends _$ImmunizationNotifier {
  @override
  Future<void> build() async {}

  Future<ImmunizationEntity> addImmunization(ImmunizationEntity immunization) async {
    final repo = ref.read(immunizationRepositoryProvider);
    final newImmunization = await repo.addImmunization(immunization);
    
    // Invalidate both child-specific and clinic-wide providers
    ref
      ..invalidate(immunizationsProvider(immunization.childId))
      ..invalidate(immunizationsDueSummaryProvider)
      ..invalidate(immunizationsDueTodayProvider);
    
    return newImmunization;
  }
}

/// ═══════════════════════════════════════════════════════════════════════
/// NEW: Clinic-wide immunization dashboard data
/// ═══════════════════════════════════════════════════════════════════════

/// Kenyan Immunization Schedule
/// Based on MOH Kenya EPI schedule
class ImmunizationSchedule {
  static const Map<String, int> vaccineScheduleDays = {
    'BCG': 0,           // At birth
    'OPV_0': 0,         // At birth
    'OPV_1': 42,        // 6 weeks
    'DPT_HepB_Hib_1': 42,
    'PCV_1': 42,
    'Rota_1': 42,
    'OPV_2': 70,        // 10 weeks
    'DPT_HepB_Hib_2': 70,
    'PCV_2': 70,
    'Rota_2': 70,
    'OPV_3': 98,        // 14 weeks
    'DPT_HepB_Hib_3': 98,
    'PCV_3': 98,
    'IPV': 98,
    'Measles_Rubella_1': 270,  // 9 months
    'Yellow_Fever': 270,
    'Vitamin_A_1': 180,         // 6 months
    'Vitamin_A_2': 360,         // 12 months
    'Measles_Rubella_2': 540,   // 18 months
  };

  /// Calculate which vaccines are due for a child based on DOB
  static List<String> getDueVaccines(
    DateTime dateOfBirth,
    List<String> completedVaccines,
    {DateTime? asOfDate}
  ) {
    final checkDate = asOfDate ?? DateTime.now();
    final ageInDays = checkDate.difference(dateOfBirth).inDays;
    
    final dueVaccines = <String>[];
    
    for (final entry in vaccineScheduleDays.entries) {
      final vaccineName = entry.key;
      final dueDay = entry.value;
      
      // Vaccine is due if:
      // 1. Child's age >= due day
      // 2. Not already completed
      if (ageInDays >= dueDay && !completedVaccines.contains(vaccineName)) {
        dueVaccines.add(vaccineName);
      }
    }
    
    return dueVaccines;
  }

  /// Check if vaccine is overdue (>7 days past due date)
  static bool isOverdue(DateTime dateOfBirth, String vaccineName, {DateTime? asOfDate}) {
    final checkDate = asOfDate ?? DateTime.now();
    final ageInDays = checkDate.difference(dateOfBirth).inDays;
    final dueDays = vaccineScheduleDays[vaccineName] ?? 0;
    
    return ageInDays > (dueDays + 7);
  }
}

/// Model for child immunization status
class ChildImmunizationStatus {
  final String childId;
  final String childName;
  final DateTime dateOfBirth;
  final List<String> completedVaccines;
  final List<String> dueVaccines;
  final List<String> overdueVaccines;
  final bool isFullyImmunized;

  const ChildImmunizationStatus({
    required this.childId,
    required this.childName,
    required this.dateOfBirth,
    required this.completedVaccines,
    required this.dueVaccines,
    required this.overdueVaccines,
    required this.isFullyImmunized,
  });

  int get ageInDays => DateTime.now().difference(dateOfBirth).inDays;
  int get ageInMonths => (ageInDays / 30).floor();
}

/// Summary of immunizations for dashboard
class ImmunizationsDueSummary {
  final int overdue;
  final int dueThisWeek;
  final int fullyImmunized;
  final int totalChildren;

  const ImmunizationsDueSummary({
    required this.overdue,
    required this.dueThisWeek,
    required this.fullyImmunized,
    required this.totalChildren,
  });

  const ImmunizationsDueSummary.empty()
      : overdue = 0,
        dueThisWeek = 0,
        fullyImmunized = 0,
        totalChildren = 0;
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: All children in clinic with immunization status
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<List<ChildImmunizationStatus>> clinicChildrenImmunizationStatus(
  ClinicChildrenImmunizationStatusRef ref,
) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user?.clinicId == null) return [];

  final clinicId = user!.clinicId!;

  // Fetch all children in clinic with their immunizations
  final response = await supabase
      .from('children')
      .select('''
        id,
        name,
        date_of_birth,
        immunizations(vaccine_name, administered_date)
      ''')
      .eq('clinic_id', clinicId)
      .order('date_of_birth', ascending: false);

  final childrenStatus = <ChildImmunizationStatus>[];

  for (final row in response) {
    final childId = row['id'] as String;
    final childName = row['name'] as String;
    final dob = DateTime.parse(row['date_of_birth'] as String);
    
    // Extract completed vaccines
    final immunizations = row['immunizations'] as List?;
    final completedVaccines = immunizations
        ?.map((imm) => imm['vaccine_name'] as String)
        .toList() ?? [];

    // Calculate due and overdue vaccines
    final dueVaccines = ImmunizationSchedule.getDueVaccines(
      dob,
      completedVaccines,
    );

    final overdueVaccines = dueVaccines.where((vaccine) {
      return ImmunizationSchedule.isOverdue(dob, vaccine);
    }).toList();

    // Check if fully immunized (completed all vaccines for their age)
    final allPossibleVaccines = ImmunizationSchedule.getDueVaccines(
      dob,
      [],
    );
    final isFullyImmunized = dueVaccines.isEmpty && allPossibleVaccines.isNotEmpty;

    childrenStatus.add(ChildImmunizationStatus(
      childId: childId,
      childName: childName,
      dateOfBirth: dob,
      completedVaccines: completedVaccines,
      dueVaccines: dueVaccines,
      overdueVaccines: overdueVaccines,
      isFullyImmunized: isFullyImmunized,
    ));
  }

  return childrenStatus;
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Immunization summary for dashboard
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<ImmunizationsDueSummary> immunizationsDueSummary(
  ImmunizationsDueSummaryRef ref,
) async {
  final childrenStatus = await ref.watch(
    clinicChildrenImmunizationStatusProvider.future,
  );

  if (childrenStatus.isEmpty) {
    return const ImmunizationsDueSummary.empty();
  }

  final now = DateTime.now();
  final oneWeekFromNow = now.add(const Duration(days: 7));

  int overdueCount = 0;
  int dueThisWeekCount = 0;
  int fullyImmunizedCount = 0;

  for (final child in childrenStatus) {
    // Count overdue children
    if (child.overdueVaccines.isNotEmpty) {
      overdueCount++;
    }

    // Count children with vaccines due this week
    final hasDueThisWeek = child.dueVaccines.any((vaccine) {
      final dueDays = ImmunizationSchedule.vaccineScheduleDays[vaccine] ?? 0;
      final dueDate = child.dateOfBirth.add(Duration(days: dueDays));
      return dueDate.isBefore(oneWeekFromNow) && 
             dueDate.isAfter(now.subtract(const Duration(days: 7)));
    });
    if (hasDueThisWeek) {
      dueThisWeekCount++;
    }

    // Count fully immunized children
    if (child.isFullyImmunized) {
      fullyImmunizedCount++;
    }
  }

  return ImmunizationsDueSummary(
    overdue: overdueCount,
    dueThisWeek: dueThisWeekCount,
    fullyImmunized: fullyImmunizedCount,
    totalChildren: childrenStatus.length,
  );
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Immunizations due TODAY (for top stats card)
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<int> immunizationsDueToday(
  ImmunizationsDueTodayRef ref,
) async {
  final childrenStatus = await ref.watch(
    clinicChildrenImmunizationStatusProvider.future,
  );

  final today = DateTime.now();
  int dueCount = 0;

  for (final child in childrenStatus) {
    final hasDueToday = child.dueVaccines.any((vaccine) {
      final dueDays = ImmunizationSchedule.vaccineScheduleDays[vaccine] ?? 0;
      final dueDate = child.dateOfBirth.add(Duration(days: dueDays));
      
      // Check if due date is today (within same day)
      return dueDate.year == today.year &&
             dueDate.month == today.month &&
             dueDate.day == today.day;
    });
    
    if (hasDueToday) {
      dueCount++;
    }
  }

  return dueCount;
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Children with overdue immunizations (for detailed list)
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<List<ChildImmunizationStatus>> overdueImmunizations(
  OverdueImmunizationsRef ref,
) async {
  final allChildren = await ref.watch(
    clinicChildrenImmunizationStatusProvider.future,
  );

  return allChildren
      .where((child) => child.overdueVaccines.isNotEmpty)
      .toList()
    ..sort((a, b) => b.overdueVaccines.length.compareTo(a.overdueVaccines.length));
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Children with immunizations due this week (for detailed list)
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<List<ChildImmunizationStatus>> immunizationsDueThisWeek(
  ImmunizationsDueThisWeekRef ref,
) async {
  final allChildren = await ref.watch(
    clinicChildrenImmunizationStatusProvider.future,
  );

  final now = DateTime.now();
  final oneWeekFromNow = now.add(const Duration(days: 7));

  return allChildren.where((child) {
    return child.dueVaccines.any((vaccine) {
      final dueDays = ImmunizationSchedule.vaccineScheduleDays[vaccine] ?? 0;
      final dueDate = child.dateOfBirth.add(Duration(days: dueDays));
      return dueDate.isBefore(oneWeekFromNow) && 
             dueDate.isAfter(now.subtract(const Duration(days: 7)));
    });
  }).toList();
}