import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/api_urls.dart';
import '../../../core/servicess/shared_pref_helper.dart';

class ProfileProvider extends ChangeNotifier {
  String _fullName = '';
  String _email = '';
  String _mobileNumber = '';
  DateTime _dob = DateTime(1996, 3, 15);
  String _gender = 'Male';
  String _city = '';
  bool _isVerified = true;
  bool _isLoading = false;

  ProfileProvider() {
    initProfile();
  }

  // Getters
  String get fullName => _fullName;
  String get email => _email;
  String get mobileNumber => _mobileNumber;
  DateTime get dob => _dob;
  String get gender => _gender;
  String get city => _city;
  bool get isVerified => _isVerified;
  bool get isLoading => _isLoading;

  /// SharedPreferences se user data load karna
  Future<void> initProfile() async {
    final userData = await SharedPrefHelper.getUserData();
    _fullName = userData['name'] ?? '';
    _email = userData['email'] ?? '';
    _mobileNumber = userData['phone'] ?? '';
    _city = userData['city'] ?? '';
    notifyListeners();
  }

  /// Backend API Call: PUT /api/v1/customers/profile
  Future<bool> saveProfileChanges({
    required String name,
    required DateTime dob,
    required String gender,
    required String city,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/customers/profile'));

      final payload = {
        'name': name.trim(),
        'city': city.trim(),
        'phone': _mobileNumber.trim(),
      };

      final response = await http
          .put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _fullName = name.trim();
        _dob = dob;
        _gender = gender;
        _city = city.trim();

        // SharedPreferences me naya data sync karein
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', _fullName);
        await prefs.setString('user_city', _city);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (_) {
      // Offline fallback: Update local storage
      _fullName = name.trim();
      _dob = dob;
      _gender = gender;
      _city = city.trim();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _fullName);
      await prefs.setString('user_city', _city);

      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updateMobile(String newMobile) {
    _mobileNumber = newMobile;
    notifyListeners();
  }
}