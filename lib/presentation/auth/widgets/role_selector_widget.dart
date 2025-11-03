/// Role Selector Widget
/// Allows user to select their role during signup
library;

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class RoleSelectorWidget extends StatelessWidget {
  final UserRole selectedRole;
  final bool enabled;
  final ValueChanged<UserRole> onRoleChanged;
  final bool showMotherOption;

  const RoleSelectorWidget({
    super.key,
    required this.selectedRole,
    required this.enabled,
    required this.onRoleChanged,
    this.showMotherOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showMotherOption ? 'Select Your Role' : 'Healthcare Provider Type',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Mother Role (conditional)
        if (showMotherOption) ...[
          _RoleCard(
            title: 'Mother',
            description: 'Access your maternal health records',
            icon: Icons.pregnant_woman,
            color: AppColors.primaryPink,
            isSelected: selectedRole == UserRole.mother,
            enabled: enabled,
            onTap: () => onRoleChanged(UserRole.mother),
          ),
          const SizedBox(height: 12),
        ],
        
        // Nurse/Doctor Role
        _RoleCard(
          title: 'Healthcare Provider',
          description: 'Manage patient records and appointments',
          icon: Icons.medical_services,
          color: Colors.blue,
          isSelected: selectedRole == UserRole.nurse,
          enabled: enabled,
          onTap: () => onRoleChanged(UserRole.nurse),
        ),
        const SizedBox(height: 12),
        
        // Admin Role
        _RoleCard(
          title: 'Administrator',
          description: 'System administration and oversight',
          icon: Icons.admin_panel_settings,
          color: Colors.purple,
          isSelected: selectedRole == UserRole.admin,
          enabled: enabled,
          onTap: () => onRoleChanged(UserRole.admin),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection Indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}