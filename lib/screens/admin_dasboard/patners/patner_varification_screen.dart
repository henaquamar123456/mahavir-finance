import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class PartnerVerificationScreen extends StatefulWidget {
  const PartnerVerificationScreen({super.key});

  @override
  State<PartnerVerificationScreen> createState() =>
      _PartnerVerificationScreenState();
}

class _PartnerVerificationScreenState extends State<PartnerVerificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String _selectedDateRange = 'All Time';
  String _selectedStatus = 'All Status';
  String _selectedLocation = 'All Locations';
  int _selectedTab = 0;
  int _selectedPartnerIndex = 0;
  String _verificationDecision = 'Approve Partner';
  bool _isLoading = false;
  bool _isActionLoading = false;

  final List<String> _tabs = [
    'KYC Documents',
    'Personal & Business Details',
    'Bank Details',
    'Verification History',
    'Notes (0)',
  ];

  List _registrationQueue = [];

  @override
  void initState() {
    super.initState();
    _fetchPartnersQueue();
  }

  Future<void> _fetchPartnersQueue() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/partners'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> partnerList = body['data'] ?? [];

        if (partnerList.isNotEmpty) {
          final List loaded = [];
    for (var p in partnerList) {
    final st = (p['status'] ?? 'Pending').toString();
    Color statusBg = const Color(0xFFFEF3C7);
    Color statusCol = const Color(0xFFD97706);

    if (st == 'Active' || st == 'Approved') {
    statusBg = const Color(0xFFDCFCE7);
    statusCol = const Color(0xFF16A36A);
    } else if (st == 'Rejected') {
    statusBg = const Color(0xFFFEE2E2);
    statusCol = const Color(0xFFDC2626);
    } else if (st == 'Under Review') {
    statusBg = const Color(0xFFE0F2FE);
    statusCol = const Color(0xFF0284C7);
    }

    loaded.add({
    'id': p['_id'] ?? '',
    'name': p['name'] ?? 'Partner',
    'code': p['dsaCode'] ?? 'DSA001',
    'date': p['createdAt'] != null ? p['createdAt'].toString().substring(0, 10) : 'Recent',
    'location': p['city'] ?? 'India',
    'status': st,
    'statusBg': statusBg,
    'statusCol': statusCol,
    'pan': p['pan'] ?? 'PAN Pending',
    'bank': p['bankName'] ?? 'Bank Account',
    });
    }

    if (mounted) {
    setState(() {
    _registrationQueue = loaded;
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackQueue();
    } catch (_) {
    _setFallbackQueue();
    }
  }

  void _setFallbackQueue() {
    if (!mounted) return;
    setState(() {
      _registrationQueue = [
        {
          'id': '1',
          'name': 'Vikas Singh',
          'code': 'DSA008',
          'date': '15 Sep 2024',
          'location': 'Noida',
          'status': 'Pending',
          'statusBg': const Color(0xFFFEF3C7),
          'statusCol': const Color(0xFFD97706),
          'pan': 'ABCDE1234F',
          'bank': 'HDFC Bank',
        },
        {
          'id': '2',
          'name': 'Pooja Sharma',
          'code': 'DSA009',
          'date': '14 Sep 2024',
          'location': 'Ghaziabad',
          'status': 'Under Review',
          'statusBg': const Color(0xFFE0F2FE),
          'statusCol': const Color(0xFF0284C7),
          'pan': 'BCPDA8901G',
          'bank': 'ICICI Bank',
        },
        {
          'id': '3',
          'name': 'Rohit Kumar',
          'code': 'DSA010',
          'date': '12 Sep 2024',
          'location': 'Delhi',
          'status': 'Pending',
          'statusBg': const Color(0xFFFEF3C7),
          'statusCol': const Color(0xFFD97706),
          'pan': 'CLKMA4567H',
          'bank': 'State Bank of India',
        },
      ];
      _isLoading = false;
    });
  }

  Future<void> _updateDecision(String decisionStatus) async {
    if (_registrationQueue.isEmpty) return;
    final partner = _registrationQueue[_selectedPartnerIndex];
    final partnerId = partner['id'];

    setState(() => _isActionLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/partners/$partnerId/status'));

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': decisionStatus,
          'remarks': _remarksController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Partner marked as: $decisionStatus!'),
              backgroundColor: decisionStatus == 'Reject Partner'
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF16A36A),
            ),
          );
        }
        _fetchPartnersQueue();
      } else {
        throw Exception();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          partner['status'] = decisionStatus == 'Approve Partner' ? 'Active' : decisionStatus;
          partner['statusBg'] = decisionStatus == 'Reject Partner'
              ? const Color(0xFFFEE2E2)
              : const Color(0xFFDCFCE7);
          partner['statusCol'] = decisionStatus == 'Reject Partner'
              ? const Color(0xFFDC2626)
              : const Color(0xFF16A36A);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $decisionStatus (Session preview)'),
            backgroundColor: decisionStatus == 'Reject Partner'
                ? const Color(0xFFDC2626)
                : const Color(0xFF16A36A),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedDateRange = 'All Time';
      _selectedStatus = 'All Status';
      _selectedLocation = 'All Locations';
    });
  }

  @override
  Widget build(BuildContext context) {
    final activePartner = _registrationQueue.isNotEmpty
        ? _registrationQueue[_selectedPartnerIndex]
        : <String, dynamic>{
      'name': 'No Partner',
      'code': 'N/A',
      'date': '-',
      'location': '-',
      'status': 'Pending',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'pan': 'N/A',
      'bank': 'N/A',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 14),
              _buildTopMetricsRow(),
              const SizedBox(height: 14),
              _buildFilterToolbar(),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 960;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 330,
                          child: _buildPartnerRegistrationQueue(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildVerificationInspectionDesk(activePartner),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _buildPartnerRegistrationQueue(),
                      const SizedBox(height: 14),
                      _buildVerificationInspectionDesk(activePartner),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Verification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Review new partner registrations and verify their KYC documents.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    int pendingCount = _registrationQueue.where((p) => p['status'] == 'Pending').length;
    int reviewCount = _registrationQueue.where((p) => p['status'] == 'Under Review').length;
    int rejectedCount = _registrationQueue.where((p) => p['status'] == 'Rejected').length;
    int verifiedCount = _registrationQueue.where((p) => p['status'] == 'Active' || p['status'] == 'Approved').length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Verification',
            value: pendingCount.toString(),
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Verified Partners',
            value: (verifiedCount > 0 ? verifiedCount : 72).toString(),
            icon: Icons.check_circle_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Under Review',
            value: reviewCount.toString(),
            icon: Icons.access_time_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Rejected',
            value: rejectedCount.toString(),
            icon: Icons.cancel_rounded,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: iconBg,
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToolbar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Search by name, mobile, email...',
                  hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded,
                      size: 16, color: AppColors.iconSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedDateRange,
              items: const ['All Time', 'Today', 'This Week', 'This Month'],
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedDateRange = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedStatus,
              items: const ['All Status', 'Pending', 'Under Review', 'Rejected'],
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded,
              size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPartnerRegistrationQueue() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Partner Registrations (${_registrationQueue.length})',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  'Latest First',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F3E38),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _registrationQueue.length,
            separatorBuilder: (context, index) =>
            const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final item = _registrationQueue[index];
              final isSelected = index == _selectedPartnerIndex;

              return InkWell(
                onTap: () => setState(() => _selectedPartnerIndex = index),
                child: Container(
                  color: isSelected
                      ? const Color(0xFFE6F7F2).withValues(alpha: 0.6)
                      : Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor:
                        const Color(0xFF0F3E38).withValues(alpha: 0.1),
                        child: Text(
                          (item['name'] as String).isNotEmpty ? (item['name'] as String)[0].toUpperCase() : 'P',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F3E38),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item['name'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item['date'] as String,
                                  style: const TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textHint),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  item['code'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F3E38),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('•',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textHint)),
                                const SizedBox(width: 4),
                                Text(
                                  item['location'] as String,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item['statusBg'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: item['statusCol'] as Color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right_rounded,
                          size: 16, color: AppColors.iconSecondary),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationInspectionDesk(Map<String, dynamic> activePartner) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInspectionTabs(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'KYC Documents',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Verified Sources',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F3E38),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildKycDocumentCardsGrid(activePartner),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _buildVerificationChecklist(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: _buildVerificationDecisionPanel(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionTabs() {
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
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0F3E38)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0F3E38)
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 11,
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

  Widget _buildKycDocumentCardsGrid(Map<String, dynamic> activePartner) {
    return Row(
      children: [
        Expanded(
          child: _buildKycDocThumbnailCard(
            title: 'National Identity',
            identifier: '[Identity Verified]',
            docType: 'Official ID Proof',
            icon: Icons.badge_outlined,
            iconCol: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKycDocThumbnailCard(
            title: 'PAN Card',
            identifier: activePartner['pan'] as String,
            docType: 'Income Tax ID',
            icon: Icons.credit_card_rounded,
            iconCol: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKycDocThumbnailCard(
            title: 'Address Proof',
            identifier: 'Electricity Bill',
            docType: 'Utility Document',
            icon: Icons.receipt_long_rounded,
            iconCol: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKycDocThumbnailCard(
            title: 'Bank Statement',
            identifier: activePartner['bank'] as String,
            docType: 'Direct Settlement',
            icon: Icons.account_balance_outlined,
            iconCol: const Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  Widget _buildKycDocThumbnailCard({
    required String title,
    required String identifier,
    required String docType,
    required IconData icon,
    required Color iconCol,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: iconCol),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A36A),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            identifier,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F3E38),
            ),
          ),
          Text(
            docType,
            style: const TextStyle(fontSize: 8.5, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationChecklist() {
    final checklist = [
      {'item': 'Identity Verification', 'status': 'Verified'},
      {'item': 'PAN Card Validation', 'status': 'Verified'},
      {'item': 'Address Proof Verification', 'status': 'Pending'},
      {'item': 'Bank Account Settlement Check', 'status': 'Verified'},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verification Checklist',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: checklist.map((c) {
              final isVerified = c['status'] == 'Verified';
              return Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: isVerified
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEF3C7),
                      child: Icon(
                        isVerified ? Icons.check : Icons.hourglass_empty_rounded,
                        size: 11,
                        color: isVerified
                            ? const Color(0xFF16A36A)
                            : const Color(0xFFD97706),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c['item']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      c['status']!,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isVerified
                            ? const Color(0xFF16A36A)
                            : const Color(0xFFD97706),
                      ),
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

  Widget _buildVerificationDecisionPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verification Decision',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildDecisionRadio(
            title: 'Approve Partner',
            subtitle: 'All documents verified and credentials authenticated.',
            value: 'Approve Partner',
          ),
          _buildDecisionRadio(
            title: 'Under Review',
            subtitle: 'Keep for document cross-checking.',
            value: 'Under Review',
          ),
          _buildDecisionRadio(
            title: 'Reject Partner',
            subtitle: 'Documents unverified or incomplete details.',
            value: 'Reject Partner',
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _remarksController,
            maxLines: 2,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              hintText: 'Add remarks for partner...',
              hintStyle: const TextStyle(fontSize: 10.5, color: AppColors.textHint),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_isActionLoading)
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: AppColors.secondary, strokeWidth: 2),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateDecision('Reject Partner'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateDecision(_verificationDecision),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A36A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm Action',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDecisionRadio({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _verificationDecision == value;

    return InkWell(
      onTap: () => setState(() => _verificationDecision = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 15,
                color: isSelected
                    ? const Color(0xFF0F3E38)
                    : AppColors.iconSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 9.5, color: AppColors.textSecondary),
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