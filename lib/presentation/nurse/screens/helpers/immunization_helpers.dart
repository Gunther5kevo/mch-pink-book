// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../providers/child_provider.dart';
import '../../screens/immunization_screen.dart';

class ImmunizationHelpers {
  ImmunizationHelpers._();

  static void openImmunizationFlow(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) {
          return Consumer(
            builder: (context, ref, _) {
              final childrenState = ref.watch(allChildrenProvider);

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.vaccines, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Select Child for Immunization',
                          style:
                              AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: childrenState.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: LoadingShimmer(count: 5, compact: true),
                          )
                        : childrenState.error != null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    const SizedBox(height: 8),
                                    Text('Error: ${childrenState.error}'),
                                    TextButton(
                                      onPressed: () =>
                                          ref.refresh(allChildrenProvider),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : childrenState.children.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Text(
                                        'No children registered in the clinic.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: scrollController,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: childrenState.children.length,
                                    itemBuilder: (ctx, i) {
                                      final child = childrenState.children[i];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: AppColors
                                                .primaryPink
                                                .withOpacity(0.2),
                                            child: Text(
                                              child.fullName.isNotEmpty
                                                  ? child.fullName[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryPink,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            child.fullName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'DOB: ${child.dateOfBirth.toLocal().toString().split(' ')[0]}',
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ImmunizationScreen(
                                                        childId: child.id),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}