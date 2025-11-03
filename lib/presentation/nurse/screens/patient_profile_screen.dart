/// lib/presentation/screens/nurse/patient_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';

import '../../providers/patients_provider.dart';
import 'tabs/pregnancy_tab.dart';
import 'tabs/children_tab.dart';
import 'tabs/appointments_tab.dart';

class PatientProfileScreen extends ConsumerStatefulWidget {
  final Patient patient;

  const PatientProfileScreen({super.key, required this.patient});

  @override
  ConsumerState<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends ConsumerState<PatientProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.patient.type == 'mother' ? 3 : 1, // Children only get Appointments
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMother = widget.patient.type == 'mother';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        bottom: isMother
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Pregnancy'),
                  Tab(text: 'Children'),
                  Tab(text: 'Appointments'),
                ],
              )
            : null,
      ),
      body: isMother
          ? TabBarView(
              controller: _tabController,
              children: [
                PregnancyTab(motherId: widget.patient.id),
                ChildrenTab(motherId: widget.patient.id),
                AppointmentsTab(patient: widget.patient),
              ],
            )
          : AppointmentsTab(patient: widget.patient), // Child only sees appointments
    );
  }
}