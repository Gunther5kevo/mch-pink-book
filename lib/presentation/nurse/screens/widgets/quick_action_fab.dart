import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_pink_book/presentation/nurse/screens/helpers/navigation_helpers.dart';
import 'package:mch_pink_book/presentation/nurse/screens/nurse_appointments_screen.dart';
import 'package:mch_pink_book/presentation/nurse/screens/register_patient_screen.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../nurse/screens/search_patient_screen.dart';
import '../helpers/immunization_helpers.dart';
import '../helpers/dialog_helpers.dart';

class QuickActionFAB extends ConsumerWidget {
  const QuickActionFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showQuickActionsMenu(context, ref),
      backgroundColor: AppColors.primaryPink,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showQuickActionsMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildQuickActionTile(
              context: context,
              icon: Icons.person_add,
              label: 'Register Patient',
              color: AppColors.primaryPink,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPatientScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionTile(
              context: context,
              icon: Icons.medical_services,
              label: 'Record Visit',
              color: AppColors.accentGreen,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchPatientScreen(),
                  ),
                );
              },
            ),
            _buildQuickActionTile(
              context: context,
              icon: Icons.calendar_month,
              label: 'Schedule Appointment',
              color: AppColors.accentBlue,
              onTap: () {
                Navigator.pop(context);
                NavigationHelpers.goToAppointments(
                  context,
                  AppointmentFilterType.upcoming,
                );
              },
            ),
            _buildQuickActionTile(
              context: context,
              icon: Icons.baby_changing_station,
              label: 'New Baby / Birth Registration',
              color: AppColors.secondary,
              onTap: () {
                Navigator.pop(context);
                DialogHelpers.showComingSoon(context, 'Birth Registration');
              },
            ),
            _buildQuickActionTile(
              context: context,
              icon: Icons.vaccines,
              label: 'Record Immunization',
              color: AppColors.accentOrange,
              onTap: () {
                Navigator.pop(context);
                ImmunizationHelpers.openImmunizationFlow(context, ref);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}