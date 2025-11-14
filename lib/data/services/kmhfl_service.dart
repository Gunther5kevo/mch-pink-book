/// KMHFL Service - With comprehensive debug logging
/// Searches KMHFL API and upserts to local clinics table
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// 🐛 Debug flag - set to false in production
const bool _kDebugMode = true;

void _debugLog(String message, {String emoji = '🔍'}) {
  if (_kDebugMode) {
    print('$emoji [KMHFL_SERVICE] $message');
  }
}

/// Service for KMHFL API integration and clinic database sync
class KmhflService {
  static const String baseUrl = 'https://kmhfl.health.go.ke/api/facilities/facilities/';
  static const Duration timeoutDuration = Duration(seconds: 15);
  
  final SupabaseClient _supabase;

  KmhflService(this._supabase) {
    _debugLog('KmhflService initialized', emoji: '🚀');
    _debugLog('Base URL: $baseUrl', emoji: '🌐');
    _debugLog('Timeout: ${timeoutDuration.inSeconds}s', emoji: '⏱️');
  }

  /// Search facilities in KMHFL API
  Future<List<KmhflFacility>> searchFacilities(String query) async {
  if (query.trim().isEmpty) {
    _debugLog('Empty query provided, returning empty list', emoji: '⚠️');
    return [];
  }

  _debugLog('═══════════════════════════════════════', emoji: '🔎');
  _debugLog('Starting facility search', emoji: '🔎');
  _debugLog('Query: "$query"', emoji: '📝');
  _debugLog('Query length: ${query.length} chars', emoji: '📏');

  try {
    // ✅ FIXED: Use Uri.parse with proper query parameters
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'search': query,
        'format': 'json',
      },
    );
    
    _debugLog('Full URL: $uri', emoji: '🌐');
    _debugLog('Sending HTTP GET request...', emoji: '📡');
    
    final startTime = DateTime.now();
    
    final response = await http.get(uri).timeout(
      timeoutDuration,
      onTimeout: () {
        _debugLog('❌ Request timed out after ${timeoutDuration.inSeconds}s', emoji: '❌');
        throw Exception('Request timed out. Please check your connection.');
      },
    );

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    
    _debugLog('Response received in ${duration.inMilliseconds}ms', emoji: '⏱️');
    _debugLog('Status code: ${response.statusCode}', emoji: '📊');
    _debugLog('Response body length: ${response.body.length} bytes', emoji: '📦');

    if (response.statusCode == 200) {
      _debugLog('✅ Success - Status 200', emoji: '✅');
      
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _debugLog('JSON decoded successfully', emoji: '✅');
        _debugLog('Response keys: ${data.keys.toList()}', emoji: '🔑');
        
        final results = (data['results'] as List<dynamic>?) ?? [];
        _debugLog('Results count: ${results.length}', emoji: '📊');
        
        if (results.isEmpty) {
          _debugLog('No facilities found in response', emoji: '⚠️');
          _debugLog('═══════════════════════════════════════', emoji: '🏁');
          return [];
        }
        
        _debugLog('Parsing facilities...', emoji: '⚙️');
        final facilities = <KmhflFacility>[];
        int parsedCount = 0;
        int operationalCount = 0;
        int skippedCount = 0;
        
        for (var i = 0; i < results.length; i++) {
          try {
            final facility = KmhflFacility.fromJson(results[i] as Map<String, dynamic>);
            parsedCount++;
            
            if (facility.operationStatus == 'Operational') {
              facilities.add(facility);
              operationalCount++;
              
              // Log first 3 facilities
              if (operationalCount <= 3) {
                _debugLog('  [$operationalCount] ${facility.name}', emoji: '  ✅');
                _debugLog('      Code: ${facility.code}, County: ${facility.county}', emoji: '     ');
              }
            } else {
              skippedCount++;
              if (skippedCount <= 2) {
                _debugLog('  Skipped (${facility.operationStatus}): ${facility.name}', emoji: '  ⏭️');
              }
            }
          } catch (e) {
            _debugLog('  ❌ Error parsing facility $i: $e', emoji: '  ❌');
          }
        }
        
        _debugLog('Parsing complete:', emoji: '📊');
        _debugLog('  Total in response: ${results.length}', emoji: '  •');
        _debugLog('  Successfully parsed: $parsedCount', emoji: '  •');
        _debugLog('  Operational: $operationalCount', emoji: '  •');
        _debugLog('  Skipped (non-operational): $skippedCount', emoji: '  •');
        _debugLog('Returning ${facilities.length} operational facilities', emoji: '✅');
        _debugLog('═══════════════════════════════════════', emoji: '🏁');
        
        return facilities;
      } catch (e) {
        _debugLog('❌ JSON parsing error: $e', emoji: '❌');
        _debugLog('Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}', emoji: '📄');
        _debugLog('═══════════════════════════════════════', emoji: '🏁');
        throw Exception('Failed to parse response: $e');
      }
    } else if (response.statusCode == 404) {
      _debugLog('⚠️ 404 Not Found - No facilities match query', emoji: '⚠️');
      _debugLog('═══════════════════════════════════════', emoji: '🏁');
      return [];
    } else {
      _debugLog('❌ HTTP Error ${response.statusCode}', emoji: '❌');
      _debugLog('Response body: ${response.body}', emoji: '📄');
      _debugLog('═══════════════════════════════════════', emoji: '🏁');
      throw Exception('Failed to fetch facilities (${response.statusCode})');
    }
  } catch (e) {
    _debugLog('❌ Exception caught: $e', emoji: '❌');
    _debugLog('Exception type: ${e.runtimeType}', emoji: '  📌');
    
    if (e.toString().contains('timed out')) {
      _debugLog('Timeout error detected', emoji: '⏱️');
      _debugLog('═══════════════════════════════════════', emoji: '🏁');
      rethrow;
    }
    
    _debugLog('═══════════════════════════════════════', emoji: '🏁');
    throw Exception('Network error: ${e.toString()}');
  }
}

  /// Get facility by MFL code from KMHFL API
  Future<KmhflFacility?> getFacilityByCode(String mflCode) async {
    if (mflCode.trim().isEmpty) {
      _debugLog('Empty MFL code provided', emoji: '⚠️');
      return null;
    }

    _debugLog('Fetching facility by MFL code: $mflCode', emoji: '🔍');

    try {
      final uri = Uri.parse('$baseUrl?code=$mflCode');
      _debugLog('URL: $uri', emoji: '🌐');
      
      final response = await http.get(uri).timeout(timeoutDuration);

      _debugLog('Response status: ${response.statusCode}', emoji: '📊');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = (data['results'] as List<dynamic>?) ?? [];
        
        _debugLog('Results found: ${results.length}', emoji: '📊');
        
        if (results.isNotEmpty) {
          final facility = KmhflFacility.fromJson(results[0] as Map<String, dynamic>);
          _debugLog('✅ Facility found: ${facility.name}', emoji: '✅');
          return facility;
        }
      }
      
      _debugLog('No facility found for code: $mflCode', emoji: '⚠️');
      return null;
    } catch (e) {
      _debugLog('❌ Error fetching facility by code: $e', emoji: '❌');
      return null;
    }
  }

  /// Upsert facility to local clinics table
  /// Returns the clinic_id from your database
  Future<String> upsertClinicToDatabase(KmhflFacility facility) async {
    _debugLog('═══════════════════════════════════════', emoji: '💾');
    _debugLog('Starting clinic upsert to database', emoji: '💾');
    _debugLog('Facility: ${facility.name}', emoji: '🏥');
    _debugLog('MFL Code: ${facility.code}', emoji: '🔢');
    _debugLog('County: ${facility.county}', emoji: '📍');
    _debugLog('Type: ${facility.facilityType}', emoji: '🏷️');
    _debugLog('Status: ${facility.operationStatus}', emoji: '⚡');
    
    try {
      _debugLog('Calling RPC function: upsert_clinic_from_kmhfl', emoji: '📡');
      
      final params = {
        'p_mfl_code': facility.code,
        'p_name': facility.name,
        'p_county': facility.county,
        'p_sub_county': facility.subCounty,
        'p_facility_type': facility.facilityType,
        'p_operation_status': facility.operationStatus,
      };
      
      _debugLog('RPC params:', emoji: '📋');
      params.forEach((key, value) {
        _debugLog('  $key: $value', emoji: '  •');
      });
      
      final startTime = DateTime.now();
      
      final response = await _supabase.rpc(
        'upsert_clinic_from_kmhfl',
        params: params,
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      _debugLog('RPC completed in ${duration.inMilliseconds}ms', emoji: '⏱️');
      _debugLog('Response type: ${response.runtimeType}', emoji: '📦');
      _debugLog('Response value: $response', emoji: '📄');

      final clinicId = response as String;
      _debugLog('✅ Clinic upserted successfully!', emoji: '✅');
      _debugLog('Clinic ID: $clinicId', emoji: '🆔');
      _debugLog('═══════════════════════════════════════', emoji: '🏁');
      
      return clinicId;
      
    } catch (e) {
      _debugLog('❌ RPC Error: $e', emoji: '❌');
      _debugLog('Error type: ${e.runtimeType}', emoji: '  📌');
      
      if (e is PostgrestException) {
        _debugLog('PostgrestException details:', emoji: '  📋');
        _debugLog('  Message: ${e.message}', emoji: '  •');
        _debugLog('  Code: ${e.code}', emoji: '  •');
        _debugLog('  Details: ${e.details}', emoji: '  •');
        _debugLog('  Hint: ${e.hint}', emoji: '  •');
      }
      
      // Fallback: try direct insert/update
      _debugLog('Attempting fallback: direct insert/update', emoji: '🔄');
      
      try {
        _debugLog('Checking for existing clinic with MFL code: ${facility.code}', emoji: '🔍');
        
        final existing = await _supabase
            .from('clinics')
            .select('id')
            .eq('mfl_code', facility.code)
            .maybeSingle();

        if (existing != null) {
          _debugLog('Existing clinic found, updating...', emoji: '🔄');
          _debugLog('Existing clinic ID: ${existing['id']}', emoji: '🆔');
          
          await _supabase
              .from('clinics')
              .update({
                'name': facility.name,
                'county': facility.county,
                'sub_county': facility.subCounty,
                'facility_type': facility.facilityType,
                'operation_status': facility.operationStatus,
                'last_synced_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', existing['id']);
          
          _debugLog('✅ Clinic updated successfully via fallback', emoji: '✅');
          _debugLog('═══════════════════════════════════════', emoji: '🏁');
          return existing['id'] as String;
        } else {
          _debugLog('No existing clinic found, inserting new...', emoji: '➕');
          
          final response = await _supabase
              .from('clinics')
              .insert({
                'mfl_code': facility.code,
                'name': facility.name,
                'county': facility.county,
                'sub_county': facility.subCounty,
                'facility_type': facility.facilityType,
                'operation_status': facility.operationStatus,
                'source': 'KMHFL',
                'verified': true,
                'last_synced_at': DateTime.now().toIso8601String(),
              })
              .select('id')
              .single();
          
          final newId = response['id'] as String;
          _debugLog('✅ New clinic inserted successfully via fallback', emoji: '✅');
          _debugLog('New clinic ID: $newId', emoji: '🆔');
          _debugLog('═══════════════════════════════════════', emoji: '🏁');
          return newId;
        }
      } catch (fallbackError) {
        _debugLog('❌ Fallback also failed: $fallbackError', emoji: '❌');
        _debugLog('Fallback error type: ${fallbackError.runtimeType}', emoji: '  📌');
        
        if (fallbackError is PostgrestException) {
          _debugLog('Fallback PostgrestException:', emoji: '  📋');
          _debugLog('  Message: ${fallbackError.message}', emoji: '  •');
          _debugLog('  Code: ${fallbackError.code}', emoji: '  •');
        }
        
        _debugLog('═══════════════════════════════════════', emoji: '🏁');
        rethrow;
      }
    }
  }

  /// Search and upsert - convenience method
  /// Searches KMHFL and ensures selected facility exists in local DB
  Future<ClinicRecord> searchAndUpsert(KmhflFacility facility) async {
    _debugLog('searchAndUpsert called for: ${facility.name}', emoji: '🔄');
    
    final clinicId = await upsertClinicToDatabase(facility);
    
    _debugLog('Creating ClinicRecord with ID: $clinicId', emoji: '📋');
    
    return ClinicRecord(
      id: clinicId,
      mflCode: facility.code,
      name: facility.name,
      county: facility.county,
      subCounty: facility.subCounty,
      facilityType: facility.facilityType,
      operationStatus: facility.operationStatus,
    );
  }

  /// Get clinic from local database by MFL code
  Future<ClinicRecord?> getLocalClinicByMflCode(String mflCode) async {
    _debugLog('Fetching local clinic by MFL code: $mflCode', emoji: '🔍');
    
    try {
      final response = await _supabase
          .from('clinics')
          .select()
          .eq('mfl_code', mflCode)
          .maybeSingle();

      if (response == null) {
        _debugLog('No local clinic found for MFL code: $mflCode', emoji: '⚠️');
        return null;
      }

      final clinic = ClinicRecord.fromJson(response);
      _debugLog('✅ Local clinic found: ${clinic.name}', emoji: '✅');
      return clinic;
    } catch (e) {
      _debugLog('❌ Error fetching local clinic: $e', emoji: '❌');
      return null;
    }
  }

  /// Sync facility from KMHFL to local database
  /// Useful for refreshing existing clinic data
  Future<void> syncClinicFromKmhfl(String mflCode) async {
    _debugLog('Syncing clinic from KMHFL: $mflCode', emoji: '🔄');
    
    final facility = await getFacilityByCode(mflCode);
    if (facility != null) {
      await upsertClinicToDatabase(facility);
      _debugLog('✅ Clinic synced successfully', emoji: '✅');
    } else {
      _debugLog('⚠️ Could not sync - facility not found in KMHFL', emoji: '⚠️');
    }
  }
}

/// Model for KMHFL facility data (from API)
class KmhflFacility {
  final String code;
  final String name;
  final String county;
  final String subCounty;
  final String facilityType;
  final String operationStatus;

  KmhflFacility({
    required this.code,
    required this.name,
    required this.county,
    required this.subCounty,
    required this.facilityType,
    required this.operationStatus,
  });

  factory KmhflFacility.fromJson(Map<String, dynamic> json) {
    if (_kDebugMode) {
      _debugLog('Parsing facility JSON:', emoji: '📦');
      _debugLog('  name: ${json['name']}', emoji: '  •');
      _debugLog('  code: ${json['code']}', emoji: '  •');
      _debugLog('  county: ${json['county']}', emoji: '  •');
    }
    
    return KmhflFacility(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Facility',
      county: json['county']?.toString() ?? '',
      subCounty: json['sub_county']?.toString() ?? '',
      facilityType: json['facility_type_name']?.toString() ?? '',
      operationStatus: json['operation_status_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'county': county,
      'sub_county': subCounty,
      'facility_type': facilityType,
      'operation_status': operationStatus,
    };
  }

  String get displaySubtitle => '$county — $facilityType (MFL: $code)';
  bool get isOperational => operationStatus == 'Operational';

  @override
  String toString() => 'KmhflFacility(name: $name, code: $code)';
}

/// Model for clinic record in local database
class ClinicRecord {
  final String id;
  final String mflCode;
  final String name;
  final String county;
  final String subCounty;
  final String facilityType;
  final String operationStatus;

  ClinicRecord({
    required this.id,
    required this.mflCode,
    required this.name,
    required this.county,
    required this.subCounty,
    required this.facilityType,
    required this.operationStatus,
  });

  factory ClinicRecord.fromJson(Map<String, dynamic> json) {
    return ClinicRecord(
      id: json['id']?.toString() ?? '',
      mflCode: json['mfl_code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      county: json['county']?.toString() ?? '',
      subCounty: json['sub_county']?.toString() ?? '',
      facilityType: json['facility_type']?.toString() ?? '',
      operationStatus: json['operation_status']?.toString() ?? 'Operational',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mfl_code': mflCode,
      'name': name,
      'county': county,
      'sub_county': subCounty,
      'facility_type': facilityType,
      'operation_status': operationStatus,
    };
  }
}