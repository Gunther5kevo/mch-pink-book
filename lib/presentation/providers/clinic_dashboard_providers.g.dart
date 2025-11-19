// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clinicStatsHash() => r'98c46dd15faa47c047b60925075d228a1b8782ac';

/// ═══════════════════════════════════════════════════════════════════════
/// 📊 MAIN CLINIC STATS PROVIDER
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [clinicStats].
@ProviderFor(clinicStats)
final clinicStatsProvider = AutoDisposeFutureProvider<ClinicStats>.internal(
  clinicStats,
  name: r'clinicStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clinicStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ClinicStatsRef = AutoDisposeFutureProviderRef<ClinicStats>;
String _$activePregnanciesHash() => r'ff2ae85ab704512b5e5a38e5a435c5b3d1ded412';

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

/// FIXED: Get pregnancies via proper JOIN with fallback
///
/// Copied from [activePregnancies].
@ProviderFor(activePregnancies)
const activePregnanciesProvider = ActivePregnanciesFamily();

/// FIXED: Get pregnancies via proper JOIN with fallback
///
/// Copied from [activePregnancies].
class ActivePregnanciesFamily
    extends Family<AsyncValue<List<PregnancyWithMother>>> {
  /// FIXED: Get pregnancies via proper JOIN with fallback
  ///
  /// Copied from [activePregnancies].
  const ActivePregnanciesFamily();

  /// FIXED: Get pregnancies via proper JOIN with fallback
  ///
  /// Copied from [activePregnancies].
  ActivePregnanciesProvider call(
    PregnancyFilter filter,
  ) {
    return ActivePregnanciesProvider(
      filter,
    );
  }

  @override
  ActivePregnanciesProvider getProviderOverride(
    covariant ActivePregnanciesProvider provider,
  ) {
    return call(
      provider.filter,
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
  String? get name => r'activePregnanciesProvider';
}

/// FIXED: Get pregnancies via proper JOIN with fallback
///
/// Copied from [activePregnancies].
class ActivePregnanciesProvider
    extends AutoDisposeFutureProvider<List<PregnancyWithMother>> {
  /// FIXED: Get pregnancies via proper JOIN with fallback
  ///
  /// Copied from [activePregnancies].
  ActivePregnanciesProvider(
    PregnancyFilter filter,
  ) : this._internal(
          (ref) => activePregnancies(
            ref as ActivePregnanciesRef,
            filter,
          ),
          from: activePregnanciesProvider,
          name: r'activePregnanciesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activePregnanciesHash,
          dependencies: ActivePregnanciesFamily._dependencies,
          allTransitiveDependencies:
              ActivePregnanciesFamily._allTransitiveDependencies,
          filter: filter,
        );

  ActivePregnanciesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final PregnancyFilter filter;

  @override
  Override overrideWith(
    FutureOr<List<PregnancyWithMother>> Function(ActivePregnanciesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActivePregnanciesProvider._internal(
        (ref) => create(ref as ActivePregnanciesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PregnancyWithMother>> createElement() {
    return _ActivePregnanciesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivePregnanciesProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ActivePregnanciesRef
    on AutoDisposeFutureProviderRef<List<PregnancyWithMother>> {
  /// The parameter `filter` of this provider.
  PregnancyFilter get filter;
}

class _ActivePregnanciesProviderElement
    extends AutoDisposeFutureProviderElement<List<PregnancyWithMother>>
    with ActivePregnanciesRef {
  _ActivePregnanciesProviderElement(super.provider);

  @override
  PregnancyFilter get filter => (origin as ActivePregnanciesProvider).filter;
}

String _$highRiskMothersHash() => r'cf360d22a145aeac08a7f4009ff00a29d9529a7e';

/// ═══════════════════════════════════════════════════════════════════════
/// ⚠️ HIGH-RISK MOTHERS
/// ═══════════════════════════════════════════════════════════════════════
///
/// Copied from [highRiskMothers].
@ProviderFor(highRiskMothers)
final highRiskMothersProvider =
    AutoDisposeFutureProvider<List<PregnancyWithMother>>.internal(
  highRiskMothers,
  name: r'highRiskMothersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highRiskMothersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HighRiskMothersRef
    = AutoDisposeFutureProviderRef<List<PregnancyWithMother>>;
String _$highRiskBreakdownHash() => r'a5923e35fb4a30aed43ebb1bde9fce9ed7a7ad5f';

/// See also [highRiskBreakdown].
@ProviderFor(highRiskBreakdown)
final highRiskBreakdownProvider =
    AutoDisposeFutureProvider<Map<String, int>>.internal(
  highRiskBreakdown,
  name: r'highRiskBreakdownProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highRiskBreakdownHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HighRiskBreakdownRef = AutoDisposeFutureProviderRef<Map<String, int>>;
String _$defaultersHash() => r'23eb6d7c66dab3fa4010ae2b28ed0ede4430b288';

/// See also [defaulters].
@ProviderFor(defaulters)
final defaultersProvider = AutoDisposeFutureProvider<List<Defaulter>>.internal(
  defaulters,
  name: r'defaultersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$defaultersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DefaultersRef = AutoDisposeFutureProviderRef<List<Defaulter>>;
String _$todayTasksHash() => r'1d700578c067e4d98231818b2f7e02cedeb8150b';

/// See also [todayTasks].
@ProviderFor(todayTasks)
final todayTasksProvider = AutoDisposeFutureProvider<TodayTasks>.internal(
  todayTasks,
  name: r'todayTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodayTasksRef = AutoDisposeFutureProviderRef<TodayTasks>;
String _$immunizationsDueSummaryHash() =>
    r'769efbdb9dbd4018d549d4637ba7c5895357b435';

/// See also [immunizationsDueSummary].
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
