/// Pregnancy Provider (Presentation Layer)
/// Exposes pregnancy data reactively to the UI
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/pregnancy_entity.dart';
import '../../data/services/pregnancy_service.dart';
import 'providers.dart'; // Import to access currentUserProvider

/// Provider for PregnancyService
final pregnancyServiceProvider = Provider<PregnancyService>((ref) {
  return PregnancyService(Supabase.instance.client);
});

/// Provider for active pregnancy of current user
final activePregnancyProvider = FutureProvider.autoDispose
    .family<PregnancyEntity?, String>((ref, motherId) async {
  final service = ref.watch(pregnancyServiceProvider);
  return await service.getActivePregnancy(motherId);
});

/// NEW: Provider for current logged-in user's pregnancy
/// This is what your home and pregnancy screens need
final currentPregnancyProvider = FutureProvider.autoDispose<PregnancyEntity?>((ref) async {
  // Get the current user first
  final currentUser = await ref.watch(currentUserProvider.future);
  
  if (currentUser == null) {
    return null;
  }

  // Get their active pregnancy
  final service = ref.watch(pregnancyServiceProvider);
  return await service.getActivePregnancy(currentUser.id);
});

/// Alternative: Stream version for real-time updates of current user's pregnancy
final currentPregnancyStreamProvider = StreamProvider.autoDispose<PregnancyEntity?>((ref) async* {
  final currentUser = await ref.watch(currentUserProvider.future);
  
  if (currentUser == null) {
    yield null;
    return;
  }

  final supabase = Supabase.instance.client;
  
  yield* supabase
      .from('pregnancies')
      .stream(primaryKey: ['id'])
      .map((data) {
        // Filter for this user's active pregnancy
        final filtered = data.where((row) => 
          row['mother_id'] == currentUser.id && 
          row['is_active'] == true
        ).toList();
        
        if (filtered.isEmpty) return null;
        
        // Sort by created_at to get the most recent
        filtered.sort((a, b) => 
          DateTime.parse(b['created_at'] as String)
              .compareTo(DateTime.parse(a['created_at'] as String))
        );
        
        return _mapToEntity(filtered.first);
      });
});

/// Provider for all pregnancies of a mother (history)
final pregnancyHistoryProvider = FutureProvider.autoDispose
    .family<List<PregnancyEntity>, String>((ref, motherId) async {
  final service = ref.watch(pregnancyServiceProvider);
  return await service.getAllPregnancies(motherId);
});

/// Provider for a specific pregnancy by ID
final pregnancyByIdProvider = FutureProvider.autoDispose
    .family<PregnancyEntity?, String>((ref, pregnancyId) async {
  final service = ref.watch(pregnancyServiceProvider);
  return await service.getPregnancyById(pregnancyId);
});

/// State notifier for pregnancy operations
class PregnancyNotifier extends StateNotifier<AsyncValue<PregnancyEntity?>> {
  final PregnancyService _service;
  final String motherId;

  PregnancyNotifier(this._service, this.motherId)
      : super(const AsyncValue.loading()) {
    _loadActivePregnancy();
  }

  /// Load active pregnancy
  Future<void> _loadActivePregnancy() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _service.getActivePregnancy(motherId);
    });
  }

  /// Refresh pregnancy data
  Future<void> refresh() async {
    await _loadActivePregnancy();
  }

  /// Create a new pregnancy
  Future<bool> createPregnancy({
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
      state = const AsyncValue.loading();
      
      final pregnancy = await _service.createPregnancy(
        motherId: motherId,
        expectedDelivery: expectedDelivery,
        lmp: lmp,
        eddConfirmedBy: eddConfirmedBy,
        gravida: gravida,
        parity: parity,
        riskFlags: riskFlags,
        bloodGroup: bloodGroup,
        rhesus: rhesus,
        hivStatus: hivStatus,
        syphilisStatus: syphilisStatus,
        hepatitisB: hepatitisB,
        notes: notes,
      );

      state = AsyncValue.data(pregnancy);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Update pregnancy details
  Future<bool> updatePregnancy(PregnancyEntity pregnancy) async {
    try {
      state = const AsyncValue.loading();
      
      final updated = await _service.updatePregnancy(
        pregnancy.id,
        pregnancy,
      );

      state = AsyncValue.data(updated);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Update expected delivery date
  Future<bool> updateExpectedDelivery(
    String pregnancyId,
    DateTime newDate,
  ) async {
    final current = state.value;
    if (current == null) return false;

    final updated = current.copyWith(expectedDelivery: newDate);
    return await updatePregnancy(updated);
  }

  /// Update risk flags
  Future<bool> updateRiskFlags(
    String pregnancyId,
    List<String> riskFlags,
  ) async {
    try {
      state = const AsyncValue.loading();
      
      final updated = await _service.updateRiskFlags(pregnancyId, riskFlags);
      state = AsyncValue.data(updated);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Complete pregnancy with outcome
  Future<bool> completePregnancy({
    required String pregnancyId,
    required String outcome,
    required DateTime outcomeDate,
    DateTime? actualDelivery,
    String? deliveryPlace,
    String? notes,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final completed = await _service.completePregnancy(
        pregnancyId: pregnancyId,
        outcome: outcome,
        outcomeDate: outcomeDate,
        actualDelivery: actualDelivery,
        deliveryPlace: deliveryPlace,
        notes: notes,
      );

      state = AsyncValue.data(completed);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Deactivate pregnancy
  Future<bool> deactivatePregnancy(String pregnancyId) async {
    try {
      state = const AsyncValue.loading();
      await _service.deactivatePregnancy(pregnancyId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// Provider for pregnancy notifier
final pregnancyNotifierProvider = StateNotifierProvider.autoDispose
    .family<PregnancyNotifier, AsyncValue<PregnancyEntity?>, String>(
  (ref, motherId) {
    final service = ref.watch(pregnancyServiceProvider);
    return PregnancyNotifier(service, motherId);
  },
);

/// Computed provider for pregnancy status
final pregnancyStatusProvider = Provider.autoDispose
    .family<String?, String>((ref, motherId) {
  final pregnancy = ref.watch(activePregnancyProvider(motherId));
  
  return pregnancy.when(
    data: (p) => p?.statusText,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Computed provider for trimester
final trimesterProvider = Provider.autoDispose
    .family<int?, String>((ref, motherId) {
  final pregnancy = ref.watch(activePregnancyProvider(motherId));
  
  return pregnancy.when(
    data: (p) => p?.trimester,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Computed provider for days until delivery
final daysUntilDeliveryProvider = Provider.autoDispose
    .family<int?, String>((ref, motherId) {
  final pregnancy = ref.watch(activePregnancyProvider(motherId));
  
  return pregnancy.when(
    data: (p) => p?.daysUntilDelivery,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Computed provider for high risk status
final isHighRiskProvider = Provider.autoDispose
    .family<bool, String>((ref, motherId) {
  final pregnancy = ref.watch(activePregnancyProvider(motherId));
  
  return pregnancy.when(
    data: (p) => p?.isHighRisk ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Stream provider for real-time pregnancy updates
/// Uses the new Supabase stream API with filtering in the map function
final pregnancyStreamProvider = StreamProvider.autoDispose
    .family<PregnancyEntity?, String>((ref, motherId) {
  final supabase = Supabase.instance.client;
  
  return supabase
      .from('pregnancies')
      .stream(primaryKey: ['id'])
      .map((data) {
        // Filter for this mother's active pregnancy
        final filtered = data.where((row) => 
          row['mother_id'] == motherId && 
          row['is_active'] == true
        ).toList();
        
        if (filtered.isEmpty) return null;
        
        // Sort by created_at to get the most recent
        filtered.sort((a, b) => 
          DateTime.parse(b['created_at'] as String)
              .compareTo(DateTime.parse(a['created_at'] as String))
        );
        
        return _mapToEntity(filtered.first);
      });
});

/// Helper function to map JSON to entity
PregnancyEntity _mapToEntity(Map<String, dynamic> json) {
  // Handle risk_flags which could be JSONB array or List
  List<String> riskFlags = [];
  if (json['risk_flags'] != null) {
    if (json['risk_flags'] is List) {
      riskFlags = (json['risk_flags'] as List).cast<String>();
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