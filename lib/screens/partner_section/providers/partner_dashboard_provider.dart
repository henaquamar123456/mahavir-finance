import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../p_models/partner_model_screen.dart';

class PartnerDashboardProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  String _partnerName = 'Partner';
  String _partnerId = 'MFP00000';
  String _partnerEmail = '';

  int _totalLeads = 0;
  int _pendingLeads = 0;
  int _approvedLeads = 0;
  int _rejectedLeads = 0;
  double _totalEarnings = 0.0;

  List<PartnerLeadModel> _recentLeads = [];
  List<dynamic> _rawLoans = [];

  PartnerDashboardProvider() {
    loadDashboardData();
  }

  // Getters
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get partnerName => _partnerName;
  String get partnerId => _partnerId;
  String get partnerEmail => _partnerEmail;

  int get totalLeads => _totalLeads;
  int get pendingLeads => _pendingLeads;
  int get approvedLeads => _approvedLeads;
  int get rejectedLeads => _rejectedLeads;
  double get totalEarnings => _totalEarnings;

  List<PartnerLeadModel> get recentLeads => _recentLeads;
  List<dynamic> get rawLoans => _rawLoans;

  void setBottomNavIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Real API Integration & Lead Fetching
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userData = await SharedPrefHelper.getUserData();
      final token = await SharedPrefHelper.getToken();

      _partnerName = userData['name'] ?? 'Mahavir Partner';
      _partnerEmail = userData['email'] ?? '';

      // Check partner referral code
      if (userData['dsaCode'] != null && userData['dsaCode'].toString().isNotEmpty) {
        _partnerId = userData['dsaCode'];
      } else {
        final phone = userData['phone'] ?? '1234';
        _partnerId = 'MFP${phone.length >= 4 ? phone.substring(phone.length - 4) : phone}';
      }

      if (token == null) {
        _setFallbackData();
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Real API Call
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loans/dsa/$_partnerId'));
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> loans = data['data'] ?? [];
        _rawLoans = loans;

        int pendingCount = 0;
        int approvedCount = 0;
        int rejectedCount = 0;
        double approvedVolume = 0.0;
        List<PartnerLeadModel> parsedLeads = [];

        final dateFormat = DateFormat('dd MMM yyyy');
        final timeFormat = DateFormat('hh:mm a');

        for (var item in loans) {
          final statusStr = (item['status'] ?? 'Pending').toString();
          final amount = double.tryParse(item['loanAmount'].toString()) ?? 0.0;

          if (statusStr.toLowerCase() == 'approved' || statusStr.toLowerCase() == 'disbursed') {
            approvedCount++;
            approvedVolume += amount;
          } else if (statusStr.toLowerCase() == 'rejected') {
            rejectedCount++;
          } else {
            pendingCount++;
          }

          // Extract Customer Data
          String custName = 'Customer';
          String custPhone = '';
          String custEmail = '';
          String custCity = item['city'] ?? 'India';

          if (item['customer'] is Map) {
            custName = item['customer']['name'] ?? 'Customer';
            custPhone = item['customer']['phone'] ?? '';
            custEmail = item['customer']['email'] ?? '';
          }

          DateTime createdDate = DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now();
          final loanType = (item['loanType'] ?? 'Personal Loan').toString();

          // Correct PartnerLeadStatus Enum Mapping
          PartnerLeadStatus leadStatus;
          if (statusStr.toLowerCase() == 'approved' || statusStr.toLowerCase() == 'disbursed') {
            leadStatus = PartnerLeadStatus.approved;
          } else if (statusStr.toLowerCase() == 'rejected') {
            leadStatus = PartnerLeadStatus.rejected;
          } else if (statusStr.toLowerCase() == 'under review') {
            leadStatus = PartnerLeadStatus.underReview;
          } else {
            leadStatus = PartnerLeadStatus.pending;
          }

          parsedLeads.add(
            PartnerLeadModel(
              id: item['_id']?.toString() ?? '',
              customerName: custName,
              customerId: item['customer'] is Map ? (item['customer']['_id']?.toString() ?? '') : '',
              phone: custPhone,
              email: custEmail,
              city: custCity,
              loanCategory: loanType,
              amount: amount,
              tenure: '${item['tenureMonths'] ?? 12} Months',
              date: dateFormat.format(createdDate),
              time: timeFormat.format(createdDate),
              status: leadStatus,
              icon: _getCategoryIcon(loanType),
              iconColor: _getCategoryColor(loanType),
              isExistingCustomer: item['isExistingCustomer'] ?? false,
            ),
          );
        }

        _totalLeads = loans.length;
        _approvedLeads = approvedCount;
        _pendingLeads = pendingCount;
        _rejectedLeads = rejectedCount;
        _totalEarnings = approvedVolume * 0.015; // 1.5% DSA Commission
        _recentLeads = parsedLeads.take(5).toList();
      } else {
        _setFallbackData();
      }
    } catch (e) {
      _setFallbackData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setFallbackData() {
    _totalLeads = PartnerLeadModel.sampleLeads.length;
    _approvedLeads = 2;
    _pendingLeads = 1;
    _rejectedLeads = 1;
    _totalEarnings = 125600;
    _recentLeads = PartnerLeadModel.sampleLeads;
  }

  IconData _getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home loan':
        return Icons.home_rounded;
      case 'car loan':
        return Icons.directions_car_rounded;
      case 'business loan':
        return Icons.business_center_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'home loan':
        return const Color(0xFF0284C7);
      case 'business loan':
        return const Color(0xFF7C3AED);
      case 'car loan':
        return const Color(0xFFD97706);
      default:
        return AppColors.secondary;
    }
  }
}