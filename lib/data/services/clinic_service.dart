/// Clinic Service - Manages clinic data in local Supabase database
/// Works with the normalized 'clinics' table (formerly 'facilities')
library;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/clinic_entity.dart';

class ClinicService {
  final SupabaseClient _supabase;

  ClinicService(this._supabase);

  /// Get current user's clinic from the database
  /// Fetches clinic based on the user's clinic_id
  Future<ClinicEntity?> getCurrentClinic(String userId) async {
    try {
      // First get the user's clinic_id
      final userResponse = await _supabase
          .from('users')
          .select('clinic_id')
          .eq('id', userId)
          .maybeSingle();

      if (userResponse == null || userResponse['clinic_id'] == null) {
        return null;
      }

      final clinicId = userResponse['clinic_id'] as String;

      // Now fetch the clinic details
      final clinicResponse = await _supabase
          .from('clinics')
          .select()
          .eq('id', clinicId)
          .maybeSingle();

      if (clinicResponse == null) {
        return null;
      }

      return ClinicEntity.fromJson(clinicResponse);
    } catch (e) {
      print('❌ Error fetching current clinic: $e');
      return null;
    }
  }

  /// Get clinic by ID
  Future<ClinicEntity?> getClinicById(String clinicId) async {
    try {
      final response = await _supabase
          .from('clinics')
          .select()
          .eq('id', clinicId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ClinicEntity.fromJson(response);
    } catch (e) {
      print('❌ Error fetching clinic by ID: $e');
      return null;
    }
  }

  /// Get clinic by MFL code from local database
  Future<ClinicEntity?> getClinicByMflCode(String mflCode) async {
    try {
      final response = await _supabase
          .from('clinics')
          .select()
          .eq('mfl_code', mflCode)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ClinicEntity.fromJson(response);
    } catch (e) {
      print('❌ Error fetching clinic by MFL code: $e');
      return null;
    }
  }

  /// Get all clinics in a specific county
  Future<List<ClinicEntity>> getClinicsByCounty(String county) async {
    try {
      final response = await _supabase
          .from('clinics')
          .select()
          .eq('county', county)
          .order('name');

      return (response as List)
          .map((json) => ClinicEntity.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching clinics by county: $e');
      return [];
    }
  }

  /// Get all clinics in a specific sub-county
  Future<List<ClinicEntity>> getClinicsBySubCounty(String subCounty) async {
    try {
      final response = await _supabase
          .from('clinics')
          .select()
          .eq('sub_county', subCounty)
          .order('name');

      return (response as List)
          .map((json) => ClinicEntity.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching clinics by sub-county: $e');
      return [];
    }
  }

  /// Search clinics in local database by name
  Future<List<ClinicEntity>> searchClinicsByName(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _supabase
          .from('clinics')
          .select()
          .ilike('name', '%${query.trim()}%')
          .order('name')
          .limit(50);

      return (response as List)
          .map((json) => ClinicEntity.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error searching clinics: $e');
      return [];
    }
  }

  /// Get all users (healthcare providers) working at a specific clinic
  Future<List<Map<String, dynamic>>> getClinicProviders(String clinicId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id, full_name, email, role, phone_number')
          .eq('clinic_id', clinicId)
          .neq('role', 'mother')
          .order('full_name');

      return (response as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('❌ Error fetching clinic providers: $e');
      return [];
    }
  }

  /// Get clinic statistics (total mothers, appointments, etc.)
  Future<Map<String, dynamic>?> getClinicStats(String clinicId) async {
    try {
      final response = await _supabase.rpc('get_clinic_stats', params: {
        'p_clinic_id': clinicId,
      });

      return response as Map<String, dynamic>?;
    } catch (e) {
      print('❌ Error fetching clinic stats: $e');
      return null;
    }
  }

  /// Update clinic information
  /// Note: This should be restricted to admin users only
  Future<bool> updateClinic(String clinicId, Map<String, dynamic> updates) async {
    try {
      // Remove fields that shouldn't be updated
      final allowedUpdates = Map<String, dynamic>.from(updates);
      allowedUpdates.remove('id');
      allowedUpdates.remove('mfl_code');
      allowedUpdates.remove('created_at');

      await _supabase
          .from('clinics')
          .update(allowedUpdates)
          .eq('id', clinicId);

      return true;
    } catch (e) {
      print('❌ Error updating clinic: $e');
      return false;
    }
  }

  /// Update user's clinic assignment
  Future<bool> assignUserToClinic(String userId, String clinicId) async {
    try {
      await _supabase
          .from('users')
          .update({'clinic_id': clinicId})
          .eq('id', userId);

      return true;
    } catch (e) {
      print('❌ Error assigning user to clinic: $e');
      return false;
    }
  }

  /// Remove user's clinic assignment
  Future<bool> removeUserFromClinic(String userId) async {
    try {
      await _supabase
          .from('users')
          .update({'clinic_id': null})
          .eq('id', userId);

      return true;
    } catch (e) {
      print('❌ Error removing user from clinic: $e');
      return false;
    }
  }

  /// Check if a clinic exists by MFL code
  Future<bool> clinicExistsByMflCode(String mflCode) async {
    try {
      final response = await _supabase
          .from('clinics')
          .select('id')
          .eq('mfl_code', mflCode)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Get total number of clinics in the database
  Future<int> getTotalClinicsCount() async {
    try {
      final response = await _supabase
          .from('clinics')
          .select('id')
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      print('❌ Error getting clinics count: $e');
      return 0;
    }
  }
}