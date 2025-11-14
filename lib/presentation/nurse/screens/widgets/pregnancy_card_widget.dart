import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../providers/clinic_dashboard_providers.dart';
import '../helpers/navigation_helpers.dart';

class PregnancyCardWidget extends StatelessWidget {
  final PregnancyWithMother pregnancy;

  const PregnancyCardWidget({
    super.key,
    required this.pregnancy,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = pregnancy.statusText == 'High Risk'
        ? Colors.red
        : pregnancy.statusText == 'Overdue'
            ? Colors.orange
            : AppColors.accentGreen;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => NavigationHelpers.navigateToMotherProfile(context, pregnancy.pregnancy.motherId
),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryPink.withOpacity(0.2),
                    child: Text(
                      pregnancy.motherName[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pregnancy.motherName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          pregnancy.ancNumber ?? 'No ANC#',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pregnancy.statusText,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'GA',
                      value: pregnancy.gestationalAgeText,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.event_available,
                      label: 'Next Visit',
                      value: pregnancy.nextVisitDate != null
                          ? _formatNextVisit(pregnancy.nextVisitDate!)
                          : 'Not scheduled',
                    ),
                  ),
                ],
              ),
              if (pregnancy.pregnancy.riskFlags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 6,
                  children: pregnancy.pregnancy.riskFlags
                      .map((flag) => Chip(
                            label: Text(
                              flag,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.red.shade700,
                              ),
                            ),
                            backgroundColor: Colors.red.shade50,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatNextVisit(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.isNegative) {
      return 'Overdue ${diff.inDays.abs()} days';
    } else if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Tomorrow';
    } else if (diff.inDays < 7) {
      return 'In ${diff.inDays} days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textLight,
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}