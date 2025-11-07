// lib/data/services/clinic_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/clinic_entity.dart';

class ClinicService {
  final SupabaseClient _client;

  ClinicService(this._client);

  Future<ClinicEntity?> getCurrentClinic(String userId) async {
    try {
      // Example: assume a `user_clinics` join table that links user → clinic
      final response = await _client
          .from('user_clinics')
          .select('clinics(*)')
          .eq('user_id', userId)
          .eq('clinics.is_active', true)
          .single();

      // ignore: unnecessary_cast
      final clinicJson = (response as Map<String, dynamic>)['clinics'] as Map<String, dynamic>;
      return ClinicEntity.fromJson(clinicJson);
    } catch (e) {
      // If no link or error, fall back to a default clinic (optional)
      return null;
    }
  }
}