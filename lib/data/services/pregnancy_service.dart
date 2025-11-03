/// Pregnancy Service (Data Layer)
/// Handles all pregnancy-related database operations
library;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/pregnancy_entity.dart';
import '../../core/errors/app_exceptions.dart';

class PregnancyService {
  final SupabaseClient _supabase;

  PregnancyService(this._supabase);

  /// Get active pregnancy for a mother
  Future<PregnancyEntity?> getActivePregnancy(String motherId) async {
    try {
      final response = await _supabase
          .from('pregnancies')
          .select()
          .eq('mother_id', motherId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to fetch active pregnancy: ${e.message}');
    } catch (e) {
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
    try {
      // Deactivate any existing active pregnancy first
      await _deactivateExistingPregnancies(motherId);

      // Get the next pregnancy number
      final pregnancyNumber = await _getNextPregnancyNumber(motherId);

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

      final response = await _supabase
          .from('pregnancies')
          .insert(data)
          .select()
          .single();

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to create pregnancy: ${e.message}');
    } catch (e) {
      throw DatabaseException('Unexpected error creating pregnancy: $e');
    }
  }

  /// Update an existing pregnancy
  Future<PregnancyEntity> updatePregnancy(
    String pregnancyId,
    PregnancyEntity pregnancy,
  ) async {
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

      return _mapToEntity(response);
    } on PostgrestException catch (e) {
      throw DatabaseException('Failed to update pregnancy: ${e.message}');
    } catch (e) {
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
      deliveryPlace: json['delivery_place'] as String?, // UUID as string
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool,
      version: json['version'] as int,
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}