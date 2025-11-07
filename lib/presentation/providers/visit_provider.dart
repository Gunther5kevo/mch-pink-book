import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import '../../domain/entities/visit_entity.dart';
import '../../data/repositories/visit_repository.dart';
import 'auth_notifier.dart';

final visitRepositoryProvider = Provider<VisitRepository>((ref) {
  return VisitRepository();
});

final visitProvider = Provider<VisitService>((ref) {
  final repo = ref.read(visitRepositoryProvider);
  final auth = ref.watch(authNotifierProvider);

  final user = auth.maybeWhen(
    authenticated: (u) => u,
    orElse: () => null,
  );

  if (user == null) {
    throw StateError('User must be logged in to record a visit');
  }

  return VisitService(
    repo,
    providerId: user.id,
    clinicId: user.clinicId ?? 'default-clinic-id',
  );
});

class VisitService {
  final VisitRepository _repo;
  final String _providerId;
  final String _clinicId;

  VisitService(this._repo,
      {required String providerId, required String clinicId})
      : _providerId = providerId,
        _clinicId = clinicId;

  Future<VisitEntity> recordVisit({
    required String subjectId,
    required String subjectType,
    required VisitType type,
    required DateTime visitDate,
    String? pregnancyId,
    int? visitNumber,
    int? gestationWeeks,
    Map<String, dynamic> vitals = const {},
    Map<String, dynamic> labResults = const {},
    Map<String, dynamic> examination = const {},
    List<Map<String, dynamic>> prescriptions = const [],
    List<Map<String, dynamic>> referrals = const [],
    DateTime? nextVisitDate,
    String? advice,
    String? notes,
  }) async {
    final visit = VisitEntity(
      id: '',
      subjectId: subjectId,
      subjectType: subjectType,
      pregnancyId: pregnancyId,
      type: type,
      visitNumber: visitNumber,
      visitDate: visitDate,
      gestationWeeks: gestationWeeks,
      providerId: _providerId,
      clinicId: _clinicId,
      vitals: vitals,
      labResults: labResults,
      examination: examination,
      prescriptions: prescriptions,
      referrals: referrals,
      nextVisitDate: nextVisitDate,
      advice: advice,
      notes: notes,
      version: 1,
      lastUpdatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _repo.createVisit(visit);
  }
}