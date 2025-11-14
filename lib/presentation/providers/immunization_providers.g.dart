// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'immunization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$immunizationsHash() => r'cbb88d61d44caddf6d5e6c3157ad775def5eec72';

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
/// EXISTING: Per-child immunization tracking
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [immunizations].
@ProviderFor(immunizations)
const immunizationsProvider = ImmunizationsFamily();

/// ═══════════════════════════════════════════════════════════════════════
/// EXISTING: Per-child immunization tracking
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [immunizations].
class ImmunizationsFamily extends Family<AsyncValue<List<ImmunizationEntity>>> {
  /// ═══════════════════════════════════════════════════════════════════════
  /// EXISTING: Per-child immunization tracking
  /// ═══════════════════════════════════════════════════════════════════════
  ///
  /// Copied from [immunizations].
  const ImmunizationsFamily();

  /// ═══════════════════════════════════════════════════════════════════════
  /// EXISTING: Per-child immunization tracking
  /// ═══════════════════════════════════════════════════════════════════════
  ///
  /// Copied from [immunizations].
  ImmunizationsProvider call(
    String childId,
  ) {
    return ImmunizationsProvider(
      childId,
    );
  }

  @override
  ImmunizationsProvider getProviderOverride(
    covariant ImmunizationsProvider provider,
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
  String? get name => r'immunizationsProvider';
}

/// ═══════════════════════════════════════════════════════════════════════
/// EXISTING: Per-child immunization tracking
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [immunizations].
class ImmunizationsProvider
    extends AutoDisposeFutureProvider<List<ImmunizationEntity>> {
  /// ═══════════════════════════════════════════════════════════════════════
  /// EXISTING: Per-child immunization tracking
  /// ═══════════════════════════════════════════════════════════════════════
  ///
  /// Copied from [immunizations].
  ImmunizationsProvider(
    String childId,
  ) : this._internal(
          (ref) => immunizations(
            ref as ImmunizationsRef,
            childId,
          ),
          from: immunizationsProvider,
          name: r'immunizationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$immunizationsHash,
          dependencies: ImmunizationsFamily._dependencies,
          allTransitiveDependencies:
              ImmunizationsFamily._allTransitiveDependencies,
          childId: childId,
        );

  ImmunizationsProvider._internal(
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
    FutureOr<List<ImmunizationEntity>> Function(ImmunizationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImmunizationsProvider._internal(
        (ref) => create(ref as ImmunizationsRef),
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
  AutoDisposeFutureProviderElement<List<ImmunizationEntity>> createElement() {
    return _ImmunizationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImmunizationsProvider && other.childId == childId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, childId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ImmunizationsRef
    on AutoDisposeFutureProviderRef<List<ImmunizationEntity>> {
  /// The parameter `childId` of this provider.
  String get childId;
}

class _ImmunizationsProviderElement
    extends AutoDisposeFutureProviderElement<List<ImmunizationEntity>>
    with ImmunizationsRef {
  _ImmunizationsProviderElement(super.provider);

  @override
  String get childId => (origin as ImmunizationsProvider).childId;
}

String _$clinicChildrenImmunizationStatusHash() =>
    r'9f31bb24ace367da8fc22bf16088340afdf51c2d';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: All children in clinic with immunization status
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [clinicChildrenImmunizationStatus].
@ProviderFor(clinicChildrenImmunizationStatus)
final clinicChildrenImmunizationStatusProvider =
    AutoDisposeFutureProvider<List<ChildImmunizationStatus>>.internal(
  clinicChildrenImmunizationStatus,
  name: r'clinicChildrenImmunizationStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clinicChildrenImmunizationStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ClinicChildrenImmunizationStatusRef
    = AutoDisposeFutureProviderRef<List<ChildImmunizationStatus>>;
String _$immunizationsDueSummaryHash() =>
    r'bba7834f1b68b45bad8b66f125d2779964966b6e';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Immunization summary for dashboard
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [immunizationsDueSummary].
@ProviderFor(immunizationsDueSummary)
final immunizationsDueSummaryProvider =
    AutoDisposeFutureProvider<ImmunizationsDueSummary>.internal(
  immunizationsDueSummary,
  name: r'immunizationsDueSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$immunizationsDueSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImmunizationsDueSummaryRef
    = AutoDisposeFutureProviderRef<ImmunizationsDueSummary>;
String _$immunizationsDueTodayHash() =>
    r'f75ae8fafe7fa0e2dacd2bf2d687ce74f83227c0';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Immunizations due TODAY (for top stats card)
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [immunizationsDueToday].
@ProviderFor(immunizationsDueToday)
final immunizationsDueTodayProvider = AutoDisposeFutureProvider<int>.internal(
  immunizationsDueToday,
  name: r'immunizationsDueTodayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$immunizationsDueTodayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImmunizationsDueTodayRef = AutoDisposeFutureProviderRef<int>;
String _$overdueImmunizationsHash() =>
    r'3940900b18a67f8c27d5fd7f6b06aad28296018b';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Children with overdue immunizations (for detailed list)
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [overdueImmunizations].
@ProviderFor(overdueImmunizations)
final overdueImmunizationsProvider =
    AutoDisposeFutureProvider<List<ChildImmunizationStatus>>.internal(
  overdueImmunizations,
  name: r'overdueImmunizationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overdueImmunizationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OverdueImmunizationsRef
    = AutoDisposeFutureProviderRef<List<ChildImmunizationStatus>>;
String _$immunizationsDueThisWeekHash() =>
    r'5bb38bdbd269420f62a2d032c2d8c488eb2be860';

/// ═══════════════════════════════════════════════════════════════════════
/// Provider: Children with immunizations due this week (for detailed list)
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [immunizationsDueThisWeek].
@ProviderFor(immunizationsDueThisWeek)
final immunizationsDueThisWeekProvider =
    AutoDisposeFutureProvider<List<ChildImmunizationStatus>>.internal(
  immunizationsDueThisWeek,
  name: r'immunizationsDueThisWeekProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$immunizationsDueThisWeekHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImmunizationsDueThisWeekRef
    = AutoDisposeFutureProviderRef<List<ChildImmunizationStatus>>;
String _$immunizationNotifierHash() =>
    r'a40bef527ed4629b674282c5eef516dd7d990fb5';

/// See also [ImmunizationNotifier].
@ProviderFor(ImmunizationNotifier)
final immunizationNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ImmunizationNotifier, void>.internal(
  ImmunizationNotifier.new,
  name: r'immunizationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$immunizationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ImmunizationNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
