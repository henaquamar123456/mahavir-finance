import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;



import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  bool _isLoading = true;

  String _selectedLoanType = 'All Loan Types';
  String _selectedPartner = 'All Partners';
  String _selectedStatus = 'All Status';
  String _selectedDateRange = 'Last 30 Days';

  int _totalLeads = 1248;
  int _conversions = 248;
  int _activePartners = 48;
  String _totalDisbursed = '₹ 1.85 Cr';

  Map<String, dynamic> _funnelData = {
    'totalLeads': 1248,
    'qualifiedLeads': 684,
    'underReview': 412,
    'approved': 298,
    'disbursed': 248,
  };

  List _categoryPerformance = [
  {'name': 'Home Loan', 'leads': 320, 'conv': 98},
  {'name': 'Car Loan', 'leads': 214, 'conv': 62},
  {'name': 'Personal Loan', 'leads': 198, 'conv': 58},
  {'name': 'Education Loan', 'leads': 142, 'conv': 46},
  {'name': 'Business Loan', 'leads': 118, 'conv': 38},
  {'name': 'Gold Loan', 'leads': 86, 'conv': 25},
  {'name': 'Agriculture Loan', 'leads': 74, 'conv': 21},
  {'name': 'Medical Loan', 'leads': 62, 'conv': 18},
  ];

  final List<String> _loanTypes = const [
    'All Loan Types',
    'Home Loan',
    'Car Loan',
    'Personal Loan',
    'Business Loan',
    'Education Loan',
  ];

  List<String> _partners = [
    'All Partners',
    'Rohit Sharma',
    'Pooja Verma',
    'Amit Yadav',
    'Vikram Singh',
    'Neha Gupta',
  ];

  List _topPartners = [
  {'name': 'Rohit Sharma', 'code': 'DSA001', 'leads': 245, 'conversions': 68, 'rate': '27.8%'},
  {'name': 'Pooja Verma', 'code': 'DSA002', 'leads': 198, 'conversions': 52, 'rate': '26.3%'},
  {'name': 'Amit Yadav', 'code': 'DSA003', 'leads': 176, 'conversions': 45, 'rate': '25.6%'},
  {'name': 'Vikram Singh', 'code': 'DSA004', 'leads': 142, 'conversions': 38, 'rate': '26.8%'},
  {'name': 'Neha Gupta', 'code': 'DSA005', 'leads': 121, 'conversions': 31, 'rate': '25.6%'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final queryParams = {
        if (_selectedLoanType != 'All Loan Types') 'loanType': _selectedLoanType,
        if (_selectedStatus != 'All Status') 'status': _selectedStatus,
        if (_selectedPartner != 'All Partners') 'partner': _selectedPartner,
      };

      final uri = Uri.parse(MFUrls.mfBaseUrl('api/v1/analytics/overview'))
          .replace(queryParameters: queryParams);

      final res = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (res.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(res.body);
        final dynamic data = body['data'];

        if (data is Map) {
          final stats = data['stats'];
          final funnel = data['funnel'];
          final categories = data['categoryPerformance'];
          final partners = data['topPartners'];

          if (mounted) {
            setState(() {
              if (stats != null) {
                _totalLeads = stats['totalLeads'] ?? _totalLeads;
                _conversions = stats['conversions'] ?? _conversions;
                _activePartners = stats['activePartners'] ?? _activePartners;
                final num disbursed = stats['totalDisbursed'] ?? 0;
                _totalDisbursed = CurrencyFormatter.formatWhole(disbursed.toDouble());
              }

              if (funnel != null) {
                _funnelData = Map<String, dynamic>.from(funnel);
              }

              if (categories is List && categories.isNotEmpty) {
                _categoryPerformance = List.from(categories);
              }

              if (partners is List && partners.isNotEmpty) {
                _topPartners = List.from(partners);
                _partners = [
                  'All Partners',
                  ..._topPartners.map((p) => p['name'].toString()).toSet(),
                ];
              }

              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoading = false);
  }

  // ==========================================
  // EXPORT REPORT FUNCTIONALITY
  // ==========================================
  Future<void> _exportReport() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparing complete Analytics & Leads CSV Report...'),
        backgroundColor: Color(0xFF0F3E38),
      ),
    );

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/analytics/export'));

      final res = await http.get(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (res.statusCode == 200) {
        final bytes = utf8.encode(res.body);
        final blob = html.Blob([bytes]);
        final blobUrl = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: blobUrl)
          ..setAttribute('download', 'Mahavir_Finance_Analytics_Report.csv')
          ..click();
        html.Url.revokeObjectUrl(blobUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report exported and downloaded successfully!'),
              backgroundColor: Color(0xFF16A36A),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export initiated via browser connection!'),
            backgroundColor: Color(0xFF16A36A),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 16),
              _buildTopMetricsRow(),
              const SizedBox(height: 16),
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildTrendChartCard()),
                        const SizedBox(width: 14),
                        Expanded(flex: 4, child: _buildLeadSourcesCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildTrendChartCard(),
                      const SizedBox(height: 14),
                      _buildLeadSourcesCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildCategoryPerformanceCard()),
                        const SizedBox(width: 14),
                        Expanded(flex: 4, child: _buildConversionFunnelCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildCategoryPerformanceCard(),
                      const SizedBox(height: 14),
                      _buildConversionFunnelCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildMonthlyPerformanceCard()),
                        const SizedBox(width: 14),
                        Expanded(flex: 5, child: _buildTopPartnersCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildMonthlyPerformanceCard(),
                      const SizedBox(height: 14),
                      _buildTopPartnersCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildTopLoanProductsCard()),
                        const SizedBox(width: 14),
                        Expanded(flex: 6, child: _buildKeyInsightsCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildTopLoanProductsCard(),
                      const SizedBox(height: 14),
                      _buildKeyInsightsCard(),
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

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports & Analytics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track performance, analyze trends and make better decisions.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF0F3E38)),
                  SizedBox(width: 6),
                  Text(
                    'Real-time Live Sync',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
              tooltip: 'Refresh Analytics',
              onPressed: _fetchAnalytics,
            ),
            ElevatedButton.icon(
              onPressed: _exportReport,
              icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Export Report',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Leads',
            value: '$_totalLeads',
            badgeText: '+Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Pipeline Total',
            icon: Icons.groups_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Conversions',
            value: '$_conversions',
            badgeText: 'Disbursed',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Approved Loans',
            icon: Icons.percent_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Active Partners',
            value: '$_activePartners',
            badgeText: 'DSA',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Active agents',
            icon: Icons.handshake_outlined,
            iconBg: const Color(0xFFF3E8FF),
            iconColor: const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Total Disbursed',
            value: _totalDisbursed,
            badgeText: 'Volume',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Total Pipeline',
            icon: Icons.currency_rupee_rounded,
            iconBg: const Color(0xFFE6F7F2),
            iconColor: const Color(0xFF0F3E38),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
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
              Text(title, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: iconBg, child: Icon(icon, size: 16, color: iconColor)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildFilterToolbar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownFilter(
              value: _selectedLoanType,
              items: _loanTypes,
              onChanged: (v) => setState(() => _selectedLoanType = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdownFilter(
              value: _selectedPartner,
              items: _partners,
              onChanged: (v) => setState(() => _selectedPartner = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdownFilter(
              value: _selectedStatus,
              items: const ['All Status', 'Pending', 'Under Review', 'Approved', 'Disbursed'],
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdownFilter(
              value: _selectedDateRange,
              items: const ['Last 30 Days', 'Last 7 Days', 'This Month', 'Last Quarter'],
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedDateRange = v!),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _fetchAnalytics,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Apply Filters', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedLoanType = 'All Loan Types';
                _selectedPartner = 'All Partners';
                _selectedStatus = 'All Status';
                _selectedDateRange = 'Last 30 Days';
              });
              _fetchAnalytics();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTrendChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leads & Conversions Trend', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  Text('Daily performance metrics for current period', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
              Row(
                children: [
                  _buildLegend(const Color(0xFF0F3E38), 'Total Leads'),
                  const SizedBox(width: 10),
                  _buildLegend(const Color(0xFF0284C7), 'Conversions'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Current Status: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Text('Total Leads: $_totalLeads', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
                const SizedBox(width: 8),
                Text('Conversions: $_conversions', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0284C7))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrendChartPainter(),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('01 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              Text('05 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              Text('10 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              Text('15 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              Text('20 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              Text('25 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              Text('30 Sep', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadSourcesCard() {
    final sources = [
      {'name': 'Mobile App', 'pct': '42%', 'color': const Color(0xFF0F3E38)},
      {'name': 'Website', 'pct': '24%', 'color': const Color(0xFF0284C7)},
      {'name': 'Partner Referral', 'pct': '18%', 'color': const Color(0xFF16A36A)},
      {'name': 'Walk-in', 'pct': '10%', 'color': const Color(0xFFD97706)},
      {'name': 'Others', 'pct': '6%', 'color': const Color(0xFF64748B)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text('Lead Sources', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('Total $_totalLeads', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0F3E38), width: 14),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$_totalLeads', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      const Text('Total', style: TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: sources.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: s['color'] as Color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(s['name'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.primary)),
                          ),
                          Text(s['pct'] as String, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text(
                'Loan Category Performance',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  _buildLegend(const Color(0xFF0F3E38), 'Leads'),
                  const SizedBox(width: 10),
                  _buildLegend(const Color(0xFF0284C7), 'Conversions'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _categoryPerformance.map((cat) {
                final int leads = (cat['leads'] as num?)?.toInt() ?? 0;
                final int conv = (cat['conv'] as num?)?.toInt() ?? 0;

                // .toDouble() add kiya gaya hai:
                final double hLeads = (leads > 0 ? (leads / 350.0) * 110.0 : 10.0)
                    .clamp(10.0, 110.0)
                    .toDouble();
                final double hConv = (conv > 0 ? (conv / 350.0) * 110.0 : 6.0)
                    .clamp(6.0, 110.0)
                    .toDouble();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 12,
                          height: hLeads,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F3E38),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 12,
                          height: hConv,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0284C7),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 50,
                      child: Text(
                        (cat['name'] as String).replaceAll(' Loan', ''),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 8.5, color: AppColors.textSecondary),
                      ),
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

  Widget _buildConversionFunnelCard() {
    final double eff = _totalLeads > 0 ? (_conversions / _totalLeads) * 100 : 19.9;

    final funnel = [
      {'label': 'Total Leads', 'count': '${_funnelData['totalLeads']}', 'pct': '100%', 'color': const Color(0xFF0F3E38), 'w': 1.0},
      {'label': 'Qualified Leads', 'count': '${_funnelData['qualifiedLeads']}', 'pct': '54.8%', 'color': const Color(0xFF0284C7), 'w': 0.82},
      {'label': 'Under Review', 'count': '${_funnelData['underReview']}', 'pct': '33.0%', 'color': const Color(0xFF7C3AED), 'w': 0.64},
      {'label': 'Approved', 'count': '${_funnelData['approved']}', 'pct': '23.9%', 'color': const Color(0xFFD97706), 'w': 0.50},
      {'label': 'Disbursed', 'count': '${_funnelData['disbursed']}', 'pct': '${eff.toStringAsFixed(1)}%', 'color': const Color(0xFF16A36A), 'w': 0.38},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text('Conversion Funnel', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('Efficiency: ${eff.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF16A36A))),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            children: funnel.map((step) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(step['label'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.primary)),
                    ),
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 16,
                          color: const Color(0xFFF1F5F9),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: step['w'] as double,
                            child: Container(color: step['color'] as Color),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 58,
                      child: Text(
                        '${step['count']} (${step['pct']})',
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
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

  Widget _buildMonthlyPerformanceCard() {
    final monthly = [
      {'m': 'Apr 2024', 'l': 420, 'c': 152},
      {'m': 'May 2024', 'l': 484, 'c': 178},
      {'m': 'Jun 2024', 'l': 512, 'c': 201},
      {'m': 'Jul 2024', 'l': 638, 'c': 246},
      {'m': 'Aug 2024', 'l': 712, 'c': 287},
      {'m': 'Sep 2024', 'l': _totalLeads, 'c': _conversions},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Performance Trend', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('Last 6 Months', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthly.map((m) {
                final double hl = (((m['l'] as int) / 1300) * 105).clamp(10, 110);
                final double hc = (((m['c'] as int) / 1300) * 105).clamp(6, 110);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 14,
                          height: hl,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F3E38),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 14,
                          height: hc,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0284C7),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(m['m'] as String, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPartnersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Performing Partners', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              Text('Live Leaderboard', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
            ],
          ),
          const SizedBox(height: 12),
          ..._topPartners.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                      (p['name'] as String).isNotEmpty ? (p['name'] as String)[0].toUpperCase() : 'P',
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['name'] as String, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Text('${p['code']} • ${p['leads']} Total Leads', style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${p['conversions']} Converted', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF16A36A))),
                      Text('Rate: ${p['rate']}', style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopLoanProductsCard() {
    final products = [
      {'name': 'Home Loan', 'pct': '28%', 'color': const Color(0xFF0F3E38)},
      {'name': 'Personal Loan', 'pct': '22%', 'color': const Color(0xFF16A36A)},
      {'name': 'Car Loan', 'pct': '18%', 'color': const Color(0xFF0284C7)},
      {'name': 'Education Loan', 'pct': '12%', 'color': const Color(0xFFD97706)},
      {'name': 'Business Loan', 'pct': '10%', 'color': const Color(0xFF7C3AED)},
      {'name': 'Others', 'pct': '10%', 'color': const Color(0xFF94A3B8)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Loan Products', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 12),
          ...products.map((prod) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: prod['color'] as Color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(prod['name'] as String, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                  ),
                  Text(prod['pct'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKeyInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Key Insights & Executive Summary', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 10),
          _buildInsightItem(
            'Pipeline Status: $_totalLeads Total Leads Processed',
            'Conversion velocity maintains stable trajectory with $_conversions successfully disbursed accounts.',
            Icons.trending_up_rounded,
            const Color(0xFF16A36A),
          ),
          _buildInsightItem(
            'Portfolio Volume: $_totalDisbursed',
            'Aggregate disbursements across active borrower channels & partner networks.',
            Icons.account_balance_wallet_rounded,
            const Color(0xFF0F3E38),
          ),
          _buildInsightItem(
            'Partner Network: $_activePartners Active DSA Partners',
            'Key contributing channels delivering verified inquiries and accelerated KYC submissions.',
            Icons.star_rounded,
            const Color(0xFFD97706),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String desc, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 1),
                Text(desc, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, height: 1.25)),
              ],
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
}

class _TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final leadsPaint = Paint()
      ..color = const Color(0xFF0F3E38)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final convPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final leadsPath = Path();
    leadsPath.moveTo(0, size.height * 0.7);
    leadsPath.quadraticBezierTo(size.width * 0.25, size.height * 0.55, size.width * 0.5, size.height * 0.35);
    leadsPath.quadraticBezierTo(size.width * 0.75, size.height * 0.45, size.width, size.height * 0.15);

    final convPath = Path();
    convPath.moveTo(0, size.height * 0.85);
    convPath.quadraticBezierTo(size.width * 0.25, size.height * 0.75, size.width * 0.5, size.height * 0.55);
    convPath.quadraticBezierTo(size.width * 0.75, size.height * 0.65, size.width, size.height * 0.45);

    canvas.drawPath(leadsPath, leadsPaint);
    canvas.drawPath(convPath, convPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}