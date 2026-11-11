import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api_urls.dart';
import '../../../core/servicess/shared_pref_helper.dart';

class AuthFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String _selectedRole = 'customer'; // 'customer', 'partner', ya 'admin'
  bool _isMobileLogin = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? _errorMessage;

  String get selectedRole => _selectedRole;
  bool get isMobileLogin => _isMobileLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setSelectedRole(String role) {
    if (_selectedRole == role) return;
    _selectedRole = role;
    _errorMessage = null;
    notifyListeners();
  }

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

    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(value.trim())) {
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

  /// Real API Integration for Forgot Password / OTP Trigger
  Future<bool> forgotPassword() async {
    if (_isLoading) return false;

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> requestBody = {};

      if (_isMobileLogin) {
        requestBody['phone'] = mobileController.text.trim();
      } else {
        requestBody['email'] = emailController.text.trim().toLowerCase();
      }

      final url = Uri.parse(MFUrls.forgotPassword);

      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData['success'] == true) {
        return true;
      } else {
        _errorMessage = responseData['message'] ??
            'Unable to process reset request. Please verify and try again.';
        return false;
      }
    } on http.ClientException {
      _errorMessage = 'Network connection issue. Please check your internet.';
      return false;
    } catch (e) {
      _errorMessage = 'Server error or request timed out: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Real API Integration with Session Storage
  Future<String?> login() async {
    if (_isLoading) return null;

    if (!(formKey.currentState?.validate() ?? false)) {
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String password = passwordController.text.trim();

      final Map<String, dynamic> requestBody = {
        'password': password,
      };

      if (_isMobileLogin) {
        requestBody['phone'] = mobileController.text.trim();
      } else {
        requestBody['email'] = emailController.text.trim().toLowerCase();
      }

      final url = Uri.parse(MFUrls.login);

      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final String? token = responseData['token'];
        final dynamic rawUser = responseData['data'] ?? responseData['user'];

        final Map<String, dynamic> userData =
        rawUser != null ? Map<String, dynamic>.from(rawUser) : {};

        final String serverRole =
        (userData['role'] ?? _selectedRole).toString().toLowerCase();

        if (token != null) {
          await SharedPrefHelper.saveUserSession(
            token: token,
            userData: userData,
          );
        }

        return serverRole;
      } else {
        _errorMessage = responseData['message'] ??
            'Invalid credentials. Please verify and try again.';
        return null;
      }
    } on http.ClientException {
      _errorMessage = 'Network connection issue. Please check your internet.';
      return null;
    } catch (e) {
      _errorMessage = 'Server error or connection timeout: ${e.toString()}';
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