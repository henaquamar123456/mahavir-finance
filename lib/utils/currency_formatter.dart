
import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _inrWholeFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Formats an amount with two decimal places.
  /// Example: 125000.50 -> ₹1,25,000.50
  static String format(num amount) {
    return _inrFormatter.format(amount);
  }

  /// Formats an amount without decimal places.
  /// Example: 125000 -> ₹1,25,000
  static String formatWhole(num amount) {
    return _inrWholeFormatter.format(amount);
  }

  /// Formats an amount in a compact Indian style.
  /// Example: 150000 -> ₹1.5 L
  /// Example: 2500000 -> ₹25 L
  /// Example: 10000000 -> ₹1 Cr
  static String formatCompact(num amount) {
    final absAmount = amount.abs();
    final sign = amount < 0 ? '-' : '';

    if (absAmount >= 10000000) {
      return '$sign₹${_trimZeros(absAmount / 10000000)} Cr';
    }

    if (absAmount >= 100000) {
      return '$sign₹${_trimZeros(absAmount / 100000)} L';
    }

    if (absAmount >= 1000) {
      return '$sign₹${_trimZeros(absAmount / 1000)} K';
    }

    return formatWhole(amount);
  }

  static String _trimZeros(double value) {
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  /// Parses a numeric string into an amount.
  /// Returns null if the value is invalid.
  static double? parse(String value) {
    final cleaned = value
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(cleaned);
  }
}
