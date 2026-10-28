import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../c_models/emi_calculation_model.dart';

class EmiCalculatorProvider extends ChangeNotifier {
  String _selectedLoanType = 'Personal Loan';
  double _loanAmount = 500000;
  double _interestRate = 10.5;
  int _tenureYears = 5;

  EmiResultModel? _result;

  EmiCalculatorProvider() {
    calculateEmi();
  }

  // Getters
  String get selectedLoanType => _selectedLoanType;
  double get loanAmount => _loanAmount;
  double get interestRate => _interestRate;
  int get tenureYears => _tenureYears;
  EmiResultModel? get result => _result;

  final List<String> loanTypes = [
    'Personal Loan',
    'Business Loan',
    'Car Loan',
    'Credit Card Loan',
    'Education Loan',
    'Gold Loan',
    'Home Loan',
    'Loan Against Property',
  ];

  void setLoanType(String type) {
    _selectedLoanType = type;
    notifyListeners();
  }

  void setLoanAmount(double amount) {
    _loanAmount = amount;
    calculateEmi();
  }

  void setInterestRate(double rate) {
    _interestRate = rate;
    calculateEmi();
  }

  void setTenureYears(int years) {
    _tenureYears = years;
    calculateEmi();
  }

  /// Reduces balance EMI formula: E = P * r * (1+r)^n / ((1+r)^n - 1)
  void calculateEmi() {
    final double p = _loanAmount;
    final double monthlyRate = (_interestRate / 12) / 100;
    // Syntax error fixed here
    final int totalMonths = _tenureYears * 12;

    if (p <= 0 || monthlyRate <= 0 || totalMonths <= 0) return;

    final double emiFactor = pow(1 + monthlyRate, totalMonths).toDouble();
    final double monthlyEmi = (p * monthlyRate * emiFactor) / (emiFactor - 1);

    final double totalPayable = monthlyEmi * totalMonths;
    final double totalInterest = totalPayable - p;

    final double principalPercentage = (p / totalPayable) * 100;
    final double interestPercentage = (totalInterest / totalPayable) * 100;

    // Generate Year-wise Amortization Breakdown
    final List<YearlyBreakdownItem> breakdown = [];
    double remainingBalance = p;

    for (int y = 1; y <= _tenureYears; y++) {
      double yearlyPrincipal = 0;
      double yearlyInterest = 0;

      for (int m = 1; m <= 12; m++) {
        final double monthInterest = remainingBalance * monthlyRate;
        final double monthPrincipal = monthlyEmi - monthInterest;

        yearlyInterest += monthInterest;
        yearlyPrincipal += monthPrincipal;
        remainingBalance -= monthPrincipal;
      }

      if (remainingBalance < 0 || y == _tenureYears) {
        remainingBalance = 0;
      }

      breakdown.add(
        YearlyBreakdownItem(
          year: y,
          principalPaid: yearlyPrincipal,
          interestPaid: yearlyInterest,
          outstandingBalance: remainingBalance,
        ),
      );
    }

    _result = EmiResultModel(
      loanAmount: p,
      interestRate: _interestRate,
      tenureYears: _tenureYears,
      monthlyEmi: monthlyEmi,
      totalInterest: totalInterest,
      totalPayable: totalPayable,
      principalPercentage: principalPercentage,
      interestPercentage: interestPercentage,
      yearlyBreakdown: breakdown,
    );

    notifyListeners();
  }

  void reset() {
    _selectedLoanType = 'Personal Loan';
    _loanAmount = 500000;
    _interestRate = 10.5;
    _tenureYears = 5;
    calculateEmi();
  }
}