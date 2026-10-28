
class AppValidators {
  AppValidators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    final nameValue = value.trim();

    if (nameValue.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r"^[a-zA-Z][a-zA-Z\s.'-]*$").hasMatch(nameValue)) {
      return 'Please enter a valid name';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailValue = value.trim();

    if (!RegExp(
      r'^[A-Za-z0-9.!#$%&'
      r"'*+/=?^_`{|}~-]+@"
      r'[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?'
      r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)+$',
    ).hasMatch(emailValue)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit Indian mobile number';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

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

  static String? otp(String? value) {
    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit OTP';
    }

    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }

    final amountValue = double.tryParse(value.trim());

    if (amountValue == null || !amountValue.isFinite) {
      return 'Please enter a valid amount';
    }

    if (amountValue <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  static String? pan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your PAN number';
    }

    if (!RegExp(
      r'^[A-Z]{5}[0-9]{4}[A-Z]$',
    ).hasMatch(value.trim().toUpperCase())) {
      return 'Please enter a valid PAN number';
    }

    return null;
  }

  static String? pincode(String? value) {
    if (value == null || !RegExp(r'^[1-9]\d{5}$').hasMatch(value.trim())) {
      return 'Please enter a valid 6-digit PIN code';
    }

    return null;
  }
}
