import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;

  int _totalCustomers = 0;
  int _totalPartners = 0;
  int _totalLeads = 0;
  int _pendingLeads = 0;
  int _underReviewLeads = 0;
  int _approvedLeads = 0;
  int _rejectedLeads = 0;
  double _totalDisbursed = 0.0;
  double _totalCommission = 0.0;

  List _recentLeads = [];
  List _topPartners = [];
  List _categoryBreakdown = [];
  List _monthlyOverview = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  Future<void> _loadDashboardStats() async {
    setState(() => _isLoading = true);
    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/dashboard-stats'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'] ?? {};
        if (mounted) {
          setState(() {
            _totalCustomers = data['totalCustomers'] ?? 0;
            _totalPartners = data['totalPartners'] ?? 0;
            _totalLeads = data['totalLeads'] ?? 0;
            _pendingLeads = data['pendingLeads'] ?? 0;
            _underReviewLeads = data['underReviewLeads'] ?? 0;
            _approvedLeads = data['approvedLeads'] ?? 0;
            _rejectedLeads = data['rejectedLeads'] ?? 0;
            _totalDisbursed = (data['totalDisbursed'] as num?)?.toDouble() ?? 0.0;
            _totalCommission = (data['totalCommission'] as num?)?.toDouble() ?? (_totalDisbursed * 0.015);

            _recentLeads = (data['recentLeads'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
                [];

            _topPartners = (data['topPartners'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
                [];

            _categoryBreakdown = (data['categoryBreakdown'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
                [];

            _monthlyOverview = (data['monthlyOverview'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
                [];

            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back, Admin!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            Text(
              "Here's what's happening with Mahavir Finance today.",
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
            tooltip: 'Refresh Dashboard',
            onPressed: _loadDashboardStats,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top 4 Metric Cards
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

  // 1. Metric Cards
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Customers',
            '$_totalCustomers',
            '+Active',
            'Registered Borrowers',
            Icons.people_rounded,
            const Color(0xFF0284C7),
            const Color(0xFFE0F2FE),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            'Total Partners',
            '$_totalPartners',
            'DSA',
            'Active Agents',
            Icons.handshake_rounded,
            const Color(0xFF16A36A),
            const Color(0xFFDCFCE7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            'Total Loan Leads',
            '$_totalLeads',
            'Pipeline',
            'Applications',
            Icons.description_rounded,
            const Color(0xFF7C3AED),
            const Color(0xFFF3E8FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            'Total Disbursed',
            CurrencyFormatter.formatWhole(_totalDisbursed),
            'Volume',
            'Disbursed loans',
            Icons.currency_rupee_rounded,
            const Color(0xFF0F3E38),
            const Color(0xFFE6F7F2),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title,
      String val,
      String badge,
      String sub,
      IconData icon,
      Color col,
      Color bg,
      ) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16A36A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: bg, child: Icon(icon, size: 13, color: col)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  val,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 9.5, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Status Row
  Widget _buildLeadStatusRow() {
    return Row(
      children: [
        Expanded(child: _buildStatusPill('Pending Leads', '$_pendingLeads', 'Pipeline', const Color(0xFFD97706), const Color(0xFFFEF3C7))),
        const SizedBox(width: 10),
        Expanded(child: _buildStatusPill('Under Review', '$_underReviewLeads', 'Reviewing', const Color(0xFF0284C7), const Color(0xFFE0F2FE))),
        const SizedBox(width: 10),
        Expanded(child: _buildStatusPill('Approved Leads', '$_approvedLeads', 'Approved', const Color(0xFF16A36A), const Color(0xFFDCFCE7))),
        const SizedBox(width: 10),
        Expanded(child: _buildStatusPill('Rejected Leads', '$_rejectedLeads', 'Declined', const Color(0xFFDC2626), const Color(0xFFFEE2E2))),
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

  // 3. Dynamic Monthly Bar Chart
  Widget _buildMonthlyBarChartCard() {
    final list = _monthlyOverview.isNotEmpty
        ? _monthlyOverview
        : [
      {'m': 'Jan', 'val': 0},
      {'m': 'Feb', 'val': 0},
      {'m': 'Mar', 'val': 0},
      {'m': 'Apr', 'val': 0},
      {'m': 'May', 'val': 0},
      {'m': 'Jun', 'val': 0},
    ];

    int maxVal = 1;
    for (var item in list) {
      final v = (item['val'] as num?)?.toInt() ?? 0;
      if (v > maxVal) maxVal = v;
    }

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
          const Text(
            'Lead Submissions Overview',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: list.map((m) {
                final val = (m['val'] as num?)?.toDouble() ?? 0.0;
                final barHeight = (val / maxVal) * 105.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 18,
                      height: barHeight > 6 ? barHeight : 6,
                      decoration: BoxDecoration(
                        color: val == maxVal && val > 0
                            ? const Color(0xFF0F3E38)
                            : const Color(0xFF16A36A),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      m['m'].toString(),
                      style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Dynamic Category Breakdown
  Widget _buildCategoryBreakdownCard() {
    final categories = _categoryBreakdown.isNotEmpty
        ? _categoryBreakdown
        : [
      {'name': 'Home Loan', 'pct': '0%', 'color': '#0F3E38'},
      {'name': 'Personal Loan', 'pct': '0%', 'color': '#16A36A'},
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
              const Text(
                'Top Loan Categories',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              Text(
                'Total $_totalLeads',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...categories.map((c) {
            Color dotColor = const Color(0xFF0F3E38);
            if (c['color'] != null) {
              final hex = c['color'].toString().replaceAll('#', '');
              dotColor = Color(int.parse('FF$hex', radix: 16));
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: dotColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c['name'].toString(),
                      style: const TextStyle(fontSize: 11, color: AppColors.primary),
                    ),
                  ),
                  Text(
                    '${c['pct']} (${c['count'] ?? 0})',
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 5. Dynamic Recent Leads Table
  Widget _buildRecentLeadsTable() {
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
          const Text(
            'Recent Loan Leads Queue',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          if (_recentLeads.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No loan applications submitted yet.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ),
            )
          else
            ..._recentLeads.map((l) {
              final String status = l['status']?.toString() ?? 'Under Review';
              final isApproved = status.toLowerCase() == 'approved' || status.toLowerCase() == 'disbursed';
              final isRejected = status.toLowerCase() == 'rejected';

              Color statusBg = const Color(0xFFE0F2FE);
              Color statusCol = const Color(0xFF0284C7);
              if (isApproved) {
                statusBg = const Color(0xFFDCFCE7);
                statusCol = const Color(0xFF16A36A);
              } else if (isRejected) {
                statusBg = const Color(0xFFFEE2E2);
                statusCol = const Color(0xFFDC2626);
              }

              final amt = (l['amount'] as num?)?.toDouble() ?? 0.0;

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
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l['name']?.toString() ?? 'Borrower',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          Text(
                            '${l['type']} • ${l['date']}',
                            style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        CurrencyFormatter.formatWhole(amt),
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: statusCol),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // 6. Dynamic Top Partners Table
  Widget _buildTopPartnersTable() {
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
          const Text(
            'Top Performing Partners',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          if (_topPartners.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No partners registered yet.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ),
            )
          else
            ..._topPartners.map((p) {
              final name = p['name']?.toString() ?? 'Partner';
              final comm = (p['comm'] as num?)?.toDouble() ?? 0.0;

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
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'P',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          Text(
                            '${p['approved']}/${p['leads']} leads approved',
                            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatWhole(comm),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF16A36A)),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}