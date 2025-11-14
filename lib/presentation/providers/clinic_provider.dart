/// Updated Clinic Providers - With local database search and debug logging
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/clinic_service.dart';
import '../../data/services/kmhfl_service.dart';
import '../../domain/entities/clinic_entity.dart';
import 'providers.dart';

// ============================================================================
// EXISTING SUPABASE CLINIC SERVICE
// ============================================================================

/// Provider for the existing ClinicService (Supabase-based)
final clinicServiceProvider = Provider((ref) {
  return ClinicService(Supabase.instance.client);
});

/// Provider for getting current user's clinic from Supabase
final currentClinicProvider = FutureProvider<ClinicEntity?>((ref) async {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) async {
      if (user == null) return null;
      final service = ref.read(clinicServiceProvider);
      return await service.getCurrentClinic(user.id);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// ============================================================================
// KMHFL API SERVICE (for signup/search)
// ============================================================================

/// Provider for KMHFL API service
/// Used during healthcare provider signup to search facilities
final kmhflServiceProvider = Provider((ref) {
  return KmhflService(Supabase.instance.client);
});

/// Provider for searching facilities in KMHFL by query string
final kmhflSearchProvider = FutureProvider.family<List<KmhflFacility>, String>(
  (ref, query) async {
    if (query.trim().isEmpty) return [];
    
    final service = ref.read(kmhflServiceProvider);
    return service.searchFacilities(query);
  },
);

/// Provider for getting a specific facility by MFL code from KMHFL API
final kmhflFacilityByCodeProvider = FutureProvider.family<KmhflFacility?, String>(
  (ref, mflCode) async {
    if (mflCode.trim().isEmpty) return null;
    
    final service = ref.read(kmhflServiceProvider);
    return service.getFacilityByCode(mflCode);
  },
);

/// State provider for selected KMHFL facility during signup
/// This temporarily holds the facility selected from KMHFL search
final selectedKmhflFacilityProvider = StateProvider<KmhflFacility?>((ref) => null);

/// State provider for the clinic_id after upsert
/// This is what gets saved to users.clinic_id
final selectedClinicIdProvider = StateProvider<String?>((ref) => null);

// ============================================================================
// LOCAL DATABASE SEARCH PROVIDERS (NEW)
// ============================================================================

/// Provider for searching clinics in local database
/// Searches by name, MFL code, county, or sub-county
final clinicSearchProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, query) async {
    if (query.trim().isEmpty) {
      print('🔍 Clinic Search: Empty query, returning empty list');
      return [];
    }

    final supabase = Supabase.instance.client;
    final trimmedQuery = query.trim();
    
    print('🔍 ==========================================');
    print('🔍 Starting clinic search');
    print('🔍 Query: "$trimmedQuery"');
    print('🔍 Query length: ${trimmedQuery.length}');
    print('🔍 ==========================================');
    
    try {
      // Build the search query
      final searchPattern = '%$trimmedQuery%';
      print('🔍 Search pattern: "$searchPattern"');
      
      // Log the exact query being built
      print('🔍 Building query...');
      print('🔍 Table: clinics');
      print('🔍 Filters: OR condition on name, mfl_code, county, sub_county');
      
      final response = await supabase
          .from('clinics')
          .select()
          .or(
            'name.ilike.%$trimmedQuery%,'
            'mfl_code.ilike.%$trimmedQuery%,'
            'county.ilike.%$trimmedQuery%,'
            'sub_county.ilike.%$trimmedQuery%'
          )
          .order('name', ascending: true)
          .limit(50);

      print('🔍 ==========================================');
      print('🔍 Query executed successfully');
      print('🔍 Response type: ${response.runtimeType}');
      print('🔍 Results count: ${response.length}');
      
      if (response.isEmpty) {
        print('⚠️ No results found for query: "$trimmedQuery"');
        print('💡 Suggestions:');
        print('   - Check if clinics table has data');
        print('   - Verify column names match: name, mfl_code, county, sub_county');
        print('   - Try a broader search term');
      } else {
        print('✅ Found ${response.length} clinics');
        print('🔍 First result sample:');
        final firstResult = response[0];
        print('   - ID: ${firstResult['id']}');
        print('   - Name: ${firstResult['name']}');
        print('   - MFL Code: ${firstResult['mfl_code']}');
        print('   - County: ${firstResult['county']}');
        print('   - Sub County: ${firstResult['sub_county']}');
      }
      print('🔍 ==========================================');

      return List<Map<String, dynamic>>.from(response);
      
    } on PostgrestException catch (e) {
      print('❌ ==========================================');
      print('❌ PostgrestException occurred');
      print('❌ Message: ${e.message}');
      print('❌ Details: ${e.details}');
      print('❌ Hint: ${e.hint}');
      print('❌ Code: ${e.code}');
      print('❌ ==========================================');
      
      // Provide helpful error messages
      if (e.code == '42P01') {
        print('💡 Table "clinics" does not exist. Please check:');
        print('   1. Table name is correct');
        print('   2. Table has been created in Supabase');
        print('   3. RLS policies allow reading');
      } else if (e.code == '42703') {
        print('💡 Column does not exist. Please verify columns:');
        print('   - name, mfl_code, county, sub_county');
      }
      
      throw Exception('Database error: ${e.message}');
      
    } catch (e, stackTrace) {
      print('❌ ==========================================');
      print('❌ Unexpected error occurred');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error: $e');
      print('❌ Stack trace:');
      print(stackTrace);
      print('❌ ==========================================');
      
      throw Exception('Failed to search clinics: $e');
    }
  },
);

/// Provider for getting a single clinic by ID from local database
final clinicByIdProvider = FutureProvider.family<Map<String, dynamic>?, String>(
  (ref, clinicId) async {
    print('🔍 Fetching clinic by ID: $clinicId');
    
    final supabase = Supabase.instance.client;
    
    try {
      final response = await supabase
          .from('clinics')
          .select()
          .eq('id', clinicId)
          .maybeSingle();

      if (response == null) {
        print('⚠️ No clinic found with ID: $clinicId');
      } else {
        print('✅ Clinic found: ${response['name']}');
      }

      return response;
      
    } catch (e) {
      print('❌ Error fetching clinic by ID: $e');
      throw Exception('Failed to fetch clinic: $e');
    }
  },
);

/// Provider for getting all clinics (useful for initial load or showing popular ones)
final allClinicsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  
  try {
    final response = await supabase
        .from('clinics')
        .select()
        .order('name', ascending: true)
        .limit(100); // Get top 100 clinics

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    throw Exception('Failed to fetch clinics: $e');
  }
});

/// State provider for selected clinic during signup (from local database)
final selectedClinicProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// ============================================================================
// CLINIC UPSERT PROVIDER
// ============================================================================

/// Provider to upsert selected KMHFL facility to local clinics table
/// Returns the clinic_id that should be saved to users.clinic_id
final upsertSelectedClinicProvider = FutureProvider<String?>((ref) async {
  final selectedFacility = ref.watch(selectedKmhflFacilityProvider);
  
  if (selectedFacility == null) return null;
  
  final service = ref.read(kmhflServiceProvider);
  
  try {
    final clinicId = await service.upsertClinicToDatabase(selectedFacility);
    // Store the clinic_id for use in signup
    ref.read(selectedClinicIdProvider.notifier).state = clinicId;
    return clinicId;
  } catch (e) {
    print('❌ Error upserting clinic: $e');
    return null;
  }
});

// ============================================================================
// LOCAL CLINIC LOOKUP PROVIDERS
// ============================================================================

/// Provider to get clinic from local database by MFL code
final localClinicByMflCodeProvider = FutureProvider.family<ClinicRecord?, String>(
  (ref, mflCode) async {
    if (mflCode.trim().isEmpty) return null;
    
    final service = ref.read(kmhflServiceProvider);
    return service.getLocalClinicByMflCode(mflCode);
  },
);

/// Provider to check if user's clinic is still valid in KMHFL
final clinicVerificationStatusProvider = FutureProvider<ClinicVerificationStatus>((ref) async {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) async {
      if (user == null) {
        return ClinicVerificationStatus.notApplicable;
      }
      
      // Only check for healthcare providers
      if (user.role == 'mother') {
        return ClinicVerificationStatus.notApplicable;
      }
      
      // Get user's clinic_id
      final clinicId = user.clinicId; // Assuming you have this field
      if (clinicId == null) {
        return ClinicVerificationStatus.noClinicAssigned;
      }
      
      // Get clinic from database
      final clinic = await ref.read(clinicServiceProvider).getCurrentClinic(user.id);
      if (clinic == null) {
        return ClinicVerificationStatus.clinicNotFound;
      }
      
      // Check if clinic has MFL code
      final mflCode = clinic.mflCode; // Assuming your ClinicEntity has this
      if (mflCode == null || mflCode.isEmpty) {
        return ClinicVerificationStatus.missingMflCode;
      }
      
      // Verify against KMHFL
      try {
        final service = ref.read(kmhflServiceProvider);
        final kmhflFacility = await service.getFacilityByCode(mflCode);
        
        if (kmhflFacility == null) {
          return ClinicVerificationStatus.notFoundInKmhfl;
        }
        
        if (kmhflFacility.operationStatus != 'Operational') {
          return ClinicVerificationStatus.notOperational;
        }
        
        return ClinicVerificationStatus.verified;
      } catch (e) {
        print('❌ Error verifying clinic: $e');
        return ClinicVerificationStatus.verificationError;
      }
    },
    loading: () => ClinicVerificationStatus.checking,
    error: (_, __) => ClinicVerificationStatus.verificationError,
  );
});

// ============================================================================
// DEBUG PROVIDERS
// ============================================================================

/// Helper provider to test database connection
final testDatabaseConnectionProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  print('🔍 ==========================================');
  print('🔍 Testing database connection...');
  
  final supabase = Supabase.instance.client;
  
  try {
    // Test 1: Check if we can query the clinics table
    print('🔍 Test 1: Checking clinics table access...');
    
    // Use count to check if table is accessible
    final countResponse = await supabase
        .from('clinics')
        .select('id')
        .limit(1);
    
    print('✅ Clinics table accessible');
    
    // Test 2: Get table structure
    print('🔍 Test 2: Fetching sample record...');
    final sampleResponse = await supabase
        .from('clinics')
        .select()
        .limit(1)
        .maybeSingle();
    
    if (sampleResponse != null) {
      print('✅ Sample record retrieved');
      print('🔍 Available columns: ${sampleResponse.keys.join(', ')}');
      
      return {
        'status': 'success',
        'message': 'Database connection working',
        'has_data': true,
        'columns': sampleResponse.keys.toList(),
        'sample': sampleResponse,
      };
    } else {
      print('⚠️ Clinics table exists but has no data');
      
      return {
        'status': 'warning',
        'message': 'Table exists but is empty',
        'has_data': false,
      };
    }
    
  } on PostgrestException catch (e) {
    print('❌ PostgrestException: ${e.message}');
    print('❌ Code: ${e.code}');
    
    return {
      'status': 'error',
      'message': e.message,
      'code': e.code,
      'details': e.details,
    };
    
  } catch (e) {
    print('❌ Unexpected error: $e');
    
    return {
      'status': 'error',
      'message': e.toString(),
    };
  } finally {
    print('🔍 ==========================================');
  }
});

/// Provider to check RLS policies
final checkRlsPoliciesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  print('🔍 ==========================================');
  print('🔍 Checking RLS policies for clinics table...');
  
  final supabase = Supabase.instance.client;
  
  try {
    // Try to read without authentication context
    final response = await supabase
        .from('clinics')
        .select('id')
        .limit(1);
    
    print('✅ RLS policies allow reading');
    
    return {
      'status': 'success',
      'message': 'RLS policies allow reading',
      'can_read': true,
    };
    
  } on PostgrestException catch (e) {
    if (e.code == '42501') {
      print('❌ RLS policy violation');
      print('💡 The clinics table has RLS enabled but no policy allows reading');
      print('💡 Solution: Add a policy like:');
      print('   CREATE POLICY "Allow public read on clinics"');
      print('   ON clinics FOR SELECT');
      print('   TO authenticated, anon');
      print('   USING (true);');
    }
    
    return {
      'status': 'error',
      'message': e.message,
      'code': e.code,
      'rls_issue': e.code == '42501',
    };
    
  } catch (e) {
    return {
      'status': 'error',
      'message': e.toString(),
    };
  } finally {
    print('🔍 ==========================================');
  }
});

// ============================================================================
// CLINIC STATISTICS PROVIDERS
// ============================================================================

/// Provider to get clinic statistics
final clinicStatsProvider = FutureProvider.family<Map<String, dynamic>?, String>(
  (ref, clinicId) async {
    if (clinicId.isEmpty) return null;
    
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.rpc('get_clinic_stats', params: {
        'p_clinic_id': clinicId,
      });
      
      return response as Map<String, dynamic>?;
    } catch (e) {
      print('❌ Error fetching clinic stats: $e');
      return null;
    }
  },
);

/// Provider to get all providers in a clinic
final clinicProvidersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, clinicId) async {
    if (clinicId.isEmpty) return [];
    
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.rpc('get_clinic_providers', params: {
        'p_clinic_id': clinicId,
      }) as List<dynamic>;
      
      return response.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('❌ Error fetching clinic providers: $e');
      return [];
    }
  },
);

// ============================================================================
// ENUMS AND EXTENSIONS
// ============================================================================

/// Enum for clinic verification status
enum ClinicVerificationStatus {
  notApplicable,      // User is not a healthcare provider
  noClinicAssigned,   // Provider has no clinic_id
  clinicNotFound,     // clinic_id doesn't exist in database
  missingMflCode,     // Clinic exists but has no MFL code
  notFoundInKmhfl,    // MFL code not found in KMHFL
  notOperational,     // Facility exists but not operational
  verified,           // Facility verified and operational
  checking,           // Currently checking
  verificationError,  // Error during verification
}

extension ClinicVerificationStatusX on ClinicVerificationStatus {
  String get displayText {
    switch (this) {
      case ClinicVerificationStatus.notApplicable:
        return 'Not Applicable';
      case ClinicVerificationStatus.noClinicAssigned:
        return 'No Clinic Assigned';
      case ClinicVerificationStatus.clinicNotFound:
        return 'Clinic Not Found';
      case ClinicVerificationStatus.missingMflCode:
        return 'MFL Code Missing';
      case ClinicVerificationStatus.notFoundInKmhfl:
        return 'Facility Not Found in KMHFL';
      case ClinicVerificationStatus.notOperational:
        return 'Facility Not Operational';
      case ClinicVerificationStatus.verified:
        return 'Verified';
      case ClinicVerificationStatus.checking:
        return 'Checking...';
      case ClinicVerificationStatus.verificationError:
        return 'Verification Error';
    }
  }
  
  bool get isVerified => this == ClinicVerificationStatus.verified;
  
  bool get hasIssue => this == ClinicVerificationStatus.noClinicAssigned ||
                       this == ClinicVerificationStatus.clinicNotFound ||
                       this == ClinicVerificationStatus.missingMflCode ||
                       this == ClinicVerificationStatus.notFoundInKmhfl ||
                       this == ClinicVerificationStatus.notOperational;
}