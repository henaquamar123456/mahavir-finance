import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../customer-section/notifications/notifications_screen.dart';
import '../dasboard/partner_dashboard_screen.dart';
import '../leads/my_leads_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How can I register as a DSA Partner?',
      'answer':
      'You can register by navigating to the Partner Registration screen from login, filling in your KYC, PAN, and business details. Our team verifies your profile within 24 hours.',
      'icon': Icons.person_outline_rounded,
      'color': const Color(0xFF0284C7),
      'bg': const Color(0xFFEFF6FF),
    },
    {
      'question': 'What documents are required for loan application?',
      'answer':
      'Standard requirements include Identity Proof (PAN Card), Address Proof, last 3 months salary slips or 2 years ITR, and last 6 months bank statements.',
      'icon': Icons.description_outlined,
      'color': const Color(0xFF0284C7),
      'bg': const Color(0xFFEFF6FF),
    },
    {
      'question': 'How and when will I receive my commission?',
      'answer':
      'Commissions are disbursed directly to your verified bank account on a monthly payout cycle once the loan disbursal is confirmed by our lending partner.',
      'icon': Icons.currency_rupee_rounded,
      'color': const Color(0xFF16A36A),
      'bg': const Color(0xFFDCFCE7),
    },
    {
      'question': 'How can I check the status of my leads?',
      'answer':
      'Go to the "My Leads" section or tap on any lead to see the detailed real-time timeline tracker from submission to disbursal.',
      'icon': Icons.access_time_rounded,
      'color': const Color(0xFF0284C7),
      'bg': const Color(0xFFEFF6FF),
    },
    {
      'question': 'What should I do if my lead is rejected?',
      'answer':
      'Check the rejection remarks in the lead details screen. You can re-submit with rectified documentation or contact your dedicated Relationship Manager for assistance.',
      'icon': Icons.verified_outlined,
      'color': const Color(0xFF0284C7),
      'bg': const Color(0xFFEFF6FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          AssetsConstants.mahavirLogo,
          height: 30,
          errorBuilder: (_, __, ___) => const Text(
            'MAHAVIR FINANCE',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: 0.5,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
              child: const Icon(Icons.person, size: 20, color: Color(0xFF0F3E38)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Support Agent Graphic
              _buildHeaderBanner(),
              const SizedBox(height: 16),

              // 1. Four Quick Action Cards (FAQs, Contact Support, Raise Query, History)
              _buildQuickActionCardsGrid(),
              const SizedBox(height: 20),

              // 2. Frequently Asked Questions Section
              _buildSectionHeader('Frequently Asked Questions', hasViewAll: true, onViewAll: () {}),
              const SizedBox(height: 10),
              _buildFaqList(),
              const SizedBox(height: 20),

              // 3. Contact Support Channels (Call, Email, WhatsApp)
              _buildSectionHeader('Contact Support', subtitle: 'Get in touch with our support team through your preferred channel.'),
              const SizedBox(height: 12),
              _buildContactChannelsRow(),
              const SizedBox(height: 20),

              // 4. Raise a Support Query Banner & Tile
              _buildRaiseQuerySection(),
              const SizedBox(height: 16),

              // 5. Need Immediate Help Card
              _buildImmediateHelpCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3, // Help & Support tab active
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: const Color(0xFFDCFCE7),
        onDestinationSelected: (index) {
          if (index == 3) return;

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PartnerDashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MyLeadsScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF16A36A)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description, color: Color(0xFF16A36A)),
            label: 'My Leads',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_rounded, color: Color(0xFF16A36A)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.headset_mic_rounded, color: Color(0xFF16A36A)),
            label: 'Help & Support',
          ),
        ],
      ),
    );
  }

  // Header Title with Agent Graphic
  Widget _buildHeaderBanner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "We're here to help you. Find answers, contact support or raise your query.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Color(0xFF0284C7),
                size: 32,
              ),
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat_bubble_rounded, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 4 Top Action Cards Grid
  Widget _buildQuickActionCardsGrid() {
    final actions = [
      {
        'title': 'FAQs',
        'sub': 'Find quick\nanswers',
        'icon': Icons.help_outline_rounded,
        'color': const Color(0xFF16A36A),
        'bg': const Color(0xFFDCFCE7),
      },
      {
        'title': 'Contact Support',
        'sub': 'Chat, Call or Email\nus',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFEFF6FF),
      },
      {
        'title': 'Raise a Query',
        'sub': 'Submit your\nissue',
        'icon': Icons.edit_note_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7),
      },
      {
        'title': 'Support History',
        'sub': 'Track your\nqueries',
        'icon': Icons.headphones_outlined,
        'color': const Color(0xFFDC2626),
        'bg': const Color(0xFFFEE2E2),
      },
    ];

    return Row(
      children: actions.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: item['bg'] as Color,
                  child: Icon(item['icon'] as IconData, size: 18, color: item['color'] as Color),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['sub'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: AppColors.textSecondary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // FAQs Accordion List
  Widget _buildFaqList() {
    return Column(
      children: _faqs.map((faq) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: faq['bg'] as Color,
                child: Icon(faq['icon'] as IconData, size: 15, color: faq['color'] as Color),
              ),
              title: Text(
                faq['question'] as String,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              children: [
                Text(
                  faq['answer'] as String,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Contact Channels (Call Us, Email Us, WhatsApp)
  Widget _buildContactChannelsRow() {
    final channels = [
      {
        'title': 'Call Us',
        'val': '+91 1800 123 4567',
        'sub': 'Mon-Sat, 9 AM-7 PM',
        'icon': Icons.phone_rounded,
        'color': const Color(0xFF16A36A),
        'bg': const Color(0xFFDCFCE7),
      },
      {
        'title': 'Email Us',
        'val': 'support@mahavirfinance.in',
        'sub': 'We reply within 24 hours',
        'icon': Icons.email_rounded,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFEFF6FF),
      },
      {
        'title': 'WhatsApp',
        'val': '+91 98765 43210',
        'sub': 'Chat with our team',
        'icon': Icons.chat_bubble_rounded,
        'color': const Color(0xFFDC2626),
        'bg': const Color(0xFFFEE2E2),
      },
    ];

    return Row(
      children: channels.map((c) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: c['bg'] as Color,
                  child: Icon(c['icon'] as IconData, size: 16, color: c['color'] as Color),
                ),
                const SizedBox(height: 8),
                Text(
                  c['title'] as String,
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const SizedBox(height: 3),
                Text(
                  c['val'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  c['sub'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 8, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Raise Query Card
  Widget _buildRaiseQuerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Raise a Support Query', subtitle: "Facing an issue? Submit your query and we'll get back to you soon."),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.post_add_rounded, size: 20, color: Color(0xFF7C3AED)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Submit a New Query',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Describe your issue and our team will assist you.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.iconSecondary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Need Immediate Help Card
  Widget _buildImmediateHelpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Need Immediate Help?',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF065F46)),
                ),
                SizedBox(height: 2),
                Text(
                  'Talk to our support team for instant assistance.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF047857)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Call Now',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle, bool hasViewAll = false, VoidCallback? onViewAll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            if (hasViewAll)
              InkWell(
                onTap: onViewAll,
                child: const Text(
                  'View All >',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}