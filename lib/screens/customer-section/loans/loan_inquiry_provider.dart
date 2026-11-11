import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../constants/api_urls.dart';
import '../../../core/servicess/shared_pref_helper.dart';

class LoanInquiryProvider extends ChangeNotifier {
  int _currentStep = 0; // 0: Loan Details, 1: Personal Details, 2: Review

  // Step 1: Loan Details
  String _selectedCategory = 'Personal Loan';
  double _loanAmount = 500000;
  String _loanPurpose = 'Home Renovation';
  String _preferredTenure = '5 Years (60 months)';

  // Step 2: Personal & Employment Details
  String _fullName = '';
  String _mobileNumber = '';
  String _email = '';
  DateTime _dob = DateTime(1998, 3, 15);
  String _employmentType = 'Salaried';
  double _monthlyIncome = 50000;
  String _companyName = 'Private Business / Company';
  String _city = '';

  // Step 3: Terms & Submission Status
  bool _agreedToTerms = true;
  bool _isLoading = false;
  String? _errorMessage;

  String? _referenceId;
  DateTime? _submittedAt;

  final List<String> categories = [
    'Personal Loan',
    'Home Loan',
    'Business Loan',
    'Car Loan',
    'Education Loan',
    'Gold Loan',
    'Loan Against Property',
    'Credit Card Loan',
  ];

  final List<String> purposes = [
    'Home Renovation',
    'Wedding & Family Function',
    'Medical Emergency',
    'Business Expansion',
    'Higher Education',
    'Debt Consolidation',
    'Travel & Holiday',
    'Other Personal Needs',
  ];

  final List<String> tenures = [
    '1 Year (12 months)',
    '2 Years (24 months)',
    '3 Years (36 months)',
    '5 Years (60 months)',
    '7 Years (84 months)',
    '10 Years (120 months)',
  ];

  final List<String> employmentTypes = [
    'Salaried',
    'Self-Employed Professional',
    'Business Owner',
    'Other',
  ];

  LoanInquiryProvider({String? initialCategory}) {
    if (initialCategory != null && initialCategory.trim().isNotEmpty) {
      final trimmed = initialCategory.trim();
      final match = categories.firstWhere(
            (c) => c.toLowerCase() == trimmed.toLowerCase(),
        orElse: () => trimmed,
      );
      _selectedCategory = match;

      if (!categories.contains(_selectedCategory)) {
        categories.add(_selectedCategory);
      }
    }
    _loadSavedUserData();
  }

  // Getters
  int get currentStep => _currentStep;
  String get selectedCategory => _selectedCategory;
  double get loanAmount => _loanAmount;
  String get loanPurpose => _loanPurpose;
  String get preferredTenure => _preferredTenure;

  String get fullName => _fullName;
  String get mobileNumber => _mobileNumber;
  String get email => _email;
  DateTime get dob => _dob;
  String get employmentType => _employmentType;
  double get monthlyIncome => _monthlyIncome;
  String get companyName => _companyName;
  String get city => _city;

  bool get agreedToTerms => _agreedToTerms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get referenceId => _referenceId;
  DateTime? get submittedAt => _submittedAt;

  // Tenure string se months extract karna
  int get tenureMonths {
    final match = RegExp(r'\((\d+)\s*months\)').firstMatch(_preferredTenure);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 12;
    }
    final yearMatch = RegExp(r'(\d+)\s*Year').firstMatch(_preferredTenure);
    if (yearMatch != null) {
      return (int.tryParse(yearMatch.group(1)!) ?? 1) * 12;
    }
    return 12;
  }

  /// SharedPreferences se login user details auto load karna
  Future<void> _loadSavedUserData() async {
    final userData = await SharedPrefHelper.getUserData();
    _fullName = userData['name'] ?? '';
    _mobileNumber = userData['phone'] ?? '';
    _email = userData['email'] ?? '';
    _city = userData['city'] ?? '';
    notifyListeners();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    if (!categories.contains(category)) {
      categories.add(category);
    }
    notifyListeners();
  }

  void setLoanAmount(double amount) {
    _loanAmount = amount;
    notifyListeners();
  }

  void setLoanPurpose(String purpose) {
    _loanPurpose = purpose;
    notifyListeners();
  }

  void setPreferredTenure(String tenure) {
    _preferredTenure = tenure;
    notifyListeners();
  }

  void updatePersonalDetails({
    required String name,
    required String mobile,
    required String email,
    required DateTime dob,
  }) {
    _fullName = name;
    _mobileNumber = mobile;
    _email = email;
    _dob = dob;
    notifyListeners();
  }

  void updateEmploymentDetails({
    required String empType,
    required double income,
    required String company,
    required String city,
  }) {
    _employmentType = empType;
    _monthlyIncome = income;
    _companyName = company;
    _city = city;
    notifyListeners();
  }

  void toggleTermsAgreement(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  /// Real Backend API Call (POST /api/v1/loans/apply)
  Future<bool> submitInquiry() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) {
        _errorMessage = 'Session expired. Please login again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final payload = {
        'loanAmount': _loanAmount,
        'loanType': _selectedCategory,
        'tenureMonths': tenureMonths,
        'purpose': _loanPurpose,
        'employmentType': _employmentType,
        'monthlyIncome': _monthlyIncome,
        'companyName': _companyName,
        'city': _city,
      };

      final response = await http
          .post(
        Uri.parse(MFUrls.applyLoan),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        final loanData = data['data'] ?? {};
        final now = DateTime.now();
        _submittedAt = now;

        // Backend loan id ya fallback clean Reference ID
        _referenceId = loanData['_id']?.toString() ??
            loanData['id']?.toString() ??
            'MF${DateFormat('yyyyMMdd').format(now)}${1000 + Random().nextInt(9000)}';

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Failed to submit loan inquiry.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Server connection error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}