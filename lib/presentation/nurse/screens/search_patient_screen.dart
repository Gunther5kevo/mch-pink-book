import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/domain/entities/patient_entity.dart';
import '../../providers/patients_provider.dart';
import 'patient_profile_screen.dart';

class SearchPatientScreen extends ConsumerStatefulWidget {
  const SearchPatientScreen({super.key});

  @override
  ConsumerState<SearchPatientScreen> createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends ConsumerState<SearchPatientScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _searchController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(patientSearchProvider.notifier).state = '';
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        ref.read(patientSearchProvider.notifier).state = value;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _debounce?.cancel();
    ref.read(patientSearchProvider.notifier).state = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = ref.watch(filteredPatientsProvider);
    final query = ref.watch(patientSearchProvider);

    // Filter per tab
    final mothers = filtered.where((p) => p.type == 'mother').toList();
    final children = filtered.where((p) => p.type == 'child').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patient'),
        centerTitle: true,
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Mothers'),
            Tab(text: 'Children'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ---- Search bar ----
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: _focusNode.hasFocus
                    ? Colors.white
                    : Colors.grey.shade100,
                boxShadow: [
                  if (_focusNode.hasFocus)
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, or phone',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: _updateSearchQuery,
              ),
            ),
          ),

          // ---- Results per tab ----
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBody(filtered, query.isNotEmpty),
                _buildBody(mothers, query.isNotEmpty),
                _buildBody(children, query.isNotEmpty),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(List<Patient> patients, bool hasQuery) {
    if (patients.isEmpty && hasQuery) {
      return Center(
        key: const ValueKey('empty'),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_search, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No matching patients found',
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      key: const ValueKey('list'),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: patients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, i) {
        final p = patients[i];
        return _PatientCard(
          patient: p,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PatientProfileScreen(patient: p),
            ),
          ),
        );
      },
    );
  }
}

// ---------- Improved Card ----------
class _PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const _PatientCard({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMother = patient.type == 'mother';
    final borderColor =
        isMother ? AppColors.primaryPink : AppColors.accentBlue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: borderColor, width: 4)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: borderColor,
              child: Text(
                patient.name.isNotEmpty
                    ? patient.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: AppTextStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.badge, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('ID: ${patient.id}',
                          style: AppTextStyles.caption),
                    ],
                  ),
                  if (patient.phone != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(patient.phone!,
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    isMother
                        ? 'Mother'
                        : 'Child${patient.motherId != null ? ' • Linked' : ''}',
                    style: TextStyle(
                      color: borderColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
