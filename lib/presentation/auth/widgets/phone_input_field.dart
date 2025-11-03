/// Phone Input Field Widget
/// Custom input for Kenyan phone numbers
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
        PhoneNumberFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '0712345678',
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/ke_flag.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.flag, size: 24);
                },
              ),
              const SizedBox(width: 8),
              const Text(
                '+254',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 24,
                color: AppColors.divider,
              ),
            ],
          ),
        ),
        helperText: 'Enter your Kenyan mobile number',
      ),
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    
    // Check if it's a valid Kenyan number
    if (cleaned.length < 9 || cleaned.length > 12) {
      return 'Enter a valid phone number';
    }

    // Must start with 0, 7, 1, or 254
    if (!RegExp(r'^(0|7|1|254)').hasMatch(cleaned)) {
      return 'Enter a valid Kenyan number';
    }

    return null;
  }
}

/// Phone Number Formatter
/// Formats phone numbers as user types
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.isEmpty) {
      return newValue;
    }

    // Add spaces for better readability
    String formatted = text;
    if (text.length > 3) {
      formatted = '${text.substring(0, 3)} ${text.substring(3)}';
    }
    if (text.length > 6) {
      formatted = '${text.substring(0, 3)} ${text.substring(3, 6)} ${text.substring(6)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}