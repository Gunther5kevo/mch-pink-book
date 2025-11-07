/// Child Provider
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart'; // Required for ListEquality

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildrenState &&
        const ListEquality().equals(other.children, children) &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(
        const ListEquality().hash(children),
        isLoading,
        error,
      );
}

// === MOTHER-SPECIFIC NOTIFIER ===
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
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshChildren() => loadChildren();

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

      state = state.copyWith(children: [...state.children, newChild]);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

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

      final updatedList = state.children.map((c) => c.id == childId ? updatedChild : c).toList();
      state = state.copyWith(children: updatedList);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteChild(String childId) async {
    try {
      await _childService.deleteChild(childId);
      final updatedList = state.children.where((c) => c.id != childId).toList();
      state = state.copyWith(children: updatedList);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> filterByAgeCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final children = await _childService.getChildrenByAgeCategory(motherId, category);
      state = state.copyWith(children: children, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

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
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<String?> uploadChildPhoto(
    String childId,
    List<int> fileBytes,
    String fileExtension,
  ) async {
    try {
      final photoUrl = await _childService.uploadChildPhoto(childId, fileBytes, fileExtension);
      final updatedList = state.children.map((c) {
        return c.id == childId ? c.copyWith(photoUrl: photoUrl) : c;
      }).toList();
      state = state.copyWith(children: updatedList);
      return photoUrl;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

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

// === ALL CHILDREN NOTIFIER (FOR NURSE) ===
class AllChildrenNotifier extends StateNotifier<ChildrenState> {
  final ChildService _childService;

  AllChildrenNotifier(this._childService) : super(const ChildrenState()) {
    loadAllChildren();
  }

  Future<void> loadAllChildren() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final children = await _childService.getAllChildren();
      state = state.copyWith(children: children, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => loadAllChildren();
}

// === PROVIDERS ===

// For mother-specific children
final childrenProvider = StateNotifierProvider.family<ChildrenNotifier, ChildrenState, String>(
  (ref, motherId) {
    final childService = ref.watch(childServiceProvider);
    return ChildrenNotifier(childService, motherId);
  },
);

// For ALL children (nurse/clinic view)
final allChildrenProvider = StateNotifierProvider<AllChildrenNotifier, ChildrenState>((ref) {
  final childService = ref.watch(childServiceProvider);
  return AllChildrenNotifier(childService);
});

// Single child by ID
final childProvider = FutureProvider.family<ChildEntity?, String>((ref, childId) async {
  final childService = ref.watch(childServiceProvider);
  return await childService.getChildById(childId);
});

// Child by QR code
final childByQrProvider = FutureProvider.family<ChildEntity?, String>((ref, qrCode) async {
  final childService = ref.watch(childServiceProvider);
  return await childService.getChildByQrCode(qrCode);
});