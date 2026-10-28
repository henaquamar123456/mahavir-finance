import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../c_models/loan_product_model.dart';
import 'apply_loan_screen.dart';
import 'loan_inquiry_provider.dart';

class LoanDetailsScreen extends StatefulWidget {
  final LoanProductModel loan;

  const LoanDetailsScreen({
    super.key,
    required this.loan,
  });

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          AssetsConstants.mahavirLogo,
          height: 32,
          errorBuilder: (_, __, ___) => const Text(
            'Mahavir Finance',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.error : AppColors.primary,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroHeader(loan),
                            const SizedBox(height: 14),
                            _buildStatsGrid(loan),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelColor: AppColors.secondary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.secondary,
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Eligibility'),
                            Tab(text: 'Documents'),
                            Tab(text: 'FAQ'),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(loan),
                    _buildEligibilityTab(loan),
                    _buildDocumentsTab(loan),
                    _buildFaqTab(loan),
                  ],
                ),
              ),
            ),
            _buildBottomApplyBar(context, loan),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(LoanProductModel loan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loan.title,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  loan.shortDescription,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBulletPoint('Quick Approval'),
                _buildBulletPoint('Minimal Documentation'),
                _buildBulletPoint('Flexible Repayment'),
                _buildBulletPoint('Competitive Interest Rates'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: loan.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(loan.icon, size: 48, color: loan.iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.secondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(LoanProductModel loan) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildStatCard(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                label: 'Loan Amount',
                value: loan.amountDisplay,
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                icon: Icons.percent_rounded,
                iconColor: AppColors.secondary,
                iconBg: const Color(0xFFDCFCE7),
                label: 'Interest Rate',
                value: loan.interestRateDisplay,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              _buildStatCard(
                icon: Icons.calendar_month_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFEFF6FF),
                label: 'Tenure',
                value: loan.tenureDisplay,
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF7C3AED),
                iconBg: const Color(0xFFF3E8FF),
                label: 'Processing Fee',
                value: '0.5% - 2%',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(LoanProductModel loan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardContainer(
            title: 'About ${loan.title}',
            child: Text(
              'A ${loan.title.toLowerCase()} can help you meet your financial requirements with complete peace of mind. Get quick funds with flexible repayment options through our verified RBI-registered lending partners.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildCardContainer(
            title: 'Key Features & Benefits',
            child: Column(
              children: [
                _buildBenefitRow(
                  icon: Icons.shield_outlined,
                  title: 'No Collateral Required',
                  subtitle: 'Get funds without pledging any security or assets.',
                ),
                _buildBenefitRow(
                  icon: Icons.flash_on_outlined,
                  title: 'Quick Disbursal',
                  subtitle: 'Speedy approval with end-to-end digital processing.',
                ),
                _buildBenefitRow(
                  icon: Icons.tune_rounded,
                  title: 'Flexible Tenure',
                  subtitle: 'Choose repayment tenures that comfortably fit your monthly budget.',
                ),
                _buildBenefitRow(
                  icon: Icons.layers_outlined,
                  title: 'Multiple Use Cases',
                  subtitle: 'Use the funds for any legitimate personal or business need.',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityTab(LoanProductModel loan) {
    final criteria = [
      {'title': 'Age', 'value': '21 - 60 Years', 'icon': Icons.cake_outlined},
      {'title': 'Employment Type', 'value': 'Salaried or Self-Employed', 'icon': Icons.work_outline_rounded},
      {'title': 'Minimum Income', 'value': '₹20,000/month (As per lender)', 'icon': Icons.payments_outlined},
      {'title': 'Credit Score', 'value': '650+ Preferred for best rates', 'icon': Icons.speed_rounded},
      {'title': 'Nationality', 'value': 'Indian Resident', 'icon': Icons.flag_outlined},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildCardContainer(
        title: 'Eligibility Criteria',
        child: Column(
          children: criteria.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(c['icon'] as IconData, size: 18, color: AppColors.secondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['title'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c['value'] as String,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDocumentsTab(LoanProductModel loan) {
    final docs = [
      {
        'title': 'Identity Proof',
        'desc': 'Aadhaar Card, PAN Card, Passport or Voter ID',
        'icon': Icons.badge_outlined,
      },
      {
        'title': 'Address Proof',
        'desc': 'Aadhaar Card, Utility Bill, Driving License, or Rent Agreement',
        'icon': Icons.home_work_outlined,
      },
      {
        'title': 'Income Proof',
        'desc': 'Salary Slips (Last 3 months) or Bank Statement (Last 6 months)',
        'icon': Icons.receipt_long_outlined,
      },
      {
        'title': 'Photographs',
        'desc': 'Recent passport size color photograph',
        'icon': Icons.camera_alt_outlined,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildCardContainer(
        title: 'Required Documents',
        child: Column(
          children: docs.map((d) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(d['icon'] as IconData, size: 18, color: const Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d['title'] as String,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d['desc'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFaqTab(LoanProductModel loan) {
    final faqs = [
      {
        'q': 'How long does approval take?',
        'a': 'Digital verification usually completes within 24 to 48 hours depending on document correctness.',
      },
      {
        'q': 'Are there any prepayment charges?',
        'a': 'Prepayment charges vary by lending partner. Many partners offer zero prepayment penalties after 6 to 12 EMIs.',
      },
      {
        'q': 'Can I apply if I am self-employed?',
        'a': 'Yes, self-employed individuals with minimum 1-year operational business and ITR returns are eligible.',
      },
      {
        'q': 'Is collateral required for this loan?',
        'a': 'No, personal loans and select quick loans are unsecured and do not require pledging any asset.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final item = faqs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: ExpansionTile(
            shape: const Border(),
            title: Text(
              item['q']!,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(
                  item['a']!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardContainer({required String title, required Widget child}) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildBenefitRow({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Fixed Apply Button (Fixed constructor parameter passing)
  Widget _buildBottomApplyBar(BuildContext context, LoanProductModel loan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.8))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => LoanInquiryProvider(initialCategory: loan.title),
                  child: ApplyLoanScreen(initialCategory: loan.title),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}