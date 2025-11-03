/// Child Card Widget
/// Display child information
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ChildCard extends StatelessWidget {
  final String name;
  final String age;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ChildCard({
    super.key,
    required this.name,
    required this.age,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryPinkLight,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? const Icon(Icons.child_care, color: AppColors.primaryPink)
              : null,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(age),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}