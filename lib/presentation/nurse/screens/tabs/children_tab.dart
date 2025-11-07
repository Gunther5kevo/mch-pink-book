import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../providers/child_provider.dart';
import '../../../../domain/entities/child_entity.dart';
import '../../../shared/widgets/loading_shimmer.dart';

/// ---------------------------------------------------------------
/// CHILDREN TAB – displays mother’s children list
/// ---------------------------------------------------------------
class ChildrenTab extends ConsumerWidget {
  final String motherId;
  const ChildrenTab({super.key, required this.motherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(childrenProvider(motherId));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPink,
        onPressed: () {
          // TODO: navigate to "Add Child" screen
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(childrenProvider(motherId).notifier).refreshChildren();
        },
        child: Builder(
          builder: (_) {
            if (state.isLoading) {
              return const _ChildrenShimmer();
            }

            if (state.error != null) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: AppTextStyles.error,
                  textAlign: TextAlign.center,
                ),
              );
            }

            final children = state.children;
            if (children.isEmpty) {
              return const _EmptyChildrenState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: children.length,
              itemBuilder: (context, index) {
                return _ChildCard(child: children[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// SHIMMER STATE (while loading)
/// ---------------------------------------------------------------
class _ChildrenShimmer extends StatelessWidget {
  const _ChildrenShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: LoadingShimmer(
          height: 100,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// EMPTY STATE
/// ---------------------------------------------------------------
class _EmptyChildrenState extends StatelessWidget {
  const _EmptyChildrenState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.child_care, size: 72, color: AppColors.accentBlue),
            const SizedBox(height: 12),
            Text('No Children Found', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'You can add a child record linked to this mother.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// CHILD CARD (single child display)
/// ---------------------------------------------------------------
class _ChildCard extends StatelessWidget {
  final ChildEntity child;
  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Navigate to child details screen
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Photo
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    child.photoUrl != null ? NetworkImage(child.photoUrl!) : null,
                backgroundColor: AppColors.accentBlue.withOpacity(0.2),
                child: child.photoUrl == null
                    ? const Icon(Icons.child_care, color: AppColors.accentBlue)
                    : null,
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(child.name ?? 'Unnamed Child', style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text(
                      'Born: ${child.dateOfBirthFormatted}',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      'Age: ${child.ageInMonths} months',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Gender Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (child.gender?.toLowerCase() == 'male'
                          ? Colors.blue.shade100
                          : Colors.pink.shade100)
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  child.gender?.toUpperCase() ?? '—',
                  style: AppTextStyles.caption.copyWith(
                    color: child.gender?.toLowerCase() == 'male'
                        ? Colors.blue.shade700
                        : Colors.pink.shade700,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
