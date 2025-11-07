import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mch_pink_book/core/constants/app_constants.dart';

// Domain
import 'package:mch_pink_book/domain/entities/patient_entity.dart' as domain;

// Providers
import '../../providers/visit_provider.dart';
import '../../providers/pregnancy_provider.dart';
import '../../providers/appointments_provider.dart';

class RecordVisitBottomSheet extends ConsumerStatefulWidget {
  final domain.Patient patient;
  final String? appointmentId;

  const RecordVisitBottomSheet({
    super.key,
    required this.patient,
    this.appointmentId,
  });

  @override
  ConsumerState<RecordVisitBottomSheet> createState() =>
      _RecordVisitBottomSheetState();
}

class _RecordVisitBottomSheetState extends ConsumerState<RecordVisitBottomSheet> {
  // ────────────────────── Form State ──────────────────────
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  VisitType? _visitType;
  bool _isSubmitting = false;

  // Controllers
  final _notesController = TextEditingController();
  final _gestationController = TextEditingController();
  final _weightController = TextEditingController();
  final _bpSysController = TextEditingController();
  final _bpDiaController = TextEditingController();
  final _examinationController = TextEditingController();
  final _labResultsController = TextEditingController();
  final _prescriptionController = TextEditingController();

  // Photos (upload only)
  final List<XFile> _images = [];
  final _picker = ImagePicker();

  // Supabase
  final _supabase = Supabase.instance.client;

  // ────────────────────── Dynamic Visibility ──────────────────────
  bool get showGestation =>
      _visitType == VisitType.anc ||
      _visitType == VisitType.delivery ||
      _visitType == VisitType.postnatal;

  bool get showExamination =>
      _visitType == VisitType.anc ||
      _visitType == VisitType.delivery ||
      _visitType == VisitType.postnatal;

  bool get showLabResults =>
      _visitType == VisitType.anc || _visitType == VisitType.postnatal;

  bool get showPrescriptions =>
      _visitType == VisitType.anc ||
      _visitType == VisitType.delivery ||
      _visitType == VisitType.general;

  // ────────────────────── Helpers ──────────────────────
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null && _images.length < 3) {
      setState(() => _images.add(picked));
    }
  }

  Future<String?> _getPregnancyId() async {
    if (widget.patient.type != 'mother') return null;
    final pregnancyAsync = ref.read(activePregnancyProvider(widget.patient.id));
    return pregnancyAsync.when(
      data: (p) => p?.id,
      loading: () => null,
      error: (_, __) => null,
    );
  }

  Future<List<String>> _uploadPhotos(String visitId) async {
    final urls = <String>[];
    const bucket = 'visit-photos';
    for (int i = 0; i < _images.length; i++) {
      final file = File(_images[i].path);
      final ext = _images[i].path.split('.').last;
      final path = '$visitId/photo_$i.$ext';
      try {
        await _supabase.storage.from(bucket).upload(path, file);
        final url = _supabase.storage.from(bucket).getPublicUrl(path);
        urls.add(url);
      } catch (e) {
        debugPrint('Photo upload failed: $e');
      }
    }
    return urls;
  }

  Future<void> _markAppointmentCompleted(String visitId) async {
    if (widget.appointmentId == null) return;
    try {
      await _supabase.from('appointments').update({
        'status': 'completed',
        'completed_at': DateTime.now().toIso8601String(),
        'visit_id': visitId,
      }).eq('id', widget.appointmentId!);
    } catch (e) {
      debugPrint('Failed to mark appointment completed: $e');
    }
  }

  // ────────────────────── Submit Logic ──────────────────────
    void _submit() async {
    if (!_formKey.currentState!.validate() || _visitType == null || _isSubmitting)
      return;

    setState(() => _isSubmitting = true);

    final visitService = ref.read(visitProvider);

    // Build vitals
    final vitals = <String, dynamic>{};
    final weight = _weightController.text.trim();
    final bpSys = _bpSysController.text.trim();
    final bpDia = _bpDiaController.text.trim();

    if (weight.isNotEmpty) vitals['weight'] = double.tryParse(weight);
    if (bpSys.isNotEmpty && bpDia.isNotEmpty) {
      vitals['bp_systolic'] = int.tryParse(bpSys);
      vitals['bp_diastolic'] = int.tryParse(bpDia);
    }

    // Build optional JSONB fields with correct typing
    final examination = showExamination && _examinationController.text.isNotEmpty
        ? <String, dynamic>{'notes': _examinationController.text}
        : <String, dynamic>{};

    final labResults = showLabResults && _labResultsController.text.isNotEmpty
        ? <String, dynamic>{'summary': _labResultsController.text}
        : <String, dynamic>{};

    final prescriptions = showPrescriptions && _prescriptionController.text.isNotEmpty
        ? <Map<String, dynamic>>[
            {'description': _prescriptionController.text}
          ]
        : <Map<String, dynamic>>[];

    try {
      final pregnancyId = await _getPregnancyId();

      final visit = await visitService.recordVisit(
        subjectId: widget.patient.id,
        subjectType: widget.patient.type,
        type: _visitType!,
        visitDate: _selectedDate,
        pregnancyId: pregnancyId,
        gestationWeeks: showGestation && _gestationController.text.isNotEmpty
            ? int.tryParse(_gestationController.text)
            : null,
        vitals: vitals,
        examination: examination,
        labResults: labResults,
        prescriptions: prescriptions,
        notes: _notesController.text,
        nextVisitDate: null,
        advice: null,
      );

      // Upload photos (no DB update)
      if (_images.isNotEmpty) {
        await _uploadPhotos(visit.id);
      }

      await _markAppointmentCompleted(visit.id);

      ref.invalidate(nurseAppointmentsProvider);
      ref.invalidate(motherAppointmentsProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visit recorded successfully!'),
          backgroundColor: AppColors.accentGreen,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
  
  // ────────────────────── Lifecycle ──────────────────────
  @override
  void dispose() {
    _notesController.dispose();
    _gestationController.dispose();
    _weightController.dispose();
    _bpSysController.dispose();
    _bpDiaController.dispose();
    _examinationController.dispose();
    _labResultsController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  // ────────────────────── UI ──────────────────────
  @override
  Widget build(BuildContext context) {
    final isMother = widget.patient.type == 'mother';

    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.92,
      minChildSize: 0.6,
      initialChildSize: 0.75,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            children: [
              // ── Drag Handle ──
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Title ──
              Text(
                'Record Visit – ${widget.patient.name}',
                style: AppTextStyles.h3.copyWith(color: AppColors.primaryPink),
              ),
              const SizedBox(height: 24),

              // ── Date Picker ──
              ListTile(
                leading: const Icon(Icons.calendar_today, color: AppColors.accentGreen),
                title: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 16),

              // ── Visit Type ──
              DropdownButtonFormField<VisitType>(
                value: _visitType,
                decoration: InputDecoration(
                  labelText: 'Visit Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: VisitType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.displayName)))
                    .toList(),
                validator: (v) => v == null ? 'Required' : null,
                onChanged: _isSubmitting
                    ? null
                    : (v) {
                        setState(() => _visitType = v);
                      },
              ),
              const SizedBox(height: 16),

              // ── Gestation (ANC/Delivery/PNC) ──
              if (showGestation && isMother) ...[
                TextFormField(
                  controller: _gestationController,
                  keyboardType: TextInputType.number,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Gestation (weeks)',
                    suffixText: 'weeks',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v?.isEmpty ?? true
                      ? null
                      : int.tryParse(v!) == null
                          ? 'Invalid number'
                          : null,
                ),
                const SizedBox(height: 16),
              ],

              // ── Vitals (always shown) ──
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      enabled: !_isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        suffixText: 'kg',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _bpSysController,
                      keyboardType: TextInputType.number,
                      enabled: !_isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'BP Sys',
                        suffixText: 'mmHg',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _bpDiaController,
                      keyboardType: TextInputType.number,
                      enabled: !_isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'BP Dia',
                        suffixText: 'mmHg',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Examination ──
              if (showExamination) ...[
                TextFormField(
                  controller: _examinationController,
                  maxLines: 3,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Examination Notes',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Lab Results ──
              if (showLabResults) ...[
                TextFormField(
                  controller: _labResultsController,
                  maxLines: 3,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Lab Results',
                    hintText: 'e.g. Hb=12.5, Urine=Negative',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Prescriptions ──
              if (showPrescriptions) ...[
                TextFormField(
                  controller: _prescriptionController,
                  maxLines: 2,
                  enabled: !_isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Prescriptions',
                    hintText: 'e.g. Ferrous sulfate – 1 tab daily',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Notes (always shown) ──
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                enabled: !_isSubmitting,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // ── Photos (upload only) ──
              Wrap(
                spacing: 8,
                children: [
                  ..._images.map((img) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(img.path), width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: _isSubmitting
                                  ? null
                                  : () => setState(() => _images.remove(img)),
                            ),
                          ),
                        ],
                      )),
                  if (_images.length < 3 && !_isSubmitting)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_a_photo, color: Colors.grey),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Submit ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Save Visit', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}