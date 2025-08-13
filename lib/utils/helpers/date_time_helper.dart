import 'package:intl/intl.dart';

class DateTimeHelper {
  static bool isUtcDateToday(String utcDateTimeString) {
    // Parse the UTC datetime string
    DateTime givenUtc = DateTime.parse(utcDateTimeString);

    // Convert to local time
    DateTime givenLocal = givenUtc.toLocal();

    // Get today's date
    DateTime now = DateTime.now();

    // Compare only the date parts
    return now.year == givenLocal.year &&
        now.month == givenLocal.month &&
        now.day == givenLocal.day;
  }

  static bool isDateToday(DateTime utcDateTime) {
    DateTime localDate = utcDateTime.toLocal();
    DateTime now = DateTime.now();

    return now.year == localDate.year &&
        now.month == localDate.month &&
        now.day == localDate.day;
  }

  static String formatTimestamp(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp); // e.g., 10:15 AM
  }

  static String formatDate(DateTime timestamp) {
    return DateFormat('d MMM yyyy').format(timestamp); // e.g., 10:15 AM
  }

  static String formatDate1(DateTime timestamp) {
    return DateFormat('dd MM yyyy').format(timestamp); // e.g., 10:15 AM
  }
}
