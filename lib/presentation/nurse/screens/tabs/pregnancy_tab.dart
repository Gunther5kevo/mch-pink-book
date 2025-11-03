import 'package:flutter/material.dart';
import 'package:mch_pink_book/core/constants/app_constants.dart';

class PregnancyTab extends StatelessWidget {
  final String motherId;
  const PregnancyTab({super.key, required this.motherId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pregnant_woman, size: 64, color: AppColors.primaryPink),
          const SizedBox(height: 16),
          Text('Pregnancy Records', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text('Mother ID: $motherId'),
        ],
      ),
    );
  }
}