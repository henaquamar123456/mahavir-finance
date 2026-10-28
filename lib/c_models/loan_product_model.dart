import 'package:flutter/material.dart';

class LoanProductModel {
  final String id;
  final String title;
  final String shortDescription;
  final String detailedDescription;
  final String category; // 'Personal', 'Business', 'Car', etc.
  final IconData icon;
  final Color iconColor;
  final double minAmount;
  final double maxAmount;
  final String amountDisplay;
  final double minInterestRate;
  final double maxInterestRate;
  final String interestRateDisplay;
  final String tenureDisplay;
  final int minTenureYears;
  final int maxTenureYears;

  const LoanProductModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.detailedDescription,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.minAmount,
    required this.maxAmount,
    required this.amountDisplay,
    required this.minInterestRate,
    required this.maxInterestRate,
    required this.interestRateDisplay,
    required this.tenureDisplay,
    required this.minTenureYears,
    required this.maxTenureYears,
  });

  static List<LoanProductModel> get sampleLoans => [
    const LoanProductModel(
      id: '1',
      title: 'Personal Loan',
      shortDescription: 'Meet your personal needs with ease',
      detailedDescription:
      'For your personal needs like wedding, travel, medical, etc.',
      category: 'Personal',
      icon: Icons.savings_rounded,
      iconColor: Color(0xFFD97706),
      minAmount: 50000,
      maxAmount: 4000000,
      amountDisplay: '₹50K - ₹40L',
      minInterestRate: 10.0,
      maxInterestRate: 24.0,
      interestRateDisplay: '10% - 24%',
      tenureDisplay: '1 - 5 Years',
      minTenureYears: 1,
      maxTenureYears: 5,
    ),
    const LoanProductModel(
      id: '2',
      title: 'Business Loan',
      shortDescription: 'Fuel your business growth',
      detailedDescription:
      'Grow your business with flexible financing options.',
      category: 'Business',
      icon: Icons.business_center_rounded,
      iconColor: Color(0xFF854D0E),
      minAmount: 100000,
      maxAmount: 50000000,
      amountDisplay: '₹1L - ₹5Cr',
      minInterestRate: 9.0,
      maxInterestRate: 20.0,
      interestRateDisplay: '9% - 20%',
      tenureDisplay: '1 - 7 Years',
      minTenureYears: 1,
      maxTenureYears: 7,
    ),
    const LoanProductModel(
      id: '3',
      title: 'Car Loan',
      shortDescription: 'Drive your dream car today',
      detailedDescription:
      'Get easy financing for your dream car with minimal paper work.',
      category: 'Car',
      icon: Icons.directions_car_rounded,
      iconColor: Color(0xFFDC2626),
      minAmount: 100000,
      maxAmount: 10000000,
      amountDisplay: '₹1L - ₹1Cr',
      minInterestRate: 8.0,
      maxInterestRate: 18.0,
      interestRateDisplay: '8% - 18%',
      tenureDisplay: '1 - 7 Years',
      minTenureYears: 1,
      maxTenureYears: 7,
    ),
    const LoanProductModel(
      id: '4',
      title: 'Credit Card Loan',
      shortDescription: 'Quick financing with flexibility',
      detailedDescription:
      'Quick funds with minimal documentation on your credit limit.',
      category: 'Credit Card',
      icon: Icons.credit_card_rounded,
      iconColor: Color(0xFF2563EB),
      minAmount: 50000,
      maxAmount: 1000000,
      amountDisplay: '₹50K - ₹10L',
      minInterestRate: 12.0,
      maxInterestRate: 24.0,
      interestRateDisplay: '12% - 24%',
      tenureDisplay: '6 Months - 5 Years',
      minTenureYears: 1,
      maxTenureYears: 5,
    ),
    const LoanProductModel(
      id: '5',
      title: 'Education Loan',
      shortDescription: 'Invest in a brighter future',
      detailedDescription:
      'Pursue your higher studies in India or abroad effortlessly.',
      category: 'Education',
      icon: Icons.school_rounded,
      iconColor: Color(0xFFEA580C),
      minAmount: 100000,
      maxAmount: 7500000,
      amountDisplay: '₹1L - ₹75L',
      minInterestRate: 8.5,
      maxInterestRate: 14.0,
      interestRateDisplay: '8.5% - 14%',
      tenureDisplay: '1 - 10 Years',
      minTenureYears: 1,
      maxTenureYears: 10,
    ),
    const LoanProductModel(
      id: '6',
      title: 'Gold Loan',
      shortDescription: 'Get instant funds against your gold',
      detailedDescription:
      'Instant cash approval against gold ornaments with safety.',
      category: 'Gold',
      icon: Icons.monetization_on_rounded,
      iconColor: Color(0xFFCA8A04),
      minAmount: 20000,
      maxAmount: 2500000,
      amountDisplay: '₹20K - ₹25L',
      minInterestRate: 7.0,
      maxInterestRate: 16.0,
      interestRateDisplay: '7% - 16%',
      tenureDisplay: '3 Months - 3 Years',
      minTenureYears: 1,
      maxTenureYears: 3,
    ),
    const LoanProductModel(
      id: '7',
      title: 'Home Loan',
      shortDescription: 'Turn your dream home into reality',
      detailedDescription:
      'Affordable home loans with low EMI and transparent processing.',
      category: 'Home',
      icon: Icons.home_rounded,
      iconColor: Color(0xFF059669),
      minAmount: 500000,
      maxAmount: 100000000,
      amountDisplay: '₹5L - ₹10Cr',
      minInterestRate: 8.2,
      maxInterestRate: 12.0,
      interestRateDisplay: '8.2% - 12%',
      tenureDisplay: '5 - 30 Years',
      minTenureYears: 5,
      maxTenureYears: 30,
    ),
    const LoanProductModel(
      id: '8',
      title: 'Loan Against Property',
      shortDescription: 'Unlock the value of your property',
      detailedDescription:
      'Leverage your residential or commercial property for high liquidity.',
      category: 'Property',
      icon: Icons.apartment_rounded,
      iconColor: Color(0xFF4F46E5),
      minAmount: 1000000,
      maxAmount: 50000000,
      amountDisplay: '₹10L - ₹5Cr',
      minInterestRate: 9.5,
      maxInterestRate: 15.0,
      interestRateDisplay: '9.5% - 15%',
      tenureDisplay: '3 - 15 Years',
      minTenureYears: 3,
      maxTenureYears: 15,
    ),
  ];
}