import 'package:intl/intl.dart';

/// Centralized date format helpers for consistent UI
class AppDateFormats {
  static final short = DateFormat('dd MMM yyyy');        // e.g. 07 Nov 2025
  static final long = DateFormat('EEEE, dd MMM yyyy');   // e.g. Friday, 07 Nov 2025
  static final time = DateFormat('hh:mm a');             // e.g. 08:45 AM
  static final full = DateFormat('dd MMM yyyy • hh:mm a');

  /// Returns a user-friendly human-readable format.
  static String humanReadable(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today • ${time.format(date)}';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'Yesterday • ${time.format(date)}';
    } else if (target == today.add(const Duration(days: 1))) {
      return 'Tomorrow • ${time.format(date)}';
    } else {
      return full.format(date);
    }
  }
}
