/// Clinic Info Card Widget
/// Display clinic information
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ClinicInfoCard extends StatelessWidget {
  final String clinicName;
  final DateTime? lastVisitDate;
  final VoidCallback? onViewDetails;

  const ClinicInfoCard({
    super.key,
    required this.clinicName,
    this.lastVisitDate,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_hospital, color: AppColors.primaryPink),
                SizedBox(width: 8),
                Text(
                  'Your Preferred Clinic',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              clinicName,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            if (lastVisitDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Last visit: ${_formatDate(lastVisitDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            if (onViewDetails != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('View Details'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}