/// lib/presentation/nurse/screens/create_appointment_screen.dart
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../providers/appointments_provider.dart';
import '../../providers/patients_provider.dart';

class CreateAppointmentScreen extends ConsumerStatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  ConsumerState<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState
    extends ConsumerState<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();

  String? _selectedPatientId;
  VisitType _selectedType = VisitType.anc;
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));
  int _durationMinutes = 30;
  bool _isSubmitting = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        ref.read(patientSearchProvider.notifier).state =
            _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);
    final filteredPatients = ref.watch(filteredPatientsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        title: Text('New Appointment', style: AppTextStyles.h2),
        elevation: 0,
        actions: [
          _isSubmitting
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text('Save',
                      style:
                          AppTextStyles.button.copyWith(color: Colors.white)),
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------- LOADING / ERROR -------------------
              if (patientsAsync.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      LinearProgressIndicator(color: AppColors.primaryPink),
                      SizedBox(height: 12),
                      Text('Loading patients...',
                          style: AppTextStyles.bodyMedium),
                    ],
                  ),
                )
              else if (patientsAsync.hasError)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${patientsAsync.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(patientsProvider.notifier).refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else ...[
                // ------------------- PATIENT SEARCH -------------------
                // ------------------- PATIENT SEARCH -------------------
                Text(
                  'Select Patient',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),

                Autocomplete<Patient>(
                  optionsBuilder: (textEditingValue) {
                    final query = textEditingValue.text.trim().toLowerCase();

                    // Show all when empty
                    if (query.isEmpty) return filteredPatients;

                    return filteredPatients.where((p) =>
                        p.name.toLowerCase().contains(query) ||
                        p.id.toLowerCase().contains(query) ||
                        (p.phone?.toLowerCase().contains(query) ?? false) ||
                        (p.nationalId?.toLowerCase().contains(query) ?? false));
                  },
                  displayStringForOption: (p) => '${p.name} • ${p.id}',
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      onTap: () {
                        // 🪄 Show dropdown immediately when tapped
                        if (controller.text.isEmpty) {
                          controller.text = ' ';
                          Future.delayed(const Duration(milliseconds: 50), () {
                            controller.clear();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: filteredPatients.isEmpty
                            ? 'No patients found'
                            : 'Tap to see ${filteredPatients.length} patients...',
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textLight),
                        suffixIcon: _selectedPatientId != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _selectedPatientId = null;
                                    controller.clear();
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      validator: (_) => _selectedPatientId == null
                          ? 'Please select a patient'
                          : null,
                    );
                  },
                  onSelected: (patient) {
                    setState(() {
                      _selectedPatientId = patient.id;
                    });
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    if (options.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final patient = options.elementAt(index);
                              return ListTile(
                                leading: Icon(
                                  patient.type == 'mother'
                                      ? Icons.person
                                      : Icons.child_care,
                                  color: patient.type == 'mother'
                                      ? AppColors.primaryPink
                                      : AppColors.primaryBlue,
                                ),
                                title: Text(patient.name,
                                    style: AppTextStyles.bodyMedium),
                                subtitle: Text(patient.id,
                                    style: AppTextStyles.caption),
                                onTap: () => onSelected(patient),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ------------------- VISIT TYPE -------------------
              Text('Visit Type',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<VisitType>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: VisitType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(type.icon, color: type.color, size: 20),
                        const SizedBox(width: 8),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ------------------- DATE & TIME -------------------
              Text('Date & Time',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedDate.formattedDate),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              _selectedDate.hour,
                              _selectedDate.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedDate.formattedTime),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_selectedDate),
                        );
                        if (time != null) {
                          setState(() {
                            _selectedDate = DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ------------------- DURATION -------------------
              Text('Duration',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<int>(
                initialValue: _durationMinutes,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [15, 30, 45, 60].map((min) {
                  return DropdownMenuItem(
                      value: min, child: Text('$min minutes'));
                }).toList(),
                onChanged: (value) => setState(() => _durationMinutes = value!),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ------------------- NOTES -------------------
              Text('Notes (Optional)',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any special instructions...',
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- SUBMIT -------------------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedPatientId == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(appointmentActionsProvider).createAppointment(
            userId: _selectedPatientId!,
            type: _selectedType,
            scheduledAt: _selectedDate,
            durationMinutes: _durationMinutes,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(SuccessMessages.appointmentBooked),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      ref.invalidate(nurseAppointmentsProvider);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
