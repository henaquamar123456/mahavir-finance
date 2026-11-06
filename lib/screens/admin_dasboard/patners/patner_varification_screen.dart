import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

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

  final List<String> _tabs = [
    'KYC Documents',
    'Personal & Business Details',
    'Bank Details',
    'Verification History',
    'Notes (0)',
  ];

  // Partner verification records
  final List<Map<String, dynamic>> _registrationQueue = [
    {
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
    {
      'name': 'Anjali Verma',
      'code': 'DSA011',
      'date': '11 Sep 2024',
      'location': 'Gurugram',
      'status': 'Pending',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'pan': 'DFMNA1234J',
      'bank': 'Axis Bank',
    },
    {
      'name': 'Suresh Patel',
      'code': 'DSA012',
      'date': '10 Sep 2024',
      'location': 'Noida',
      'status': 'Rejected',
      'statusBg': const Color(0xFFFEE2E2),
      'statusCol': const Color(0xFFDC2626),
      'pan': 'EGHPA5678K',
      'bank': 'Kotak Mahindra',
    },
    {
      'name': 'Deepak Kumar',
      'code': 'DSA013',
      'date': '09 Sep 2024',
      'location': 'Faridabad',
      'status': 'Under Review',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'pan': 'FHIJA9012L',
      'bank': 'Punjab National Bank',
    },
    {
      'name': 'Neha Gupta',
      'code': 'DSA014',
      'date': '08 Sep 2024',
      'location': 'Delhi',
      'status': 'Pending',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'pan': 'GJKSA3456M',
      'bank': 'HDFC Bank',
    },
    {
      'name': 'Amit Yadav',
      'code': 'DSA015',
      'date': '07 Sep 2024',
      'location': 'Greater Noida',
      'status': 'Pending',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'pan': 'HKLUA7890N',
      'bank': 'Bank of Baroda',
    },
  ];

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
    final activePartner = _registrationQueue[_selectedPartnerIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Verification',
            value: '8',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Verified Partners',
            value: '72',
            icon: Icons.check_circle_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Under Review',
            value: '4',
            icon: Icons.access_time_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Rejected',
            value: '6',
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
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedLocation,
              items: const [
                'All Locations',
                'Noida',
                'Delhi',
                'Ghaziabad',
                'Gurugram',
                'Faridabad'
              ],
              onChanged: (v) => setState(() => _selectedLocation = v!),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded,
                size: 14, color: AppColors.primary),
            label: const Text('Filters',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 6),
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
              children: const [
                Text(
                  'Partner Registrations (8)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
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
                      ? const Color(0xFFE6F7F2).withOpacity(0.6)
                      : Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor:
                        const Color(0xFF0F3E38).withOpacity(0.1),
                        child: Text(
                          (item['name'] as String)[0],
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
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Showing 1 to 8 of 8 partners',
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
                Text('10 per page',
                    style: TextStyle(fontSize: 10, color: AppColors.primary)),
              ],
            ),
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
                'View All',
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
            title: 'Aadhaar Card',
            identifier: 'XXXX-XXXX-4589',
            docType: 'National ID',
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
            docType: 'Utility Bill',
            icon: Icons.receipt_long_rounded,
            iconCol: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildKycDocThumbnailCard(
            title: 'Bank Statement',
            identifier: activePartner['bank'] as String,
            docType: 'Last 6 Months',
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
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening full view for $title')),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.visibility_outlined,
                    size: 12, color: Color(0xFF0284C7)),
                SizedBox(width: 4),
                Text(
                  'View Full Image',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationChecklist() {
    final checklist = [
      {'item': 'Aadhaar Card', 'status': 'Verified', 'action': 'View'},
      {'item': 'PAN Card', 'status': 'Verified', 'action': 'View'},
      {'item': 'Address Proof', 'status': 'Pending', 'action': 'View'},
      {'item': 'Bank Details', 'status': 'Pending', 'action': 'View'},
      {'item': 'Photo', 'status': 'Verified', 'action': 'View'},
      {
        'item': 'Business Documents (GST/Proof)',
        'status': 'Not Uploaded',
        'action': 'Upload',
      },
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
              final isPending = c['status'] == 'Pending';

              Color statusBg = const Color(0xFFFEE2E2);
              Color statusCol = const Color(0xFFDC2626);
              if (isVerified) {
                statusBg = const Color(0xFFDCFCE7);
                statusCol = const Color(0xFF16A36A);
              } else if (isPending) {
                statusBg = const Color(0xFFFEF3C7);
                statusCol = const Color(0xFFD97706);
              }

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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        c['status']!,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: statusCol,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        c['action']!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F3E38),
                        ),
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
            subtitle: 'All documents verified and details are correct.',
            value: 'Approve Partner',
          ),
          _buildDecisionRadio(
            title: 'Under Review',
            subtitle: 'Keep for further review or verification.',
            value: 'Under Review',
          ),
          _buildDecisionRadio(
            title: 'Reject Partner',
            subtitle: 'Documents invalid or details incorrect.',
            value: 'Reject Partner',
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _remarksController,
            maxLines: 2,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              hintText: 'Add remarks (Optional)...',
              hintStyle:
              const TextStyle(fontSize: 10.5, color: AppColors.textHint),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Decision recorded: $_verificationDecision (Rejected)'),
                        backgroundColor: const Color(0xFFDC2626),
                      ),
                    );
                  },
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Partner marked as: $_verificationDecision!'),
                        backgroundColor: const Color(0xFF16A36A),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A36A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Approve Partner',
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