import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class TaskItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final VoidCallback onTap;
  final Color? color;

  const TaskItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.primaryPink;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: itemColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: itemColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}