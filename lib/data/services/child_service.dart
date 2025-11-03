/// Child Service
library;

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/child_entity.dart';

class ChildService {
  final SupabaseClient _supabase;

  ChildService(this._supabase);

  /// Get all children for a mother
  Future<List<ChildEntity>> getMotherChildren(String motherId) async {
    try {
      final response = await _supabase
          .from('children')
          .select()
          .eq('mother_id', motherId)
          .eq('is_active', true)
          .order('date_of_birth', ascending: false);

      return (response as List)
          .map((json) => _mapToEntity(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch children: $e');
    }
  }

  /// Get a single child by ID
  Future<ChildEntity?> getChildById(String childId) async {
    try {
      final response = await _supabase
          .from('children')
          .select()
          .eq('id', childId)
          .eq('is_active', true)
          .single();

      return _mapToEntity(response);
    } catch (e) {
      throw Exception('Failed to fetch child: $e');
    }
  }

  /// Create a new child
  Future<ChildEntity> createChild({
    required String motherId,
    required String name,
    required DateTime dateOfBirth,
    required String gender,
    String? pregnancyId,
    double? birthWeight,
    double? birthLength,
    double? headCircumference,
    String? birthPlace,
    String? birthCertificateNo,
    Map<String, dynamic>? apgarScore,
    String? birthComplications,
    String? photoUrl,
  }) async {
    try {
      final data = {
        'mother_id': motherId,
        'pregnancy_id': pregnancyId,
        'name': name,
        'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
        'gender': gender,
        'birth_weight': birthWeight,
        'birth_length': birthLength,
        'head_circumference': headCircumference,
        'birth_place': birthPlace,
        'birth_certificate_no': birthCertificateNo,
        'apgar_score': apgarScore,
        'birth_complications': birthComplications,
        'photo_url': photoUrl,
      };

      final response = await _supabase
          .from('children')
          .insert(data)
          .select()
          .single();

      return _mapToEntity(response);
    } catch (e) {
      throw Exception('Failed to create child: $e');
    }
  }

  /// Update child information
  Future<ChildEntity> updateChild({
    required String childId,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    double? birthWeight,
    double? birthLength,
    double? headCircumference,
    String? birthPlace,
    String? birthCertificateNo,
    Map<String, dynamic>? apgarScore,
    String? birthComplications,
    String? photoUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (name != null) data['name'] = name;
      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      }
      if (gender != null) data['gender'] = gender;
      if (birthWeight != null) data['birth_weight'] = birthWeight;
      if (birthLength != null) data['birth_length'] = birthLength;
      if (headCircumference != null) data['head_circumference'] = headCircumference;
      if (birthPlace != null) data['birth_place'] = birthPlace;
      if (birthCertificateNo != null) data['birth_certificate_no'] = birthCertificateNo;
      if (apgarScore != null) data['apgar_score'] = apgarScore;
      if (birthComplications != null) data['birth_complications'] = birthComplications;
      if (photoUrl != null) data['photo_url'] = photoUrl;

      final response = await _supabase
          .from('children')
          .update(data)
          .eq('id', childId)
          .select()
          .single();

      return _mapToEntity(response);
    } catch (e) {
      throw Exception('Failed to update child: $e');
    }
  }

  /// Soft delete a child
  Future<void> deleteChild(String childId) async {
    try {
      await _supabase
          .from('children')
          .update({'is_active': false})
          .eq('id', childId);
    } catch (e) {
      throw Exception('Failed to delete child: $e');
    }
  }

  /// Get children by age category
  Future<List<ChildEntity>> getChildrenByAgeCategory(
    String motherId,
    String ageCategory,
  ) async {
    try {
      final children = await getMotherChildren(motherId);
      
      return children.where((child) {
        final months = child.ageInMonths;
        switch (ageCategory.toLowerCase()) {
          case 'infant':
            return months < 12;
          case 'toddler':
            return months >= 12 && months < 36;
          case 'child':
            return months >= 36;
          default:
            return true;
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to filter children: $e');
    }
  }

  /// Search children by name
  Future<List<ChildEntity>> searchChildren(
    String motherId,
    String query,
  ) async {
    try {
      final response = await _supabase
          .from('children')
          .select()
          .eq('mother_id', motherId)
          .eq('is_active', true)
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      return (response as List)
          .map((json) => _mapToEntity(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search children: $e');
    }
  }

  /// Upload child photo
/// Upload child photo
Future<String> uploadChildPhoto(String childId, List<int> fileBytes, String fileExtension) async {
  try {
    final fileName = '$childId-${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    final storagePath = 'children/$childId/$fileName';

    // Convert List<int> to Uint8List
    final uint8List = Uint8List.fromList(fileBytes);

    await _supabase.storage
        .from('child-photos')
        .uploadBinary(storagePath, uint8List);

    final photoUrl = _supabase.storage
        .from('child-photos')
        .getPublicUrl(storagePath);

    // Update child record with photo URL
    await _supabase
        .from('children')
        .update({'photo_url': photoUrl})
        .eq('id', childId);

    return photoUrl;
  } catch (e) {
    throw Exception('Failed to upload photo: $e');
  }
}

  /// Get child by QR code
  Future<ChildEntity?> getChildByQrCode(String qrCode) async {
    try {
      final response = await _supabase
          .from('children')
          .select()
          .eq('unique_qr_code', qrCode)
          .eq('is_active', true)
          .single();

      return _mapToEntity(response);
    } catch (e) {
      throw Exception('Failed to fetch child by QR code: $e');
    }
  }

  /// Helper method to map JSON to ChildEntity
  ChildEntity _mapToEntity(Map<String, dynamic> json) {
    return ChildEntity(
      id: json['id'] as String,
      motherId: json['mother_id'] as String,
      pregnancyId: json['pregnancy_id'] as String?,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      birthWeight: json['birth_weight'] != null
          ? double.parse(json['birth_weight'].toString())
          : null,
      birthLength: json['birth_length'] != null
          ? double.parse(json['birth_length'].toString())
          : null,
      headCircumference: json['head_circumference'] != null
          ? double.parse(json['head_circumference'].toString())
          : null,
      birthPlace: json['birth_place'] as String?,
      birthCertificateNo: json['birth_certificate_no'] as String?,
      apgarScore: json['apgar_score'] as Map<String, dynamic>?,
      birthComplications: json['birth_complications'] as String?,
      uniqueQrCode: json['unique_qr_code'] as String,
      photoUrl: json['photo_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      version: json['version'] as int? ?? 1,
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}