import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _fullName = 'Rohit Kumar';
  String _email = 'rohit.kumar@gmail.com';
  String _mobileNumber = '9876543210';
  DateTime _dob = DateTime(1996, 3, 15);
  String _gender = 'Male';
  String _city = 'Noida, Uttar Pradesh';
  bool _isVerified = true;

  // Getters
  String get fullName => _fullName;
  String get email => _email;
  String get mobileNumber => _mobileNumber;
  DateTime get dob => _dob;
  String get gender => _gender;
  String get city => _city;
  bool get isVerified => _isVerified;

  void updateBasicDetails({
    required String name,
    required DateTime dob,
    required String gender,
    required String city,
  }) {
    _fullName = name;
    _dob = dob;
    _gender = gender;
    _city = city;
    notifyListeners();
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