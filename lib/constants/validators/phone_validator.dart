
class PhoneValidators {
  PhoneValidators._();

  /// Validates a required Indian mobile number.
  /// Accepts 10 digits starting with 6, 7, 8, or 9.
  static String? validateIndianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    final phone = value.trim();

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  /// Validates a phone number that may include India's +91 code.
  /// Examples: +919876543210 or 9876543210.
  static String? validateWithCountryCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    final phone = value.trim();

    if (!RegExp(r'^(?:\+91[\s-]?)?[6-9]\d{9}$')
        .hasMatch(phone)) {
      return 'Enter a valid Indian mobile number';
    }

    return null;
  }

  /// Validates an optional Indian mobile number.
  static String? validateOptional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return validateIndianMobile(value);
  }

  /// Checks whether the field is empty.
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    return null;
  }
}
