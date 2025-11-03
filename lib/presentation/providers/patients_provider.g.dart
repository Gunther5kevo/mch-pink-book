// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$patientsHash() => r'4e325317eb90420b394dbc92967192a2a3f6fe1c';

/// ---------------------------------------------------------------------------
/// 2. Unified Patients provider – mothers + children
/// ---------------------------------------------------------------------------
///
/// Copied from [Patients].
@ProviderFor(Patients)
final patientsProvider =
    AutoDisposeAsyncNotifierProvider<Patients, List<Patient>>.internal(
  Patients.new,
  name: r'patientsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$patientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Patients = AutoDisposeAsyncNotifier<List<Patient>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
