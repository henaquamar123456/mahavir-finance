import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class LeadDetailsAdminScreen extends StatefulWidget {
  final Map<String, dynamic>? leadData;

  const LeadDetailsAdminScreen({super.key, this.leadData});

  @override
  State<LeadDetailsAdminScreen> createState() => _LeadDetailsAdminScreenState();
}

class _LeadDetailsAdminScreenState extends State<LeadDetailsAdminScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Overview',
    'Documents (6)',
    'Verification',
    'Notes (3)',
    'Activity History',
    'Communication',
  ];

  @override
  Widget build(BuildContext context) {
    final name = widget.leadData?['name'] ?? 'Amit Shah';
    final leadId = widget.leadData?['leadId'] ?? 'LD00001';
    final phone = widget.leadData?['phone'] ?? '+91 9876543210';
    final email = widget.leadData?['email'] ?? 'amit.shah@gmail.com';
    final loanType = widget.leadData?['loanType'] ?? 'Home Loan';
    final amount = widget.leadData?['amount'] ?? '₹ 25,00,000';
    final partner = widget.leadData?['partner'] ?? 'Rahul Kumar';
    final partnerCode = widget.leadData?['partnerCode'] ?? 'DSA001';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Breadcrumb navigation
              _buildTopBreadcrumb(context),
              const SizedBox(height: 12),

              // 2. Title & Action Buttons Row
              _buildHeaderTitleRow(),
              const SizedBox(height: 14),

              // 3. Top Lead Summary Strip & Pipeline Tracker
              _buildLeadOverviewBanner(
                  name, leadId, phone, email, partner, partnerCode),
              const SizedBox(height: 14),

              // 4. Navigation Tabs Row
              _buildTabsRow(),
              const SizedBox(height: 16),

              // 5. 2-Column Responsive Information Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Loan, Personal & Partner Information
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              _buildLoanInformationCard(loanType, amount),
                              const SizedBox(height: 14),
                              _buildPersonalInformationCard(name, phone, email),
                              const SizedBox(height: 14),
                              _buildPartnerInformationCard(
                                  partner, partnerCode),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Right Column: Documents, Verification Checklist & Review Notes
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

              // 6. Bottom Sticky Decision Bar
              _buildBottomActionBar(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Breadcrumb navigation
  Widget _buildTopBreadcrumb(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back_ios_new_rounded,
                size: 13, color: Color(0xFF0F3E38)),
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

  // 2. Title & Action Buttons Row
  Widget _buildHeaderTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_rounded,
                  size: 15, color: Colors.white),
              label: const Text(
                'Assign to Executive',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_note_rounded,
                  size: 16, color: AppColors.primary),
              label: const Text(
                'Add Note',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                children: [
                  Text('More',
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Top Lead Summary Strip & Pipeline Tracker
  Widget _buildLeadOverviewBanner(String name, String leadId, String phone,
      String email, String partner, String partnerCode) {
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
                backgroundColor:
                const Color(0xFF0F3E38).withOpacity(0.1),
                child: Text(
                  name.isNotEmpty ? name[0] : 'L',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F3E38)),
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
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lead ID: $leadId',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F3E38)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Under Review',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0284C7)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text('$phone  •  $email',
                        style: const TextStyle(
                            fontSize: 10.5, color: AppColors.textSecondary)),
                    const Text('Noida, Uttar Pradesh',
                        style: TextStyle(
                            fontSize: 10.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetaBlock('Lead Source', 'Partner (DSA)'),
                    _buildMetaBlock('Partner Name', '$partner ($partnerCode)'),
                    _buildMetaBlock('Submitted On', '12 Sep 2024, 10:30 AM'),
                    _buildMetaBlock(
                        'Assigned To', 'Neha Sharma (Loan Officer)'),
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
              _buildTrackerStep('Submitted', '12 Sep', isDone: true),
              _buildTrackerLine(isDone: true),
              _buildTrackerStep('Under Review', '13 Sep', isCurrent: true),
              _buildTrackerLine(isDone: false),
              _buildTrackerStep('Approved', 'Pending', isDone: false),
              _buildTrackerLine(isDone: false),
              _buildTrackerStep('Disbursed', 'Pending', isDone: false),
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
        Text(label,
            style: const TextStyle(
                fontSize: 9.5, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(val,
            style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary)),
      ],
    );
  }

  Widget _buildTrackerStep(String title, String subtitle,
      {bool isDone = false, bool isCurrent = false}) {
    Color col = AppColors.textHint;
    if (isDone) col = const Color(0xFF16A36A);
    if (isCurrent) col = const Color(0xFF0284C7);

    return Row(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: col.withOpacity(0.15),
          child: CircleAvatar(radius: 4, backgroundColor: col),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: col)),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 9, color: AppColors.textSecondary)),
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

  // 4. Navigation Tabs Row
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
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0F3E38)
                        : AppColors.border,
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

  // Left Column - Loan Information Card
  Widget _buildLoanInformationCard(String loanType, String amount) {
    return _buildSectionCard(
      title: 'Loan Information',
      onEdit: () {},
      child: Column(
        children: [
          _buildInfoRow2(
              'Loan Type', loanType, 'Requested Amount', amount,
              isBoldSecond: true),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2(
              'Loan Tenure', '20 Years', 'Purpose', 'Purchase a new house'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Property Location', 'Noida, Uttar Pradesh',
              'Expected Disbursal', 'Oct 2024'),
          const Divider(height: 14, color: AppColors.divider),
          _buildSingleInfoRow(
              'Remarks', 'Need loan for ready to move 2BHK flat'),
        ],
      ),
    );
  }

  // Left Column - Personal Information Card
  Widget _buildPersonalInformationCard(
      String name, String phone, String email) {
    return _buildSectionCard(
      title: 'Personal Information',
      onEdit: () {},
      child: Column(
        children: [
          _buildInfoRow2('Full Name', name, 'Date of Birth',
              '15 Mar 1992 (32 years)'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Gender', 'Male', 'Marital Status', 'Married'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Mobile Number', phone, 'Email Address', email),
          const Divider(height: 14, color: AppColors.divider),
          _buildSingleInfoRow('Address',
              'A-102, Sector 62, Noida, Uttar Pradesh 201309'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Employment Type', 'Salaried', 'Company Name',
              'TCS Pvt. Ltd.'),
          const Divider(height: 14, color: AppColors.divider),
          _buildSingleInfoRow('Monthly Income', '₹ 1,20,000', isBold: true),
        ],
      ),
    );
  }

  // Left Column - Partner Information Card
  Widget _buildPartnerInformationCard(String partner, String partnerCode) {
    return _buildSectionCard(
      title: 'Partner Information',
      child: Column(
        children: [
          _buildInfoRow2(
              'Partner Name', partner, 'Partner ID', partnerCode),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Mobile Number', '+91 91234 56789',
              'Email Address', 'rahul.kumar@gmail.com'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Location', 'Noida, Uttar Pradesh',
              'Commission Rate', '1.5%'),
          const Divider(height: 14, color: AppColors.divider),
          _buildInfoRow2('Total Leads', '48', 'Approved Leads', '32'),
        ],
      ),
    );
  }

  // Right Column - Submitted Documents Card (6)
  Widget _buildSubmittedDocumentsCard() {
    final docs = [
      {'name': 'Aadhaar Card', 'status': 'Verified'},
      {'name': 'PAN Card', 'status': 'Verified'},
      {'name': 'Address Proof', 'status': 'Pending'},
      {'name': 'Income Proof (Salary Slip)', 'status': 'Verified'},
      {'name': 'Bank Statement (6 Months)', 'status': 'Pending'},
      {'name': 'Property Documents', 'status': 'Not Verified'},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Submitted Documents (6)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              Text('View All',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: docs.map((doc) {
              final isVerified = doc['status'] == 'Verified';
              final isPending = doc['status'] == 'Pending';

              Color statusBg = const Color(0xFFFEE2E2);
              Color statusCol = const Color(0xFFDC2626);
              if (isVerified) {
                statusBg = const Color(0xFFDCFCE7);
                statusCol = const Color(0xFF16A36A);
              } else if (isPending) {
                statusBg = const Color(0xFFFEF3C7);
                statusCol = const Color(0xFFD97706);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 15, color: Color(0xFF0284C7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doc['name']!,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        doc['status']!,
                        style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: statusCol),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.visibility_outlined,
                        size: 14, color: Color(0xFF0F3E38)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Right Column - Verification Checklist Card
  Widget _buildVerificationChecklistCard() {
    final checks = [
      {'title': 'Aadhaar Card', 'status': 'Verified'},
      {'title': 'PAN Card', 'status': 'Verified'},
      {'title': 'Address Proof', 'status': 'Pending'},
      {'title': 'Income Proof (Salary Slip)', 'status': 'Verified'},
      {'title': 'Bank Statement (6 Months)', 'status': 'Pending'},
      {'title': 'Property Documents', 'status': 'Not Verified'},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Verification Checklist',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              Text('Edit',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: checks.map((c) {
              final isVerified = c['status'] == 'Verified';
              final isPending = c['status'] == 'Pending';

              Color statusCol = const Color(0xFFDC2626);
              if (isVerified) statusCol = const Color(0xFF16A36A);
              if (isPending) statusCol = const Color(0xFFD97706);

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      isVerified
                          ? Icons.check_circle_rounded
                          : isPending
                          ? Icons.hourglass_bottom_rounded
                          : Icons.cancel_rounded,
                      size: 14,
                      color: statusCol,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(c['title']!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.primary)),
                    ),
                    Text(
                      c['status']!,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusCol),
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

  // Right Column - Review Notes Card
  Widget _buildReviewNotesCard() {
    final notes = [
      {
        'author': 'Neha Sharma (Loan Officer)',
        'time': '13 Sep 2024, 02:15 PM',
        'note':
        'Documents are valid. Property documents need further verification.',
      },
      {
        'author': 'Rahul Kumar (DSA)',
        'time': '12 Sep 2024, 11:30 AM',
        'note': 'Customer is genuine. Interested for early disbursement.',
      },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Review Notes',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              Text('+ Add Note',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: notes.map((n) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(n['author']!,
                            style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F3E38))),
                        Text(n['time']!,
                            style: const TextStyle(
                                fontSize: 9.5, color: AppColors.textHint)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(n['note']!,
                        style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textSecondary,
                            height: 1.3)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 6. Bottom Sticky Decision Bar
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Back to List',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          Wrap(
            spacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Lead marked as Rejected!'),
                        backgroundColor: Color(0xFFDC2626)),
                  );
                },
                icon: const Icon(Icons.close_rounded,
                    size: 15, color: Color(0xFFDC2626)),
                label: const Text('Reject Lead',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFDC2626))),
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: const BorderSide(color: Color(0xFFDC2626)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Lead approved and moved to disbursal queue!'),
                        backgroundColor: Color(0xFF16A36A)),
                  );
                },
                icon: const Icon(Icons.check_rounded,
                    size: 15, color: Colors.white),
                label: const Text('Approve Lead',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A36A),
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helpers
  Widget _buildSectionCard(
      {required String title, required Widget child, VoidCallback? onEdit}) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              if (onEdit != null)
                InkWell(
                  onTap: onEdit,
                  child: const Text('Edit',
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F3E38))),
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow2(String l1, String v1, String l2, String v2,
      {bool isBoldSecond = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(v1,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                v2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  isBoldSecond ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldSecond
                      ? const Color(0xFF0F3E38)
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInfoRow(String label, String value,
      {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                  color: isBold ? const Color(0xFF0F3E38) : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}