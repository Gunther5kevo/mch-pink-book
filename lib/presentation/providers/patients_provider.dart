/// lib/presentation/providers/patients_provider.dart
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/supabase_client.dart';
import '../../domain/entities/patient_entity.dart' as domain;

part 'patients_provider.g.dart';

/// ---------------------------------------------------------------------------
/// 1. Tiny DTO – only lives here, never used outside this file
/// ---------------------------------------------------------------------------
class _PatientDto {
  final String id;
  final String name;
  final String? phone;
  final String? nationalId;
  final String type;      // 'mother' or 'child'
  final String? motherId;

  const _PatientDto({
    required this.id,
    required this.name,
    this.phone,
    this.nationalId,
    required this.type,
    this.motherId,
  });

  // -----------------------------------------------------------------
  // Convert raw JSON → DTO
  // -----------------------------------------------------------------
  factory _PatientDto.fromJson(Map<String, dynamic> json, {required String type}) {
    return _PatientDto(
      id: json['id'] as String,
      name: type == 'child' ? json['name'] as String : json['full_name'] as String,
      phone: json['phone_e164'] as String?,
      nationalId: json['national_id'] as String?,
      type: type,
      motherId: json['mother_id'] as String?,
    );
  }

  // -----------------------------------------------------------------
  // DTO → clean domain entity
  // -----------------------------------------------------------------
  domain.Patient toDomain() => domain.Patient(
        id: id,
        name: name,
        type: type,
        phone: phone,
        nationalId: nationalId,
        motherId: motherId,
      );
}

/// ---------------------------------------------------------------------------
/// 2. Unified Patients provider – returns **domain.Patient**
/// ---------------------------------------------------------------------------
@riverpod
class Patients extends _$Patients {
  @override
  Future<List<domain.Patient>> build() async {
    final supabase = SupabaseClientManager.client;

    debugPrint(
        'PatientsProvider: client ready, user: ${supabase.auth.currentUser?.id ?? 'anon'}');

    try {
      // ------------------- Mothers -------------------
      final mothersResponse = await supabase
          .from('users')
          .select('id, full_name, phone_e164, national_id')
          .eq('role', 'mother')
          .eq('is_active', true)
          .order('full_name', ascending: true);

      final mothers = (mothersResponse as List)
          .map((json) => _PatientDto.fromJson(json, type: 'mother'))
          .map((dto) => dto.toDomain())
          .toList();

      // ------------------- Children ------------------
      final childrenResponse = await supabase
          .from('children')
          .select('id, name, mother_id')
          .order('name', ascending: true);

      final children = (childrenResponse as List)
          .map((json) => _PatientDto.fromJson(json, type: 'child'))
          .map((dto) => dto.toDomain())
          .toList();

      debugPrint('PatientsProvider: ${mothers.length} mothers, ${children.length} children');

      return [...mothers, ...children];
    } catch (e, stack) {
      debugPrint('PatientsProvider ERROR: $e');
      debugPrint('Stack: $stack');
      rethrow;
    }
  }

  /// Pull-to-refresh
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

/// ---------------------------------------------------------------------------
/// 3. Search providers – work with **domain.Patient**
/// ---------------------------------------------------------------------------
final patientSearchProvider = StateProvider<String>((ref) => '');

final filteredPatientsProvider = Provider<List<domain.Patient>>((ref) {
  final query = ref.watch(patientSearchProvider).trim();
  final asyncPatients = ref.watch(patientsProvider);

  final patients = asyncPatients.maybeWhen(
    data: (list) => list,
    orElse: () => <domain.Patient>[],
  );

  if (query.isEmpty) return patients;
  return patients.where((p) => p.matches(query)).toList();
});