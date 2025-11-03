/// Mother Appointments Screen
/// View only – no booking
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/domain/entities/appointment_entity.dart';
import 'package:mch_pink_book/presentation/providers/appointments_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';

class MotherAppointmentsScreen extends ConsumerStatefulWidget {
  const MotherAppointmentsScreen({super.key});

  @override
  ConsumerState<MotherAppointmentsScreen> createState() => _MotherAppointmentsScreenState();
}

class _MotherAppointmentsScreenState extends ConsumerState<MotherAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) => user == null
          ? const Scaffold(body: Center(child: Text('User not found')))
          : _buildTabs(user.id),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildTabs(String userId) {
    final upcoming = ref.watch(motherAppointmentsProvider((userId, MotherAppointmentFilter.upcoming)));
    final past = ref.watch(motherAppointmentsProvider((userId, MotherAppointmentFilter.past)));
    final cancelled = ref.watch(motherAppointmentsProvider((userId, MotherAppointmentFilter.cancelled)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [IconButton(icon: const Icon(Icons.calendar_month), onPressed: _showCalendarView)],
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
          Tab(text: 'Cancelled'),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _tabContent(upcoming, isUpcoming: true),
          _tabContent(past, isPast: true),
          _tabContent(cancelled, isCancelled: true),
        ],
      ),
    );
  }

  Widget _tabContent(AsyncValue<List<AppointmentEntity>> asyncAppointments, {bool isUpcoming = false, bool isPast = false, bool isCancelled = false}) {
    return asyncAppointments.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyState(
                icon: isUpcoming ? Icons.calendar_today : isPast ? Icons.history : Icons.cancel,
                title: isUpcoming ? 'No Upcoming Appointments' : isPast ? 'No Past Appointments' : 'No Cancelled Appointments',
                subtitle: isUpcoming ? 'Your nurse will schedule visits' : isPast ? 'Completed visits appear here' : 'Cancelled visits appear here',
                iconColor: isUpcoming ? AppColors.accentBlue : Colors.grey,
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(motherAppointmentsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (_, i) => _appointmentCard(appointments[i], isPast: isPast, isCancelled: isCancelled),
          ),
        );
      },
      loading: () => const Center(child: LoadingShimmer(count: 3, height: 120)),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Error: $e'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.invalidate(motherAppointmentsProvider), child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(AppointmentEntity apt, {bool isPast = false, bool isCancelled = false}) {
    final color = apt.type.color;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetails(apt),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(apt.type.icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(apt.type.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(apt.clinicId ?? 'Clinic', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  if (isCancelled)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Cancelled', style: TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600)),
                    )
                  else if (isPast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Completed', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(apt.formattedDate, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(apt.formattedTime, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
              if (apt.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.note, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(apt.notes!, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCalendarView() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calendar view - Coming soon!')));
  void _showDetails(AppointmentEntity apt) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details - Coming soon!')));
}