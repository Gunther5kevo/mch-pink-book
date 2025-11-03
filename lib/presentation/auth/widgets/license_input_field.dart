/// License Input Field
/// Input field for healthcare provider license numbers
library;

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';

class LicenseInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final UserRole role;

  const LicenseInputField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.role,
  });

  String get _labelText {
    switch (role) {
      case UserRole.nurse:
        return 'Nursing License Number';
      case UserRole.admin:
        return 'Medical License Number';
      default:
        return 'License Number';
    }
  }

  String get _hintText {
    switch (role) {
      case UserRole.nurse:
        return 'e.g., NCK/12345';
      case UserRole.admin:
        return 'e.g., KMA/67890';
      default:
        return 'Enter your license number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: _labelText,
            hintText: _hintText,
            prefixIcon: const Icon(Icons.badge_outlined),
            helperText: 'Required for healthcare providers',
            helperStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textLight,
            ),
          ),
          validator: (value) => Validators.licenseNumber(value, role),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 8),
        
        // Info Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.info.withOpacity(0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your license will be verified by our team. You\'ll receive confirmation within 24-48 hours.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}