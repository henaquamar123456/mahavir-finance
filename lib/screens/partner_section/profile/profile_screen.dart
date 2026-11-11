import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../auth/login/login_screen.dart';
import 'edit_patner_profile.dart';

class PartnerProfileScreen extends StatefulWidget {
  const PartnerProfileScreen({super.key});

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  int _selectedTab = 0;
  bool _isLoading = true;

  String _partnerName = 'Partner';
  String _partnerPhone = '';
  String _partnerEmail = '';
  String _partnerCity = 'Gujarat, India';
  String _dsaCode = 'DSA001';
  String _partnerStatus = 'Active';

  final List<String> _tabs = [
    'All Details',
    'Personal Details',
    'Business Details',
    'Bank & Payout',
    'Documents',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// 1. Load Local Data & Fetch Fresh Profile from Backend
  Future<void> _loadProfileData() async {
    try {
      final userData = await SharedPrefHelper.getUserData();
      final token = await SharedPrefHelper.getToken();

      if (mounted) {
        setState(() {
          _partnerName = userData['name'] ?? 'Mahavir Partner';
          _partnerPhone = userData['phone'] ?? '';
          _partnerEmail = userData['email'] ?? '';
          _partnerCity = (userData['city'] != null && userData['city'].toString().isNotEmpty)
              ? userData['city']
              : 'India';
          _dsaCode = userData['dsaCode'] ?? 'DSA001';
          _partnerStatus = userData['status'] ?? 'Active';
          _isLoading = false;
        });
      }

      if (token == null) return;

      // Real API Call: GET /api/v1/auth/me
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/auth/me'));
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final profile = data['data'] ?? {};

        if (mounted) {
          setState(() {
            _partnerName = profile['name'] ?? _partnerName;
            _partnerPhone = profile['phone'] ?? _partnerPhone;
            _partnerEmail = profile['email'] ?? _partnerEmail;
            _partnerCity = profile['city'] ?? _partnerCity;
            _dsaCode = profile['dsaCode'] ?? _dsaCode;
            _partnerStatus = profile['status'] ?? _partnerStatus;
          });
        }
      }
    } catch (_) {
      // Retain cached data silently
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 2. Logout Session Management
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
        ),
        content: const Text(
          'Are you sure you want to log out of your Mahavir Finance Partner account?',
          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await SharedPrefHelper.clearSession();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
            : RefreshIndicator(
          color: AppColors.secondary,
          onRefresh: _loadProfileData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  'Manage your partner credentials and business details.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // 1. Partner Hero Card
                _buildPartnerHeroCard(),
                const SizedBox(height: 14),

                // 2. Navigation Pills
                _buildPillsRow(),
                const SizedBox(height: 16),

                // 3. Sections with Tab Filtering
                if (_selectedTab == 0 || _selectedTab == 1) ...[
                  _buildPersonalDetailsCard(),
                  const SizedBox(height: 14),
                ],

                if (_selectedTab == 0 || _selectedTab == 2) ...[
                  _buildBusinessDetailsCard(),
                  const SizedBox(height: 14),
                ],

                if (_selectedTab == 0 || _selectedTab == 3) ...[
                  _buildBankDetailsCard(),
                  const SizedBox(height: 14),
                ],

                if (_selectedTab == 0 || _selectedTab == 4) ...[
                  _buildKycDocumentsCard(),
                  const SizedBox(height: 14),
                ],

                // 4. Account Settings & Logout
                _buildAccountSettingsTile(),
                const SizedBox(height: 24),
              ],
            ),
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
      child: Row(
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
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
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
                    Flexible(
                      child: Text(
                        _partnerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _partnerStatus,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A36A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'DSA Referral Code: $_dsaCode',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F3E38),
                  ),
                ),
                const SizedBox(height: 3),
                if (_partnerPhone.isNotEmpty)
                  Text(
                    _partnerPhone,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                if (_partnerEmail.isNotEmpty)
                  Text(
                    _partnerEmail,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                Text(
                  _partnerCity,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditPartnerProfileScreen()),
                  );
                  _loadProfileData();
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Standard Partner',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD97706),
                      ),
                    ),
                    Text(
                      '1.5% Commission',
                      style: TextStyle(fontSize: 8.5, color: Color(0xFF92400E)),
                    ),
                  ],
                ),
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
          _buildTwoColRow('Full Name', _partnerName, 'Role', 'DSA Partner'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Mobile Number', _partnerPhone, 'Assigned Code', _dsaCode),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Email Address', _partnerEmail, 'Registered City', _partnerCity),
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
          _buildTwoColRow('Partner Category', 'DSA Channel Partner', 'Commission Slab', '1.5% Per Disbursed Lead'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Service Scope', 'Personal / Home / Business Loans', 'Operational Region', _partnerCity),
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
          _buildTwoColRow('Beneficiary Name', _partnerName, 'Payout Mode', 'Direct Bank Transfer (NEFT/RTGS)'),
          const Divider(height: 16, color: AppColors.divider),
          _buildTwoColRow('Account Status', 'Active Payout Ledger', 'Cycle', 'Weekly Settlement'),
        ],
      ),
    );
  }

  // 6. KYC Documents Card
  Widget _buildKycDocumentsCard() {
    final docs = [
      {'name': 'Identity Proof', 'status': 'Verified'},
      {'name': 'PAN Card', 'status': 'Verified'},
      {'name': 'Bank Account Proof', 'status': 'Verified'},
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
                'Partner Verification Documents',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
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

  // 7. Account Settings & Logout Tile
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
          onTap: _confirmLogout,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFDC2626)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log Out',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
                      ),
                      Text(
                        'End current partner session on this device',
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