import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryPink.withOpacity(0.2),
        checkmarkColor: AppColors.primaryPink,
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: selected ? AppColors.primaryPink : AppColors.textDark,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}