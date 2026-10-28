import 'package:flutter/material.dart';
import 'package:mahavir_finance/screens/customer-section/loans/loans_screen.dart';
import 'package:provider/provider.dart';
import '../../../c_models/financial_service_model.dart';
import '../../../c_models/loan_product_model.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/asset_constants.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../widgets/customer_drawer.dart'; // <-- Custom Drawer Import
import '../../../widgets/enquire_now_bottom_sheet.dart';
import '../blog/blog_list_screen.dart';
import '../calculator/emi_calculator_screen.dart';
import '../contact/contact_us_screen.dart';
import '../loans/loan_details_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../services/service_details_screen.dart';
import '../services/services_screen.dart';
import 'customer_home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: const _HomeScaffoldView(),
    );
  }
}

class _HomeScaffoldView extends StatelessWidget {
  const _HomeScaffoldView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    final List<Widget> appScreens = [
      const HomeMainContent(),
      const LoansScreen(),
      const EmiCalculatorScreen(),
      const ServicesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.iconPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset(
          AssetsConstants.mahavirLogo,
          height: 35,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.trending_up,
            color: AppColors.secondary,
            size: 28,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Stack(
              children: [
                Icon(Icons.notifications_outlined, color: AppColors.iconPrimary),
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () => provider.setBottomNavIndex(4),
              borderRadius: BorderRadius.circular(18),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFE2E8F0),
                child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),

      // Single Clean Line Drawer Binding
      drawer: const CustomerDrawer(),

      body: appScreens[provider.currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: provider.currentIndex,
        onDestinationSelected: (index) {
          provider.setBottomNavIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.secondary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: AppColors.secondary),
            label: 'Loans',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate, color: AppColors.secondary),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.miscellaneous_services_outlined),
            selectedIcon: Icon(Icons.miscellaneous_services, color: AppColors.secondary),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.secondary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeMainContent extends StatelessWidget {
  const HomeMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPromoBanner(context, provider),
          const SizedBox(height: 20),
          _buildTopServicesRow(context),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loan Categories',
                style: AppTextStyles.headingMedium,
              ),
              InkWell(
                onTap: () => provider.setBottomNavIndex(1),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: AppTextStyles.link.copyWith(
                          color: AppColors.secondary,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.secondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLoanCategoriesGrid(context, provider),
          const SizedBox(height: 20),
          _buildEmiCalculatorCard(provider),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Lending Partners',
                style: AppTextStyles.headingMedium,
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: AppTextStyles.link.copyWith(
                          color: AppColors.secondary,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.secondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLendingPartnersGrid(),
          const SizedBox(height: 24),
          Text(
            'Why Choose Mahavir Finance?',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 12),
          _buildWhyChooseUsGrid(),
          const SizedBox(height: 24),
          Text(
            'Quick Links',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 12),
          _buildQuickLinks(context, provider),
          const SizedBox(height: 20),
          _buildGuidanceCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, HomeProvider provider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.headingLarge.copyWith(fontSize: 24, height: 1.15),
                    children: const [
                      TextSpan(text: 'Build Your\n'),
                      TextSpan(
                        text: 'Financial Future\nWith Confidence.',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    'Get the right loan solutions with expert guidance and trusted financial services.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    EnquireNowBottomSheet.show(context, initialService: 'Financial Consulting');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    minimumSize: const Size(150, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Get Consultation', style: AppTextStyles.button.copyWith(fontSize: 13, color: Colors.white)),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    bool isActive = provider.currentBannerIndex == index;
                    return GestureDetector(
                      onTap: () => provider.setBannerIndex(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.secondary : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
              child: Image.asset(
                AssetsConstants.splashIllustration,
                height: 145,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopServicesRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildServiceCard(
            context,
            'Financial\nConsulting',
            'Expert advice for a secure future',
            Icons.psychology_alt_outlined,
            AppColors.successBackground,
            AppColors.secondary,
            'Financial Consulting',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildServiceCard(
            context,
            'Investment\nPlanning',
            'Plan today for better tomorrow',
            Icons.trending_up_rounded,
            AppColors.infoBackground,
            AppColors.info,
            'Investment Planning',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildServiceCard(
            context,
            'Financial\nGuidance',
            'Personalized financial solutions',
            Icons.handshake_outlined,
            AppColors.successBackground,
            AppColors.secondary,
            'Financial Guidance',
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color bgColor,
      Color iconColor,
      String serviceKey,
      ) {
    return InkWell(
      onTap: () {
        final matched = FinancialServiceModel.sampleServices.firstWhere(
              (s) => s.title.toLowerCase().contains(serviceKey.toLowerCase()),
          orElse: () => FinancialServiceModel.sampleServices.first,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailsScreen(service: matched),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: bgColor,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelLarge.copyWith(fontSize: 12, height: 1.2),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 9.5,
                height: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCategoriesGrid(BuildContext context, HomeProvider provider) {
    return GridView.builder(
      itemCount: provider.loanCategories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.76,
      ),
      itemBuilder: (context, index) {
        final cat = provider.loanCategories[index];
        final String rawTitle = cat['title'].toString();
        final String cleanTitle = rawTitle.replaceAll('\n', ' ').trim();

        return InkWell(
          onTap: () {
            final matchedLoan = LoanProductModel.sampleLoans.firstWhere(
                  (loan) =>
              loan.title.toLowerCase().contains(cleanTitle.toLowerCase()) ||
                  cleanTitle.toLowerCase().contains(loan.title.toLowerCase()),
              orElse: () => LoanProductModel.sampleLoans.first,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoanDetailsScreen(loan: matchedLoan),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cat['color'],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Center(
                    child: Icon(cat['icon'], color: cat['iconColor'], size: 24),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cat['title'],
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: 10.5,
                  height: 1.15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmiCalculatorCard(HomeProvider provider) {
    return InkWell(
      onTap: () => provider.setBottomNavIndex(2),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.successBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA7F3D0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calculate_outlined, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculate Your EMI',
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Plan your loan with our easy EMI calculator',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.secondary,
              child: Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLendingPartnersGrid() {
    final partners = [
      {'name': 'SBI', 'color': const Color(0xFF1E3A8A)},
      {'name': 'HDFC BANK', 'color': const Color(0xFF004C8F)},
      {'name': 'ICICI Bank', 'color': const Color(0xFFB91C1C)},
      {'name': 'AXIS BANK', 'color': const Color(0xFF831843)},
      {'name': 'KOTAK', 'color': const Color(0xFFDC2626)},
      {'name': 'BAJAJ FINSERV', 'color': const Color(0xFF0284C7)},
      {'name': 'TATA CAPITAL', 'color': const Color(0xFF1E293B)},
      {'name': 'ADITYA BIRLA', 'color': const Color(0xFF991B1B)},
      {'name': 'SHRIRAM', 'color': const Color(0xFFD97706)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: partners.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final p = partners[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            p['name'] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: p['color'] as Color,
              letterSpacing: 0.3,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWhyChooseUsGrid() {
    final features = [
      {
        'title': 'Trusted Partners',
        'desc': 'Tie-ups with top lending institutions',
        'icon': Icons.handshake_outlined,
      },
      {
        'title': 'Experienced Team',
        'desc': 'Expert guidance at every step',
        'icon': Icons.groups_outlined,
      },
      {
        'title': 'Quick Process',
        'desc': 'Hassle-free loan application',
        'icon': Icons.bolt_rounded,
      },
      {
        'title': 'Dedicated Support',
        'desc': 'Personalized customer assistance',
        'icon': Icons.support_agent_rounded,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final f = features[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(f['icon'] as IconData, size: 22, color: AppColors.secondary),
              const SizedBox(height: 6),
              Text(
                f['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                f['desc'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textSecondary,
                  height: 1.25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickLinks(BuildContext context, HomeProvider provider) {
    final links = [
      {'title': 'Apply for Loan', 'icon': Icons.assignment_outlined, 'tab': 1},
      {'title': 'EMI Calculator', 'icon': Icons.calculate_outlined, 'tab': 2},
      {'title': 'Contact Us', 'icon': Icons.call_outlined, 'tab': null},
      {'title': 'Financial Blog', 'icon': Icons.article_outlined, 'tab': null},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: links.map((link) {
        return InkWell(
          onTap: () {
            if (link['tab'] != null) {
              provider.setBottomNavIndex(link['tab'] as int);
            } else if (link['title'] == 'Contact Us') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactUsScreen()),
              );
            } else if (link['title'] == 'Financial Blog') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlogListScreen()),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(link['icon'] as IconData, size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Text(
                  link['title'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGuidanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need Expert Guidance?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Talk to our financial experts and find the best loan solution for you.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                EnquireNowBottomSheet.show(context, initialService: 'Financial Consulting');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Free Consultation',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}