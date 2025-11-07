// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$patientsHash() => r'fac4c8d92e2342ddadc1f2fe4e260c3ee922a454';

/// ---------------------------------------------------------------------------
/// 2. Unified Patients provider – returns **domain.Patient**
/// ---------------------------------------------------------------------------
///
/// Copied from [Patients].
@ProviderFor(Patients)
final patientsProvider =
    AutoDisposeAsyncNotifierProvider<Patients, List<domain.Patient>>.internal(
  Patients.new,
  name: r'patientsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$patientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Patients = AutoDisposeAsyncNotifier<List<domain.Patient>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
