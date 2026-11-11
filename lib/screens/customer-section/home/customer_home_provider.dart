import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api_urls.dart';
import '../../../constants/app_colors.dart';
import '../../../core/servicess/shared_pref_helper.dart';

class HomeProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int _currentBannerIndex = 0;

  String _userName = '';
  List<dynamic> _myLoans = [];
  bool _isLoadingLoans = false;

  int get currentIndex => _currentIndex;
  int get currentBannerIndex => _currentBannerIndex;
  String get userName => _userName;
  List<dynamic> get myLoans => _myLoans;
  bool get isLoadingLoans => _isLoadingLoans;

  HomeProvider() {
    loadCustomerData();
  }

  void setBottomNavIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setBannerIndex(int index) {
    _currentBannerIndex = index;
    notifyListeners();
  }

  Future<void> loadCustomerData() async {
    final userData = await SharedPrefHelper.getUserData();
    _userName = userData['name'] ?? 'Customer';
    notifyListeners();

    await fetchMyLoans();
  }

  Future<void> fetchMyLoans() async {
    final token = await SharedPrefHelper.getToken();
    if (token == null) return;

    _isLoadingLoans = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(MFUrls.myLoans),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _myLoans = data['data'] ?? [];
        }
      }
    } catch (_) {
      // Backend not running / connection issue
    } finally {
      _isLoadingLoans = false;
      notifyListeners();
    }
  }

  final List loanCategories = [
  {'title': 'Personal\nLoan', 'icon': Icons.person, 'color': AppColors.successBackground, 'iconColor': AppColors.success},
  {'title': 'Business\nLoan', 'icon': Icons.business_center, 'color': AppColors.infoBackground, 'iconColor': AppColors.info},
  {'title': 'Car Loan', 'icon': Icons.directions_car, 'color': AppColors.errorBackground, 'iconColor': AppColors.error},
  {'title': 'Credit Card\nLoan', 'icon': Icons.credit_card, 'color': const Color(0xFFF3E8FF), 'iconColor': const Color(0xFF9333EA)},
  {'title': 'Education\nLoan', 'icon': Icons.school, 'color': AppColors.warningBackground, 'iconColor': AppColors.warning},
  {'title': 'Gold Loan', 'icon': Icons.wallet, 'color': AppColors.warningBackground, 'iconColor': AppColors.warning},
  {'title': 'Home Loan', 'icon': Icons.home, 'color': AppColors.successBackground, 'iconColor': AppColors.success},
  {'title': 'Loan Against\nProperty', 'icon': Icons.apartment, 'color': AppColors.infoBackground, 'iconColor': AppColors.info},
  ];
}