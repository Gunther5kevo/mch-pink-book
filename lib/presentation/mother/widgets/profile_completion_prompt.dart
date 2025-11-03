/// Profile Completion Prompt Widget
/// Prompt users to complete their profile
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ProfileCompletionPrompt extends StatelessWidget {
  final VoidCallback onComplete;

  const ProfileCompletionPrompt({
    super.key,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.warning.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.warning),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add your details for a personalized experience',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onComplete,
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}