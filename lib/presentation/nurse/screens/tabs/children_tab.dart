/// lib/presentation/screens/nurse/tabs/children_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';
import 'package:mch_pink_book/domain/entities/child_entity.dart';
import 'package:mch_pink_book/presentation/providers/child_provider.dart';

class ChildrenTab extends ConsumerWidget {
  final String motherId;
  final String motherName;

  const ChildrenTab({
    super.key,
    required this.motherId,
    this.motherName = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(childrenProvider(motherId));

    return RefreshIndicator(
      onRefresh: () => ref.read(childrenProvider(motherId).notifier).refreshChildren(),
      child: Builder(builder: (_) {
        if (state.isLoading && state.children.isEmpty) {
          return const _ChildrenShimmer();
        }

        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.error}', style: AppTextStyles.error),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(childrenProvider(motherId).notifier).refreshChildren(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final children = state.children;
        if (children.isEmpty) {
          return _EmptyChildrenState(motherName: motherName);
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(), // Needed for RefreshIndicator
          padding: const EdgeInsets.all(16),
          itemCount: children.length,
          itemBuilder: (context, index) => _ChildCard(child: children[index]),
        );
      }),
    );
  }
}

// ———————————————————————— SHIMMER ————————————————————————
class _ChildrenShimmer extends StatelessWidget {
  const _ChildrenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(width: 56, height: 56, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 16, width: 150, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Container(height: 14, width: 100, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Container(height: 14, width: 80, color: Colors.grey[300]),
                    ],
                  ),
                ),
                Container(width: 50, height: 24, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ———————————————————————— EMPTY STATE ————————————————————————
class _EmptyChildrenState extends StatelessWidget {
  final String motherName;
  const _EmptyChildrenState({this.motherName = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.child_care, size: 80, color: AppColors.primaryPink.withOpacity(0.6)),
            const SizedBox(height: 24),
            Text(
              motherName.isNotEmpty ? '$motherName has no children yet' : 'No children registered',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the pink button to add a child',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ———————————————————————— CHILD CARD ————————————————————————
class _ChildCard extends StatelessWidget {
  final ChildEntity child;
  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Navigate to Child Detail Screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening ${child.name}\'s profile...')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: child.photoUrl != null ? NetworkImage(child.photoUrl!) : null,
                backgroundColor: AppColors.primaryPink.withOpacity(0.2),
                child: child.photoUrl == null
                    ? Icon(
                        child.gender.toLowerCase() == 'male' ? Icons.boy : Icons.girl,
                        color: AppColors.primaryPink,
                        size: 32,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(child.name, style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text('Born: ${child.dateOfBirthFormatted}', style: AppTextStyles.bodySmall),
                    Text('Age: ${child.ageString}', style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: child.gender.toLowerCase() == 'male' ? Colors.blue.shade100 : Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  child.gender.toUpperCase(),
                  style: TextStyle(
                    color: child.gender.toLowerCase() == 'male' ? Colors.blue.shade700 : Colors.pink.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}