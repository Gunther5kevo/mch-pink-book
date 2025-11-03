/// Child Provider
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/child_entity.dart';
import '../../data/services/child_service.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Child service provider
final childServiceProvider = Provider<ChildService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ChildService(supabase);
});

// State class for children list
class ChildrenState {
  final List<ChildEntity> children;
  final bool isLoading;
  final String? error;

  const ChildrenState({
    this.children = const [],
    this.isLoading = false,
    this.error,
  });

  ChildrenState copyWith({
    List<ChildEntity>? children,
    bool? isLoading,
    String? error,
  }) {
    return ChildrenState(
      children: children ?? this.children,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Children list provider (for a specific mother)
class ChildrenNotifier extends StateNotifier<ChildrenState> {
  final ChildService _childService;
  final String motherId;

  ChildrenNotifier(this._childService, this.motherId)
      : super(const ChildrenState()) {
    loadChildren();
  }

  /// Load all children for the mother
  Future<void> loadChildren() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final children = await _childService.getMotherChildren(motherId);
      state = state.copyWith(children: children, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh children list
  Future<void> refreshChildren() async {
    await loadChildren();
  }

  /// Add a new child
  Future<bool> addChild({
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
      final newChild = await _childService.createChild(
        motherId: motherId,
        name: name,
        dateOfBirth: dateOfBirth,
        gender: gender,
        pregnancyId: pregnancyId,
        birthWeight: birthWeight,
        birthLength: birthLength,
        headCircumference: headCircumference,
        birthPlace: birthPlace,
        birthCertificateNo: birthCertificateNo,
        apgarScore: apgarScore,
        birthComplications: birthComplications,
        photoUrl: photoUrl,
      );

      state = state.copyWith(
        children: [...state.children, newChild],
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Update child information
  Future<bool> updateChild({
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
      final updatedChild = await _childService.updateChild(
        childId: childId,
        name: name,
        dateOfBirth: dateOfBirth,
        gender: gender,
        birthWeight: birthWeight,
        birthLength: birthLength,
        headCircumference: headCircumference,
        birthPlace: birthPlace,
        birthCertificateNo: birthCertificateNo,
        apgarScore: apgarScore,
        birthComplications: birthComplications,
        photoUrl: photoUrl,
      );

      final updatedList = state.children.map((child) {
        return child.id == childId ? updatedChild : child;
      }).toList();

      state = state.copyWith(children: updatedList);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete a child
  Future<bool> deleteChild(String childId) async {
    try {
      await _childService.deleteChild(childId);
      
      final updatedList = state.children
          .where((child) => child.id != childId)
          .toList();
      
      state = state.copyWith(children: updatedList);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Filter children by age category
  Future<void> filterByAgeCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final children = await _childService.getChildrenByAgeCategory(
        motherId,
        category,
      );
      state = state.copyWith(children: children, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Search children by name
  Future<void> searchChildren(String query) async {
    if (query.isEmpty) {
      await loadChildren();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final children = await _childService.searchChildren(motherId, query);
      state = state.copyWith(children: children, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Upload child photo
/// Upload child photo
Future<String?> uploadChildPhoto(
  String childId,
  List<int> fileBytes,
  String fileExtension,
) async {
  try {
    final photoUrl = await _childService.uploadChildPhoto(
      childId,
      fileBytes,
      fileExtension,
    );
    
    // Update the child in the list
    final updatedList = state.children.map((child) {
      if (child.id == childId) {
        return child.copyWith(photoUrl: photoUrl);
      }
      return child;
    }).toList();
    
    state = state.copyWith(children: updatedList);
    return photoUrl;
  } catch (e) {
    state = state.copyWith(error: e.toString());
    return null;
  }
}

  /// Get filtered children (local filtering)
  List<ChildEntity> getFilteredChildren(String filter) {
    if (filter == 'All') return state.children;
    
    return state.children.where((child) {
      final months = child.ageInMonths;
      switch (filter.toLowerCase()) {
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
  }
}

// Provider for children list
final childrenProvider = StateNotifierProvider.family<ChildrenNotifier, ChildrenState, String>(
  (ref, motherId) {
    final childService = ref.watch(childServiceProvider);
    return ChildrenNotifier(childService, motherId);
  },
);

// Single child provider
final childProvider = FutureProvider.family<ChildEntity?, String>((ref, childId) async {
  final childService = ref.watch(childServiceProvider);
  return await childService.getChildById(childId);
});

// Child by QR code provider
final childByQrProvider = FutureProvider.family<ChildEntity?, String>((ref, qrCode) async {
  final childService = ref.watch(childServiceProvider);
  return await childService.getChildByQrCode(qrCode);
});