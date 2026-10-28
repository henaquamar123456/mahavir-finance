import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isOnboardingCompleted', value);
  }

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _prefs {
    if (_preferences == null) {
      throw StateError('Call LocalStorage.init() first.');
    }
    return _preferences!;
  }

  static bool get isLoggedIn =>
      _prefs.getBool('is_logged_in') ?? false;

  static String? get userRole =>
      _prefs.getString('user_role');

  static bool get isOnboardingCompleted =>
      _prefs.getBool('is_onboarding_completed') ?? false;

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('is_logged_in', value);
  }

  static Future<void> setUserRole(String value) async {
    await _prefs.setString('user_role', value);
  }
}