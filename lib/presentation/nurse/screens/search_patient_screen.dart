/// lib/presentation/screens/nurse/search_patient_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';

import '../../providers/patients_provider.dart';
import 'patient_profile_screen.dart';

class SearchPatientScreen extends ConsumerStatefulWidget {
  const SearchPatientScreen({super.key});

  @override
  ConsumerState<SearchPatientScreen> createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends ConsumerState<SearchPatientScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset search on open
    _searchController.clear();
    ref.read(patientSearchProvider.notifier).state = '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPatients = ref.watch(filteredPatientsProvider);
    final searchQuery = ref.watch(patientSearchProvider);

    ref.listen(patientSearchProvider, (_, query) {
      // Optional: debounce if needed
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patient'),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, ID, phone...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                ref.read(patientSearchProvider.notifier).state = value;
              },
            ),
          ),

          // Results
          Expanded(
            child: filteredPatients.isEmpty && searchQuery.isNotEmpty
                ? const Center(
                    child: Text(
                      'No patients found',
                      style: AppTextStyles.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      return _PatientTile(
                        patient: patient,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientProfileScreen(patient: patient),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PatientTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const _PatientTile({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMother = patient.type == 'mother';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMother ? AppColors.primaryPink : AppColors.accentBlue,
          child: Text(
            patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.name,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${patient.id}'),
            if (patient.phone != null) Text('Phone: ${patient.phone}'),
            Text(
              isMother ? 'Mother' : 'Child${patient.motherId != null ? ' • Linked' : ''}',
              style: TextStyle(
                color: isMother ? AppColors.primaryPink : AppColors.accentBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}