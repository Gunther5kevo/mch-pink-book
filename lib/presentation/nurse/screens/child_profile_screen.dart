/// lib/presentation/screens/nurse/child_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/domain/entities/child_entity.dart';
import 'package:mch_pink_book/domain/entities/clinic_entity.dart';
import 'package:mch_pink_book/presentation/providers/child_provider.dart';
import 'package:mch_pink_book/presentation/auth/widgets/clinic_search_sheet.dart';
import 'package:mch_pink_book/presentation/providers/clinic_provider.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  final ChildEntity child;
  final String motherId;

  const ChildProfileScreen({
    super.key,
    required this.child,
    required this.motherId,
  });

  @override
  ConsumerState<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _birthWeightController;
  late TextEditingController _birthLengthController;
  late TextEditingController _headCircumferenceController;
  late TextEditingController _birthCertificateController;
  late TextEditingController _birthComplicationsController;
  
  DateTime? _selectedDob;
  String _selectedGender = 'male';
  bool _isSubmitting = false;
  
  // For birth place clinic selection
  ClinicEntity? _selectedBirthPlaceClinic;
  String? _birthPlaceClinicId;
  String? _birthPlaceClinicName;
  bool _isLoadingClinic = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.child.name);
    _birthWeightController = TextEditingController(
      text: widget.child.birthWeight?.toString() ?? '',
    );
    _birthLengthController = TextEditingController(
      text: widget.child.birthLength?.toString() ?? '',
    );
    _headCircumferenceController = TextEditingController(
      text: widget.child.headCircumference?.toString() ?? '',
    );
    _birthCertificateController = TextEditingController(
      text: widget.child.birthCertificateNo ?? '',
    );
    _birthComplicationsController = TextEditingController(
      text: widget.child.birthComplications ?? '',
    );
    _selectedDob = widget.child.dateOfBirth;
    _selectedGender = widget.child.gender;
    
    // Store the current birth place ID if it exists
    _birthPlaceClinicId = widget.child.birthPlace;
    
    // Load clinic name if birthPlace exists
    if (_birthPlaceClinicId != null) {
      _loadClinicName();
    }
  }

  Future<void> _loadClinicName() async {
    if (_birthPlaceClinicId == null) return;
    
    setState(() => _isLoadingClinic = true);
    
    try {
      final clinicData = await ref.read(clinicByIdProvider(_birthPlaceClinicId!).future);
      
      if (clinicData != null && mounted) {
        setState(() {
          _birthPlaceClinicName = clinicData['name'] as String?;
          _selectedBirthPlaceClinic = ClinicEntity.fromJson(clinicData);
        });
      }
    } catch (e) {
      // Silently fail - will show clinic ID as fallback
    } finally {
      if (mounted) {
        setState(() => _isLoadingClinic = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : widget.child.name),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            TextButton(
              onPressed: _isSubmitting ? null : _saveChanges,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('SAVE', style: TextStyle(color: Colors.white)),
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() => _isEditing = false);
                _resetFields();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: widget.child.photoUrl != null
                        ? NetworkImage(widget.child.photoUrl!)
                        : null,
                    backgroundColor: AppColors.primaryPink.withOpacity(0.2),
                    child: widget.child.photoUrl == null
                        ? Icon(
                            widget.child.gender.toLowerCase() == 'male'
                                ? Icons.boy
                                : Icons.girl,
                            color: AppColors.primaryPink,
                            size: 60,
                          )
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryPink,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.camera_alt, size: 18),
                          color: Colors.white,
                          onPressed: () {
                            // TODO: Implement photo upload
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo upload coming soon!'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Basic Information Card
            _SectionCard(
              title: 'Basic Information',
              child: Column(
                children: [
                  _isEditing
                      ? TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : _InfoRow(label: 'Name', value: widget.child.name),
                  const SizedBox(height: 16),
                  
                  _isEditing
                      ? DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('Boy')),
                            DropdownMenuItem(value: 'female', child: Text('Girl')),
                          ],
                          onChanged: (v) => setState(() => _selectedGender = v!),
                        )
                      : _InfoRow(
                          label: 'Gender',
                          value: widget.child.gender.toUpperCase(),
                        ),
                  const SizedBox(height: 16),
                  
                  _isEditing
                      ? OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            _selectedDob == null
                                ? 'Select Date of Birth'
                                : 'DOB: ${_formatDate(_selectedDob!)}',
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDob ?? DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() => _selectedDob = date);
                            }
                          },
                        )
                      : _InfoRow(
                          label: 'Date of Birth',
                          value: widget.child.dateOfBirthFormatted,
                        ),
                  const SizedBox(height: 16),
                  
                  _InfoRow(label: 'Age', value: widget.child.ageString),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Category', value: widget.child.ageCategory),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Birth Details Card
            _SectionCard(
              title: 'Birth Details',
              child: Column(
                children: [
                  _isEditing
                      ? TextFormField(
                          controller: _birthWeightController,
                          decoration: const InputDecoration(
                            labelText: 'Birth Weight (kg)',
                            border: OutlineInputBorder(),
                            helperText: 'e.g., 3.5',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        )
                      : _InfoRow(
                          label: 'Birth Weight',
                          value: widget.child.birthWeight != null
                              ? '${widget.child.birthWeight} kg'
                              : 'Not recorded',
                        ),
                  const SizedBox(height: 16),
                  
                  _isEditing
                      ? TextFormField(
                          controller: _birthLengthController,
                          decoration: const InputDecoration(
                            labelText: 'Birth Length (cm)',
                            border: OutlineInputBorder(),
                            helperText: 'e.g., 50.5',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        )
                      : _InfoRow(
                          label: 'Birth Length',
                          value: widget.child.birthLength != null
                              ? '${widget.child.birthLength} cm'
                              : 'Not recorded',
                        ),
                  const SizedBox(height: 16),
                  
                  _isEditing
                      ? TextFormField(
                          controller: _headCircumferenceController,
                          decoration: const InputDecoration(
                            labelText: 'Head Circumference (cm)',
                            border: OutlineInputBorder(),
                            helperText: 'e.g., 35.5',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        )
                      : _InfoRow(
                          label: 'Head Circumference',
                          value: widget.child.headCircumference != null
                              ? '${widget.child.headCircumference} cm'
                              : 'Not recorded',
                        ),
                  const SizedBox(height: 16),
                  
                  // Birth Place - Using ClinicSearchSheet
                  _isEditing
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                final result = await showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => const ClinicSearchSheet(),
                                );
                                
                                  if (result != null && mounted) {
                                  // Handle both ClinicEntity and Map<String, dynamic>
                                  ClinicEntity clinic;
                                  
                                  if (result is ClinicEntity) {
                                    clinic = result;
                                  } else if (result is Map<String, dynamic>) {
                                    // Convert JSON map to ClinicEntity
                                    clinic = ClinicEntity.fromJson(result);
                                  } else {
                                    return;
                                  }
                                  
                                  setState(() {
                                    _selectedBirthPlaceClinic = clinic;
                                    _birthPlaceClinicId = clinic.id;
                                    _birthPlaceClinicName = clinic.name;
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_hospital,
                                      color: AppColors.primaryPink,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _isLoadingClinic
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: AppColors.primaryPink,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Loading clinic...',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              _birthPlaceClinicName ??
                                              _selectedBirthPlaceClinic?.name ?? 
                                              (_birthPlaceClinicId != null 
                                                  ? 'Clinic selected' 
                                                  : 'Select Birth Place'),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: _birthPlaceClinicId != null 
                                                    ? FontWeight.w500 
                                                    : FontWeight.normal,
                                                color: _birthPlaceClinicId != null 
                                                    ? Colors.black87 
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                    ),
                                    if (_birthPlaceClinicId != null)
                                      IconButton(
                                        icon: const Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            _selectedBirthPlaceClinic = null;
                                            _birthPlaceClinicId = null;
                                            _birthPlaceClinicName = null;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      )
                                    else
                                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : _InfoRow(
                          label: 'Birth Place',
                          value: _birthPlaceClinicName ??
                              (widget.child.birthPlace != null
                                  ? 'Clinic ID: ${widget.child.birthPlace}'
                                  : 'Not recorded'),
                        ),
                  const SizedBox(height: 16),
                  
                  _isEditing
                      ? TextFormField(
                          controller: _birthCertificateController,
                          decoration: const InputDecoration(
                            labelText: 'Birth Certificate No.',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : _InfoRow(
                          label: 'Birth Certificate',
                          value: widget.child.birthCertificateNo ?? 'Not recorded',
                        ),
                  const SizedBox(height: 16),
                  
                  _isEditing
                      ? TextFormField(
                          controller: _birthComplicationsController,
                          decoration: const InputDecoration(
                            labelText: 'Birth Complications',
                            border: OutlineInputBorder(),
                            helperText: 'Any complications during birth',
                          ),
                          maxLines: 3,
                        )
                      : _InfoRow(
                          label: 'Complications',
                          value: widget.child.birthComplications ?? 'None recorded',
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QR Code Card
            _SectionCard(
              title: 'QR Code',
              child: _InfoRow(label: 'Code', value: widget.child.qrCode),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter child\'s name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date of birth'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(childrenProvider(widget.motherId).notifier).updateChild(
            childId: widget.child.id,
            name: _nameController.text.trim(),
            dateOfBirth: _selectedDob,
            gender: _selectedGender,
            birthWeight: _birthWeightController.text.isNotEmpty
                ? double.tryParse(_birthWeightController.text)
                : null,
            birthLength: _birthLengthController.text.isNotEmpty
                ? double.tryParse(_birthLengthController.text)
                : null,
            headCircumference: _headCircumferenceController.text.isNotEmpty
                ? double.tryParse(_headCircumferenceController.text)
                : null,
            birthPlace: _birthPlaceClinicId,
            birthCertificateNo: _birthCertificateController.text.trim().isNotEmpty
                ? _birthCertificateController.text.trim()
                : null,
            birthComplications: _birthComplicationsController.text.trim().isNotEmpty
                ? _birthComplicationsController.text.trim()
                : null,
          );

      if (!mounted) return;

      if (success) {
        setState(() {
          _isEditing = false;
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetFields() {
    _nameController.text = widget.child.name;
    _birthWeightController.text = widget.child.birthWeight?.toString() ?? '';
    _birthLengthController.text = widget.child.birthLength?.toString() ?? '';
    _headCircumferenceController.text = widget.child.headCircumference?.toString() ?? '';
    _birthCertificateController.text = widget.child.birthCertificateNo ?? '';
    _birthComplicationsController.text = widget.child.birthComplications ?? '';
    _selectedDob = widget.child.dateOfBirth;
    _selectedGender = widget.child.gender;
    _selectedBirthPlaceClinic = null;
    _birthPlaceClinicId = widget.child.birthPlace;
    _birthPlaceClinicName = null;
    
    // Reload clinic name
    if (_birthPlaceClinicId != null) {
      _loadClinicName();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthWeightController.dispose();
    _birthLengthController.dispose();
    _headCircumferenceController.dispose();
    _birthCertificateController.dispose();
    _birthComplicationsController.dispose();
    super.dispose();
  }
}

// Section Card Widget
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPink,
              ),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}