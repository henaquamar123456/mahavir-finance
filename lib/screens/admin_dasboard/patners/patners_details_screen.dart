import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class PartnerDetailsAdminScreen extends StatefulWidget {
  final Map<String, dynamic>? partnerData;

  const PartnerDetailsAdminScreen({super.key, this.partnerData});

  @override
  State<PartnerDetailsAdminScreen> createState() =>
      _PartnerDetailsAdminScreenState();
}

class _PartnerDetailsAdminScreenState extends State<PartnerDetailsAdminScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Overview',
    'Leads (48)',
    'Performance',
    'Commission',
    'Payments',
    'Documents (6)',
    'Activity',
    'Notes (3)',
  ];

  @override
  Widget build(BuildContext context) {
    final name = widget.partnerData?['name'] ?? 'Rahul Kumar';
    final code = widget.partnerData?['code'] ?? 'DSA001';
    final phone = widget.partnerData?['phone'] ?? '+91 98765 43210';
    final email = widget.partnerData?['email'] ?? 'rahul.kumar@gmail.com';
    final location = widget.partnerData?['location'] ?? 'Noida, Uttar Pradesh';

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

              // 2. Title & Actions Row (Edit, Reset Password, More)
              _buildHeaderTitleRow(),
              const SizedBox(height: 14),

              // 3. Top Profile, Business Details & KYC Summary Card
              _buildPartnerTopSummaryCard(name, code, phone, email, location),
              const SizedBox(height: 14),

              // 4. 4 Metric Cards (Total Leads, Approved, Pending, Rejected)
              _buildTopMetricsRow(),
              const SizedBox(height: 14),

              // 5. Navigation Tabs
              _buildTabsRow(),
              const SizedBox(height: 16),

              // 6. 2-Column Performance & Category Section
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildLeadsOverviewChartCard()),
                        const SizedBox(width: 14),
                        Expanded(flex: 4, child: _buildCategoryWiseCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildLeadsOverviewChartCard(),
                      const SizedBox(height: 14),
                      _buildCategoryWiseCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // 7. Bottom Multi-Column Section (Recent Leads, Activity, Documents)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildRecentLeadsTable()),
                        const SizedBox(width: 14),
                        Expanded(flex: 3, child: _buildRecentActivityTimeline()),
                        const SizedBox(width: 14),
                        Expanded(flex: 2, child: _buildSubmittedDocumentsList()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildRecentLeadsTable(),
                      const SizedBox(height: 14),
                      _buildRecentActivityTimeline(),
                      const SizedBox(height: 14),
                      _buildSubmittedDocumentsList(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Top Breadcrumb
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
              'Back to Partner List',
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

  // 2. Title & Action Buttons
  Widget _buildHeaderTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Partner Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View partner profile, leads, performance and transaction details.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined, size: 15, color: Colors.white),
              label: const Text(
                'Edit Partner',
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
              icon: const Icon(Icons.lock_reset_rounded,
                  size: 15, color: AppColors.primary),
              label: const Text(
                'Reset Password',
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

  // 3. Top Profile, Business Details & KYC Summary Card
  Widget _buildPartnerTopSummaryCard(
      String name, String code, String phone, String email, String location) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Details Column
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                  child: Text(
                    name.isNotEmpty ? name[0] : 'P',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F3E38)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Verified',
                                style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF16A36A))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(code,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F3E38))),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Active',
                                style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF16A36A))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(phone,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textSecondary)),
                      Text(email,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textSecondary)),
                      Text(location,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const VerticalDivider(width: 1, color: AppColors.divider),
          const SizedBox(width: 12),

          // Business Details Column
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Business Details',
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                    Text('Edit',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3E38))),
                  ],
                ),
                const SizedBox(height: 6),
                _buildCompactRow('Business Name', 'RK Financial Services'),
                _buildCompactRow('GST Number', '09ABCDE1234F1Z5'),
                _buildCompactRow('PAN Number', 'ABCDE1234F'),
                _buildCompactRow('Address',
                    'A-102, Sector 62, Noida, Uttar Pradesh 201309'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const VerticalDivider(width: 1, color: AppColors.divider),
          const SizedBox(width: 12),

          // KYC Status Summary Column
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('KYC Status',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
                const SizedBox(height: 6),
                _buildKycStatusLine('Aadhaar Card', 'Verified'),
                _buildKycStatusLine('PAN Card', 'Verified'),
                _buildKycStatusLine('Address Proof', 'Verified'),
                _buildKycStatusLine('Bank Details', 'Verified'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 10.5, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildKycStatusLine(String title, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 10.5, color: AppColors.textSecondary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A36A)),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Four Metric Cards Row
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricPill(
            title: 'Total Leads',
            value: '48',
            badge: '↑ 20%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '+8 this month',
            icon: Icons.assignment_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricPill(
            title: 'Approved',
            value: '32',
            badge: '↑ 18%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '66.7% of total',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricPill(
            title: 'Pending',
            value: '10',
            badge: '↑ 9%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: '20.8% of total',
            icon: Icons.access_time_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricPill(
            title: 'Rejected',
            value: '6',
            badge: '↓ 25%',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: '12.5% of total',
            icon: Icons.cancel_outlined,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricPill(
            title: 'Total Commission',
            value: '₹ 2,40,000',
            badge: '↑ 15%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '₹40,000 this month',
            icon: Icons.currency_rupee_rounded,
            iconBg: const Color(0xFFE6F7F2),
            iconColor: const Color(0xFF0F3E38),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricPill({
    required String title,
    required String value,
    required String badge,
    required Color badgeBg,
    required Color badgeColor,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                    color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                  radius: 12,
                  backgroundColor: iconBg,
                  child: Icon(icon, size: 14, color: iconColor)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style:
              const TextStyle(fontSize: 9.5, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 5. Tabs Row
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

  // 6. Left: Leads Overview Bar Chart Card
  Widget _buildLeadsOverviewChartCard() {
    final months = [
      {'m': 'Apr', 's': 6, 'a': 4},
      {'m': 'May', 's': 8, 'a': 5},
      {'m': 'Jun', 's': 7, 'a': 4},
      {'m': 'Jul', 's': 9, 'a': 6},
      {'m': 'Aug', 's': 8, 'a': 5},
      {'m': 'Sep', 's': 10, 'a': 8, 'isMax': true},
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Leads Overview',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary)),
                  Text('Submitted, approved and converted leads',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
              Row(
                children: [
                  _buildLegend(const Color(0xFF0F3E38), 'Submitted'),
                  const SizedBox(width: 8),
                  _buildLegend(const Color(0xFF16A36A), 'Approved'),
                  const SizedBox(width: 8),
                  _buildLegend(const Color(0xFFD97706), 'Pending'),
                  const SizedBox(width: 8),
                  _buildLegend(const Color(0xFFDC2626), 'Rejected'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: months.map((m) {
                final double hSubmitted = (m['s'] as int) * 11.0;
                final double hApproved = (m['a'] as int) * 11.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 14,
                          height: hSubmitted,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F3E38),
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 14,
                          height: hApproved,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A36A),
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(m['m'] as String,
                        style: const TextStyle(
                            fontSize: 9.5, color: AppColors.textSecondary)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color col, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 3, backgroundColor: col),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 9.5, color: AppColors.textSecondary)),
      ],
    );
  }

  // 6. Right: Loan Category Wise Leads & Commission Card
  Widget _buildCategoryWiseCard() {
    final categories = [
      {'name': 'Home Loan', 'pct': '36%', 'count': '17', 'color': const Color(0xFF0F3E38)},
      {'name': 'Personal Loan', 'pct': '21%', 'count': '10', 'color': const Color(0xFF16A36A)},
      {'name': 'Car Loan', 'pct': '17%', 'count': '8', 'color': const Color(0xFF0284C7)},
      {'name': 'Business Loan', 'pct': '15%', 'count': '7', 'color': const Color(0xFF7C3AED)},
      {'name': 'Education Loan', 'pct': '8%', 'count': '4', 'color': const Color(0xFFD97706)},
      {'name': 'Other Loans', 'pct': '4%', 'count': '2', 'color': const Color(0xFF94A3B8)},
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
              Text('Loan Category Wise Leads',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              Text('This Year',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          ...categories.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: c['color'] as Color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(c['name'] as String,
                        style: const TextStyle(
                            fontSize: 10.5, color: AppColors.primary)),
                  ),
                  Text('${c['pct']} (${c['count']})',
                      style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ],
              ),
            );
          }),
          const Divider(height: 14, color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Paid: ₹ 1,80,000',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF16A36A))),
              Text('Pending: ₹ 60,000',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD97706))),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Left: Recent Leads Table
  Widget _buildRecentLeadsTable() {
    final leads = [
      {
        'name': 'Amit Shah',
        'type': 'Home Loan',
        'amount': '₹25,00,000',
        'status': 'Pending',
        'statusBg': const Color(0xFFFEF3C7),
        'statusCol': const Color(0xFFD97706),
        'date': '12 Sep 2024',
      },
      {
        'name': 'Priya Verma',
        'type': 'Car Loan',
        'amount': '₹8,00,000',
        'status': 'Approved',
        'statusBg': const Color(0xFFDCFCE7),
        'statusCol': const Color(0xFF16A36A),
        'date': '10 Sep 2024',
      },
      {
        'name': 'Rohan Mehta',
        'type': 'Personal Loan',
        'amount': '₹5,00,000',
        'status': 'Approved',
        'statusBg': const Color(0xFFDCFCE7),
        'statusCol': const Color(0xFF16A36A),
        'date': '08 Sep 2024',
      },
      {
        'name': 'Neha Singh',
        'type': 'Education Loan',
        'amount': '₹10,00,000',
        'status': 'Rejected',
        'statusBg': const Color(0xFFFEE2E2),
        'statusCol': const Color(0xFFDC2626),
        'date': '05 Sep 2024',
      },
      {
        'name': 'Suresh Patel',
        'type': 'Business Loan',
        'amount': '₹6,00,000',
        'status': 'Approved',
        'statusBg': const Color(0xFFDCFCE7),
        'statusCol': const Color(0xFF16A36A),
        'date': '02 Sep 2024',
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
              Text('Recent Leads',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
              Text('View All >',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          ...leads.map((l) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l['name'] as String,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                        Text(l['type'] as String,
                            style: const TextStyle(
                                fontSize: 9.5,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(l['amount'] as String,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: l['statusBg'] as Color,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(l['status'] as String,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: l['statusCol'] as Color)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 7. Center: Recent Activity Timeline
  Widget _buildRecentActivityTimeline() {
    final activities = [
      {
        'time': '12 Sep 2024, 10:30 AM',
        'title': 'Lead approved for Amit Shah (Home Loan - ₹25,00,000)',
      },
      {
        'time': '10 Sep 2024, 04:15 PM',
        'title': 'Submitted new lead Priya Verma (Car Loan - ₹8,00,000)',
      },
      {
        'time': '08 Sep 2024, 11:20 AM',
        'title': 'Commission of ₹40,000 credited to bank',
      },
      {
        'time': '05 Sep 2024, 02:45 PM',
        'title': 'Lead rejected - Neha Singh (Credit score criteria)',
      },
      {
        'time': '01 Sep 2024, 10:15 AM',
        'title': 'Partner profile and GST verified successfully',
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
              Text('Recent Activity',
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
            children: activities.map((act) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: CircleAvatar(
                          radius: 3.5, backgroundColor: Color(0xFF16A36A)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(act['time']!,
                              style: const TextStyle(
                                  fontSize: 9, color: AppColors.textHint)),
                          const SizedBox(height: 1),
                          Text(act['title']!,
                              style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.textPrimary,
                                  height: 1.25)),
                        ],
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

  // 7. Right: Submitted Documents List
  Widget _buildSubmittedDocumentsList() {
    final docs = [
      'Aadhaar Card',
      'PAN Card',
      'Address Proof',
      'GST Certificate',
      'Bank Statement',
      'Photo',
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
              Text('Documents (6)',
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
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 14, color: Color(0xFF0284C7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(doc,
                          style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ),
                    const Icon(Icons.check_circle_rounded,
                        size: 13, color: Color(0xFF16A36A)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}