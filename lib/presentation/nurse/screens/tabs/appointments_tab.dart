import 'package:flutter/material.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import '../../../providers/patients_provider.dart';

class AppointmentsTab extends StatelessWidget {
  final Patient patient;
  const AppointmentsTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 64, color: AppColors.accentGreen),
          const SizedBox(height: 16),
          Text('Appointments', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text('For: ${patient.name} (${patient.type})'),
        ],
      ),
    );
  }
}