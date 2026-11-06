//
// import 'package:flutter/material.dart';
//
// class AuthFormProvider extends ChangeNotifier {
//   final formKey = GlobalKey<FormState>();
//
//   final mobileController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   bool _isMobileLogin = true;
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;
//
//   bool get isMobileLogin => _isMobileLogin;
//   bool get isPasswordVisible => _isPasswordVisible;
//   bool get isLoading => _isLoading;
//
//   void changeLoginMethod(bool isMobile) {
//     if (_isMobileLogin == isMobile) return;
//
//     _isMobileLogin = isMobile;
//     formKey.currentState?.reset();
//     notifyListeners();
//   }
//
//   void togglePasswordVisibility() {
//     _isPasswordVisible = !_isPasswordVisible;
//     notifyListeners();
//   }
//
//   String? validateMobile(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter mobile number';
//     }
//
//     if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
//       return 'Enter a valid 10-digit mobile number';
//     }
//
//     return null;
//   }
//
//   String? validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter email address';
//     }
//
//     if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$')
//         .hasMatch(value.trim())) {
//       return 'Enter a valid email address';
//     }
//
//     return null;
//   }
//
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter password';
//     }
//
//     if (value.length < 6) {
//       return 'Password must contain at least 6 characters';
//     }
//
//     return null;
//   }
//
//   Future<bool> validateForm() async {
//     if (_isLoading) return false;
//
//     final isValid = formKey.currentState?.validate() ?? false;
//     if (!isValid) return false;
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       // Login API / Firebase Authentication yahan connect karna hai.
//       // Actual authentication successful hone par hi true return karo.
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   @override
//   void dispose() {
//     mobileController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }




import 'package:flutter/material.dart';

class AuthFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isMobileLogin = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? _errorMessage;

  bool get isMobileLogin => _isMobileLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void changeLoginMethod(bool isMobile) {
    if (_isMobileLogin == isMobile) return;

    _isMobileLogin = isMobile;
    _errorMessage = null;
    formKey.currentState?.reset();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
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

  /// Demo login only. Replace with your real authentication API.
  Future<String?> login() async {
    if (_isLoading) return null;

    if (!(formKey.currentState?.validate() ?? false)) {
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final identifier = _isMobileLogin
          ? mobileController.text.trim()
          : emailController.text.trim().toLowerCase();

      final password = passwordController.text;

      const demoAccounts = <String, Map<String, String>>{
        'customer@example.com': {
          'password': 'customer123',
          'role': 'customer',
        },
        'admin@example.com': {
          'password': 'admin123',
          'role': 'admin',
        },
        'partner@example.com': {
          'password': 'partner123',
          'role': 'partner',
        },
        '9876543210': {
          'password': 'customer123',
          'role': 'customer',
        },
        '9876543211': {
          'password': 'admin123',
          'role': 'admin',
        },
        '9876543212': {
          'password': 'partner123',
          'role': 'partner',
        },
      };

      final account = demoAccounts[identifier];

      if (account == null || account['password'] != password) {
        _errorMessage = 'Invalid login details. Please try again.';
        return null;
      }

      return account['role'];
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return null;
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
