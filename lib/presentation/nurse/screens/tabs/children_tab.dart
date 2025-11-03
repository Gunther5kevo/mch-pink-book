import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class ChildrenTab extends StatelessWidget {
  final String motherId;
  const ChildrenTab({super.key, required this.motherId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.child_care, size: 64, color: AppColors.accentBlue),
          const SizedBox(height: 16),
          Text('Children List', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text('Linked to Mother ID: $motherId'),
        ],
      ),
    );
  }
}