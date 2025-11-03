/// Clean Healthcare Provider Signup - Email/Password with License
/// Updated to handle PendingVerification state properly
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_notifier.dart';
import '../widgets/role_selector_widget.dart';


class HealthcareProviderSignupScreen extends ConsumerStatefulWidget {
  const HealthcareProviderSignupScreen({super.key});

  @override
  ConsumerState<HealthcareProviderSignupScreen> createState() =>
      _HealthcareProviderSignupScreenState();
}

class _HealthcareProviderSignupScreenState
    extends ConsumerState<HealthcareProviderSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _facilityController = TextEditingController();

  UserRole _selectedRole = UserRole.nurse;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _facilityController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      _showSnackBar('Please agree to Terms of Service', isError: true);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match', isError: true);
      return;
    }

    final phone = _phoneController.text.trim();
    final phoneE164 = phone.isNotEmpty ? _formatPhoneNumber(phone) : null;

    await ref.read(authNotifierProvider.notifier).signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          role: _selectedRole,
          phoneE164: phoneE164,
          licenseNumber: _licenseController.text.trim(),
          facilityName: _facilityController.text.trim().isNotEmpty
              ? _facilityController.text.trim()
              : null,
        );
  }

  String? _formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    String? normalized;
    if (cleaned.startsWith('254') && cleaned.length == 12) {
      normalized = cleaned.substring(3);
    } else if (cleaned.startsWith('0') && cleaned.length == 10) {
      normalized = cleaned.substring(1);
    } else if (cleaned.length == 9) {
      normalized = cleaned;
    }

    if (normalized != null &&
        (normalized.startsWith('7') || normalized.startsWith('1')) &&
        normalized.length == 9) {
      return '+254$normalized';
    }

    return null;
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is Loading;

    // Listen for auth state changes and handle navigation
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (!mounted) return;

      if (next is PendingVerification) {
        // Navigate to pending verification screen
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.pendingVerification,
          arguments: {
            'email': next.email,
            'role': next.role.name,
            'message': next.message,
          },
        );
      } else if (next is Authenticated) {
        // Shouldn't happen for new providers, but handle gracefully
        print(
            '⚠️ Provider authenticated without verification - check auth logic');
        _showSnackBar('Account created successfully!', isError: false);
      } else if (next is Error) {
        _showSnackBar(next.message, isError: true);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Healthcare Provider',
          style: TextStyle(color: AppColors.textDark),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildInfoCard(),
                const SizedBox(height: 24),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Professional Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  enabled: !isLoading,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !isLoading,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number (Optional)
                TextFormField(
                  controller: _phoneController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Optional)',
                    hintText: '0712 345 678',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    return Validators.phoneNumber(value);
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Add your phone number for notifications (optional)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Role Selector
                RoleSelectorWidget(
                  selectedRole: _selectedRole,
                  enabled: !isLoading,
                  onRoleChanged: (role) => setState(() => _selectedRole = role),
                  showMotherOption: false,
                ),
                const SizedBox(height: 16),

                // License Number
                TextFormField(
                  controller: _licenseController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    labelText: 'License Number',
                    hintText: _selectedRole == UserRole.nurse
                        ? 'e.g., NCK/RN/12345'
                        : 'e.g., KMC/12345',
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  validator: (value) =>
                      value?.trim().isEmpty ?? true ? 'License required' : null,
                ),
                const SizedBox(height: 16),

                // Facility Name (Optional)
                TextFormField(
                  controller: _facilityController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Health Facility (Optional)',
                    hintText: 'e.g., Kenyatta National Hospital',
                    prefixIcon: Icon(Icons.local_hospital_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                // Terms Checkbox
                CheckboxListTile(
                  value: _agreeToTerms,
                  enabled: !isLoading,
                  onChanged: (value) =>
                      setState(() => _agreeToTerms = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textDark),
                      children: const [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primaryPink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' and certify my license is accurate'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: isLoading ? null : _handleSignUp,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Submit Application'),
                ),
                const SizedBox(height: 24),

                // Back Link
                _buildBackLink(isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.verified_user,
              size: 48, color: AppColors.primaryPink),
        ),
        const SizedBox(height: 16),
        const Text(
          'Healthcare Provider Registration',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Your license will be verified before activation',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Requirements',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRequirement('Valid nursing or medical license'),
          _buildRequirement('Professional email address'),
          _buildRequirement('Manual verification (24-48 hours)'),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textLight)),
          ),
        ],
      ),
    );
  }

  Widget _buildBackLink(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not a healthcare provider? ',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
        ),
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Sign Up as Mother'),
        ),
      ],
    );
  }
}
