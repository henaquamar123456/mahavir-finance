import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // 'en_IN' hata diya hai taaki bina kisi initialization ke default English format chale
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');

  static final DateFormat _dateTimeFormat =
  DateFormat('dd MMM yyyy, hh:mm a');

  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');

  static final DateFormat _dayFormat = DateFormat('EEEE');

  /// Example: 2026-10-22 -> 22 Oct 2026
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  /// Example: 22/10/2026
  static String formatShortDate(DateTime? date) {
    if (date == null) return '-';
    return _shortDateFormat.format(date);
  }

  /// Example: 22 Oct 2026, 10:30 AM
  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return _dateTimeFormat.format(date);
  }

  /// Example: 10:30 AM
  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return _timeFormat.format(date);
  }

  /// Example: October 2026
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '-';
    return _monthYearFormat.format(date);
  }

  /// Example: Thursday
  static String formatDay(DateTime? date) {
    if (date == null) return '-';
    return _dayFormat.format(date);
  }

  /// Example: Today, Yesterday, or 20 Oct 2026
  static String formatRelativeDate(DateTime? date) {
    if (date == null) return '-';

    final now = DateTime.now();
    final target = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(target).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference == -1) return 'Tomorrow';

    return formatDate(date);
  }

  /// Parses a date string safely.
  /// Example: 2026-10-22 -> DateTime
  static DateTime? parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    try {
      return DateTime.parse(value.trim());
    } catch (_) {
      return null;
    }
  }
}