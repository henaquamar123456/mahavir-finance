import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahavir_finance/screens/customer-section/notifications/notifications_screen.dart';
import 'package:mahavir_finance/screens/partner_section/customer/customer_list_screen.dart';
import 'package:mahavir_finance/screens/partner_section/support/help_support_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../p_models/partner_model_screen.dart';
import '../earnings/earning_screen.dart';
import '../leads/add_new_lead_screen.dart';
import '../leads/lead_details_screen.dart';
import '../leads/my_leads_screen.dart';
import '../profile/profile_screen.dart';
import '../providers/partner_dashboard_provider.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PartnerDashboardProvider(),
      child: const _PartnerDashboardView(),
    );
  }
}

class _PartnerDashboardView extends StatelessWidget {
  const _PartnerDashboardView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PartnerDashboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _buildPartnerDrawer(context, provider),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (scaffoldContext) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primary, size: 26),
            onPressed: () {
              Scaffold.of(scaffoldContext).openDrawer();
            },
          ),
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
            icon: const Stack(
              children: [
                Icon(Icons.notifications_outlined, color: AppColors.primary),
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(radius: 4, backgroundColor: AppColors.error),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen(),));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person, size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: provider.currentIndex,
        children: [
          _buildDashboardTab(context, provider), // Tab 0
          const MyLeadsScreen(),                 // Tab 1
          const EarningsScreen(),                // Tab 2
          const CustomerListScreen(),// Tab 3
          const PartnerProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: provider.currentIndex,
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: const Color(0xFFDCFCE7),
        onDestinationSelected: (index) {
          provider.setBottomNavIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.secondary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description, color: AppColors.secondary),
            label: 'My Leads',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            selectedIcon: Icon(Icons.bar_chart, color: AppColors.secondary),
            label: 'Earnings',
          ),
           NavigationDestination(
            icon: Icon(Icons.group),
            selectedIcon: Icon(Icons.group, color: AppColors.secondary),
            label: 'Customer',
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

  // --- Side Drawer ---
  Widget _buildPartnerDrawer(BuildContext context, PartnerDashboardProvider provider) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFDCFCE7),
                    child: Icon(Icons.person, size: 30, color: Color(0xFF0F3E38)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rajesh Kumar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'ID: MFP00124',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3E38),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Verified Partner',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A36A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      provider.setBottomNavIndex(0);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Add New Lead',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.assignment_outlined,
                    title: 'My Leads',
                    onTap: () {
                      Navigator.pop(context);
                      provider.setBottomNavIndex(1);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Earnings & Commission',
                    onTap: () {
                      Navigator.pop(context);
                      provider.setBottomNavIndex(2);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Partner Profile',
                    onTap: () {
                      Navigator.pop(context);
                      provider.setBottomNavIndex(3);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(color: AppColors.divider, height: 1),
                  ),
                  _buildDrawerItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen(),));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Policies',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: const [
                      Icon(Icons.logout_rounded, size: 20, color: Color(0xFFDC2626)),
                      SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      dense: true,
      onTap: onTap,
    );
  }

  // --- Dashboard Tab 0 ---
  Widget _buildDashboardTab(BuildContext context, PartnerDashboardProvider provider) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPartnerHeroCard(context),
            const SizedBox(height: 14),
            _buildMetricsGrid(context, provider),
            const SizedBox(height: 14),
            _buildTotalEarningsCard(context, provider),
            const SizedBox(height: 18),
            _buildQuickActionsRow(context, provider),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Leads',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                InkWell(
                  onTap: () => provider.setBottomNavIndex(1),
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.secondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...provider.recentLeads.map((lead) => _buildLeadCard(context, lead)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Hero Card
  Widget _buildPartnerHeroCard(BuildContext context) {
    const partnerId = 'MFP00124';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back,',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              const Text(
                'Rajesh Kumar!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: partnerId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Partner ID copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Partner ID: $partnerId',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.copy_rounded, size: 12, color: AppColors.secondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(
                width: 190,
                child: Text(
                  'Keep referring, keep earning\ngrow together with Mahavir Finance.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.bar_chart_rounded, size: 12, color: AppColors.secondary),
                      SizedBox(width: 4),
                      Text(
                        'Your Growth\nOur Support',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFBBF7D0),
                  child: Icon(Icons.person, size: 42, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4 Metrics Grid
  Widget _buildMetricsGrid(BuildContext context, PartnerDashboardProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildStatCard(
                count: '${provider.totalLeads}',
                label: 'Total Leads',
                icon: Icons.groups_rounded,
                iconColor: const Color(0xFF0284C7),
                iconBg: const Color(0xFFEFF6FF),
                onTap: () => provider.setBottomNavIndex(1),
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                count: '${provider.approvedLeads}',
                label: 'Approved Leads',
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.secondary,
                iconBg: const Color(0xFFDCFCE7),
                onTap: () => provider.setBottomNavIndex(1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              _buildStatCard(
                count: '${provider.pendingLeads}',
                label: 'Pending Leads',
                icon: Icons.access_time_rounded,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                onTap: () => provider.setBottomNavIndex(1),
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                count: '${provider.rejectedLeads}',
                label: 'Rejected Leads',
                icon: Icons.cancel_rounded,
                iconColor: const Color(0xFFDC2626),
                iconBg: const Color(0xFFFEE2E2),
                onTap: () => provider.setBottomNavIndex(1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String count,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.iconSecondary),
          ],
        ),
      ),
    );
  }

  // Earnings Banner
  Widget _buildTotalEarningsCard(BuildContext context, PartnerDashboardProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3E38), Color(0xFF082723)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.savings_rounded, color: Color(0xFF6EE7B7), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.formatWhole(provider.totalEarnings),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '↑ +12% vs last month',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6EE7B7),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => provider.setBottomNavIndex(2),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, size: 14, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Actions Row
  Widget _buildQuickActionsRow(BuildContext context, PartnerDashboardProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionTile(
          title: 'Add New\nLead',
          icon: Icons.person_add_alt_1_rounded,
          color: AppColors.secondary,
          bg: const Color(0xFFDCFCE7),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
            );
          },
        ),
        _buildActionTile(
          title: 'My Leads\n',
          icon: Icons.assignment_outlined,
          color: const Color(0xFF0284C7),
          bg: const Color(0xFFEFF6FF),
          onTap: () => provider.setBottomNavIndex(1),
        ),
        _buildActionTile(
          title: 'Earnings\n',
          icon: Icons.bar_chart_rounded,
          color: const Color(0xFF7C3AED),
          bg: const Color(0xFFF3E8FF),
          onTap: () => provider.setBottomNavIndex(2),
        ),
        _buildActionTile(
          title: 'Share\nReferral Code',
          icon: Icons.share_rounded,
          color: const Color(0xFFD97706),
          bg: const Color(0xFFFEF3C7),
          onTap: () {
            Clipboard.setData(const ClipboardData(text: 'MFP00124'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Referral code copied: MFP00124'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent Lead Card
  Widget _buildLeadCard(BuildContext context, PartnerLeadModel lead) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LeadDetailsScreen(lead: lead)),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: lead.iconColor.withValues(alpha: 0.12),
                  child: Icon(Icons.person, color: lead.iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.customerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${lead.loanCategory} | ${CurrencyFormatter.formatWhole(lead.amount)}',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      lead.date,
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: lead.status.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        lead.status.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: lead.status.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.iconSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}