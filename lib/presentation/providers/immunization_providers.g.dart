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

/// See also [immunizations].
@ProviderFor(immunizations)
const immunizationsProvider = ImmunizationsFamily();

/// See also [immunizations].
class ImmunizationsFamily extends Family<AsyncValue<List<ImmunizationEntity>>> {
  /// See also [immunizations].
  const ImmunizationsFamily();

  /// See also [immunizations].
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

/// See also [immunizations].
class ImmunizationsProvider
    extends AutoDisposeFutureProvider<List<ImmunizationEntity>> {
  /// See also [immunizations].
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

String _$immunizationNotifierHash() =>
    r'd9659f6ee4434e211f345aa459bbdf96e9fd2fc1';

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
