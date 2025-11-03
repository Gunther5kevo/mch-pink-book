import 'package:flutter/material.dart';
import 'package:mch_pink_book/presentation/nurse/screens/nurse_appointments_screen.dart';
import '../../../core/constants/app_constants.dart';

class NurseAppointmentFilters extends StatelessWidget {
  final AppointmentFilterType currentFilter;
  final void Function(AppointmentFilterType) onFilterChanged;

  const NurseAppointmentFilters({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: AppointmentFilterType.values.map((filter) {
          final label = filter.name[0].toUpperCase() + filter.name.substring(1);
          final isSelected = currentFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(label, style: AppTextStyles.bodyMedium),
              selected: isSelected,
              selectedColor: AppColors.primaryPinkLight,
              checkmarkColor: AppColors.primaryPinkDark,
              backgroundColor: AppColors.cardBackground,
              side: BorderSide(
                color: isSelected ? AppColors.primaryPinkDark : AppColors.divider,
                width: isSelected ? 2 : 1,
              ),
              onSelected: (_) => onFilterChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}