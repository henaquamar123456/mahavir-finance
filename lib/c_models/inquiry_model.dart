import 'package:flutter/material.dart';

enum InquiryStatus {
  pending('Pending', Color(0xFFE0F2FE), Color(0xFF0284C7)),
  underReview('Under Review', Color(0xFFFEF3C7), Color(0xFFD97706)),
  approved('Approved', Color(0xFFDCFCE7), Color(0xFF16A36A)),
  rejected('Rejected', Color(0xFFFEE2E2), Color(0xFFDC2626));

  final String label;
  final Color backgroundColor;
  final Color textColor;

  const InquiryStatus(this.label, this.backgroundColor, this.textColor);

  static InquiryStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return InquiryStatus.pending;
      case 'under review':
      case 'under_review':
        return InquiryStatus.underReview;
      case 'approved':
        return InquiryStatus.approved;
      case 'rejected':
        return InquiryStatus.rejected;
      default:
        return InquiryStatus.pending;
    }
  }
}

class InquiryModel {
  final String id;
  final String loanType;
  final InquiryStatus status;
  final DateTime date;
  final String formattedTime;
  final double amount;
  final String tenure;
  final String purpose;
  final int currentStep; // 0: Submitted, 1: Under Review, 2: Offer Stage, 3: Completed
  final String expectedDisbursal;

  // Applicant details
  final String applicantName;
  final String mobileNumber;
  final String email;
  final String employmentType;
  final double monthlyIncome;
  final String companyName;
  final String city;

  // Icon config
  final IconData icon;
  final Color iconColor;

  const InquiryModel({
    required this.id,
    required this.loanType,
    required this.status,
    required this.date,
    required this.formattedTime,
    required this.amount,
    required this.tenure,
    required this.purpose,
    required this.currentStep,
    required this.expectedDisbursal,
    required this.applicantName,
    required this.mobileNumber,
    required this.email,
    required this.employmentType,
    required this.monthlyIncome,
    required this.companyName,
    required this.city,
    required this.icon,
    required this.iconColor,
  });

  static List<InquiryModel> get sampleInquiries => [
    InquiryModel(
      id: 'MF202610200001',
      loanType: 'Personal Loan',
      status: InquiryStatus.underReview,
      date: DateTime(2026, 10, 20),
      formattedTime: '09:41 AM',
      amount: 500000,
      tenure: '5 Years',
      purpose: 'Home Renovation',
      currentStep: 1,
      expectedDisbursal: 'Within 7-10 days',
      applicantName: 'Rohit Kumar',
      mobileNumber: '+91 98765 43210',
      email: 'rohit@gmail.com',
      employmentType: 'Salaried',
      monthlyIncome: 50000,
      companyName: 'ABC Private Limited',
      city: 'Noida, Uttar Pradesh',
      icon: Icons.savings_rounded,
      iconColor: const Color(0xFFD97706),
    ),
    InquiryModel(
      id: 'MF202610150003',
      loanType: 'Home Loan',
      status: InquiryStatus.pending,
      date: DateTime(2026, 10, 15),
      formattedTime: '02:15 PM',
      amount: 2000000,
      tenure: '15 Years',
      purpose: 'Property Purchase',
      currentStep: 0,
      expectedDisbursal: 'Within 15-20 days',
      applicantName: 'Rohit Kumar',
      mobileNumber: '+91 98765 43210',
      email: 'rohit@gmail.com',
      employmentType: 'Salaried',
      monthlyIncome: 50000,
      companyName: 'ABC Private Limited',
      city: 'Noida, Uttar Pradesh',
      icon: Icons.home_rounded,
      iconColor: const Color(0xFF0284C7),
    ),
    InquiryModel(
      id: 'MF202610100005',
      loanType: 'Car Loan',
      status: InquiryStatus.approved,
      date: DateTime(2026, 10, 10),
      formattedTime: '11:30 AM',
      amount: 800000,
      tenure: '5 Years',
      purpose: 'New Car',
      currentStep: 3,
      expectedDisbursal: 'Disbursed',
      applicantName: 'Rohit Kumar',
      mobileNumber: '+91 98765 43210',
      email: 'rohit@gmail.com',
      employmentType: 'Salaried',
      monthlyIncome: 50000,
      companyName: 'ABC Private Limited',
      city: 'Noida, Uttar Pradesh',
      icon: Icons.directions_car_rounded,
      iconColor: const Color(0xFF16A36A),
    ),
    InquiryModel(
      id: 'MF202609250002',
      loanType: 'Education Loan',
      status: InquiryStatus.rejected,
      date: DateTime(2026, 9, 25),
      formattedTime: '04:20 PM',
      amount: 300000,
      tenure: '4 Years',
      purpose: 'Higher Education',
      currentStep: 0,
      expectedDisbursal: 'N/A',
      applicantName: 'Rohit Kumar',
      mobileNumber: '+91 98765 43210',
      email: 'rohit@gmail.com',
      employmentType: 'Salaried',
      monthlyIncome: 50000,
      companyName: 'ABC Private Limited',
      city: 'Noida, Uttar Pradesh',
      icon: Icons.school_rounded,
      iconColor: const Color(0xFF7C3AED),
    ),
  ];
}