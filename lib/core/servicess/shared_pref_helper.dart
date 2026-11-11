import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // Private Storage Keys
  static const String _keyToken = 'jwt_token';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserStatus = 'user_status';
  static const String _keyDsaCode = 'user_dsa_code';
  static const String _keyCity = 'user_city';
  static const String _keyState = 'user_state';

  /// Login hone ke baad complete session data save karein
  static Future<void> saveUserSession({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, token);
    await prefs.setBool(_keyIsLoggedIn, true);

    await prefs.setString(_keyUserId, userData['id']?.toString() ?? '');
    await prefs.setString(_keyUserName, userData['name']?.toString() ?? '');
    await prefs.setString(_keyUserEmail, userData['email']?.toString() ?? '');
    await prefs.setString(_keyUserPhone, userData['phone']?.toString() ?? '');
    await prefs.setString(
        _keyUserRole, userData['role']?.toString().toLowerCase() ?? 'customer');
    await prefs.setString(_keyUserStatus, userData['status']?.toString() ?? 'Active');
    await prefs.setString(_keyDsaCode, userData['dsaCode']?.toString() ?? '');
    await prefs.setString(_keyCity, userData['city']?.toString() ?? '');
    await prefs.setString(_keyState, userData['state']?.toString() ?? '');
  }




// Class ke andar yeh method add karein:
  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('user_data', jsonEncode(userData));
  }
  // ================= GETTERS =================

  /// JWT Token get karein (Protected API calls ke headers me use karne ke liye)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Check karein user pehle se logged-in hai ya nahi (Splash Screen routing ke liye)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logged-in user ka role fetch karein ('customer', 'admin', 'partner')
  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole) ?? 'customer';
  }

  /// User ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Saari saved user profile details ek sath Map me get karein
  static Future getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_keyUserId),
      'name': prefs.getString(_keyUserName),
      'email': prefs.getString(_keyUserEmail),
      'phone': prefs.getString(_keyUserPhone),
      'role': prefs.getString(_keyUserRole),
      'status': prefs.getString(_keyUserStatus),
      'dsaCode': prefs.getString(_keyDsaCode),
      'city': prefs.getString(_keyCity),
      'state': prefs.getString(_keyState),
    };
  }

  // ================= LOGOUT =================

  /// Logout hone par pura session data clear karein
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}