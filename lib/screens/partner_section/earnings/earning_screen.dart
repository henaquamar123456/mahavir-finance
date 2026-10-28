import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _selectedPeriod = 'This Month';

  final List<String> _periods = [
    'This Month',
    'Last 3 Months',
    'Last 6 Months',
    'This Year',
    'All Time',
  ];

  final List<Map<String, dynamic>> _categoryBreakdown = [
    {
      'title': 'Personal Loan',
      'amount': 24500.0,
      'leads': 12,
      'color': const Color(0xFF16A36A),
      'icon': Icons.person_outline_rounded,
    },
    {
      'title': 'Home Loan',
      'amount': 38200.0,
      'leads': 8,
      'color': const Color(0xFF0284C7),
      'icon': Icons.home_outlined,
    },
    {
      'title': 'Car Loan',
      'amount': 32600.0,
      'leads': 10,
      'color': const Color(0xFFDC2626),
      'icon': Icons.directions_car_outlined,
    },
    {
      'title': 'Business Loan',
      'amount': 30300.0,
      'leads': 6,
      'color': const Color(0xFF7C3AED),
      'icon': Icons.business_center_outlined,
    },
  ];

  final List<Map<String, dynamic>> _recentPayments = [
    {
      'title': 'Commission Payout',
      'desc': 'Bank Transfer • 15 Sep 2024',
      'amount': 25000.0,
      'status': 'Paid',
      'isPaid': true,
      'icon': Icons.account_balance_outlined,
    },
    {
      'title': 'Pending Commission',
      'desc': 'For 5 Approved Leads',
      'amount': 18400.0,
      'status': 'Pending',
      'isPaid': false,
      'icon': Icons.hourglass_top_rounded,
    },
    {
      'title': 'Commission Payout',
      'desc': 'Bank Transfer • 02 Sep 2024',
      'amount': 32000.0,
      'status': 'Paid',
      'isPaid': true,
      'icon': Icons.account_balance_outlined,
    },
    {
      'title': 'Pending Commission',
      'desc': 'For 3 Approved Leads',
      'amount': 17000.0,
      'status': 'Pending',
      'isPaid': false,
      'icon': Icons.hourglass_top_rounded,
    },
    {
      'title': 'Commission Payout',
      'desc': 'Bank Transfer • 18 Aug 2024',
      'amount': 33200.0,
      'status': 'Paid',
      'isPaid': true,
      'icon': Icons.account_balance_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              Text(
                'Earnings & Commission',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Track your earnings, pending commission and payment history.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // 1. 3 Top Summary Metrics Strip
              _buildTopSummaryCards(),
              const SizedBox(height: 16),

              // 2. Period Filter Chips
              _buildPeriodChips(),
              const SizedBox(height: 16),

              // 3. Earnings Overview Bar Chart Card
              _buildChartCard(),
              const SizedBox(height: 20),

              // 4. Commission Breakdown Section
              _buildSectionHeader('Commission Breakdown', onViewAll: () {}),
              const SizedBox(height: 10),
              _buildCommissionBreakdownGrid(),
              const SizedBox(height: 20),

              // 5. Recent Commission Payments Section
              _buildSectionHeader('Recent Commission Payments', onViewAll: () {}),
              const SizedBox(height: 10),
              ..._recentPayments.map((payment) => _buildPaymentItemCard(payment)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Summary Cards (Total, Pending, Paid)
  Widget _buildTopSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Earnings',
            amount: '₹ 1,25,600',
            subtitle: 'All time earnings',
            icon: Icons.account_balance_wallet_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Commission',
            amount: '₹ 35,400',
            subtitle: 'Yet to be paid',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: 'Paid Commission',
            amount: '₹ 90,200',
            subtitle: 'Already received',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String amount,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  // 2. Period Filter Chips
  Widget _buildPeriodChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedPeriod = period),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0F3E38) : AppColors.border,
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 3. Earnings Overview Bar Chart
  Widget _buildChartCard() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
    final heights = [
      {'earned': 0.20, 'pending': 0.05, 'paid': 0.05},
      {'earned': 0.15, 'pending': 0.08, 'paid': 0.15},
      {'earned': 0.25, 'pending': 0.10, 'paid': 0.18},
      {'earned': 0.18, 'pending': 0.06, 'paid': 0.14},
      {'earned': 0.35, 'pending': 0.12, 'paid': 0.20},
      {'earned': 0.28, 'pending': 0.08, 'paid': 0.16},
      {'earned': 0.38, 'pending': 0.10, 'paid': 0.20},
      {'earned': 0.48, 'pending': 0.15, 'paid': 0.22},
      {'earned': 0.25, 'pending': 0.15, 'paid': 0.18},
      {'earned': 0.58, 'pending': 0.16, 'paid': 0.20},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
                'Earnings Overview',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              // Legend
              Row(
                children: [
                  _buildLegendItem('Earned', const Color(0xFF16A36A)),
                  const SizedBox(width: 8),
                  _buildLegendItem('Pending', const Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  _buildLegendItem('Paid', const Color(0xFF0284C7)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart Display Area
          SizedBox(
            height: 170,
            child: Row(
              children: [
                // Y-Axis Labels
                const SizedBox(
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('80K', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                      Text('60K', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                      Text('40K', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                      Text('20K', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                      Text('0', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // Bars with Grid Lines
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                              (_) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(months.length, (index) {
                          final h = heights[index];
                          final isHighest = index == months.length - 1;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isHighest)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F3E38),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '₹62,400',
                                    style: TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox(
                                  width: 14,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 110 * (h['paid'] as double),
                                        color: const Color(0xFF0284C7),
                                      ),
                                      Container(
                                        height: 110 * (h['pending'] as double),
                                        color: const Color(0xFFF59E0B),
                                      ),
                                      Container(
                                        height: 110 * (h['earned'] as double),
                                        color: const Color(0xFF16A36A),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                months[index],
                                style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  // 4. Commission Breakdown 4 Cards
  Widget _buildCommissionBreakdownGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categoryBreakdown.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.85,
      ),
      itemBuilder: (context, index) {
        final cat = _categoryBreakdown[index];
        final Color col = cat['color'] as Color;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: col.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(cat['icon'] as IconData, size: 20, color: col),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      CurrencyFormatter.formatWhole(cat['amount'] as double),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    Text(
                      '${cat['leads']} Leads',
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. Recent Payments List
  Widget _buildPaymentItemCard(Map<String, dynamic> payment) {
    final bool isPaid = payment['isPaid'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              payment['icon'] as IconData,
              color: isPaid ? const Color(0xFF16A36A) : const Color(0xFFD97706),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['title'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  payment['desc'] as String,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatWhole(payment['amount'] as double),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  payment['status'] as String,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isPaid ? const Color(0xFF16A36A) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.iconSecondary),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        InkWell(
          onTap: onViewAll,
          child: const Text(
            'View All >',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
          ),
        ),
      ],
    );
  }
}