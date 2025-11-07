/// lib/presentation/screens/nurse/tabs/appointments_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/utils/app_date_formats.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../providers/appointments_provider.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../../domain/entities/appointment_entity.dart';

class AppointmentsTab extends ConsumerWidget {
  final String userId; // user_id from patient
  const AppointmentsTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(
      motherAppointmentsProvider((userId, MotherAppointmentFilter.upcoming)),
    );

    return appointmentsAsync.when(
      loading: () => const LoadingShimmer(count: 4, height: 110),
      error: (e, _) => Center(child: Text('Error loading appointments: $e')),
      data: (appointments) {
        if (appointments.isEmpty) {
          return const Center(
            child: Text(
              'No appointments found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: appointments.length,
          itemBuilder: (_, i) {
            final a = appointments[i];
            return _AppointmentCard(appointment: a);
          },
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final isPast = appointment.scheduledAt.isBefore(DateTime.now());
    final color = isPast ? Colors.grey[200] : AppColors.primaryPink.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.calendar, color: AppColors.primaryPink),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.type.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  AppDateFormats.humanReadable(appointment.scheduledAt),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          if (appointment.status == AppointmentStatus.scheduled)
            const Icon(Icons.schedule, color: Colors.orange),
          if (appointment.status == AppointmentStatus.completed)
            const Icon(Icons.check_circle, color: Colors.green),
          if (appointment.status == AppointmentStatus.cancelled)
            const Icon(Icons.cancel, color: Colors.red),
        ],
      ),
    );
  }
}
