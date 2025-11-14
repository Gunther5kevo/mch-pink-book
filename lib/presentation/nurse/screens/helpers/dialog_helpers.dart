// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class DialogHelpers {
  DialogHelpers._();

  static void showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon!'),
        backgroundColor: AppColors.primaryPinkDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<bool> showSignOutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Sign out?'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static void showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter Options'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pregnancy Stage',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                title: const Text('1st Trimester'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('2nd Trimester'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('3rd Trimester'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              const Divider(),
              Text(
                'Visit Status',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                title: const Text('Overdue Visits'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('Today\'s Visits'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('Upcoming This Week'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              const Divider(),
              Text(
                'Risk Category',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                title: const Text('High Risk'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('Normal'),
                value: false,
                onChanged: (value) {},
                dense: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Apply filters
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}