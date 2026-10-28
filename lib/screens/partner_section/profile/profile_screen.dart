import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';

import '../customer/customer_list_screen.dart';
import '../dasboard/partner_dashboard_screen.dart';
import '../leads/my_leads_screen.dart';
import 'edit_patner_profile.dart';

class PartnerProfileScreen extends StatefulWidget {
  const PartnerProfileScreen({super.key});

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = [
    'Personal Details',
    'Business Details',
    'Bank & Payout',
    'Documents',
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
              // Header Title
              const Text(
                'Partner Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Manage your personal and business details.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // 1. Partner Profile Card
              _buildPartnerHeroCard(),
              const SizedBox(height: 14),

              // 2. Navigation Pills
              _buildPillsRow(),
              const SizedBox(height: 16),

              // 3. Personal Details Section
              _buildPersonalDetailsCard(),
              const SizedBox(height: 14),

              // 4. Business Details Section
              _buildBusinessDetailsCard(),
              const SizedBox(height: 14),

              // 5. Bank & Payout Details Section
              _buildBankDetailsCard(),
              const SizedBox(height: 14),

              // 6. KYC Documents Section
              _buildKycDocumentsCard(),
              const SizedBox(height: 14),

              // 7. Account Settings Tile
              _buildAccountSettingsTile(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Partner Hero Card
  Widget _buildPartnerHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                    child: const Icon(Icons.person, size: 36, color: Color(0xFF0F3E38)),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A36A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Rohan Kumar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Verified Partner',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A36A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Partner ID: PARTNER0012',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F3E38),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '+91 98765 43210',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Text(
                      'rohan.kumar@gmail.com',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const Text(
                      'Noida, Uttar Pradesh',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditPartnerProfileScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: const BorderSide(color: Color(0xFF0F3E38)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F3E38),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Gold Partner',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFD97706),
                          ),
                        ),
                        Text(
                          'Since Sep 2023',
                          style: TextStyle(fontSize: 8.5, color: Color(0xFF92400E)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Navigation Pills
  Widget _buildPillsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = index),
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
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 3. Personal Details Card
  Widget _buildPersonalDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            title: 'Personal Details',
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF16A36A),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditPartnerProfileScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildTwoColRow('Full Name', 'Rohan Kumar', 'Date of Birth', '12 Jan 1995'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Mobile Number', '+91 98765 43210', 'Gender', 'Male'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow(
            'Email Address',
            'rohan.kumar@gmail.com',
            'Current Address',
            'B-203, Sector 62, Noida,\nUttar Pradesh - 201309',
          ),
        ],
      ),
    );
  }

  // 4. Business Details Card
  Widget _buildBusinessDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            title: 'Business Details',
            icon: Icons.business_center_outlined,
            iconColor: const Color(0xFF0284C7),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditPartnerProfileScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildTwoColRow('Business Name', 'RK Associates', 'Years of Experience', '3 Years'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Business Type', 'DSA Agent', 'Area of Operation', 'Noida, Delhi, Ghaziabad'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow(
            'GST Number',
            '27ABCDE1234F1Z5',
            'Business Address',
            'Office No. 12, Sector 62\nNoida, Uttar Pradesh - 201309',
          ),
        ],
      ),
    );
  }

  // 5. Bank & Payout Details Card
  Widget _buildBankDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            title: 'Bank & Payout Details',
            icon: Icons.account_balance_outlined,
            iconColor: const Color(0xFFD97706),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditPartnerProfileScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildTwoColRow('Account Holder Name', 'Rohan Kumar', 'Bank Name', 'HDFC Bank'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Account Number', '5010 2345 6789', 'IFSC Code', 'HDFC0001234'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('UPI ID', 'rohan123@okhdfcbank', 'Payout Frequency', 'Monthly'),
        ],
      ),
    );
  }

  // 6. KYC Documents Card
  Widget _buildKycDocumentsCard() {
    final docs = [
      {'name': 'Aadhaar Card', 'status': 'Verified'},
      {'name': 'PAN Card', 'status': 'Verified'},
      {'name': 'Address Proof', 'status': 'Verified'},
      {'name': 'Bank Statement', 'status': 'Verified'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF16A36A)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'KYC Documents',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A36A)),
                    const SizedBox(width: 6),
                    Text(
                      doc['name']!,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${doc['status']!}',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF16A36A), fontWeight: FontWeight.w600),
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

  // 7. Account Settings Tile
  Widget _buildAccountSettingsTile() {
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings_outlined, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Account Settings',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Text(
                        'Change password, notification settings, logout etc.',
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
    );
  }

  Widget _buildCardHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ],
        ),
        InkWell(
          onTap: onEdit,
          child: const Text(
            'Edit',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
          ),
        ),
      ],
    );
  }

  Widget _buildTwoColRow(String l1, String v1, String l2, String v2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                v1,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
        ),
        if (l2.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  v2,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ),
      ],
    );
  }
}