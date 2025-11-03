/// Pregnancy Card Widget
/// Display pregnancy information for mothers
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class PregnancyCard extends StatelessWidget {
  final DateTime expectedDeliveryDate;
  final VoidCallback? onTap;

  const PregnancyCard({
    super.key,
    required this.expectedDeliveryDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = expectedDeliveryDate.difference(DateTime.now()).inDays;
    final weeksRemaining = (daysRemaining / 7).floor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentBlue.withOpacity(0.7),
              AppColors.accentBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentBlue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pregnant_woman, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Your Pregnancy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCountdown(
                    value: daysRemaining > 0 ? '$daysRemaining' : '0',
                    label: 'Days Left',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  _buildCountdown(
                    value: weeksRemaining > 0 ? '$weeksRemaining' : '0',
                    label: 'Weeks Left',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Expected: ${_formatDate(expectedDeliveryDate)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdown({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
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