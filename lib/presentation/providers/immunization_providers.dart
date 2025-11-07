// lib/presentation/providers/immunization_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/immunization_entity.dart';
import '../../data/repositories/immunization_repository.dart';

part 'immunization_providers.g.dart';

@riverpod
Future<List<ImmunizationEntity>> immunizations(
    ImmunizationsRef ref, String childId) {
  return ref.watch(immunizationRepositoryProvider).getByChildId(childId);
}

@riverpod
class ImmunizationNotifier extends _$ImmunizationNotifier {
  @override
  Future<void> build() async {}

  Future<ImmunizationEntity> addImmunization(ImmunizationEntity immunization) async {
    final repo = ref.read(immunizationRepositoryProvider);
    final newImmunization = await repo.addImmunization(immunization);
    ref.invalidate(immunizationsProvider(immunization.childId));
    return newImmunization;
  }
}