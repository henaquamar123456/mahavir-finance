
import 'package:flutter/material.dart';

class AuthFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isMobileLogin = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  bool get isMobileLogin => _isMobileLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;

  void changeLoginMethod(bool isMobile) {
    if (_isMobileLogin == isMobile) return;

    _isMobileLogin = isMobile;
    formKey.currentState?.reset();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter mobile number';
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email address';
    }

    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  Future<bool> validateForm() async {
    if (_isLoading) return false;

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Login API / Firebase Authentication yahan connect karna hai.
      // Actual authentication successful hone par hi true return karo.
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
