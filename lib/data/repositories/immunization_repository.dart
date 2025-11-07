// lib/data/repositories/immunization_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/immunization_entity.dart';

final immunizationRepositoryProvider = Provider<ImmunizationRepository>((ref) {
  return ImmunizationRepository(Supabase.instance.client);
});

class ImmunizationRepository {
  final SupabaseClient _client;

  ImmunizationRepository(this._client);

  Future<List<ImmunizationEntity>> getByChildId(String childId) async {
    final response = await _client
        .from('immunizations')
        .select()
        .eq('child_id', childId)
        .order('administered_date', ascending: true);

    return (response as List)
        .map((json) => ImmunizationEntity.fromJson(json))
        .toList();
  }

  Future<ImmunizationEntity> addImmunization(ImmunizationEntity immunization) async {
    final data = immunization.toJson()..remove('id'); // let DB generate UUID
    final response = await _client
        .from('immunizations')
        .insert(data)
        .select()
        .single();

    return ImmunizationEntity.fromJson(response);
  }

  // Optional: edit/delete later
  Future<void> updateImmunization(ImmunizationEntity immunization) async {
    await _client
        .from('immunizations')
        .update(immunization.toJson())
        .eq('id', immunization.id);
  }

  Future<void> deleteImmunization(String id) async {
    await _client.from('immunizations').delete().eq('id', id);
  }
}