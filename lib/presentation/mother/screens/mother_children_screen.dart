/// Mother Children Screen - Updated with Provider Integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/providers/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/child_provider.dart';

import '../../shared/widgets/empty_state.dart';
import '../../../domain/entities/child_entity.dart';


class MotherChildrenScreen extends ConsumerStatefulWidget {
  const MotherChildrenScreen({super.key});

  @override
  ConsumerState<MotherChildrenScreen> createState() =>
      _MotherChildrenScreenState();
}

class _MotherChildrenScreenState extends ConsumerState<MotherChildrenScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // Get current user/mother ID from auth provider
    final currentUser = ref.watch(currentUserProvider);
    final motherId = currentUser.value?.id ?? '';

    // Watch children state
    final childrenState = ref.watch(childrenProvider(motherId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Children'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(motherId),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: _buildBody(childrenState, motherId),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddChildDialog(motherId),
        icon: const Icon(Icons.add),
        label: const Text('Add Child'),
        backgroundColor: AppColors.primaryPink,
      ),
    );
  }

  Widget _buildBody(ChildrenState state, String motherId) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(childrenProvider(motherId).notifier).refreshChildren(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.children.isEmpty) {
      return _buildEmptyState(motherId);
    }

    return _buildContent(state.children, motherId);
  }

  Widget _buildEmptyState(String motherId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: EmptyState(
          icon: Icons.child_care,
          title: 'No Children Added',
          subtitle: 'Start by adding your first child\'s information',
          actionLabel: 'Add Child',
          onAction: () => _showAddChildDialog(motherId),
          iconColor: AppColors.primaryPink,
        ),
      ),
    );
  }

  Widget _buildContent(List<ChildEntity> children, String motherId) {
    final notifier = ref.read(childrenProvider(motherId).notifier);
    final filteredChildren = notifier.getFilteredChildren(_selectedFilter);

    return RefreshIndicator(
      onRefresh: () => notifier.refreshChildren(),
      child: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: filteredChildren.isEmpty
                ? _buildNoResultsState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredChildren.length,
                    itemBuilder: (context, index) {
                      final child = filteredChildren[index];
                      return _buildChildItem(child, motherId);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Infant', 'Toddler', 'Child'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedFilter = filter);
                },
                selectedColor: AppColors.primaryPink.withOpacity(0.2),
                checkmarkColor: AppColors.primaryPink,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryPink : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChildItem(ChildEntity child, String motherId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToChildDetail(child),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Child Avatar
              Hero(
                tag: 'child-${child.id}',
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: _getAvatarColor(child.gender),
                  backgroundImage: child.photoUrl != null
                      ? NetworkImage(child.photoUrl!)
                      : null,
                  child: child.photoUrl == null
                      ? Icon(
                          child.gender.toLowerCase() == 'male'
                              ? Icons.boy
                              : Icons.girl,
                          color: Colors.white,
                          size: 32,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              // Child Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${child.ageString} • ${child.genderDisplay}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildChildStats(child),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 8),
                        Text('View Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'vaccines',
                    child: Row(
                      children: [
                        Icon(Icons.vaccines, size: 20),
                        SizedBox(width: 8),
                        Text('Vaccines'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'growth',
                    child: Row(
                      children: [
                        Icon(Icons.show_chart, size: 20),
                        SizedBox(width: 8),
                        Text('Growth Chart'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _handleChildAction(value, child, motherId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildStats(ChildEntity child) {
    return Row(
      children: [
        _buildStatBadge(
          Icons.cake,
          'DOB: ${_formatDate(child.dateOfBirth)}',
          AppColors.accentBlue,
        ),
        if (child.birthWeight != null) ...[
          const SizedBox(width: 8),
          _buildStatBadge(
            Icons.monitor_weight,
            '${child.birthWeight}kg',
            child.isLowBirthWeight ? Colors.orange : AppColors.accentGreen,
          ),
        ],
      ],
    );
  }

  Widget _buildStatBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No children found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  Color _getAvatarColor(String gender) {
    return gender.toLowerCase() == 'male'
        ? AppColors.accentBlue.withOpacity(0.7)
        : AppColors.primaryPink.withOpacity(0.7);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showSearch(String motherId) {
    showSearch(
      context: context,
      delegate: _ChildSearchDelegate(ref, motherId),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filter by Age',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('All Children'),
              onTap: () {
                setState(() => _selectedFilter = 'All');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.baby_changing_station),
              title: const Text('Infants (0-1 year)'),
              onTap: () {
                setState(() => _selectedFilter = 'Infant');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.child_care),
              title: const Text('Toddlers (1-3 years)'),
              onTap: () {
                setState(() => _selectedFilter = 'Toddler');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.accessibility_new),
              title: const Text('Children (3+ years)'),
              onTap: () {
                setState(() => _selectedFilter = 'Child');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddChildDialog(String motherId) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    DateTime? selectedBirthDate;
    String selectedGender = 'male';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Child'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Boy')),
                      DropdownMenuItem(value: 'female', child: Text('Girl')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedGender = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() => selectedBirthDate = date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedBirthDate == null
                          ? 'Select Birth Date'
                          : 'Birth Date: ${_formatDate(selectedBirthDate!)}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedBirthDate != null) {
                final notifier = ref.read(childrenProvider(motherId).notifier);
                final success = await notifier.addChild(
                  name: nameController.text.trim(),
                  dateOfBirth: selectedBirthDate!,
                  gender: selectedGender,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Child added successfully!'
                          : 'Failed to add child'),
                      backgroundColor:
                          success ? AppColors.success : AppColors.error,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _navigateToChildDetail(ChildEntity child) {
    // TODO: Navigate to child detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${child.name} profile...')),
    );
  }

  void _handleChildAction(String action, ChildEntity child, String motherId) {
    final notifier = ref.read(childrenProvider(motherId).notifier);

    switch (action) {
      case 'view':
        _navigateToChildDetail(child);
        break;
      case 'edit':
        // TODO: Implement edit dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit child - Coming soon!')),
        );
        break;
      case 'vaccines':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vaccine records - Coming soon!')),
        );
        break;
      case 'growth':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Growth chart - Coming soon!')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(child, notifier);
        break;
    }
  }

  void _showDeleteConfirmation(ChildEntity child, ChildrenNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Child'),
        content: Text('Are you sure you want to remove ${child.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await notifier.deleteChild(child.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Child removed successfully'
                        : 'Failed to remove child'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Search Delegate
class _ChildSearchDelegate extends SearchDelegate<ChildEntity?> {
  final WidgetRef ref;
  final String motherId;

  _ChildSearchDelegate(this.ref, this.motherId);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final childrenState = ref.watch(childrenProvider(motherId));
    final children = childrenState.children;

    final results = children.where((child) {
      return child.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No children found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final child = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryPinkLight,
            backgroundImage: child.photoUrl != null
                ? NetworkImage(child.photoUrl!)
                : null,
            child: child.photoUrl == null
                ? Icon(
                    child.gender.toLowerCase() == 'male' ? Icons.boy : Icons.girl,
                    color: AppColors.primaryPink,
                  )
                : null,
          ),
          title: Text(child.name),
          subtitle: Text(child.ageString),
          onTap: () => close(context, child),
        );
      },
    );
  }
}