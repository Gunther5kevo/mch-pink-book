/// lib/presentation/screens/nurse/add_child_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/presentation/providers/child_provider.dart';

class AddChildScreen extends ConsumerStatefulWidget {
  final String motherId;
  final String motherName;

  const AddChildScreen({
    super.key,
    required this.motherId,
    required this.motherName,
  });

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDob;
  String _gender = 'male';

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Child for ${widget.motherName}'),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.trim().isEmpty == true ? 'Name required' : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Boy')),
                  DropdownMenuItem(value: 'female', child: Text('Girl')),
                ],
                onChanged: (v) => setState(() => _gender = v!),
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDob == null
                      ? 'Select Date of Birth'
                      : 'DOB: ${_formatDate(_selectedDob!)}',
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _selectedDob = date);
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register Child', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await ref.read(childrenProvider(widget.motherId).notifier).addChild(
          name: _nameController.text.trim(),
          dateOfBirth: _selectedDob!,
          gender: _gender,
        );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Child registered!' : 'Failed to register child'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}