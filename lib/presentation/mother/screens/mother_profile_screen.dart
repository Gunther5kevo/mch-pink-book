/// lib/presentation/mother/screens/mother_profile_screen.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/supabase_client.dart';
import '../../../domain/entities/user_entity.dart';
import '../../providers/auth_notifier.dart';

class MotherProfileScreen extends ConsumerStatefulWidget {
  const MotherProfileScreen({super.key});

  @override
  ConsumerState<MotherProfileScreen> createState() => _MotherProfileScreenState();
}

class _MotherProfileScreenState extends ConsumerState<MotherProfileScreen> {
  bool _isEditing = false;
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyNameController;

  String? _preferredClinic;
  DateTime? _lastVisitDate;
  int _numberOfChildren = 0;
  bool _isPregnant = false;
  DateTime? _expectedDeliveryDate;

  final List<String> _clinics = [
    'Githunguri Health Centre',
    'Machakos Level 5 Hospital',
    'Matuu Sub-County Hospital',
    'Kenyatta National Hospital',
    'Pumwani Maternity Hospital',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      final user = authState.user;

      _fullNameController.text = user.fullName;
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneE164 ?? '';
      _preferredClinic = user.preferredClinic;
      _lastVisitDate = user.lastVisitDate;

      // Safe metadata access
      final metadata = user.metadata;
      _numberOfChildren = metadata['number_of_children'] is int
          ? metadata['number_of_children'] as int
          : 0;

      _isPregnant = metadata['is_pregnant'] is bool
          ? metadata['is_pregnant'] as bool
          : false;

      final deliveryDateStr = metadata['expected_delivery_date'];
      if (deliveryDateStr is String) {
        _expectedDeliveryDate = DateTime.tryParse(deliveryDateStr);
      }

      // Load emergency contact if exists (from user entity or metadata)
      _emergencyContactController.text = metadata['emergency_contact']?.toString() ?? '';
      _emergencyNameController.text = metadata['emergency_name']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _emergencyNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final supabase = SupabaseClientManager.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare metadata
      final metadata = <String, dynamic>{
        'number_of_children': _numberOfChildren,
        'is_pregnant': _isPregnant,
        if (_expectedDeliveryDate != null)
          'expected_delivery_date': _expectedDeliveryDate!.toIso8601String(),
        if (_emergencyContactController.text.trim().isNotEmpty)
          'emergency_contact': _emergencyContactController.text.trim(),
        if (_emergencyNameController.text.trim().isNotEmpty)
          'emergency_name': _emergencyNameController.text.trim(),
        'profile_updated_at': DateTime.now().toIso8601String(),
      };

      // Update the users table directly
      final updates = <String, dynamic>{
        'full_name': _fullNameController.text.trim(),
        'preferred_clinic': _preferredClinic,
        'last_visit_date': _lastVisitDate?.toIso8601String(),
        'metadata': metadata,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Only include emergency fields if they have values
      if (_emergencyContactController.text.trim().isNotEmpty) {
        updates['emergency_contact'] = _emergencyContactController.text.trim();
      }
      if (_emergencyNameController.text.trim().isNotEmpty) {
        updates['emergency_name'] = _emergencyNameController.text.trim();
      }

      debugPrint('=== Updating user profile ===');
      debugPrint('User ID: $userId');
      debugPrint('Updates: $updates');

      await supabase
          .from('users')
          .update(updates)
          .eq('id', userId);

      debugPrint('Profile updated successfully');

      // Refresh auth state to get updated user
      await ref.read(authNotifierProvider.notifier).refreshUser();

      if (mounted) {
        setState(() => _isEditing = false);
        _showSuccess('Profile updated successfully!');
      }
    } catch (e, stackTrace) {
      debugPrint('=== Profile update error ===');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        _showError('Failed to update profile: $e');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _selectDate(bool isDeliveryDate) async {
    final now = DateTime.now();
    final initialDate = isDeliveryDate
        ? _expectedDeliveryDate ?? now.add(const Duration(days: 180))
        : _lastVisitDate ?? now;

    final firstDate = isDeliveryDate ? now : DateTime(2020);
    final lastDate = isDeliveryDate ? now.add(const Duration(days: 365)) : now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryPink,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isDeliveryDate) {
          _expectedDeliveryDate = picked;
        } else {
          _lastVisitDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit Profile',
            )
          else
            TextButton(
              onPressed: _isSubmitting ? null : _saveProfile,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          if (_isEditing)
            TextButton(
              onPressed: _isSubmitting ? null : () {
                setState(() {
                  _isEditing = false;
                  _loadUserData(); // Reload original data
                });
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: authState is Authenticated
          ? _buildContent(authState.user)
          : const Center(child: CircularProgressIndicator(color: AppColors.primaryPink)),
    );
  }

  Widget _buildContent(UserEntity user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: AppSpacing.lg),

            _buildSection(
              title: 'Personal Information',
              icon: Icons.person,
              children: [
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                  validator: (v) => v?.trim().isEmpty == true ? 'Name is required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  enabled: false,
                  helperText: 'Email cannot be changed',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  enabled: false,
                  helperText: 'Phone cannot be changed',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection(
              title: 'Emergency Contact',
              icon: Icons.emergency,
              children: [
                _buildTextField(
                  controller: _emergencyNameController,
                  label: 'Emergency Contact Name',
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(
                  controller: _emergencyContactController,
                  label: 'Emergency Contact Phone',
                  icon: Icons.phone_outlined,
                  enabled: _isEditing,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection(
              title: 'Family Information',
              icon: Icons.family_restroom,
              children: [
                _buildChildrenCounter(),
                const SizedBox(height: AppSpacing.md),
                _buildPregnancyToggle(),
                if (_isPregnant) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildDeliveryDateSelector(),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection(
              title: 'Health Facility',
              icon: Icons.local_hospital,
              children: [
                _buildClinicDropdown(),
                const SizedBox(height: AppSpacing.md),
                _buildLastVisitDateSelector(),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSection(
              title: 'Account',
              icon: Icons.settings,
              children: [
                _buildActionTile('Change Password', Icons.lock_outline, _showComingSoon),
                _buildActionTile('Notification Settings', Icons.notifications_outlined, _showComingSoon),
                _buildActionTile('Language', Icons.language, _showComingSoon, subtitle: 'English'),
                const Divider(),
                _buildActionTile(
                  'Sign Out',
                  Icons.logout,
                  _confirmSignOut,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Version 1.0.0', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserEntity user) {
    final initial = user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryPink, AppColors.primaryPinkDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryPink),
                      onPressed: _showComingSoon,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.fullName,
            style: AppTextStyles.h2.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Mother', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.circular(AppBorderRadius.md)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryPink),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, color: enabled ? AppColors.primaryPink : AppColors.textLight),
        border: OutlineInputBorder(borderRadius: AppBorderRadius.circular(AppBorderRadius.md)),
        filled: !enabled,
        fillColor: enabled ? null : AppColors.cardBackground.withOpacity(0.3),
      ),
      validator: validator,
    );
  }

  Widget _buildChildrenCounter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryPinkLight.withOpacity(0.2),
        borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: _isEditing ? AppColors.primaryPink.withOpacity(0.3) : Colors.transparent),
      ),
      child: Column(
        children: [
          const Text('Number of Children', style: AppTextStyles.bodyLarge),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isEditing)
                IconButton(
                  onPressed: _numberOfChildren > 0 ? () => setState(() => _numberOfChildren--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.primaryPink,
                  iconSize: 32,
                ),
              if (_isEditing) const SizedBox(width: 16),
              Column(
                children: [
                  Text('$_numberOfChildren', style: AppTextStyles.h1.copyWith(color: AppColors.primaryPink)),
                  Text(_numberOfChildren == 1 ? 'child' : 'children', style: AppTextStyles.bodySmall),
                ],
              ),
              if (_isEditing) const SizedBox(width: 16),
              if (_isEditing)
                IconButton(
                  onPressed: _numberOfChildren < 15 ? () => setState(() => _numberOfChildren++) : null,
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.primaryPink,
                  iconSize: 32,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyToggle() {
    return SwitchListTile(
      title: const Text('Currently Pregnant'),
      subtitle: Text(_isPregnant ? 'Expecting a baby' : 'Not pregnant'),
      value: _isPregnant,
      onChanged: _isEditing
          ? (v) => setState(() {
                _isPregnant = v;
                if (!v) _expectedDeliveryDate = null;
              })
          : null,
      activeThumbColor: AppColors.primaryPink,
      secondary: Icon(_isPregnant ? Icons.pregnant_woman : Icons.person, color: AppColors.primaryPink),
    );
  }

  Widget _buildDeliveryDateSelector() {
    return InkWell(
      onTap: _isEditing ? () => _selectDate(true) : null,
      borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primaryPink),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expected Delivery Date', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(
                    _expectedDeliveryDate == null ? 'Not set' : _formatDate(_expectedDeliveryDate!),
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (_expectedDeliveryDate != null) ...[
                    const SizedBox(height: 4),
                    Text(_getDaysRemaining(), style: AppTextStyles.caption.copyWith(color: AppColors.primaryPink)),
                  ],
                ],
              ),
            ),
            if (_isEditing) const Icon(Icons.edit_outlined, color: AppColors.primaryPink),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _preferredClinic,
      decoration: InputDecoration(
        labelText: 'Preferred Health Facility',
        prefixIcon: const Icon(Icons.local_hospital),
        border: OutlineInputBorder(borderRadius: AppBorderRadius.circular(AppBorderRadius.md)),
        filled: !_isEditing,
        fillColor: _isEditing ? null : AppColors.cardBackground.withOpacity(0.3),
      ),
      items: _clinics.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: _isEditing ? (v) => setState(() => _preferredClinic = v) : null,
    );
  }

  Widget _buildLastVisitDateSelector() {
    return InkWell(
      onTap: _isEditing ? () => _selectDate(false) : null,
      borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          color: _isEditing ? null : AppColors.cardBackground.withOpacity(0.3),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primaryPink),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last Clinic Visit', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Text(
                    _lastVisitDate == null ? 'Not set' : _formatDate(_lastVisitDate!),
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (_isEditing) const Icon(Icons.edit_outlined, color: AppColors.primaryPink),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap, {String? subtitle, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textDark),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDaysRemaining() {
    if (_expectedDeliveryDate == null) return '';
    final days = _expectedDeliveryDate!.difference(DateTime.now()).inDays;
    if (days < 0) return 'Past due';
    if (days == 0) return 'Due today!';
    if (days == 1) return '1 day left';
    return '$days days left';
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!'), behavior: SnackBarBehavior.floating),
    );
  }
}