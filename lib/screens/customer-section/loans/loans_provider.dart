import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../c_models/loan_product_model.dart';


class LoansProvider extends ChangeNotifier {
  List<LoanProductModel> _allLoans = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Filter sheet parameters
  List<String> _selectedTypes = [];
  RangeValues _amountRange = const RangeValues(50000, 50000000);
  RangeValues _interestRange = const RangeValues(5, 24);
  String _selectedTenure = 'All'; // 'All', '1-3 Years', '3-5 Years', '5+ Years'

  // Current view mode: true = List View, false = Grid View
  bool _isListView = false;

  LoansProvider() {
    _allLoans = LoanProductModel.sampleLoans;
  }

  // Getters
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get selectedTypes => _selectedTypes;
  RangeValues get amountRange => _amountRange;
  RangeValues get interestRange => _interestRange;
  String get selectedTenure => _selectedTenure;
  bool get isListView => _isListView;

  int get activeFiltersCount {
    int count = 0;
    if (_selectedTypes.isNotEmpty) count++;
    if (_amountRange.start > 50000 || _amountRange.end < 50000000) count++;
    if (_interestRange.start > 5 || _interestRange.end < 24) count++;
    if (_selectedTenure != 'All') count++;
    return count;
  }

  List<String> get categories => [
    'All',
    'Personal',
    'Business',
    'Home',
    'Education',
    'Car',
    'Credit Card',
    'Gold',
  ];

  List<LoanProductModel> get filteredLoans {
    return _allLoans.where((loan) {
      // 1. Search Query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = loan.title.toLowerCase().contains(query);
        final matchesDesc = loan.shortDescription.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc) return false;
      }

      // 2. Chip Category
      if (_selectedCategory != 'All') {
        if (!loan.title.toLowerCase().contains(_selectedCategory.toLowerCase()) &&
            loan.category.toLowerCase() != _selectedCategory.toLowerCase()) {
          return false;
        }
      }

      // 3. Filter Sheet: Loan Types
      if (_selectedTypes.isNotEmpty) {
        final matchesType = _selectedTypes.any(
              (t) => loan.title.toLowerCase().contains(t.toLowerCase()),
        );
        if (!matchesType) return false;
      }

      // 4. Amount Range
      if (loan.maxAmount < _amountRange.start || loan.minAmount > _amountRange.end) {
        return false;
      }

      // 5. Interest Rate
      if (loan.maxInterestRate < _interestRange.start ||
          loan.minInterestRate > _interestRange.end) {
        return false;
      }

      // 6. Tenure
      if (_selectedTenure == '1-3 Years') {
        if (loan.minTenureYears > 3 || loan.maxTenureYears < 1) return false;
      } else if (_selectedTenure == '3-5 Years') {
        if (loan.minTenureYears > 5 || loan.maxTenureYears < 3) return false;
      } else if (_selectedTenure == '5+ Years') {
        if (loan.maxTenureYears < 5) return false;
      }

      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleViewMode() {
    _isListView = !_isListView;
    notifyListeners();
  }

  void setListView(bool value) {
    _isListView = value;
    notifyListeners();
  }

  void toggleLoanType(String type) {
    if (_selectedTypes.contains(type)) {
      _selectedTypes.remove(type);
    } else {
      _selectedTypes.add(type);
    }
    notifyListeners();
  }

  void setAmountRange(RangeValues values) {
    _amountRange = values;
    notifyListeners();
  }

  void setInterestRange(RangeValues values) {
    _interestRange = values;
    notifyListeners();
  }

  void setSelectedTenure(String tenure) {
    _selectedTenure = tenure;
    notifyListeners();
  }

  void applyFilterSheet() {
    // Screenshot 3 me filter lagte hi screen List view ban jaati hai
    _isListView = true;
    notifyListeners();
  }

  void clearFilters() {
    _selectedTypes.clear();
    _amountRange = const RangeValues(50000, 50000000);
    _interestRange = const RangeValues(5, 24);
    _selectedTenure = 'All';
    _isListView = false;
    notifyListeners();
  }
}