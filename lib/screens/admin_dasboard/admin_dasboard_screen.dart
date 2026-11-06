import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome Back, Admin!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
                Text(
                  "Here's what's happening with Mahavir Finance today.",
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: const [
                Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text(
                  '01 Sep 2024 - 30 Sep 2024',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top 5 Metric Cards
              _buildTopMetricsRow(),
              const SizedBox(height: 14),

              // 2. 4 Lead Status Highlights
              _buildLeadStatusRow(),
              const SizedBox(height: 16),

              // 3. Two Charts: Monthly Lead Overview & Category Wise Leads
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildMonthlyBarChartCard()),
                  const SizedBox(width: 14),
                  Expanded(flex: 4, child: _buildCategoryBreakdownCard()),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Two Tables: Recent Loan Leads & Top Performing Partners
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildRecentLeadsTable()),
                  const SizedBox(width: 14),
                  Expanded(flex: 4, child: _buildTopPartnersTable()),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Five Main Metric Cards
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(child: _buildMetricCard('Total Customers', '1,248', '+12%', '+132 this month', Icons.people_rounded, const Color(0xFF0284C7), const Color(0xFFE0F2FE))),
        const SizedBox(width: 10),
        Expanded(child: _buildMetricCard('Total Partners', '86', '+8%', '+6 this month', Icons.handshake_rounded, const Color(0xFF16A36A), const Color(0xFFDCFCE7))),
        const SizedBox(width: 10),
        Expanded(child: _buildMetricCard('Total Loan Leads', '524', '+18%', '+80 this month', Icons.description_rounded, const Color(0xFF7C3AED), const Color(0xFFF3E8FF))),
        const SizedBox(width: 10),
        Expanded(child: _buildMetricCard('Total Disbursed', '1.28 Cr', '+22%', '+23.5 L this month', Icons.currency_rupee_rounded, const Color(0xFF0F3E38), const Color(0xFFE6F7F2))),
        const SizedBox(width: 10),
        Expanded(child: _buildMetricCard('Total Commission', '12.8 L', '+15%', 'For 86 partners', Icons.account_balance_wallet_rounded, const Color(0xFFD97706), const Color(0xFFFEF3C7))),
      ],
    );
  }

  Widget _buildMetricCard(String title, String val, String badge, String sub, IconData icon, Color col, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                child: Text(badge, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF16A36A))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: bg, child: Icon(icon, size: 13, color: col)),
              const SizedBox(width: 8),
              Text(val, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 9.5, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Lead Status Breakdown Badges
  Widget _buildLeadStatusRow() {
    return Row(
      children: [
        Expanded(child: _buildStatusPill('Pending Leads', '156', '↑ 20%', const Color(0xFFD97706), const Color(0xFFFEF3C7))),
        const SizedBox(width: 10),
        Expanded(child: _buildStatusPill('Under Review', '84', '↑ 14%', const Color(0xFF0284C7), const Color(0xFFE0F2FE))),
        const SizedBox(width: 10),
        Expanded(child: _buildStatusPill('Approved Leads', '312', '+10%', const Color(0xFF16A36A), const Color(0xFFDCFCE7))),
        const SizedBox(width: 10),
        Expanded(child: _buildStatusPill('Rejected Leads', '56', '↓ 5%', const Color(0xFFDC2626), const Color(0xFFFEE2E2))),
      ],
    );
  }

  Widget _buildStatusPill(String title, String count, String pct, Color col, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: col.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: col)),
              Text(count, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: col)),
            ],
          ),
          Text(pct, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: col)),
        ],
      ),
    );
  }

  // 3. Monthly Bar Chart Card (Jan - Sep)
  Widget _buildMonthlyBarChartCard() {
    final months = [
      {'m': 'Jan', 'val': 45},
      {'m': 'Feb', 'val': 70},
      {'m': 'Mar', 'val': 110},
      {'m': 'Apr', 'val': 95},
      {'m': 'May', 'val': 140},
      {'m': 'Jun', 'val': 120},
      {'m': 'Jul', 'val': 160},
      {'m': 'Aug', 'val': 185},
      {'m': 'Sep', 'val': 210, 'isMax': true},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                  Text('Lead Overview', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  Text('Monthly loan submissions and conversions', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
              Row(
                children: [
                  _buildLegend(const Color(0xFF0F3E38), 'Submitted'),
                  const SizedBox(width: 8),
                  _buildLegend(const Color(0xFF16A36A), 'Approved'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: months.map((m) {
                final height = ((m['val'] as int) / 220) * 110;
                final isMax = m['isMax'] == true;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 18,
                      height: height,
                      decoration: BoxDecoration(
                        color: isMax ? const Color(0xFF0F3E38) : const Color(0xFF16A36A),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(m['m'] as String, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
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
        Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
      ],
    );
  }

  // Category Breakdown
  Widget _buildCategoryBreakdownCard() {
    final categories = [
      {'name': 'Home Loan', 'pct': '28%', 'count': '148', 'color': const Color(0xFF0F3E38)},
      {'name': 'Personal Loan', 'pct': '22%', 'count': '115', 'color': const Color(0xFF16A36A)},
      {'name': 'Car Loan', 'pct': '18%', 'count': '94', 'color': const Color(0xFF0284C7)},
      {'name': 'Business Loan', 'pct': '15%', 'count': '78', 'color': const Color(0xFF7C3AED)},
      {'name': 'Education Loan', 'pct': '10%', 'count': '52', 'color': const Color(0xFFD97706)},
      {'name': 'Other Loans', 'pct': '7%', 'count': '37', 'color': const Color(0xFF94A3B8)},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Loan Category Wise', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('Total 524', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 12),
          ...categories.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: c['color'] as Color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(c['name'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.primary)),
                  ),
                  Text('${c['pct']} (${c['count']})', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 4. Recent Loan Leads Table
  Widget _buildRecentLeadsTable() {
    final leads = [
      {'name': 'Amit Shah', 'type': 'Home Loan', 'amount': '₹25,00,000', 'status': 'Approved', 'statusBg': const Color(0xFFDCFCE7), 'statusCol': const Color(0xFF16A36A), 'date': '12 Sep 2024'},
      {'name': 'Priya Verma', 'type': 'Car Loan', 'amount': '₹8,00,000', 'status': 'Under Review', 'statusBg': const Color(0xFFE0F2FE), 'statusCol': const Color(0xFF0284C7), 'date': '12 Sep 2024'},
      {'name': 'Rohan Mehta', 'type': 'Personal Loan', 'amount': '₹5,00,000', 'status': 'Submitted', 'statusBg': const Color(0xFFFEF3C7), 'statusCol': const Color(0xFFD97706), 'date': '11 Sep 2024'},
      {'name': 'Neha Singh', 'type': 'Education Loan', 'amount': '₹10,00,000', 'status': 'Rejected', 'statusBg': const Color(0xFFFEE2E2), 'statusCol': const Color(0xFFDC2626), 'date': '10 Sep 2024'},
      {'name': 'Suresh Patel', 'type': 'Business Loan', 'amount': '₹15,00,000', 'status': 'Approved', 'statusBg': const Color(0xFFDCFCE7), 'statusCol': const Color(0xFF16A36A), 'date': '10 Sep 2024'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Recent Loan Leads', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('View All >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          ...leads.map((l) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l['name'] as String, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text(l['type'] as String, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(l['amount'] as String, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: l['statusBg'] as Color, borderRadius: BorderRadius.circular(4)),
                    child: Text(l['status'] as String, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: l['statusCol'] as Color)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Top Performing Partners Table
  Widget _buildTopPartnersTable() {
    final partners = [
      {'name': 'Rahul Kumar', 'leads': '48', 'approved': '32', 'comm': '₹2,40,000'},
      {'name': 'Amit Yadav', 'leads': '36', 'approved': '25', 'comm': '₹1,85,000'},
      {'name': 'Sunil Sharma', 'leads': '32', 'approved': '20', 'comm': '₹1,60,000'},
      {'name': 'Pooja Singh', 'leads': '28', 'approved': '18', 'comm': '₹1,25,000'},
      {'name': 'Vikash Singh', 'leads': '24', 'approved': '15', 'comm': '₹1,10,000'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Top Performing Partners', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('View All >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 10),
          ...partners.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                    child: Text((p['name'] as String)[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['name'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('${p['approved']}/${p['leads']} leads approved', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Text(p['comm'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF16A36A))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}