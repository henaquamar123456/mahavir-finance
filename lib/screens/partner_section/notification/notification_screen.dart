import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../customer/customer_list_screen.dart';
import '../dasboard/partner_dashboard_screen.dart';
import '../profile/profile_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List _allNotifications = [
  {
  'title': 'Lead Approved',
  'time': 'Just now',
  'desc': 'Your lead application has been verified and approved by the credit team.',
  'category': 'Lead Updates',
  'icon': Icons.check_circle_rounded,
  'iconColor': const Color(0xFF16A36A),
  'iconBg': const Color(0xFFDCFCE7),
  },
  {
  'title': 'Lead Under Review',
  'time': '1 hour ago',
  'desc': "Customer application is under review by loan underwriting team.",
  'category': 'Lead Updates',
  'icon': Icons.access_time_rounded,
  'iconColor': const Color(0xFF0284C7),
  'iconBg': const Color(0xFFEFF6FF),
  },
  {
  'title': 'Commission Credited',
  'time': '1 day ago',
  'desc': '1.5% commission has been registered to your ledger for approved referral.',
  'category': 'Lead Updates',
  'icon': Icons.account_balance_wallet_rounded,
  'iconColor': const Color(0xFF16A36A),
  'iconBg': const Color(0xFFDCFCE7),
  },
  {
  'title': 'New Loan Product Launched',
  'time': '2 days ago',
  'desc': 'We are excited to announce business loan disbursals with fast approvals.',
  'category': 'Announcements',
  'icon': Icons.campaign_rounded,
  'iconColor': const Color(0xFF7C3AED),
  'iconBg': const Color(0xFFF3E8FF),
  },
  {
  'title': 'KYC Verified',
  'time': '3 days ago',
  'desc': 'Your partner credentials and bank verification are active.',
  'category': 'System',
  'icon': Icons.verified_user_outlined,
  'iconColor': const Color(0xFF16A36A),
  'iconBg': const Color(0xFFDCFCE7),
  },
  ];

  List get _filteredNotifications {
    if (_selectedFilter == 'All') return _allNotifications;
    return _allNotifications.where((n) => n['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _filteredNotifications;

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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Stay updated with your leads and important commission alerts.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterChipsRow(),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 44, color: AppColors.iconSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    const Text('No notifications found', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) => _buildNotificationCard(notifications[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: const Color(0xFFDCFCE7),
        onDestinationSelected: (index) {
          if (index == 2) return;
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PartnerDashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CustomerListScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PartnerProfileScreen()),
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
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt_rounded, color: Color(0xFF16A36A)),
            label: 'Customers',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_rounded, color: Color(0xFF16A36A)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF16A36A)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = [
      {'label': 'All', 'key': 'All'},
      {'label': 'Lead Updates', 'key': 'Lead Updates'},
      {'label': 'Announcements', 'key': 'Announcements'},
      {'label': 'System', 'key': 'System'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedFilter = f['key']!),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
                ),
                child: Text(
                  f['label']!,
                  style: TextStyle(
                    fontSize: 11.5,
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

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item['iconBg'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'] as IconData, size: 20, color: item['iconColor'] as Color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ),
                      Text(item['time'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textHint, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['desc'] as String,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}