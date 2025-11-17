/// Pregnancy Service (Data Layer)
/// Handles all pregnancy-related database operations
/// ENHANCED: Added debug logging to diagnose null pregnancy issue
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/pregnancy_entity.dart';
import '../../core/errors/app_exceptions.dart';

class PregnancyService {
  final SupabaseClient _supabase;

  PregnancyService(this._supabase);

  /// Get active pregnancy for a mother - ENHANCED WITH DEBUG LOGGING
  Future<PregnancyEntity?> getActivePregnancy(String motherId) async {
    debugPrint('🔍 PregnancyService.getActivePregnancy called');
    debugPrint('   motherId: $motherId');
    
    try {
      // First, let's check if ANY pregnancies exist for this mother
      final allPregnancies = await _supabase
          .from('pregnancies')
          .select('id, mother_id, pregnancy_number, is_active, created_at')
          .eq('mother_id', motherId)
          .order('created_at', ascending: false);
      
      debugPrint('   📊 Total pregnancies for this mother: ${allPregnancies.length}');
      
      if (allPregnancies.isNotEmpty) {
        debugPrint('   📋 Pregnancy records:');
        for (var p in allPregnancies) {
          debugPrint('      - ID: ${p['id']}');
          debugPrint('        Number: ${p['pregnancy_number']}');
          debugPrint('        Active: ${p['is_active']}');
          debugPrint('        Created: ${p['created_at']}');
        }
      } else {
        debugPrint('   ⚠️ NO pregnancies found for this mother!');
      }
      
      // Now get the active one
      debugPrint('   🔎 Querying for active pregnancy...');
      final response = await _supabase
          .from('pregnancies')
          .select()
          .eq('mother_id', motherId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        debugPrint('   ❌ No active pregnancy found!');
        debugPrint('   💡 Possible reasons:');
        debugPrint('      1. No pregnancy records exist for this mother');
        debugPrint('      2. All pregnancies have is_active = false');
        debugPrint('      3. The mother_id does not match any records');
        return null;
      }

      debugPrint('   ✅ Active pregnancy found! Raw response:');
      debugPrint('      ${response.toString()}');

      final pregnancy = _mapToEntity(response);
      debugPrint('   📦 Mapped pregnancy entity:');
      debugPrint('      - ID: ${pregnancy.id}');
      debugPrint('      - Number: ${pregnancy.pregnancyNumber}');
      debugPrint('      - Expected Delivery: ${pregnancy.expectedDelivery}');
      debugPrint('      - Is Active: ${pregnancy.isActive}');
      debugPrint('      - Trimester: ${pregnancy.trimester}');
      debugPrint('      - Gestation: ${pregnancy.gestationWeeks}w ${pregnancy.gestationDays % 7}d');
      
      return pregnancy;
    } on PostgrestException catch (e) {
      debugPrint('   ❌ PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');
      throw DatabaseException('Failed to fetch active pregnancy: ${e.message}');
    } catch (e, stack) {
      debugPrint('   ❌ Unexpected error: $e');
      debugPrint('   Stack: $stack');
      throw DatabaseException('Unexpected error fetching pregnancy: $e');
    }
  }

  /// Get all pregnancies for a mother (including past ones)
  Future<List<PregnancyEntity>> getAllPregnancies(String motherId) async {
    try {
      final response = await _supabase
          .from('pregnancies')
          .select()
          .eq('mother_id', motherId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => _mapToEntity(json))
          .toList();
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to fetch pregnancies: ${e.message}');
    } catch (e) {
      throw DatabaseException('Unexpected error fetching pregnancies: $e');
    }
  }

  /// Get a specific pregnancy by ID
  Future<PregnancyEntity?> getPregnancyById(String pregnancyId) async {
    try {
      final response = await _supabase
          .from('pregnancies')
          .select()
          .eq('id', pregnancyId)
          .maybeSingle();

      if (response == null) return null;

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to fetch pregnancy: ${e.message}');
    } catch (e) {
      throw DatabaseException('Unexpected error fetching pregnancy: $e');
    }
  }

  /// Create a new pregnancy
  Future<PregnancyEntity> createPregnancy({
    required String motherId,
    required DateTime expectedDelivery,
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
    String? notes,
  }) async {
    debugPrint('📝 Creating new pregnancy for mother: $motherId');
    
    try {
      // Deactivate any existing active pregnancy first
      await _deactivateExistingPregnancies(motherId);

      // Get the next pregnancy number
      final pregnancyNumber = await _getNextPregnancyNumber(motherId);
      debugPrint('   Pregnancy number: $pregnancyNumber');

      final now = DateTime.now();
      final data = {
        'mother_id': motherId,
        'pregnancy_number': pregnancyNumber,
        'start_date': now.toIso8601String().split('T')[0], // Date only
        'expected_delivery': expectedDelivery.toIso8601String().split('T')[0], // Date only
        'lmp': lmp?.toIso8601String().split('T')[0], // Date only
        'edd_confirmed_by': eddConfirmedBy,
        'gravida': gravida,
        'parity': parity,
        'risk_flags': riskFlags ?? [],
        'blood_group': bloodGroup,
        'rhesus': rhesus,
        'hiv_status': hivStatus,
        'syphilis_status': syphilisStatus,
        'hepatitis_b': hepatitisB,
        'outcome': 'ongoing',
        'notes': notes,
        'is_active': true,
        'version': 1,
        'last_updated_at': now.toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      debugPrint('   Inserting data: $data');

      final response = await _supabase
          .from('pregnancies')
          .insert(data)
          .select()
          .single();

      debugPrint('   ✅ Pregnancy created successfully: ${response['id']}');

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      debugPrint('   ❌ Failed to create pregnancy: ${e.message}');
      throw DatabaseException('Failed to create pregnancy: ${e.message}');
    } catch (e) {
      debugPrint('   ❌ Unexpected error: $e');
      throw DatabaseException('Unexpected error creating pregnancy: $e');
    }
  }

  /// Update an existing pregnancy
  Future<PregnancyEntity> updatePregnancy(
    String pregnancyId,
    PregnancyEntity pregnancy,
  ) async {
    debugPrint('📝 Updating pregnancy: $pregnancyId');
    
    try {
      final now = DateTime.now();
      final data = {
        'expected_delivery': pregnancy.expectedDelivery.toIso8601String().split('T')[0],
        'lmp': pregnancy.lmp?.toIso8601String().split('T')[0],
        'edd_confirmed_by': pregnancy.eddConfirmedBy,
        'gravida': pregnancy.gravida,
        'parity': pregnancy.parity,
        'risk_flags': pregnancy.riskFlags,
        'blood_group': pregnancy.bloodGroup,
        'rhesus': pregnancy.rhesus,
        'hiv_status': pregnancy.hivStatus,
        'syphilis_status': pregnancy.syphilisStatus,
        'hepatitis_b': pregnancy.hepatitisB,
        'notes': pregnancy.notes,
        'version': pregnancy.version + 1,
        'last_updated_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from('pregnancies')
          .update(data)
          .eq('id', pregnancyId)
          .select()
          .single();

      debugPrint('   ✅ Pregnancy updated successfully');

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      debugPrint('   ❌ Failed to update pregnancy: ${e.message}');
      throw DatabaseException('Failed to update pregnancy: ${e.message}');
    } catch (e) {
      debugPrint('   ❌ Unexpected error: $e');
      throw DatabaseException('Unexpected error updating pregnancy: $e');
    }
  }

  /// Complete a pregnancy with outcome
  Future<PregnancyEntity> completePregnancy({
    required String pregnancyId,
    required String outcome,
    required DateTime outcomeDate,
    DateTime? actualDelivery,
    String? deliveryPlace,
    String? notes,
  }) async {
    try {
      // First get current version
      final current = await getPregnancyById(pregnancyId);
      if (current == null) {
        throw NotFoundException('Pregnancy not found');
      }

      final now = DateTime.now();
      final data = {
        'outcome': outcome,
        'outcome_date': outcomeDate.toIso8601String().split('T')[0],
        'actual_delivery': actualDelivery?.toIso8601String().split('T')[0],
        'delivery_place': deliveryPlace,
        'notes': notes,
        'is_active': false,
        'version': current.version + 1,
        'last_updated_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from('pregnancies')
          .update(data)
          .eq('id', pregnancyId)
          .select()
          .single();

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to complete pregnancy: ${e.message}');
    } catch (e) {
      throw DatabaseException('Unexpected error completing pregnancy: $e');
    }
  }

  /// Add or update risk flags
  Future<PregnancyEntity> updateRiskFlags(
    String pregnancyId,
    List<String> riskFlags,
  ) async {
    try {
      // First get current version
      final current = await getPregnancyById(pregnancyId);
      if (current == null) {
        throw NotFoundException('Pregnancy not found');
      }

      final now = DateTime.now();
      final data = {
        'risk_flags': riskFlags,
        'version': current.version + 1,
        'last_updated_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final response = await _supabase
          .from('pregnancies')
          .update(data)
          .eq('id', pregnancyId)
          .select()
          .single();

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to update risk flags: ${e.message}');
    } catch (e) {
      throw DatabaseException('Unexpected error updating risk flags: $e');
    }
  }

  /// Deactivate a pregnancy (soft delete)
  Future<void> deactivatePregnancy(String pregnancyId) async {
    try {
      // First get current version
      final current = await getPregnancyById(pregnancyId);
      if (current == null) {
        throw NotFoundException('Pregnancy not found');
      }

      final now = DateTime.now();
      await _supabase
          .from('pregnancies')
          .update({
            'is_active': false,
            'version': current.version + 1,
            'last_updated_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .eq('id', pregnancyId);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to deactivate pregnancy: ${e.message}');
    } catch (e) {
      throw DatabaseException('Unexpected error deactivating pregnancy: $e');
    }
  }

  // Private helper methods

  /// Deactivate all existing active pregnancies for a mother
  Future<void> _deactivateExistingPregnancies(String motherId) async {
    debugPrint('   🔄 Deactivating existing pregnancies for mother: $motherId');
    final now = DateTime.now();
    await _supabase
        .from('pregnancies')
        .update({
          'is_active': false,
          'last_updated_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        })
        .eq('mother_id', motherId)
        .eq('is_active', true);
  }

  /// Get the next pregnancy number for a mother
  Future<int> _getNextPregnancyNumber(String motherId) async {
    final response = await _supabase
        .from('pregnancies')
        .select('pregnancy_number')
        .eq('mother_id', motherId)
        .order('pregnancy_number', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return 1;
    return (response['pregnancy_number'] as int? ?? 0) + 1;
  }

  /// Map database JSON to PregnancyEntity
  PregnancyEntity _mapToEntity(Map<String, dynamic> json) {
    // Handle risk_flags which could be JSONB array or List
    List<String> riskFlags = [];
    if (json['risk_flags'] != null) {
      if (json['risk_flags'] is List) {
        riskFlags = (json['risk_flags'] as List).cast<String>();
      } else if (json['risk_flags'] is String) {
        // Handle if it comes back as JSON string
        riskFlags = [];
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
}