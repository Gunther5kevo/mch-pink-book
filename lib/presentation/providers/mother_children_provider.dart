/// Mother's Children Immunization Provider - FIXED
/// Fetches children data for the current mother with immunization tracking
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/supabase_client.dart';
import '../../domain/entities/immunization_entity.dart';
import 'auth_notifier.dart';
import 'immunization_providers.dart';

part 'mother_children_provider.g.dart';

/// Model for a child with immunization status (for mothers)
class MotherChildStatus {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String? gender;
  final List<ImmunizationEntity> recentImmunizations;
  final List<String> completedVaccines;
  final List<String> dueVaccines;
  final List<String> overdueVaccines;
  final String? nextVaccine;
  final DateTime? nextVaccineDate;
  final bool isFullyImmunized;

  const MotherChildStatus({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    this.gender,
    required this.recentImmunizations,
    required this.completedVaccines,
    required this.dueVaccines,
    required this.overdueVaccines,
    this.nextVaccine,
    this.nextVaccineDate,
    required this.isFullyImmunized,
  });

  int get ageInDays => DateTime.now().difference(dateOfBirth).inDays;
  int get ageInMonths => (ageInDays / 30).floor();
  int get ageInYears => (ageInDays / 365).floor();

  String get ageDisplay {
    if (ageInYears >= 2) {
      return '$ageInYears years old';
    } else if (ageInMonths >= 1) {
      return '$ageInMonths months old';
    } else {
      return '$ageInDays days old';
    }
  }

  String get immunizationStatus {
    if (overdueVaccines.isNotEmpty) {
      return 'Overdue: ${overdueVaccines.length} vaccine${overdueVaccines.length > 1 ? 's' : ''}';
    } else if (dueVaccines.isNotEmpty) {
      return 'Due: ${dueVaccines.length} vaccine${dueVaccines.length > 1 ? 's' : ''}';
    } else if (isFullyImmunized) {
      return 'Fully immunized';
    } else {
      return 'Up to date';
    }
  }
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Current mother's children with immunization status
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<List<MotherChildStatus>> motherChildren(
  MotherChildrenRef ref,
) async {
  final supabase = SupabaseClientManager.client;
  final authState = ref.watch(authNotifierProvider);

  final user = authState.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user == null) return [];

  // Fetch all children for this mother with their immunizations
  final response = await supabase
      .from('children')
      .select('''
        id,
        name,
        date_of_birth,
        gender,
        immunizations(
          id,
          vaccine_code,
          vaccine_name,
          administered_date,
          administered_by,
          notes,
          created_at,
          last_updated_at,
          version
        )
      ''')
      .eq('mother_id', user.id)
      .order('date_of_birth', ascending: false);

  final childrenStatus = <MotherChildStatus>[];

  for (final row in response) {
    final childId = row['id'] as String;
    final childName = row['name'] as String;
    final dob = DateTime.parse(row['date_of_birth'] as String);
    final gender = row['gender'] as String?;

    // Parse immunizations
    final immunizationsData = row['immunizations'] as List?;
    final immunizations = immunizationsData?.map((imm) {
      return ImmunizationEntity(
        id: imm['id'] as String,
        childId: childId,
        vaccineCode: imm['vaccine_code'] as String,
        vaccineName: imm['vaccine_name'] as String,
        administeredDate: DateTime.parse(imm['administered_date'] as String),
        administeredBy: imm['administered_by'] as String?,
        notes: imm['notes'] as String?,
        version: (imm['version'] as int?) ?? 1,
        lastUpdatedAt: DateTime.parse(imm['last_updated_at'] as String),
        createdAt: DateTime.parse(imm['created_at'] as String),
      );
    }).toList() ?? [];

    // Sort by date (most recent first)
    immunizations.sort((a, b) => 
      b.administeredDate.compareTo(a.administeredDate));

    // Get recent immunizations (last 3)
    final recentImmunizations = immunizations.take(3).toList();

    // Extract completed vaccines
    final completedVaccines = immunizations
        .map((imm) => imm.vaccineName)
        .toList();

    // Calculate due and overdue vaccines
    final dueVaccines = ImmunizationSchedule.getDueVaccines(
      dob,
      completedVaccines,
    );

    final overdueVaccines = dueVaccines.where((vaccine) {
      return ImmunizationSchedule.isOverdue(dob, vaccine);
    }).toList();

    // Calculate next vaccine
    String? nextVaccine;
    DateTime? nextVaccineDate;
    
    if (dueVaccines.isNotEmpty) {
      // Next vaccine is the first due vaccine (earliest in schedule)
      final sortedDue = dueVaccines.toList()..sort((a, b) {
        final aDays = ImmunizationSchedule.vaccineScheduleDays[a] ?? 0;
        final bDays = ImmunizationSchedule.vaccineScheduleDays[b] ?? 0;
        return aDays.compareTo(bDays);
      });
      
      nextVaccine = sortedDue.first;
      final dueDays = ImmunizationSchedule.vaccineScheduleDays[nextVaccine] ?? 0;
      nextVaccineDate = dob.add(Duration(days: dueDays));
    }

    // Check if fully immunized
    final allPossibleVaccines = ImmunizationSchedule.getDueVaccines(
      dob,
      [],
    );
    final isFullyImmunized = dueVaccines.isEmpty && 
                            allPossibleVaccines.isNotEmpty;

    childrenStatus.add(MotherChildStatus(
      id: childId,
      name: childName,
      dateOfBirth: dob,
      gender: gender,
      recentImmunizations: recentImmunizations,
      completedVaccines: completedVaccines,
      dueVaccines: dueVaccines,
      overdueVaccines: overdueVaccines,
      nextVaccine: nextVaccine,
      nextVaccineDate: nextVaccineDate,
      isFullyImmunized: isFullyImmunized,
    ));
  }

  return childrenStatus;
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Single child status by ID
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<MotherChildStatus?> childStatus(
  ChildStatusRef ref,
  String childId,
) async {
  final allChildren = await ref.watch(motherChildrenProvider.future);
  
  try {
    return allChildren.firstWhere((child) => child.id == childId);
  } catch (e) {
    return null;
  }
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Count of children with overdue immunizations
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<int> overdueImmunizationsCount(
  OverdueImmunizationsCountRef ref,
) async {
  final children = await ref.watch(motherChildrenProvider.future);
  return children.where((child) => child.overdueVaccines.isNotEmpty).length;
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Next upcoming immunization
/// ═══════════════════════════════════════════════════════════════════════
@riverpod
Future<Map<String, dynamic>?> nextImmunization(
  NextImmunizationRef ref,
) async {
  final children = await ref.watch(motherChildrenProvider.future);
  
  // Find the nearest upcoming immunization across all children
  DateTime? nearestDate;
  String? childName;
  String? vaccineName;
  
  for (final child in children) {
    if (child.nextVaccineDate != null) {
      if (nearestDate == null || child.nextVaccineDate!.isBefore(nearestDate)) {
        nearestDate = child.nextVaccineDate;
        childName = child.name;
        vaccineName = child.nextVaccine;
      }
    }
  }
  
  if (nearestDate == null) return null;
  
  return {
    'childName': childName,
    'vaccineName': vaccineName,
    'date': nearestDate,
    'daysUntil': nearestDate.difference(DateTime.now()).inDays,
  };
}