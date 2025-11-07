import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/visit_entity.dart';

class VisitRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Helper: YYYY-MM-DD for PostgreSQL `date`
  static String _dateOnly(DateTime dt) =>
      dt.toIso8601String().split('T').first;

  Future<VisitEntity> createVisit(VisitEntity visit) async {
    final data = {
      'subject_id': visit.subjectId,
      'subject_type': visit.subjectType,
      'pregnancy_id': visit.pregnancyId,
      'type': visit.type.dbValue,               // exact enum name
      'visit_number': visit.visitNumber,
      'visit_date': _dateOnly(visit.visitDate),
      'gestation_weeks': visit.gestationWeeks,
      'provider_id': visit.providerId,
      'clinic_id': visit.clinicId,
      'vitals': visit.vitals,
      'lab_results': visit.labResults,
      'examination': visit.examination,
      'prescriptions': visit.prescriptions,
      'referrals': visit.referrals,
      'next_visit_date':
          visit.nextVisitDate != null ? _dateOnly(visit.nextVisitDate!) : null,
      'advice': visit.advice,
      'notes': visit.notes,
      'version': visit.version,
      'last_updated_at': visit.lastUpdatedAt?.toIso8601String(),
    };

    final response = await _client
        .from('visits')
        .insert(data)
        .select()
        .single();

    return VisitEntity.fromJson(response);
  }
}