// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../screens/nurse_appointments_screen.dart';
import './dialog_helpers.dart';

class NavigationHelpers {
  NavigationHelpers._();

  static void goToAppointments(BuildContext context, AppointmentFilterType? filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NurseAppointmentsScreen(initialFilter: filter),
      ),
    );
  }

  static void navigateToPregnanciesList(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'Pregnancies List');
  }

  static void navigateToNewbornsList(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'Newborns List');
  }

  static void navigateToHighRiskList(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'High Risk Mothers');
  }

  static void navigateToImmunizationsDue(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'Immunizations Due');
  }

  static void navigateToMothersList(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'All Mothers');
  }

  static void navigateToFollowUps(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'Follow-up Reminders');
  }

  static void navigateToDefaulters(BuildContext context) {
    DialogHelpers.showComingSoon(context, 'Defaulter Tracking');
  }

  static void navigateToMotherProfile(BuildContext context, String motherId) {
    DialogHelpers.showComingSoon(context, 'Mother Profile');
    // TODO: Navigate to actual profile screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => PatientProfileScreen(motherId: motherId),
    //   ),
    // );
  }
}