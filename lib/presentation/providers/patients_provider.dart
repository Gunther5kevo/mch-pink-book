/// lib/presentation/providers/patients_provider.dart
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/network/supabase_client.dart';

part 'patients_provider.g.dart';

/// ---------------------------------------------------------------------------
/// 1. Patient model – mothers + children
/// ---------------------------------------------------------------------------
class Patient {
  final String id;
  final String name;
  final String? phone;
  final String? nationalId;
  final String type;      // 'mother' or 'child'
  final String? motherId; // only for children

  const Patient({
    required this.id,
    required this.name,
    this.phone,
    this.nationalId,
    required this.type,
    this.motherId,
  });

  factory Patient.fromJson(Map<String, dynamic> json, {required String type}) {
    return Patient(
      id: json['id'] as String,
      // Use 'name' for children, 'full_name' for mothers
      name: type == 'child' ? json['name'] as String : json['full_name'] as String,
      phone: json['phone_e164'] as String?,
      nationalId: json['national_id'] as String?,
      type: type,
      motherId: json['mother_id'] as String?,
    );
  }

  bool matches(String query) {
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        id.toLowerCase().contains(q) ||
        phone?.contains(q) == true ||
        nationalId?.contains(q) == true;
  }
}

/// ---------------------------------------------------------------------------
/// 2. Unified Patients provider – mothers + children
/// ---------------------------------------------------------------------------
@riverpod
class Patients extends _$Patients {
  @override
  Future<List<Patient>> build() async {
    final supabase = SupabaseClientManager.client;

    debugPrint('PatientsProvider: client ready, user: ${supabase.auth.currentUser?.id ?? 'anon'}');

    try {
      // ------------------- Mothers -------------------
      final mothersResponse = await supabase
          .from('users')
          .select('id, full_name, phone_e164, national_id')
          .eq('role', 'mother')
          .eq('is_active', true)
          .order('full_name', ascending: true);

      final List mothersJson = mothersResponse as List? ?? [];
      final mothers = mothersJson
          .map((json) => Patient.fromJson(json, type: 'mother'))
          .toList();

      // ------------------- Children ------------------
      final childrenResponse = await supabase
          .from('children')
          .select('id, name, mother_id') // ← CHANGED: 'full_name' → 'name'
          .order('name', ascending: true);

      final List childrenJson = childrenResponse as List? ?? [];
      final children = childrenJson
          .map((json) => Patient.fromJson(json, type: 'child'))
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
/// 3. Search providers
/// ---------------------------------------------------------------------------
final patientSearchProvider = StateProvider<String>((ref) => '');

final filteredPatientsProvider = Provider<List<Patient>>((ref) {
  final query = ref.watch(patientSearchProvider).trim();
  final asyncPatients = ref.watch(patientsProvider);

  final patients = asyncPatients.maybeWhen(
    data: (list) => list,
    orElse: () => <Patient>[],
  );

  if (query.isEmpty) return patients;
  return patients.where((p) => p.matches(query)).toList();
});