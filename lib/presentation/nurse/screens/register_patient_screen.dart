/// lib/presentation/nurse/screens/register_patient_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/core/network/supabase_client.dart';
import 'package:mch_pink_book/presentation/providers/patients_provider.dart';
import 'package:mch_pink_book/domain/entities/patient_entity.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing registration form state
final registrationTypeProvider = StateProvider<RegistrationType>((ref) => RegistrationType.mother);

enum RegistrationType { mother, childWithMother, childAlone }

class RegisterPatientScreen extends ConsumerStatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  ConsumerState<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends ConsumerState<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Mother/Guardian fields
  final _motherNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  
  // Child fields
  final _childNameController = TextEditingController();
  DateTime? _childDob;
  String _childGender = 'male';
  
  // Selected mother for child registration
  Patient? _selectedMother;
  
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final registrationType = ref.watch(registrationTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Patient'),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registration Type Selector
              _buildTypeSelector(registrationType),
              const SizedBox(height: 24),

              // Mother/Guardian Section
              if (registrationType == RegistrationType.mother ||
                  registrationType == RegistrationType.childWithMother)
                _buildMotherSection(registrationType),

              // Child Section
              if (registrationType != RegistrationType.mother)
                _buildChildSection(),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _getSubmitButtonText(registrationType),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector(RegistrationType current) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registration Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTypeOption(
              type: RegistrationType.mother,
              current: current,
              title: 'Mother/Guardian Only',
              subtitle: 'Register a mother or guardian',
              icon: Icons.person,
            ),
            _buildTypeOption(
              type: RegistrationType.childWithMother,
              current: current,
              title: 'Mother + Child',
              subtitle: 'Register both mother and child together',
              icon: Icons.family_restroom,
            ),
            _buildTypeOption(
              type: RegistrationType.childAlone,
              current: current,
              title: 'Child Only',
              subtitle: 'Register child without mother',
              icon: Icons.child_care,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required RegistrationType type,
    required RegistrationType current,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = type == current;
    return InkWell(
      onTap: () {
        ref.read(registrationTypeProvider.notifier).state = type;
        // Clear form when switching types
        _clearForm();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryPink : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryPink : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryPink),
          ],
        ),
      ),
    );
  }

  Widget _buildMotherSection(RegistrationType type) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppColors.primaryPink),
                const SizedBox(width: 8),
                Text(
                  type == RegistrationType.childWithMother
                      ? 'Mother/Guardian Details'
                      : 'Registration Details',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // For childWithMother, allow selecting existing mother
            if (type == RegistrationType.childWithMother) ...[
              OutlinedButton.icon(
                icon: const Icon(Icons.search),
                label: Text(
                  _selectedMother == null
                      ? 'Search Existing Mother'
                      : 'Selected: ${_selectedMother!.name}',
                ),
                onPressed: () => _showMotherSearch(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryPink,
                  side: const BorderSide(color: AppColors.primaryPink),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '- OR -',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Register New Mother',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              controller: _motherNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              enabled: _selectedMother == null,
              validator: (v) {
                if (type == RegistrationType.childWithMother && _selectedMother != null) {
                  return null; // Skip validation if mother is selected
                }
                return v?.trim().isEmpty == true ? 'Name is required' : null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                hintText: '+254...',
              ),
              enabled: _selectedMother == null,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d+\s\-()]')),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nationalIdController,
              decoration: const InputDecoration(
                labelText: 'National ID',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              enabled: _selectedMother == null,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.child_care, color: AppColors.primaryPink),
                SizedBox(width: 8),
                Text(
                  'Child Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _childNameController,
              decoration: const InputDecoration(
                labelText: 'Child Full Name *',
                prefixIcon: Icon(Icons.child_friendly),
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.trim().isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _childGender,
              decoration: const InputDecoration(
                labelText: 'Gender *',
                prefixIcon: Icon(Icons.wc),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Boy')),
                DropdownMenuItem(value: 'female', child: Text('Girl')),
              ],
              onChanged: (v) => setState(() => _childGender = v!),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _childDob == null
                    ? 'Select Date of Birth *'
                    : 'DOB: ${_formatDate(_childDob!)}',
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _childDob = date);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryPink,
                side: const BorderSide(color: AppColors.primaryPink),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMotherSearch(BuildContext context) async {
    final result = await showModalBottomSheet<Patient>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MotherSearchSheet(),
    );

    if (result != null) {
      setState(() {
        _selectedMother = result;
        _motherNameController.clear();
        _phoneController.clear();
        _nationalIdController.clear();
      });
    }
  }

  String _getSubmitButtonText(RegistrationType type) {
    switch (type) {
      case RegistrationType.mother:
        return 'Register Mother';
      case RegistrationType.childWithMother:
        return 'Register Mother & Child';
      case RegistrationType.childAlone:
        return 'Register Child';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final registrationType = ref.read(registrationTypeProvider);

    // Validate child-specific fields
    if (registrationType != RegistrationType.mother && _childDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select child date of birth')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final supabase = SupabaseClientManager.client;
      String? motherId;

      // Step 1: Handle Mother Registration (if needed)
      if (registrationType == RegistrationType.mother ||
          (registrationType == RegistrationType.childWithMother && _selectedMother == null)) {
        
        debugPrint('=== Registering new mother ===');
        debugPrint('Name: ${_motherNameController.text.trim()}');
        debugPrint('Phone: ${_phoneController.text.trim()}');
        debugPrint('National ID: ${_nationalIdController.text.trim()}');

        // Generate UUID for the mother
        const uuid = Uuid();
        motherId = uuid.v4();
        
        final motherData = {
          'id': motherId,
          'full_name': _motherNameController.text.trim(),
          'role': 'mother',
          'is_active': true,
          if (_phoneController.text.trim().isNotEmpty)
            'phone_e164': _phoneController.text.trim(),
          if (_nationalIdController.text.trim().isNotEmpty)
            'national_id': _nationalIdController.text.trim(),
        };

        await supabase
            .from('users')
            .insert(motherData);

        debugPrint('Mother registered with ID: $motherId');
      } else if (registrationType == RegistrationType.childWithMother && 
                 _selectedMother != null) {
        motherId = _selectedMother!.id;
        debugPrint('Using existing mother ID: $motherId');
      }

      // Step 2: Handle Child Registration (if needed)
      if (registrationType == RegistrationType.childWithMother ||
          registrationType == RegistrationType.childAlone) {
        
        debugPrint('=== Registering child ===');
        debugPrint('Name: ${_childNameController.text.trim()}');
        debugPrint('DOB: $_childDob');
        debugPrint('Gender: $_childGender');
        debugPrint('Mother ID: $motherId');

        final childData = {
          'name': _childNameController.text.trim(),
          'date_of_birth': _childDob!.toIso8601String(),
          'gender': _childGender,
          if (motherId != null) 'mother_id': motherId,
        };

        final childResponse = await supabase
            .from('children')
            .insert(childData)
            .select('id')
            .single();

        debugPrint('Child registered with ID: ${childResponse['id']}');
      }

      if (!mounted) return;

      // Refresh the patients list
      await ref.read(patientsProvider.notifier).refresh();

      setState(() => _isSubmitting = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getSuccessMessage(registrationType)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pop(context);
    } catch (e, stackTrace) {
      debugPrint('=== Registration Error ===');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  String _getSuccessMessage(RegistrationType type) {
    switch (type) {
      case RegistrationType.mother:
        return 'Mother registered successfully!';
      case RegistrationType.childWithMother:
        return 'Mother and child registered successfully!';
      case RegistrationType.childAlone:
        return 'Child registered successfully!';
    }
  }

  void _clearForm() {
    _motherNameController.clear();
    _phoneController.clear();
    _nationalIdController.clear();
    _childNameController.clear();
    setState(() {
      _childDob = null;
      _childGender = 'male';
      _selectedMother = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _motherNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _childNameController.dispose();
    super.dispose();
  }
}

/// Search sheet for selecting existing mothers
class MotherSearchSheet extends ConsumerStatefulWidget {
  const MotherSearchSheet({super.key});

  @override
  ConsumerState<MotherSearchSheet> createState() => _MotherSearchSheetState();
}

class _MotherSearchSheetState extends ConsumerState<MotherSearchSheet> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final asyncPatients = ref.watch(patientsProvider);
    
    // Update search query
    ref.listen(patientSearchProvider, (_, __) {});
    
    final query = _searchController.text.trim().toLowerCase();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Mother',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, phone, or ID...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (value) {
                    ref.read(patientSearchProvider.notifier).state = value;
                    setState(() {}); // Trigger rebuild
                  },
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Results
          Expanded(
            child: asyncPatients.when(
              data: (patients) {
                // Filter for mothers only and apply search
                final mothers = patients
                    .where((p) => p.type == 'mother')
                    .where((p) => query.isEmpty || p.matches(query))
                    .toList();

                if (mothers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          query.isEmpty ? 'No mothers registered' : 'No mothers found',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: mothers.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final mother = mothers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryPink.withOpacity(0.2),
                        child: const Icon(Icons.person, color: AppColors.primaryPink),
                      ),
                      title: Text(
                        mother.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (mother.phone != null)
                            Text('📱 ${mother.phone}'),
                          if (mother.nationalId != null)
                            Text('🆔 ${mother.nationalId}'),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pop(context, mother),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}