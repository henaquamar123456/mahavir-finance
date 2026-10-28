import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../contact/contact_us_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Mahavir Finance',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Your trusted financial partner for loans, advisory, and wealth solutions.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Company Story & Heritage Card
              _buildStoryCard(),
              const SizedBox(height: 16),

              // 2. Metrics & Milestones Strip
              _buildMetricsGrid(),
              const SizedBox(height: 20),

              // 3. Vision & Mission Cards
              _buildVisionMissionSection(),
              const SizedBox(height: 20),

              // 4. Core Values (PDF Page 15)
              Text(
                'Our Core Values',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 10),
              _buildCoreValuesGrid(),
              const SizedBox(height: 24),

              // 5. Why Choose Us In-Depth (PDF Page 16)
              Text(
                'Why Choose Mahavir Finance?',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 10),
              _buildWhyChooseSection(),
              const SizedBox(height: 20),

              // 6. Leadership & Advisory Team
              Text(
                'Leadership Team',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 10),
              _buildLeadershipSection(),
              const SizedBox(height: 20),

              // 7. Contact Consultation Callout
              _buildConsultationCta(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Company Story
  Widget _buildStoryCard() {
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.corporate_fare_rounded, color: AppColors.secondary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Empowering Financial Freedom',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Established with integrity and trust',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          const Text(
            'Mahavir Finance is a premier financial consultancy dedicated to simplifying complex financial choices for individuals, families, and businesses. We partner with top-tier RBI-registered Banks and NBFCs across India to offer low-interest loans, transparent processing, and customized portfolio planning.',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Metrics 4-Box Grid
  Widget _buildMetricsGrid() {
    final metrics = [
      {'val': '₹500+ Cr', 'label': 'Loans Disbursed', 'color': const Color(0xFF0284C7)},
      {'val': '25,000+', 'label': 'Happy Customers', 'color': AppColors.secondary},
      {'val': '15+ Banks', 'label': 'Lending Partners', 'color': const Color(0xFFD97706)},
      {'val': '99.2%', 'label': 'Customer Satisfaction', 'color': const Color(0xFF7C3AED)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        final m = metrics[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                m['val'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: m['color'] as Color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                m['label'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Vision & Mission
  Widget _buildVisionMissionSection() {
    return Column(
      children: [
        _buildInfoBox(
          icon: Icons.visibility_outlined,
          title: 'Our Vision',
          desc:
          'To be the most trusted financial consultancy in India, recognized for transparent practices, digital efficiency, and customer-first solutions.',
          bgColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFFBBF7D0),
          accentColor: AppColors.secondary,
        ),
        const SizedBox(height: 10),
        _buildInfoBox(
          icon: Icons.flag_outlined,
          title: 'Our Mission',
          desc:
          'To bridge borrowers and reliable lending institutions with minimal paperwork, customized advice, and competitive interest rates that empower financial growth.',
          bgColor: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
          accentColor: const Color(0xFF0284C7),
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String desc,
    required Color bgColor,
    required Color borderColor,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
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
  }

  // 4. Core Values
  Widget _buildCoreValuesGrid() {
    final values = [
      {
        'title': 'Integrity',
        'desc': 'Unbiased recommendations with zero hidden fees.',
        'icon': Icons.shield_outlined,
      },
      {
        'title': 'Transparency',
        'desc': 'Complete clarity on loan processing and interest.',
        'icon': Icons.search_rounded,
      },
      {
        'title': 'Customer First',
        'desc': 'Solutions designed around your financial needs.',
        'icon': Icons.favorite_border_rounded,
      },
      {
        'title': 'Excellence',
        'desc': 'Dedicated managers guiding you till disbursal.',
        'icon': Icons.verified_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final v = values[index];
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
              Icon(v['icon'] as IconData, size: 22, color: AppColors.secondary),
              const SizedBox(height: 6),
              Text(
                v['title'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                v['desc'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.25),
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. Why Choose Us (PDF Page 16)
  Widget _buildWhyChooseSection() {
    final points = [
      {
        'title': 'Direct Institutional Tie-ups',
        'desc': 'Authorized consulting channels for SBI, HDFC, ICICI, Axis, Kotak, and leading NBFCs.',
      },
      {
        'title': 'Tailored Repayment Flexibility',
        'desc': 'Custom tenure matches to keep your monthly cashflows comfortable and predictable.',
      },
      {
        'title': 'Zero Pre-Approval Fees',
        'desc': 'Free loan eligibility assessment without unexpected upfront consulting charges.',
      },
      {
        'title': 'Complete Data Privacy',
        'desc': 'Bank-grade encryption ensuring your identity and income data remain strictly confidential.',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: points.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['title']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p['desc']!,
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
        }).toList(),
      ),
    );
  }

  // 6. Leadership Section
  Widget _buildLeadershipSection() {
    final leaders = [
      {
        'name': 'Rajesh Jain',
        'role': 'Founder & Managing Director',
        'exp': '20+ Years in Retail Banking',
      },
      {
        'name': 'Ankit Mahavir',
        'role': 'Head of Credit & Lending Solutions',
        'exp': 'Former Credit Head at ICICI',
      },
    ];

    return Column(
      children: leaders.map((l) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(Icons.person, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      l['role']!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      l['exp']!,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 7. Consultation CTA
  Widget _buildConsultationCta(BuildContext context) {
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
            'Ready to Plan Your Loan?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Connect with our financial advisors today and unlock verified offers with low interest rates.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Contact Us Now',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}