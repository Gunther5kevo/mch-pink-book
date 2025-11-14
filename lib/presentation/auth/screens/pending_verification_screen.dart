/// Updated Pending Verification Screen
/// Shows healthcare providers they're waiting for license + facility verification
library;

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from signup
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] as String? ?? '';
    final role = args?['role'] as String? ?? 'healthcare provider';
    final clinicData = args?['clinic'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pending_outlined,
                  size: 80,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Application Submitted',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Message
              Text(
                'Thank you for registering as a $role!',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We are reviewing your license and facility information. This typically takes 24-48 hours.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Facility Card (if available)
              if (clinicData != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.local_hospital,
                              color: AppColors.success,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Facility',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  clinicData['name']?.toString() ?? '',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: AppColors.success.withValues(alpha: 0.2)),
                      const SizedBox(height: 12),
                      _buildFacilityDetail(
                        Icons.location_on_outlined,
                        'County',
                        clinicData['county']?.toString() ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      _buildFacilityDetail(
                        Icons.domain_outlined,
                        'Type',
                        clinicData['facility_type']?.toString() ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      _buildFacilityDetail(
                        Icons.verified_outlined,
                        'MFL Code',
                        clinicData['code']?.toString() ?? 'N/A',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryPink.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoItem(
                      Icons.email_outlined,
                      'Check Your Email',
                      'We\'ve sent a confirmation to $email',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      Icons.verified_user_outlined,
                      'License & Facility Verification',
                      'Our team is verifying your credentials and facility registration',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      Icons.notifications_outlined,
                      'We\'ll Notify You',
                      'You\'ll receive an email once verified',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Back to Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                child: const Text('Back to Login'),
              ),
              const SizedBox(height: 16),

              // Support Text
              TextButton(
                onPressed: () {
                  // TODO: Open support email or help center
                },
                child: Text(
                  'Need help? Contact Support',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryPink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.success),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textLight,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryPink, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}