import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class LoanInquiryManagementScreen extends StatefulWidget {
  const LoanInquiryManagementScreen({super.key});

  @override
  State<LoanInquiryManagementScreen> createState() =>
      _LoanInquiryManagementScreenState();
}

class _LoanInquiryManagementScreenState
    extends State<LoanInquiryManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedLoanType = 'All Loan Types';
  String _selectedStatus = 'All Status';
  String _selectedSource = 'All Sources';
  String _selectedTeamMember = 'All Team Members';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _loanTypes = [
    'All Loan Types',
    'Home Loan',
    'Car Loan',
    'Personal Loan',
    'Business Loan',
    'Education Loan',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Submitted',
    'Under Review',
    'Approved',
    'Rejected',
  ];

  final List<String> _sourceOptions = [
    'All Sources',
    'Mobile App',
    'Website',
    'Partner (DSA)',
    'Walk-in',
  ];

  final List<String> _teamMembers = [
    'All Team Members',
    'Rahul Kumar',
    'Pooja Sharma',
    'Amit Yadav',
    'Vikash Singh',
    'Neha Gupta',
  ];

  // PDF Page 11 ke sabhi 10 loan inquiries ka data[cite: 11]
  final List<Map<String, dynamic>> _inquiries = [
    {
      'id': 1,
      'name': 'Amit Shah',
      'phone': '+91 9876543210',
      'email': 'amit.shah@gmail.com',
      'city': 'Noida, Uttar Pradesh',
      'loanType': 'Home Loan',
      'amount': '₹ 25,00,000',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'assignedTo': 'Rahul Kumar',
      'source': 'Mobile App',
      'tenure': '20 Years',
      'purpose': 'Purchase a new house',
      'expectedDisbursal': 'Oct 2024',
      'inquiryDate': '12 Sep 2024\n10:30 AM',
    },
    {
      'id': 2,
      'name': 'Priya Verma',
      'phone': '+91 91234 56789',
      'email': 'priya.verma@gmail.com',
      'city': 'Ghaziabad, Uttar Pradesh',
      'loanType': 'Car Loan',
      'amount': '₹ 8,00,000',
      'status': 'Under Review',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'assignedTo': 'Pooja Sharma',
      'source': 'Website',
      'tenure': '5 Years',
      'purpose': 'Purchase new car',
      'expectedDisbursal': 'Sep 2024',
      'inquiryDate': '11 Sep 2024\n02:15 PM',
    },
    {
      'id': 3,
      'name': 'Rohan Mehta',
      'phone': '+91 99887 66554',
      'email': 'rohan.mehta@gmail.com',
      'city': 'Gurugram, Haryana',
      'loanType': 'Personal Loan',
      'amount': '₹ 5,00,000',
      'status': 'Submitted',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'assignedTo': 'Amit Yadav',
      'source': 'Mobile App',
      'tenure': '3 Years',
      'purpose': 'Home renovation',
      'expectedDisbursal': 'Sep 2024',
      'inquiryDate': '10 Sep 2024\n11:20 AM',
    },
    {
      'id': 4,
      'name': 'Neha Singh',
      'phone': '+91 98711 22334',
      'email': 'neha.singh@gmail.com',
      'city': 'Delhi',
      'loanType': 'Education Loan',
      'amount': '₹ 10,00,000',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'assignedTo': 'Vikash Singh',
      'source': 'Partner (DSA)',
      'tenure': '7 Years',
      'purpose': 'Higher studies',
      'expectedDisbursal': 'Oct 2024',
      'inquiryDate': '09 Sep 2024\n04:45 PM',
    },
    {
      'id': 5,
      'name': 'Suresh Patel',
      'phone': '+91 87654 32109',
      'email': 'suresh.patel@gmail.com',
      'city': 'Noida, Uttar Pradesh',
      'loanType': 'Business Loan',
      'amount': '₹ 15,00,000',
      'status': 'Rejected',
      'statusBg': const Color(0xFFFEE2E2),
      'statusCol': const Color(0xFFDC2626),
      'assignedTo': 'Deepak Verma',
      'source': 'Walk-in',
      'tenure': '5 Years',
      'purpose': 'Working capital expansion',
      'expectedDisbursal': 'Sep 2024',
      'inquiryDate': '09 Sep 2024\n12:10 PM',
    },
    {
      'id': 6,
      'name': 'Kavita Sharma',
      'phone': '+91 96543 21098',
      'email': 'kavita.sharma@gmail.com',
      'city': 'Faridabad, Haryana',
      'loanType': 'Home Loan',
      'amount': '₹ 30,00,000',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'assignedTo': 'Rahul Kumar',
      'source': 'Website',
      'tenure': '25 Years',
      'purpose': 'Villa purchase',
      'expectedDisbursal': 'Nov 2024',
      'inquiryDate': '08 Sep 2024\n09:30 AM',
    },
    {
      'id': 7,
      'name': 'Vikram Yadav',
      'phone': '+91 98765 01987',
      'email': 'vikram.yadav@gmail.com',
      'city': 'Noida, Uttar Pradesh',
      'loanType': 'Car Loan',
      'amount': '₹ 4,50,000',
      'status': 'Submitted',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'assignedTo': 'Pooja Sharma',
      'source': 'Mobile App',
      'tenure': '4 Years',
      'purpose': 'Used car loan',
      'expectedDisbursal': 'Sep 2024',
      'inquiryDate': '07 Sep 2024\n06:20 PM',
    },
    {
      'id': 8,
      'name': 'Anjali Sinha',
      'phone': '+91 91230 44556',
      'email': 'anjali.sinha@gmail.com',
      'city': 'Delhi',
      'loanType': 'Personal Loan',
      'amount': '₹ 7,50,000',
      'status': 'Under Review',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'assignedTo': 'Amit Yadav',
      'source': 'Partner (DSA)',
      'tenure': '3 Years',
      'purpose': 'Medical treatment',
      'expectedDisbursal': 'Sep 2024',
      'inquiryDate': '06 Sep 2024\n03:50 PM',
    },
    {
      'id': 9,
      'name': 'Deepak Kumar',
      'phone': '+91 99876 54321',
      'email': 'deepak.kumar@gmail.com',
      'city': 'Noida, Uttar Pradesh',
      'loanType': 'Education Loan',
      'amount': '₹ 20,00,000',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'assignedTo': 'Vikash Singh',
      'source': 'Website',
      'tenure': '10 Years',
      'purpose': 'Overseas MBA',
      'expectedDisbursal': 'Nov 2024',
      'inquiryDate': '05 Sep 2024\n11:10 AM',
    },
    {
      'id': 10,
      'name': 'Ritu Singh',
      'phone': '+91 94123 67890',
      'email': 'ritu.singh@gmail.com',
      'city': 'Greater Noida, Uttar Pradesh',
      'loanType': 'Business Loan',
      'amount': '₹ 6,00,000',
      'status': 'Rejected',
      'statusBg': const Color(0xFFFEE2E2),
      'statusCol': const Color(0xFFDC2626),
      'assignedTo': 'Neha Gupta',
      'source': 'Mobile App',
      'tenure': '2 Years',
      'purpose': 'Shop inventory expansion',
      'expectedDisbursal': 'Sep 2024',
      'inquiryDate': '04 Sep 2024\n01:40 PM',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedLoanType = 'All Loan Types';
      _selectedStatus = 'All Status';
      _selectedSource = 'All Sources';
      _selectedTeamMember = 'All Team Members';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 11 ka Inquiry Details Side Sheet / Modal[cite: 11]
  void _openInquiryDetailsModal(Map<String, dynamic> inq) {
    int modalTab = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Inquiry Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtabs: Inquiry Details, Documents (4), Notes (2)[cite: 11]
                    Row(
                      children: [
                        _buildModalTab(
                          title: 'Inquiry Details',
                          isSelected: modalTab == 0,
                          onTap: () => setModalState(() => modalTab = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Documents (4)',
                          isSelected: modalTab == 1,
                          onTap: () => setModalState(() => modalTab = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Notes (2)',
                          isSelected: modalTab == 2,
                          onTap: () => setModalState(() => modalTab = 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Customer Profile Pill[cite: 11]
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                            child: Text(
                              (inq['name'] as String)[0],
                              style: const TextStyle(
                                fontSize: 14,
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
                                    Text(
                                      inq['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: inq['statusBg'] as Color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        inq['status'] as String,
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                          color: inq['statusCol'] as Color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('${inq['phone']}  •  ${inq['email']}',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                Text(inq['city'] as String,
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Loan Information Grid[cite: 11]
                    const Text(
                      'Loan Information',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Loan Type', inq['loanType'] as String, 'Requested Amount', inq['amount'] as String, isBoldSecond: true),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Loan Tenure', inq['tenure'] as String, 'Purpose', inq['purpose'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Property Location', inq['city'] as String, 'Expected Disbursal', inq['expectedDisbursal'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Source', inq['source'] as String, 'Status', inq['status'] as String),
                    const Divider(height: 12, color: AppColors.divider),

                    // Assigned To Block[cite: 11]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Assigned To', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text('${inq['assignedTo']} (Loan Officer)',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Change',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Inquiry Timeline[cite: 11]
                    const Text(
                      'Inquiry Timeline',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 10),
                    _buildTimelineStep('Inquiry Submitted', '12 Sep 2024, 10:30 AM', isDone: true),
                    _buildTimelineStep('Documents Uploaded', '12 Sep 2024, 11:15 AM', isDone: true),
                    _buildTimelineStep('Under Review', '13 Sep 2024, 02:15 PM', isCurrent: true),
                    _buildTimelineStep('Next Follow-up', '15 Sep 2024 (Scheduled)', isScheduled: true, isLast: true),
                  ],
                ),
              ),
            ),
            actions: [
              // Bottom Action Buttons: Approve, Reject, Add Note[cite: 11]
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.edit_note_rounded, size: 15, color: Color(0xFF0F3E38)),
                    label: const Text('Add Note',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Inquiry Rejected!'), backgroundColor: Color(0xFFDC2626)),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFDC2626)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('✕ Reject',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFDC2626))),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Inquiry Approved and Lead created!'), backgroundColor: Color(0xFF16A36A)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A36A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('✓ Approve',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModalTab({required String title, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F3E38) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildModalInfoRow(String l1, String v1, String l2, String v2, {bool isBoldSecond = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(v1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(
                v2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBoldSecond ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldSecond ? const Color(0xFF0F3E38) : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String title, String subtitle,
      {bool isDone = false, bool isCurrent = false, bool isScheduled = false, bool isLast = false}) {
    Color col = AppColors.textHint;
    if (isDone) col = const Color(0xFF16A36A);
    if (isCurrent) col = const Color(0xFF0284C7);
    if (isScheduled) col = const Color(0xFFD97706);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: col.withValues(alpha: 0.2),
                child: CircleAvatar(radius: 3, backgroundColor: col),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? const Color(0xFF16A36A) : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: col)),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title and actions[cite: 11]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. Five Metric Cards (Total, Under Review, Approved, Rejected, Pending Follow-up)[cite: 11]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 11]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Loan Inquiries Data Table[cite: 11]
              _buildLoanInquiriesDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 11]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 11]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Loan Inquiry Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track and manage all customer loan inquiries from all channels.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Add New Inquiry',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting loan inquiries report...')),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 16, color: AppColors.primary),
              label: const Text(
                'Export ▾',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 1. Five Metric Cards[cite: 11]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Inquiries',
            value: '248',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'All channels',
            icon: Icons.help_outline_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Under Review',
            value: '62',
            badgeText: '↓ 8%',
            badgeBg: const Color(0xFFE0F2FE),
            badgeColor: const Color(0xFF0284C7),
            subtitle: 'In credit review',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Approved',
            value: '72',
            badgeText: '↑ 18%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Ready to disburse',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Rejected',
            value: '28',
            badgeText: '↓ 14%',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: 'Criteria not met',
            icon: Icons.cancel_outlined,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Follow-up',
            value: '86',
            badgeText: '34.7%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Awaiting customer response',
            icon: Icons.phone_forwarded_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: iconBg, child: Icon(icon, size: 14, color: iconColor)),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(fontSize: 9.5, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Search & Filter Bar[cite: 11]
  Widget _buildFilterToolbar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Search inquiries by name, mobile, loan type, status...',
                  hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded, size: 17, color: AppColors.iconSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedLoanType,
              items: _loanTypes,
              onChanged: (v) => setState(() => _selectedLoanType = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedStatus,
              items: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedSource,
              items: _sourceOptions,
              onChanged: (v) => setState(() => _selectedSource = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedTeamMember,
              items: _teamMembers,
              onChanged: (v) => setState(() => _selectedTeamMember = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedDateRange,
              items: ['All Time', 'Today', 'This Week', 'This Month'],
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedDateRange = v!),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // 3. Loan Inquiries Data Table[cite: 11]
  Widget _buildLoanInquiriesDataTable() {
    return Container(
      width: double.infinity,
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
                  'Loan Inquiries (248)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                Text(
                  'Latest First ▾',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                headingRowHeight: 44,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 56,
                horizontalMargin: 14,
                columnSpacing: 22,
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: _selectAll,
                      activeColor: const Color(0xFF0F3E38),
                      onChanged: (val) {
                        setState(() {
                          _selectAll = val ?? false;
                          if (_selectAll) {
                            _selectedRows.addAll(List.generate(_inquiries.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(label: Text('Customer Details', style: _headerStyle)),
                  const DataColumn(label: Text('Loan Type', style: _headerStyle)),
                  const DataColumn(label: Text('Requested Amount', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Assigned To', style: _headerStyle)),
                  const DataColumn(label: Text('Inquiry Date', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(_inquiries.length, (index) {
                  final item = _inquiries[index];
                  final isSelected = _selectedRows.contains(index);

                  return DataRow(
                    selected: isSelected,
                    cells: [
                      DataCell(
                        Checkbox(
                          value: isSelected,
                          activeColor: const Color(0xFF0F3E38),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedRows.add(index);
                              } else {
                                _selectedRows.remove(index);
                              }
                              _selectAll = _selectedRows.length == _inquiries.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'] as String,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            Text('${item['phone']}  •  ${item['city']}',
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      DataCell(Text(item['loanType'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
                      DataCell(Text(item['amount'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: item['statusBg'] as Color, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: item['statusCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                              child: Text(
                                (item['assignedTo'] as String)[0],
                                style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(item['assignedTo'] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          item['inquiryDate'] as String,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.2),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // View details action button[cite: 11]
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'View Inquiry Details',
                              onPressed: () => _openInquiryDetailsModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit Inquiry',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert_rounded, size: 16, color: AppColors.iconSecondary),
                              tooltip: 'More',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // 4. Pagination Footer[cite: 11]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 248 inquiries',
          style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
        Row(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _rowsPerPage,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                  items: [10, 25, 50, 100]
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n per page')))
                      .toList(),
                  onChanged: (val) => setState(() => _rowsPerPage = val!),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildPageButton('<', isEnabled: false),
            const SizedBox(width: 4),
            _buildPageButton('1', isSelected: true),
            const SizedBox(width: 4),
            _buildPageButton('2'),
            const SizedBox(width: 4),
            _buildPageButton('3'),
            const SizedBox(width: 4),
            _buildPageButton('4'),
            const SizedBox(width: 4),
            _buildPageButton('5'),
            const SizedBox(width: 4),
            const Text('...', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            _buildPageButton('25'),
            const SizedBox(width: 4),
            _buildPageButton('>'),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(String text, {bool isSelected = false, bool isEnabled = true}) {
    return InkWell(
      onTap: isEnabled ? () {} : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : isEnabled
                ? AppColors.primary
                : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}