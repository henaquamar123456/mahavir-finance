import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanInquiryProvider extends ChangeNotifier {
  int _currentStep = 0; // 0: Loan Details, 1: Personal Details, 2: Review

  // Step 1: Loan Details
  String _selectedCategory = 'Personal Loan';
  double _loanAmount = 500000;
  String _loanPurpose = 'Home Renovation';
  String _preferredTenure = '5 Years (60 months)';

  // Step 2: Personal & Employment Details
  String _fullName = 'Rohit Kumar';
  String _mobileNumber = '9876543210';
  String _email = 'rohit@gmail.com';
  DateTime _dob = DateTime(1998, 3, 15);
  String _employmentType = 'Salaried';
  double _monthlyIncome = 50000;
  String _companyName = 'ABC Private Limited';
  String _city = 'Noida, Uttar Pradesh';

  // Step 3: Terms Agreement
  bool _agreedToTerms = true;

  // Generated reference after submission
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

  /// Constructor: initialCategory direct pass karne ke liye taaki build cycle me notifyListeners trigger na ho
  LoanInquiryProvider({String? initialCategory}) {
    if (initialCategory != null && initialCategory.trim().isNotEmpty) {
      final trimmed = initialCategory.trim();
      final match = categories.firstWhere(
            (c) => c.toLowerCase() == trimmed.toLowerCase(),
        orElse: () => trimmed,
      );
      _selectedCategory = match;

      // Dropdown assertion safeguard
      if (!categories.contains(_selectedCategory)) {
        categories.add(_selectedCategory);
      }
    }
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
  String? get referenceId => _referenceId;
  DateTime? get submittedAt => _submittedAt;

  // Setters
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

  void submitInquiry() {
    final now = DateTime.now();
    final randomSuffix = (1000 + Random().nextInt(9000)).toString();
    final datePrefix = DateFormat('yyyyMMdd').format(now);
    _referenceId = 'MF$datePrefix$randomSuffix';
    _submittedAt = now;
    notifyListeners();
  }
}