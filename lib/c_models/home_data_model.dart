import 'package:flutter/material.dart';

class HomeLoanCategory {
  final String title;
  final IconData icon;
  final Color color;

  const HomeLoanCategory({
    required this.title,
    required this.icon,
    required this.color,
  });

  static List<HomeLoanCategory> get categories => const [
    HomeLoanCategory(
      title: 'Personal\nLoan',
      icon: Icons.savings_rounded,
      color: Color(0xFFD97706),
    ),
    HomeLoanCategory(
      title: 'Business\nLoan',
      icon: Icons.business_center_rounded,
      color: Color(0xFF854D0E),
    ),
    HomeLoanCategory(
      title: 'Car\nLoan',
      icon: Icons.directions_car_rounded,
      color: Color(0xFFDC2626),
    ),
    HomeLoanCategory(
      title: 'Credit Card\nLoan',
      icon: Icons.credit_card_rounded,
      color: Color(0xFF2563EB),
    ),
    HomeLoanCategory(
      title: 'Education\nLoan',
      icon: Icons.school_rounded,
      color: Color(0xFFEA580C),
    ),
    HomeLoanCategory(
      title: 'Gold\nLoan',
      icon: Icons.monetization_on_rounded,
      color: Color(0xFFCA8A04),
    ),
    HomeLoanCategory(
      title: 'Home\nLoan',
      icon: Icons.home_rounded,
      color: Color(0xFF059669),
    ),
    HomeLoanCategory(
      title: 'Loan Against\nProperty',
      icon: Icons.apartment_rounded,
      color: Color(0xFF4F46E5),
    ),
  ];
}

class LendingPartner {
  final String name;
  final String shortCode;
  final Color tagColor;

  const LendingPartner({
    required this.name,
    required this.shortCode,
    required this.tagColor,
  });

  static List<LendingPartner> get partners => const [
    LendingPartner(name: 'State Bank of India', shortCode: 'SBI', tagColor: Color(0xFF1E3A8A)),
    LendingPartner(name: 'HDFC Bank', shortCode: 'HDFC', tagColor: Color(0xFF004C8F)),
    LendingPartner(name: 'ICICI Bank', shortCode: 'ICICI', tagColor: Color(0xFFB91C1C)),
    LendingPartner(name: 'Axis Bank', shortCode: 'AXIS', tagColor: Color(0xFF831843)),
    LendingPartner(name: 'Kotak Mahindra', shortCode: 'KOTAK', tagColor: Color(0xFFDC2626)),
    LendingPartner(name: 'Bajaj Finserv', shortCode: 'BAJAJ', tagColor: Color(0xFF0284C7)),
    LendingPartner(name: 'Tata Capital', shortCode: 'TATA', tagColor: Color(0xFF1E293B)),
    LendingPartner(name: 'Aditya Birla', shortCode: 'BIRLA', tagColor: Color(0xFF991B1B)),
    LendingPartner(name: 'Shriram Finance', shortCode: 'SHRIRAM', tagColor: Color(0xFFD97706)),
  ];
}