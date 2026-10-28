import 'package:flutter/material.dart';
import '../../../c_models/inquiry_model.dart';

class InquiryProvider extends ChangeNotifier {
  List<InquiryModel> _inquiries = [];
  String _searchQuery = '';
  String _selectedStatus = 'All';

  String _filterSheetStatus = 'All';
  String? _selectedLoanType;
  DateTime? _fromDate;
  DateTime? _toDate;

  InquiryProvider() {
    _inquiries = InquiryModel.sampleInquiries;
  }

  // Getters
  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;
  String get filterSheetStatus => _filterSheetStatus;
  String? get selectedLoanType => _selectedLoanType;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  int get activeFiltersCount {
    int count = 0;
    if (_filterSheetStatus != 'All') count++;
    if (_selectedLoanType != null) count++;
    if (_fromDate != null || _toDate != null) count++;
    return count;
  }

  List<String> get statusTabs => [
    'All',
    'Pending',
    'Under Review',
    'Approved',
    'Rejected',
  ];

  List<InquiryModel> get filteredInquiries {
    return _inquiries.where((inquiry) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesType = inquiry.loanType.toLowerCase().contains(query);
        final matchesId = inquiry.id.toLowerCase().contains(query);
        if (!matchesType && !matchesId) return false;
      }

      if (_selectedStatus != 'All') {
        if (inquiry.status.label.toLowerCase() != _selectedStatus.toLowerCase()) {
          return false;
        }
      }

      if (_filterSheetStatus != 'All') {
        if (inquiry.status.label.toLowerCase() != _filterSheetStatus.toLowerCase()) {
          return false;
        }
      }

      if (_selectedLoanType != null) {
        if (inquiry.loanType.toLowerCase() != _selectedLoanType!.toLowerCase()) {
          return false;
        }
      }

      if (_fromDate != null && inquiry.date.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && inquiry.date.isAfter(_toDate!)) {
        return false;
      }

      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setFilterSheetStatus(String status) {
    _filterSheetStatus = status;
    notifyListeners();
  }

  void setSelectedLoanType(String? type) {
    _selectedLoanType = type;
    notifyListeners();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    notifyListeners();
  }

  void applyFilterSheet() {
    if (_filterSheetStatus != 'All') {
      _selectedStatus = _filterSheetStatus;
    }
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedStatus = 'All';
    _filterSheetStatus = 'All';
    _selectedLoanType = null;
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }
}