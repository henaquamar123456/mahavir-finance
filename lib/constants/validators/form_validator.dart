
class FormValidator {
  FormValidator._();

  // Required field
  static String? required(
      String? value, {
        String fieldName = 'This field',
      }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Indian mobile number
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    final mobileRegex = RegExp(r'^[6-9]\d{9}$');

    if (!mobileRegex.hasMatch(value.trim())) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  // Password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    return null;
  }

  // Confirm password
  static String? confirmPassword(
      String? value, {
        required String password,
      }) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // OTP
  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit OTP';
    }

    return null;
  }

  // Amount
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final parsedAmount = double.tryParse(value.trim());

    if (parsedAmount == null || !parsedAmount.isFinite) {
      return 'Enter a valid amount';
    }

    if (parsedAmount <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  // PAN
  static String? pan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PAN number is required';
    }

    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
        .hasMatch(value.trim().toUpperCase())) {
      return 'Enter a valid PAN number';
    }

    return null;
  }

  // PIN code
  static String? pincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PIN code is required';
    }

    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit PIN code';
    }

    return null;
  }
}
