import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/theme/app_text_styles.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/customer-section/about/about_us_screen.dart';
import '../screens/customer-section/blog/blog_list_screen.dart';
import '../screens/customer-section/contact/contact_us_screen.dart';
import '../screens/customer-section/faq/faq_screen.dart';
import '../screens/customer-section/gallery/gallery_screen.dart';
import '../screens/customer-section/home/customer_home_provider.dart';
import '../screens/customer-section/inquiries/inquiry_history_screen.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final currentIndex = homeProvider.currentIndex;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 1. Premium Header with Profile Overview
          _buildDrawerHeader(context, homeProvider),

          // 2. Scrollable Navigation Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSectionHeader('MAIN MENU'),
                const SizedBox(height: 6),
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () {
                    homeProvider.setBottomNavIndex(0);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Loan Products',
                  badge: 'Offers',
                  badgeColor: AppColors.secondary,
                  isSelected: currentIndex == 1,
                  onTap: () {
                    homeProvider.setBottomNavIndex(1);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calculate_rounded,
                  title: 'EMI Calculator',
                  isSelected: currentIndex == 2,
                  onTap: () {
                    homeProvider.setBottomNavIndex(2);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.miscellaneous_services_rounded,
                  title: 'Financial Services',
                  isSelected: currentIndex == 3,
                  onTap: () {
                    homeProvider.setBottomNavIndex(3);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_rounded,
                  title: 'My Profile',
                  isSelected: currentIndex == 4,
                  onTap: () {
                    homeProvider.setBottomNavIndex(4);
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'My Inquiries & Tracker',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InquiryHistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 14),

                _buildSectionHeader('COMPANY & KNOWLEDGE'),
                const SizedBox(height: 6),
                _buildDrawerItem(
                  icon: Icons.business_rounded,
                  title: 'About Mahavir Finance',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.photo_library_rounded,
                  title: 'Office & Events Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GalleryScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.article_rounded,
                  title: 'Financial Blog & Guides',
                  badge: 'New',
                  badgeColor: const Color(0xFF0284C7),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BlogListScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.headset_mic_rounded,
                  title: 'Help & Contact Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'FAQs',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FaqScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Bottom Footer (Logout Button + Version Badge)
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, HomeProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 18,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF133E68),
          ],
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Photo with Verified Ring
              Stack(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.2),
                      color: const Color(0xFFF1F5F9),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 34,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 11, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rohit Kumar',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'rohit.kumar@gmail.com',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.6),
                          width: 0.8,
                        ),
                      ),
                      child: const Text(
                        'Verified Customer',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6EE7B7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Shortcut Pill to view full profile
          InkWell(
            onTap: () {
              provider.setBottomNavIndex(4);
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Manage Account & Preferences',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    String? badge,
    Color? badgeColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.secondary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: isSelected ? AppColors.secondary : AppColors.iconSecondary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.secondary : AppColors.primary,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? AppColors.secondary).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor ?? AppColors.secondary,
                      ),
                    ),
                  ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.iconSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          // Logout Option
          InkWell(
            onTap: () => _showLogoutDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Logout Account',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // App Compliance & Version Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user_rounded, size: 12, color: AppColors.secondary),
              const SizedBox(width: 5),
              Text(
                'RBI Compliant Partners • v1.0.0',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        content: const Text(
          'Are you sure you want to log out of your Mahavir Finance account?',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close drawer
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}