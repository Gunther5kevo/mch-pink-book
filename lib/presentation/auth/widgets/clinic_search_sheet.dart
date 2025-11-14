/// Clinic Search Sheet - With Enhanced Debug Logging
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/clinic_provider.dart';

class ClinicSearchSheet extends ConsumerStatefulWidget {
  const ClinicSearchSheet({super.key});

  @override
  ConsumerState<ClinicSearchSheet> createState() => _ClinicSearchSheetState();
}

class _ClinicSearchSheetState extends ConsumerState<ClinicSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    print('🔍 ClinicSearchSheet initialized');
  }

  @override
  void dispose() {
    print('🔍 ClinicSearchSheet disposed');
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 Building ClinicSearchSheet, query: "$_query"');
    
    final clinicsAsync = _query.isEmpty
        ? const AsyncValue<List<Map<String, dynamic>>>.data([])
        : ref.watch(clinicSearchProvider(_query));

    // Listen for state changes and log them
    ref.listen<AsyncValue<List<Map<String, dynamic>>>>(
      clinicSearchProvider(_query),
      (previous, next) {
        next.when(
          data: (clinics) {
            print('✅ Search completed: ${clinics.length} results');
          },
          loading: () {
            print('⏳ Search loading...');
          },
          error: (error, stack) {
            print('❌ Search error: $error');
          },
        );
      },
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.local_hospital, color: AppColors.primaryPink),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Search Health Facility',
                        style: AppTextStyles.h3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        print('🔍 Closing search sheet');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Search field
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search by name, MFL code, or county',
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              print('🔍 Clearing search');
                              _searchController.clear();
                              setState(() {
                                _query = '';
                                _showInstructions = true;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    print('🔍 Search text changed: "$value"');
                    setState(() {
                      _query = value;
                      _showInstructions = value.isEmpty;
                    });
                  },
                ),
              ),

              // Debug info banner (only in debug mode)
              if (_query.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Searching for: "$_query" (Check console for logs)',
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Results area
              Expanded(
                child: _showInstructions
                    ? _buildInstructions()
                    : clinicsAsync.when(
                        data: (clinics) {
                          print('🔍 Rendering ${clinics.length} results');
                          return _buildResults(clinics, scrollController);
                        },
                        loading: () {
                          print('🔍 Showing loading indicator');
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        error: (error, stack) {
                          print('🔍 Showing error: $error');
                          return _buildError(error.toString());
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Search for Your Health Facility',
              style: AppTextStyles.h3.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start typing to search available facilities',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSearchTip('Facility name', 'e.g., "Kenyatta Hospital"'),
            const SizedBox(height: 8),
            _buildSearchTip('MFL Code', 'e.g., "13456"'),
            const SizedBox(height: 8),
            _buildSearchTip('County', 'e.g., "Nairobi"'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTip(String label, String example) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        Text(
          example,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textLight,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildResults(List<Map<String, dynamic>> clinics, ScrollController scrollController) {
    if (clinics.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No facilities found',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try a different search term or check spelling',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Debug suggestion
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Debug Tips:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Check console logs for detailed info\n'
                      '• Verify clinics table has data\n'
                      '• Check RLS policies allow reading\n'
                      '• Try searching for "hospital" or "clinic"',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      itemCount: clinics.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        final name = clinic['name'] as String;
        final county = clinic['county'] as String?;
        final subCounty = clinic['sub_county'] as String?;
        final facilityType = clinic['facility_type'] as String?;
        final mflCode = clinic['mfl_code'] as String?;

        // Build subtitle
        final subtitleParts = <String>[];
        if (county != null && county.isNotEmpty) subtitleParts.add(county);
        if (subCounty != null && subCounty.isNotEmpty) subtitleParts.add(subCounty);
        final subtitle = subtitleParts.join(', ');

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_hospital,
              color: AppColors.primaryPink,
            ),
          ),
          title: Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
              if (facilityType != null && facilityType.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        facilityType,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (mflCode != null && mflCode.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        'MFL: $mflCode',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
          onTap: () {
            print('🔍 ==========================================');
            print('🔍 Clinic selected:');
            print('   - ID: ${clinic['id']}');
            print('   - Name: $name');
            print('   - County: $county');
            print('   - Sub-County: $subCounty');
            print('   - Type: $facilityType');
            print('   - MFL Code: $mflCode');
            print('🔍 ==========================================');
            Navigator.pop(context, clinic);
          },
        );
      },
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Failed to load facilities',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Detailed error info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Troubleshooting:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Check your internet connection\n'
                    '2. Verify Supabase is configured\n'
                    '3. Check console logs for details\n'
                    '4. Ensure clinics table exists\n'
                    '5. Verify RLS policies allow reading',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                print('🔍 Retrying search...');
                setState(() {
                  _query = _searchController.text;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}