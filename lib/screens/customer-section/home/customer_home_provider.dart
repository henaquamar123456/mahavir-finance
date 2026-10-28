import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class HomeProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int _currentBannerIndex = 0;

  int get currentIndex => _currentIndex;
  int get currentBannerIndex => _currentBannerIndex;

  void setBottomNavIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setBannerIndex(int index) {
    _currentBannerIndex = index;
    notifyListeners();
  }

  final List<Map<String, dynamic>> loanCategories = [
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