import 'package:flutter/material.dart';
import '../../../p_models/partner_model_screen.dart';

class PartnerDashboardProvider extends ChangeNotifier {
  int _currentIndex = 0;

  final int totalLeads = 48;
  final int pendingLeads = 18;
  final int approvedLeads = 22;
  final int rejectedLeads = 8;
  final double totalEarnings = 125600;

  List<PartnerLeadModel> _recentLeads = [];

  PartnerDashboardProvider() {
    _recentLeads = PartnerLeadModel.sampleLeads;
  }

  int get currentIndex => _currentIndex;
  List<PartnerLeadModel> get recentLeads => _recentLeads;

  void setBottomNavIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}