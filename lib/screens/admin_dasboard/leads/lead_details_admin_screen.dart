import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';

class LeadDetailsAdminScreen extends StatefulWidget {
  final Map<String, dynamic>? leadData;

  const LeadDetailsAdminScreen({super.key, this.leadData});

  @override
  State<LeadDetailsAdminScreen> createState() => _LeadDetailsAdminScreenState();
}

class _LeadDetailsAdminScreenState extends State<LeadDetailsAdminScreen> {
  int _selectedTab = 0;
  bool _isUpdating = false;
  late String _currentStatus;

  final List<String> _tabs = [
    'Overview',
    'Documents (6)',
    'Verification',
    'Notes (3)',
    'Activity History',
    'Communication',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.leadData?['status']?.toString() ?? 'Under Review';
  }

  /// Live API Call: Update Loan Status (Approved / Rejected)
  Future<void> _updateLeadStatus(String newStatus) async {
    final loanId = widget.leadData?['_id'] ?? widget.leadData?['id'] ?? widget.leadData?['leadId'];

    if (loanId == null || loanId.toString().isEmpty) {
      setState(() => _currentStatus = newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lead status updated to $newStatus (Local Preview)'),
          backgroundColor: newStatus == 'Approved' ? const Color(0xFF16A36A) : const Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loans/admin/$loanId/status'));

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': newStatus}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => _currentStatus = newStatus);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lead successfully marked as $newStatus! Commission ledger updated.'),
              backgroundColor: newStatus == 'Approved' ? const Color(0xFF16A36A) : const Color(0xFFDC2626),
            ),
          );
        }
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (_) {
      // Fallback local update
      setState(() => _currentStatus = newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $newStatus locally.'),
            backgroundColor: newStatus == 'Approved' ? const Color(0xFF16A36A) : const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawCustomer = widget.leadData?['customer'];
    final name = (rawCustomer is Map ? rawCustomer['name'] : widget.leadData?['name']) ?? 'Amit Shah';
    final leadId = widget.leadData?['leadId'] ?? widget.leadData?['_id'] ?? 'LD00001';
    final phone = (rawCustomer is Map ? rawCustomer['phone'] : widget.leadData?['phone']) ?? '+91 9876543210';
    final email = (rawCustomer is Map ? rawCustomer['email'] : widget.leadData?['email']) ?? 'amit.shah@gmail.com';
    final loanType = widget.leadData?['loanType'] ?? 'Home Loan';
    final rawAmount = widget.leadData?['loanAmount'] ?? widget.leadData?['amount'] ?? 2500000;
    final amount = rawAmount is num ? CurrencyFormatter.formatWhole(rawAmount.toDouble()) : rawAmount.toString();
    final partner = widget.leadData?['partner'] ?? 'DSA Partner';
    final partnerCode = widget.leadData?['dsaCode'] ?? widget.leadData?['partnerCode'] ?? 'DSA001';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBreadcrumb(context),
              const SizedBox(height: 12),
              _buildHeaderTitleRow(),
              const SizedBox(height: 14),
              _buildLeadOverviewBanner(name, leadId.toString(), phone, email, partner, partnerCode),
              const SizedBox(height: 14),
              _buildTabsRow(),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _buildLoanInformationCard(loanType, amount),
                              const SizedBox(height: 14),
                              _buildPersonalInformationCard(name, phone, email),
                              const SizedBox(height: 14),
                              _buildPartnerInformationCard(partner, partnerCode),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _buildSubmittedDocumentsCard(),
                              const SizedBox(height: 14),
                              _buildVerificationChecklistCard(),
                              const SizedBox(height: 14),
                              _buildReviewNotesCard(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _buildLoanInformationCard(loanType, amount),
                      const SizedBox(height: 14),
                      _buildPersonalInformationCard(name, phone, email),
                      const SizedBox(height: 14),
                      _buildPartnerInformationCard(partner, partnerCode),
                      const SizedBox(height: 14),
                      _buildSubmittedDocumentsCard(),
                      const SizedBox(height: 14),
                      _buildVerificationChecklistCard(),
                      const SizedBox(height: 14),
                      _buildReviewNotesCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildBottomActionBar(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBreadcrumb(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(6),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: Color(0xFF0F3E38)),
            SizedBox(width: 6),
            Text(
              'Back to All Loan Leads',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F3E38),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitleRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lead Details & Review',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Check customer information, loan details, documents and take action.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeadOverviewBanner(String name, String leadId, String phone,
      String email, String partner, String partnerCode) {
    final isApproved = _currentStatus == 'Approved' || _currentStatus == 'Disbursed';
    final isRejected = _currentStatus == 'Rejected';

    Color statusBg = const Color(0xFFE0F2FE);
    Color statusColor = const Color(0xFF0284C7);
    if (isApproved) {
      statusBg = const Color(0xFFDCFCE7);
      statusColor = const Color(0xFF16A36A);
    } else if (isRejected) {
      statusBg = const Color(0xFFFEE2E2);
      statusColor = const Color(0xFFDC2626);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'L',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F3E38),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _currentStatus,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$phone • $email',
                      style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                    ),
                    const Text(
                      'Referred via Mahavir Finance Partner App',
                      style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetaBlock('Lead Source', 'Partner (DSA)'),
                    _buildMetaBlock('Partner Code', partnerCode),
                    _buildMetaBlock('Commission Rate', '1.5%'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTrackerStep('Submitted', 'Verified', isDone: true),
              _buildTrackerLine(isDone: true),
              _buildTrackerStep('Under Review', _currentStatus == 'Under Review' ? 'In Progress' : 'Done', isDone: isApproved || isRejected, isCurrent: _currentStatus == 'Under Review'),
              _buildTrackerLine(isDone: isApproved),
              _buildTrackerStep(isRejected ? 'Rejected' : 'Approved', isApproved ? 'Approved' : (isRejected ? 'Declined' : 'Pending'), isDone: isApproved, isCurrent: isApproved, isFailed: isRejected),
              _buildTrackerLine(isDone: _currentStatus == 'Disbursed'),
              _buildTrackerStep('Disbursed', _currentStatus == 'Disbursed' ? 'Done' : 'Pending', isDone: _currentStatus == 'Disbursed'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBlock(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildTrackerStep(String title, String subtitle,
      {bool isDone = false, bool isCurrent = false, bool isFailed = false}) {
    Color col = AppColors.textHint;
    if (isFailed) {
      col = const Color(0xFFDC2626);
    } else if (isDone) {
      col = const Color(0xFF16A36A);
    } else if (isCurrent) {
      col = const Color(0xFF0284C7);
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: col.withValues(alpha: 0.15),
          child: CircleAvatar(radius: 4, backgroundColor: col),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: col)),
            Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackerLine({required bool isDone}) {
    return Container(
      width: 40,
      height: 2,
      color: isDone ? const Color(0xFF16A36A) : AppColors.border,
    );
  }

  Widget _buildTabsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = index),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0F3E38) : AppColors.border,
                  ),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoanInformationCard(String loanType, String amount) {
    return _buildSectionCard(
      title: 'Loan Information',
      child: Column(
        children: [
          _buildInfoRow2('Loan Type', loanType, 'Requested Amount', amount, isBoldSecond: true),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Loan Tenure', '5 - 15 Years', 'Est. Commission (1.5%)', 'Applicable on Disbursal', isBoldSecond: true),
          const Divider(height: 14, color: AppColors.divider),
          _buildSingleInfoRow('Current Verification Stage', _currentStatus),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationCard(String name, String phone, String email) {
    return _buildSectionCard(
      title: 'Personal Information',
      child: Column(
        children: [
          _buildInfoRow2('Full Name', name, 'City / Region', 'Gujarat, India'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Mobile Number', phone, 'Email Address', email),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Employment Type', 'Salaried / Professional', 'Monthly Income', '₹ 25,000+ (Est.)', isBoldSecond: true),
        ],
      ),
    );
  }

  Widget _buildPartnerInformationCard(String partner, String partnerCode) {
    return _buildSectionCard(
      title: 'Partner (DSA) Details',
      child: Column(
        children: [
          _buildInfoRow2('Partner / Referrer', partner, 'Partner Code', partnerCode),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Commission Tier', '1.5% Standard Rate', 'Payout Cycle', 'Direct Bank Transfer'),
        ],
      ),
    );
  }

  Widget _buildSubmittedDocumentsCard() {
    final docs = [
      {'name': 'Identity Document', 'status': 'Verified'},
      {'name': 'PAN Card', 'status': 'Verified'},
      {'name': 'Income / Salary Proof', 'status': 'Verified'},
      {'name': 'Bank Statement', 'status': 'Verified'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submitted Documents',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Column(
            children: docs.map((doc) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 15, color: Color(0xFF0284C7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doc['name']!,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        doc['status']!,
                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Color(0xFF16A36A)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationChecklistCard() {
    final checks = [
      {'title': 'Identity Verification', 'status': 'Verified'},
      {'title': 'PAN Validation', 'status': 'Verified'},
      {'title': 'Income & Credit Eligibility', 'status': 'Verified'},
      {'title': 'Bank Account Check', 'status': 'Verified'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verification Checklist',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Column(
            children: checks.map((c) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A36A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(c['title']!, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                    ),
                    Text(
                      c['status']!,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF16A36A)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewNotesCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Credit Team Review Note',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Lead referred via verified DSA channel. Profile and credit history reviewed for final approval decision.',
              style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
          if (_isUpdating)
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.secondary, strokeWidth: 2))
          else
            Wrap(
              spacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _updateLeadStatus('Rejected'),
                  icon: const Icon(Icons.close_rounded, size: 15, color: Color(0xFFDC2626)),
                  label: const Text(
                    'Reject Lead',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    side: const BorderSide(color: Color(0xFFDC2626)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _updateLeadStatus('Approved'),
                  icon: const Icon(Icons.check_rounded, size: 15, color: Colors.white),
                  label: const Text(
                    'Approve Lead',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A36A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow2(String l1, String v1, String l2, String v2, {bool isBoldSecond = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(v1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                v2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBoldSecond ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldSecond ? const Color(0xFF0F3E38) : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }
}