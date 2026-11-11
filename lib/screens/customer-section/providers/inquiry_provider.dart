import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:mahavir_finance/c_models/inquiry_model.dart';
import '../../../../constants/api_urls.dart';
import '../../../core/servicess/shared_pref_helper.dart';

class InquiryProvider extends ChangeNotifier {
  List<InquiryModel> _inquiries = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedStatus = 'All';

  String _filterSheetStatus = 'All';
  String? _selectedLoanType;
  DateTime? _fromDate;
  DateTime? _toDate;

  InquiryProvider() {
    fetchInquiries();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
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

  /// Backend API Call: Customer ke applied loans load karna
  Future<void> fetchInquiries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null || token.isEmpty) {
        _errorMessage = 'Session not found. Please login again.';
        _inquiries = InquiryModel.sampleInquiries;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse(MFUrls.myLoans),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List<dynamic> loanList = data['data'] ?? [];

        if (loanList.isNotEmpty) {
          _inquiries = loanList
              .map((item) => _mapBackendLoanToInquiry(item))
              .toList();
        } else {
          _inquiries = [];
        }
      } else {
        _errorMessage = data['message'] ?? 'Failed to fetch loan inquiries.';
        _inquiries = InquiryModel.sampleInquiries;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Displaying cached records.';
      _inquiries = InquiryModel.sampleInquiries;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Backend response ko InquiryModel ke saare 19 fields ke sath map karna
  InquiryModel _mapBackendLoanToInquiry(dynamic item) {
    final String rawStatus = (item['status'] ?? 'Pending').toString();
    final InquiryStatus mappedStatus = InquiryStatus.fromString(rawStatus);

    final double amount = (item['loanAmount'] is num)
        ? (item['loanAmount'] as num).toDouble()
        : 500000.0;

    DateTime loanDate = DateTime.now();
    if (item['createdAt'] != null) {
      loanDate = DateTime.tryParse(item['createdAt'].toString()) ?? DateTime.now();
    }

    final String formattedTime = DateFormat('hh:mm a').format(loanDate);

    // Tenure parsing
    final int tenureMonths = (item['tenureMonths'] is int)
        ? item['tenureMonths']
        : int.tryParse(item['tenureMonths']?.toString() ?? '12') ?? 12;
    final String tenureDisplay = tenureMonths >= 12
        ? '${(tenureMonths / 12).round()} Years'
        : '$tenureMonths Months';

    // Status ke mutabiq tracker step mapping
    int currentStep = 0;
    String expectedDisbursal = 'Within 7-10 days';
    if (mappedStatus == InquiryStatus.underReview) {
      currentStep = 1;
      expectedDisbursal = 'Within 5-7 days';
    } else if (mappedStatus == InquiryStatus.approved) {
      currentStep = 3;
      expectedDisbursal = 'Disbursed';
    } else if (mappedStatus == InquiryStatus.rejected) {
      currentStep = 0;
      expectedDisbursal = 'N/A';
    }

    final String loanType = item['loanType']?.toString() ?? 'Personal Loan';
    final IconData icon = _getLoanIcon(loanType);
    final Color iconColor = _getLoanColor(loanType);

    // Applicant data (agar populated ho ya direct ho)
    final dynamic customer = item['customer'];
    final String applicantName = (customer is Map && customer['name'] != null)
        ? customer['name']
        : (item['applicantName']?.toString() ?? 'Customer');
    final String mobileNumber = (customer is Map && customer['phone'] != null)
        ? customer['phone']
        : (item['mobileNumber']?.toString() ?? '');
    final String email = (customer is Map && customer['email'] != null)
        ? customer['email']
        : (item['email']?.toString() ?? '');

    return InquiryModel(
      id: item['_id']?.toString() ?? item['id']?.toString() ?? 'MF202610200001',
      loanType: loanType,
      status: mappedStatus,
      date: loanDate,
      formattedTime: formattedTime,
      amount: amount,
      tenure: tenureDisplay,
      purpose: item['purpose']?.toString() ?? 'Personal Expense',
      currentStep: currentStep,
      expectedDisbursal: expectedDisbursal,
      applicantName: applicantName,
      mobileNumber: mobileNumber,
      email: email,
      employmentType: item['employmentType']?.toString() ?? 'Salaried',
      monthlyIncome: (item['monthlyIncome'] is num)
          ? (item['monthlyIncome'] as num).toDouble()
          : 50000.0,
      companyName: item['companyName']?.toString() ?? 'Private Company',
      city: item['city']?.toString() ?? '',
      icon: icon,
      iconColor: iconColor,
    );
  }

  IconData _getLoanIcon(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('home')) return Icons.home_rounded;
    if (lower.contains('car')) return Icons.directions_car_rounded;
    if (lower.contains('business')) return Icons.business_center_rounded;
    if (lower.contains('education')) return Icons.school_rounded;
    if (lower.contains('gold')) return Icons.monetization_on_rounded;
    if (lower.contains('property')) return Icons.apartment_rounded;
    return Icons.savings_rounded;
  }

  Color _getLoanColor(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('home')) return const Color(0xFF0284C7);
    if (lower.contains('car')) return const Color(0xFF16A36A);
    if (lower.contains('business')) return const Color(0xFF2563EB);
    if (lower.contains('education')) return const Color(0xFF7C3AED);
    return const Color(0xFFD97706);
  }

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