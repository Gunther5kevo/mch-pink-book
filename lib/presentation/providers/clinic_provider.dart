// lib/presentation/providers/clinic_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/clinic_service.dart';
import '../../domain/entities/clinic_entity.dart';
import 'providers.dart'; 

final clinicServiceProvider = Provider<ClinicService>((ref) {
  return ClinicService(Supabase.instance.client);
});

final currentClinicProvider = FutureProvider<ClinicEntity?>((ref) async {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) async {
      if (user == null) return null;
      final service = ref.read(clinicServiceProvider);
      return await service.getCurrentClinic(user.id);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});