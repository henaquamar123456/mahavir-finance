import 'package:flutter/material.dart';

class AddLeadProvider extends ChangeNotifier {
  int _currentStep = 1;

  final formKey = GlobalKey<FormState>();

  // Customer Information Controllers
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  // Loan Information Controllers
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTenure;

  int get currentStep => _currentStep;
  String? get selectedCategory => _selectedCategory;
  String? get selectedTenure => _selectedTenure;

  final List<String> loanCategories = [
    'Personal Loan',
    'Home Loan',
    'Business Loan',
    'Car Loan',
    'Education Loan',
    'Gold Loan',
    'Loan Against Property',
  ];

  final List<String> tenureOptions = [
    '1 Year',
    '2 Years',
    '3 Years',
    '5 Years',
    '7 Years',
    '10 Years',
    '15 Years',
    '20 Years',
  ];

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedTenure(String? tenure) {
    _selectedTenure = tenure;
    notifyListeners();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  bool validateCurrentStep() {
    return formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    dobController.dispose();
    addressController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }
}