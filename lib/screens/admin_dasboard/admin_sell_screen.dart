import 'package:flutter/material.dart';
import 'package:mahavir_finance/screens/admin_dasboard/settings/role_permission_screen.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import 'admin_dasboard_screen.dart';

import 'blogs/blogs_management_screen.dart';
import 'contant/content_management_screen.dart';
import 'customer/customer_management_screen.dart';
import 'financials/commission_management_screen.dart';
import 'financials/payout_management_screen.dart';
import 'inquiries/loan_inquiry_management_screen.dart';
import 'leads/all_loan_leads_screen.dart';
import 'notifications/notifications_management_screen.dart';
import 'patners/patner_manegment_screen.dart';
import 'products/loan_products_screen.dart';
import 'reports/reports_analytics_screen.dart';
import 'support/support_queries_screen.dart';

class AdminShellScreen extends StatefulWidget {
  const AdminShellScreen({super.key});

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Sidebar ke 14 menu items (0 se 13) ka kram
  final List<Widget> _pages = const [
    AdminDashboardScreen(),          // 0: Dashboard
    CustomerManagementScreen(),      // 1: Customers
    PartnerManagementScreen(),       // 2: Partners (DSA)
    AllLoanLeadsScreen(),            // 3: Loan Leads
    LoanProductsScreen(),            // 4: Loan Products
    LoanInquiryManagementScreen(),   // 5: Inquiries
    CommissionManagementScreen(),    // 6: Commissions
    PayoutManagementScreen(),        // 7: Payouts
    ReportsAnalyticsScreen(),        // 8: Reports & Analytics
    NotificationsManagementScreen(), // 9: Notifications
    CmsContentManagementScreen(),    // 10: CMS / Banners
    BlogManagementScreen(),          // 11: Blogs
    SupportQueriesScreen(),          // 12: Support & Queries
    RolesPermissionsScreen(),        // 13: Users & Roles
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    // Admin pages ke liye button constraints ko reset kiya gaya hai
    final adminTheme = Theme.of(context).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: isDesktop
          ? null
          : AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Mahavir Finance Admin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent()),
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 250,
              child: _buildSidebarContent(),
            ),
          Expanded(
            child: Theme(
              data: adminTheme,
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Image.asset(
                  AssetsConstants.mahavirLogo,
                  height: 30,
                  errorBuilder: (_, __, ___) => const Text(
                    'MAHAVIR',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3E38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
                _buildSectionLabel('MEMBERS'),
                _buildNavItem(1, Icons.people_outline_rounded, Icons.people_rounded, 'Customers'),
                _buildNavItem(2, Icons.handshake_outlined, Icons.handshake_rounded, 'Partners (DSA)'),
                _buildSectionLabel('LOAN MANAGEMENT'),
                _buildNavItem(3, Icons.assignment_outlined, Icons.assignment_rounded, 'Loan Leads'),
                _buildNavItem(4, Icons.category_outlined, Icons.category_rounded, 'Loan Products'),
                _buildNavItem(5, Icons.help_outline_rounded, Icons.help_rounded, 'Inquiries'),
                _buildSectionLabel('FINANCIALS'),
                _buildNavItem(6, Icons.percent_rounded, Icons.percent_rounded, 'Commissions'),
                _buildNavItem(7, Icons.payments_outlined, Icons.payments_rounded, 'Payouts'),
                _buildSectionLabel('REPORTS & ANALYTICS'),
                _buildNavItem(8, Icons.bar_chart_rounded, Icons.bar_chart_rounded, 'Reports & Analytics'),
                _buildSectionLabel('CONTENT & SUPPORT'),
                _buildNavItem(9, Icons.notifications_none_rounded, Icons.notifications_rounded, 'Notifications'),
                _buildNavItem(10, Icons.view_carousel_outlined, Icons.view_carousel_rounded, 'CMS / Banners'),
                _buildNavItem(11, Icons.article_outlined, Icons.article_rounded, 'Blogs'),
                _buildNavItem(12, Icons.headset_mic_outlined, Icons.headset_mic_rounded, 'Support & Queries'),
                _buildSectionLabel('SETTINGS'),
                _buildNavItem(13, Icons.admin_panel_settings_outlined, Icons.admin_panel_settings_rounded, 'Users & Roles'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 17,
                  backgroundColor: Color(0xFF0F3E38),
                  child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Admin User', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      Text('Super Admin', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFDC2626)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: AppColors.textHint,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFDCFCE7) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        horizontalTitleGap: 8,
        leading: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          size: 18,
          color: isSelected ? const Color(0xFF0F3E38) : AppColors.textSecondary,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected ? const Color(0xFF0F3E38) : AppColors.textPrimary,
          ),
        ),
        onTap: () {
          setState(() => _selectedIndex = index);
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}