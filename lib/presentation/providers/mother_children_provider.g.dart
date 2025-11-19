// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mother_children_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$motherChildrenHash() => r'08e0a2209c4a7ef856bba4b8961c3557c7a4fd64';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Current mother's children with immunization status
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [motherChildren].
@ProviderFor(motherChildren)
final motherChildrenProvider =
    AutoDisposeFutureProvider<List<MotherChildStatus>>.internal(
  motherChildren,
  name: r'motherChildrenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$motherChildrenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MotherChildrenRef
    = AutoDisposeFutureProviderRef<List<MotherChildStatus>>;
String _$childStatusHash() => r'baac6dd8ec0ad01496870e8a5ff8d6230896cb60';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Single child status by ID
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [childStatus].
@ProviderFor(childStatus)
const childStatusProvider = ChildStatusFamily();

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Single child status by ID
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [childStatus].
class ChildStatusFamily extends Family<AsyncValue<MotherChildStatus?>> {
  /// ═══════════════════════════════════════════════════════════════════════
  /// Provider: Single child status by ID
  /// ═══════════════════════════════════════════════════════════════════════
  ///
  /// Copied from [childStatus].
  const ChildStatusFamily();

  /// ═══════════════════════════════════════════════════════════════════════
  /// Provider: Single child status by ID
  /// ═══════════════════════════════════════════════════════════════════════
  ///
  /// Copied from [childStatus].
  ChildStatusProvider call(
    String childId,
  ) {
    return ChildStatusProvider(
      childId,
    );
  }

  @override
  ChildStatusProvider getProviderOverride(
    covariant ChildStatusProvider provider,
  ) {
    return call(
      provider.childId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'childStatusProvider';
}

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Single child status by ID
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [childStatus].
class ChildStatusProvider
    extends AutoDisposeFutureProvider<MotherChildStatus?> {
  /// ═══════════════════════════════════════════════════════════════════════
  /// Provider: Single child status by ID
  /// ═══════════════════════════════════════════════════════════════════════
  ///
  /// Copied from [childStatus].
  ChildStatusProvider(
    String childId,
  ) : this._internal(
          (ref) => childStatus(
            ref as ChildStatusRef,
            childId,
          ),
          from: childStatusProvider,
          name: r'childStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$childStatusHash,
          dependencies: ChildStatusFamily._dependencies,
          allTransitiveDependencies:
              ChildStatusFamily._allTransitiveDependencies,
          childId: childId,
        );

  ChildStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.childId,
  }) : super.internal();

  final String childId;

  @override
  Override overrideWith(
    FutureOr<MotherChildStatus?> Function(ChildStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChildStatusProvider._internal(
        (ref) => create(ref as ChildStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        childId: childId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MotherChildStatus?> createElement() {
    return _ChildStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChildStatusProvider && other.childId == childId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, childId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChildStatusRef on AutoDisposeFutureProviderRef<MotherChildStatus?> {
  /// The parameter `childId` of this provider.
  String get childId;
}

class _ChildStatusProviderElement
    extends AutoDisposeFutureProviderElement<MotherChildStatus?>
    with ChildStatusRef {
  _ChildStatusProviderElement(super.provider);

  @override
  String get childId => (origin as ChildStatusProvider).childId;
}

String _$overdueImmunizationsCountHash() =>
    r'ef15504be994dc8fd82b43f44e6544367f47a8e3';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Count of children with overdue immunizations
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [overdueImmunizationsCount].
@ProviderFor(overdueImmunizationsCount)
final overdueImmunizationsCountProvider =
    AutoDisposeFutureProvider<int>.internal(
  overdueImmunizationsCount,
  name: r'overdueImmunizationsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overdueImmunizationsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OverdueImmunizationsCountRef = AutoDisposeFutureProviderRef<int>;
String _$nextImmunizationHash() => r'123d21027e49518997cceb344479738db114ef7d';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Next upcoming immunization
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [nextImmunization].
@ProviderFor(nextImmunization)
final nextImmunizationProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
  nextImmunization,
  name: r'nextImmunizationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextImmunizationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NextImmunizationRef
    = AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
