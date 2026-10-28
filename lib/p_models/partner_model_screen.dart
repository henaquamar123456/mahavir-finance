import 'package:flutter/material.dart';

enum PartnerLeadStatus {
  pending('Pending', Color(0xFFFEF3C7), Color(0xFFD97706)),
  underReview('Under Review', Color(0xFFE0F2FE), Color(0xFF0284C7)),
  approved('Approved', Color(0xFFDCFCE7), Color(0xFF16A36A)),
  rejected('Rejected', Color(0xFFFEE2E2), Color(0xFFDC2626));

  final String label;
  final Color backgroundColor;
  final Color textColor;

  const PartnerLeadStatus(this.label, this.backgroundColor, this.textColor);
}

class PartnerLeadModel {
  final String id;
  final String customerName;
  final String customerId;
  final String phone;
  final String email;
  final String city;
  final String loanCategory;
  final double amount;
  final String tenure;
  final String date;
  final String time;
  final PartnerLeadStatus status;
  final IconData icon;
  final Color iconColor;
  final bool isExistingCustomer;

  const PartnerLeadModel({
    required this.id,
    required this.customerName,
    required this.customerId,
    required this.phone,
    required this.email,
    required this.city,
    required this.loanCategory,
    required this.amount,
    required this.tenure,
    required this.date,
    required this.time,
    required this.status,
    required this.icon,
    required this.iconColor,
    this.isExistingCustomer = false,
  });

  static List<PartnerLeadModel> get sampleLeads => [
    const PartnerLeadModel(
      id: '#LD20240912',
      customerName: 'Amit Shah',
      customerId: 'CUST00124',
      phone: '+91 98765 43210',
      email: 'amit.shah@gmail.com',
      city: 'Ahmedabad, Gujarat',
      loanCategory: 'Car Loan',
      amount: 800000,
      tenure: '5 Years',
      date: '12 Sep 2024',
      time: '10:30 AM',
      status: PartnerLeadStatus.pending,
      icon: Icons.directions_car_rounded,
      iconColor: Color(0xFF0284C7),
      isExistingCustomer: true,
    ),
    const PartnerLeadModel(
      id: '#LD20240911',
      customerName: 'Priya Sharma',
      customerId: 'CUST00125',
      phone: '+91 87654 32109',
      email: 'priya@gmail.com',
      city: 'Surat, Gujarat',
      loanCategory: 'Home Loan',
      amount: 2500000,
      tenure: '15 Years',
      date: '11 Sep 2024',
      time: '02:15 PM',
      status: PartnerLeadStatus.approved,
      icon: Icons.home_rounded,
      iconColor: Color(0xFF16A36A),
      isExistingCustomer: true,
    ),
    const PartnerLeadModel(
      id: '#LD20240910',
      customerName: 'Rohan Mehta',
      customerId: 'CUST00126',
      phone: '+91 76543 21098',
      email: 'rohan@gmail.com',
      city: 'Vadodara, Gujarat',
      loanCategory: 'Personal Loan',
      amount: 500000,
      tenure: '3 Years',
      date: '10 Sep 2024',
      time: '11:00 AM',
      status: PartnerLeadStatus.rejected,
      icon: Icons.person_rounded,
      iconColor: Color(0xFF7C3AED),
    ),
    const PartnerLeadModel(
      id: '#LD20240909',
      customerName: 'Suresh Patel',
      customerId: 'CUST00127',
      phone: '+91 91234 56789',
      email: 'suresh@gmail.com',
      city: 'Rajkot, Gujarat',
      loanCategory: 'Business Loan',
      amount: 1500000,
      tenure: '5 Years',
      date: '09 Sep 2024',
      time: '04:45 PM',
      status: PartnerLeadStatus.underReview,
      icon: Icons.business_center_rounded,
      iconColor: Color(0xFFD97706),
      isExistingCustomer: true,
    ),
  ];
}