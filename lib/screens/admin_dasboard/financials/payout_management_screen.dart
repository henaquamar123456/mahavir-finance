import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class PayoutManagementScreen extends StatefulWidget {
  const PayoutManagementScreen({super.key});

  @override
  State<PayoutManagementScreen> createState() => _PayoutManagementScreenState();
}

class _PayoutManagementScreenState extends State<PayoutManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedMonth = 'All Months';
  String _selectedStatus = 'All Status';
  String _selectedMethod = 'All Methods';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _monthOptions = [
    'All Months',
    'September 2024',
    'August 2024',
    'July 2024',
    'June 2024',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Paid',
    'Processing',
    'Failed',
  ];

  final List<String> _methodOptions = [
    'All Methods',
    'Bank Transfer',
    'UPI',
    'NEFT/RTGS',
  ];

  // PDF Page 13 ke sabhi 10 DSA partner payout records
  final List<Map<String, dynamic>> _payouts = [
    {
      'id': 1,
      'payoutId': 'PAY202409001',
      'name': 'Rahul Kumar',
      'code': 'DSA001',
      'phone': '+91 91234 56789',
      'email': 'rahul.kumar@gmail.com',
      'totalLeads': 28,
      'approvedLeads': 18,
      'commission': '₹ 85,000',
      'payoutAmount': '₹ 85,000',
      'tds': '₹ 4,250',
      'netAmount': '₹ 80,750',
      'month': 'Sep 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '05 Oct 2024',
      'requestDate': '02 Oct 2024',
      'method': 'Bank Transfer',
      'bank': 'HDFC Bank',
      'accountNo': 'XXXX XXXX 7890',
      'ifsc': 'HDFC0001234',
      'txnId': 'TXN1234567890',
      'notes':
      'September month commission payout is approved. TDS deducted as per policy.',
    },
    {
      'id': 2,
      'payoutId': 'PAY202409002',
      'name': 'Pooja Sharma',
      'code': 'DSA002',
      'phone': '+91 98765 43210',
      'email': 'pooja.sharma@gmail.com',
      'totalLeads': 24,
      'approvedLeads': 16,
      'commission': '₹ 72,000',
      'payoutAmount': '₹ 72,000',
      'tds': '₹ 3,600',
      'netAmount': '₹ 68,400',
      'month': 'Sep 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '04 Oct 2024',
      'requestDate': '01 Oct 2024',
      'method': 'Bank Transfer',
      'bank': 'ICICI Bank',
      'accountNo': 'XXXX XXXX 1234',
      'ifsc': 'ICIC0002345',
      'txnId': 'TXN1234567891',
      'notes': 'Commission approved and processed successfully.',
    },
    {
      'id': 3,
      'payoutId': 'PAY202409003',
      'name': 'Vikram Yadav',
      'code': 'DSA003',
      'phone': '+91 96543 21098',
      'email': 'vikram.yadav@gmail.com',
      'totalLeads': 32,
      'approvedLeads': 20,
      'commission': '₹ 1,05,000',
      'payoutAmount': '₹ 1,05,000',
      'tds': '₹ 5,250',
      'netAmount': '₹ 99,750',
      'month': 'Sep 2024',
      'status': 'Processing',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'paymentDate': 'Pending',
      'requestDate': '03 Oct 2024',
      'method': 'Bank Transfer',
      'bank': 'SBI Bank',
      'accountNo': 'XXXX XXXX 5678',
      'ifsc': 'SBIN0003456',
      'txnId': 'Pending',
      'notes': 'Under banking verification cycle.',
    },
    {
      'id': 4,
      'payoutId': 'PAY202408004',
      'name': 'Anjali Verma',
      'code': 'DSA004',
      'phone': '+91 98133 44556',
      'email': 'anjali.verma@gmail.com',
      'totalLeads': 18,
      'approvedLeads': 12,
      'commission': '₹ 48,000',
      'payoutAmount': '₹ 48,000',
      'tds': '₹ 2,400',
      'netAmount': '₹ 45,600',
      'month': 'Aug 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '12 Sep 2024',
      'requestDate': '08 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'Axis Bank',
      'accountNo': 'XXXX XXXX 9012',
      'ifsc': 'UTIB0004567',
      'txnId': 'TXN1234567892',
      'notes': 'August payout processed.',
    },
    {
      'id': 5,
      'payoutId': 'PAY202408005',
      'name': 'Neha Gupta',
      'code': 'DSA005',
      'phone': '+91 98712 33445',
      'email': 'neha.gupta@gmail.com',
      'totalLeads': 26,
      'approvedLeads': 15,
      'commission': '₹ 68,000',
      'payoutAmount': '₹ 68,000',
      'tds': '₹ 3,400',
      'netAmount': '₹ 64,600',
      'month': 'Aug 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '10 Sep 2024',
      'requestDate': '06 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'HDFC Bank',
      'accountNo': 'XXXX XXXX 3456',
      'ifsc': 'HDFC0001234',
      'txnId': 'TXN1234567893',
      'notes': 'August payout processed.',
    },
    {
      'id': 6,
      'payoutId': 'PAY202408006',
      'name': 'Suresh Patel',
      'code': 'DSA006',
      'phone': '+91 87654 32109',
      'email': 'suresh.patel@gmail.com',
      'totalLeads': 22,
      'approvedLeads': 10,
      'commission': '₹ 45,000',
      'payoutAmount': '₹ 45,000',
      'tds': '₹ 2,250',
      'netAmount': '₹ 42,750',
      'month': 'Aug 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '08 Sep 2024',
      'requestDate': '05 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'Kotak Bank',
      'accountNo': 'XXXX XXXX 7891',
      'ifsc': 'KKBK0005678',
      'txnId': 'TXN1234567894',
      'notes': 'August payout processed.',
    },
    {
      'id': 7,
      'payoutId': 'PAY202408007',
      'name': 'Deepak Kumar',
      'code': 'DSA007',
      'phone': '+91 99876 54321',
      'email': 'deepak.kumar@gmail.com',
      'totalLeads': 30,
      'approvedLeads': 19,
      'commission': '₹ 92,000',
      'payoutAmount': '₹ 92,000',
      'tds': '₹ 4,600',
      'netAmount': '₹ 87,400',
      'month': 'Aug 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '08 Sep 2024',
      'requestDate': '04 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'Punjab National Bank',
      'accountNo': 'XXXX XXXX 2345',
      'ifsc': 'PUNB0006789',
      'txnId': 'TXN1234567895',
      'notes': 'August payout processed.',
    },
    {
      'id': 8,
      'payoutId': 'PAY202408008',
      'name': 'Ritu Singh',
      'code': 'DSA008',
      'phone': '+91 94123 67890',
      'email': 'ritu.singh@gmail.com',
      'totalLeads': 16,
      'approvedLeads': 9,
      'commission': '₹ 38,000',
      'payoutAmount': '₹ 38,000',
      'tds': '₹ 1,900',
      'netAmount': '₹ 36,100',
      'month': 'Aug 2024',
      'status': 'Failed',
      'statusBg': const Color(0xFFFEE2E2),
      'statusCol': const Color(0xFFDC2626),
      'paymentDate': 'Failed',
      'requestDate': '03 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'Bank of Baroda',
      'accountNo': 'XXXX XXXX 6789',
      'ifsc': 'BARB0007890',
      'txnId': 'FAILED_REV',
      'notes': 'Bank account details mismatch. Needs account reverification.',
    },
    {
      'id': 9,
      'payoutId': 'PAY202408009',
      'name': 'Amit Shah',
      'code': 'DSA009',
      'phone': '+91 98765 43210',
      'email': 'amit.shah@gmail.com',
      'totalLeads': 25,
      'approvedLeads': 14,
      'commission': '₹ 60,000',
      'payoutAmount': '₹ 60,000',
      'tds': '₹ 3,000',
      'netAmount': '₹ 57,000',
      'month': 'Aug 2024',
      'status': 'Paid',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'paymentDate': '06 Sep 2024',
      'requestDate': '02 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'HDFC Bank',
      'accountNo': 'XXXX XXXX 4567',
      'ifsc': 'HDFC0001234',
      'txnId': 'TXN1234567896',
      'notes': 'August payout processed.',
    },
    {
      'id': 10,
      'payoutId': 'PAY202408010',
      'name': 'Kavita Sharma',
      'code': 'DSA010',
      'phone': '+91 96543 21098',
      'email': 'kavita.sharma@gmail.com',
      'totalLeads': 20,
      'approvedLeads': 11,
      'commission': '₹ 50,000',
      'payoutAmount': '₹ 50,000',
      'tds': '₹ 2,500',
      'netAmount': '₹ 47,500',
      'month': 'Aug 2024',
      'status': 'Processing',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'paymentDate': 'Pending',
      'requestDate': '01 Sep 2024',
      'method': 'Bank Transfer',
      'bank': 'Axis Bank',
      'accountNo': 'XXXX XXXX 8901',
      'ifsc': 'UTIB0004567',
      'txnId': 'Pending',
      'notes': 'Under banking clearing cycle.',
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
      _selectedMonth = 'All Months';
      _selectedStatus = 'All Status';
      _selectedMethod = 'All Methods';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 13 ka Payout Details Side Sheet / Modal[cite: 13]
  void _openPayoutDetailsModal(Map<String, dynamic> item) {
    int modalTab = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payout Details',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary),
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
                    // Subtabs: Payout Info, Commission Details, Lead Summary[cite: 13]
                    Row(
                      children: [
                        _buildModalTab(
                          title: 'Payout Info',
                          isSelected: modalTab == 0,
                          onTap: () => setModalState(() => modalTab = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Commission Details',
                          isSelected: modalTab == 1,
                          onTap: () => setModalState(() => modalTab = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Lead Summary',
                          isSelected: modalTab == 2,
                          onTap: () => setModalState(() => modalTab = 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Partner Profile Header Pill[cite: 13]
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
                            backgroundColor:
                            const Color(0xFF0F3E38).withValues(alpha: 0.1),
                            child: Text(
                              (item['name'] as String)[0],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F3E38)),
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
                                      item['name'] as String,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item['code'] as String,
                                      style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0F3E38)),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius:
                                        BorderRadius.circular(4),
                                      ),
                                      child: const Text('Active',
                                          style: TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF16A36A))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('${item['phone']}  •  ${item['email']}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Payout Information Financial Breakdown[cite: 13]
                    const Text(
                      'Payout Information',
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Payout ID', item['payoutId'] as String,
                        'Payout Month', 'September 2024'),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Commission Amount',
                        item['commission'] as String, 'TDS (5%)', '- ${item['tds']}'),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Net Payout Amount',
                        item['netAmount'] as String, 'Payment Method', item['method'] as String,
                        isBoldFirst: true),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Bank Name', item['bank'] as String,
                        'Account Number', item['accountNo'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('IFSC Code', item['ifsc'] as String,
                        'Transaction ID', item['txnId'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Request Date', item['requestDate'] as String,
                        'Payment Date', item['paymentDate'] as String),
                    const Divider(height: 12, color: AppColors.divider),

                    // Internal Remarks / Notes[cite: 13]
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notes',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 3),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            item['notes'] as String,
                            style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textPrimary,
                                height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // Bottom Actions: Download Invoice & Process New Payout[cite: 13]
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Downloading Tax Invoice for ${item['payoutId']}...')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded,
                        size: 15, color: Color(0xFF0F3E38)),
                    label: const Text('Download Invoice',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3E38))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'New Payout batch initialized successfully!'),
                            backgroundColor: Color(0xFF0F3E38)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3E38),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Process New Payout',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModalTab(
      {required String title,
        required bool isSelected,
        required VoidCallback onTap}) {
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

  Widget _buildModalInfoRow(String l1, String v1, String l2, String v2,
      {bool isBoldFirst = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1,
                  style: const TextStyle(
                      fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(
                v1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBoldFirst ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldFirst
                      ? const Color(0xFF0F3E38)
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2,
                  style: const TextStyle(
                      fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(v2,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ],
          ),
        ),
      ],
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
              // Header title and Process Payout action[cite: 13]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total Commission, Pending, Paid, Failed)[cite: 13]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 13]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Partner Payouts Data Table[cite: 13]
              _buildPayoutsDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 13]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 13]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Payout Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage partner payouts, track payment status and view transaction history.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Processing next batch of partner payouts...'),
                backgroundColor: Color(0xFF0F3E38),
              ),
            );
          },
          icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
          label: const Text(
            '+ Process Payout',
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F3E38),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // 1. 4 Metric Cards[cite: 13]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Commission',
            value: '₹ 12,48,500',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'This month',
            icon: Icons.currency_rupee_rounded,
            iconBg: const Color(0xFFE6F7F2),
            iconColor: const Color(0xFF0F3E38),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Payouts',
            value: '₹ 3,20,000',
            badgeText: '↓ 8%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: '24 partners',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Paid Payouts',
            value: '₹ 8,70,500',
            badgeText: '↑ 20%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '32 partners',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Failed Payouts',
            value: '₹ 45,000',
            badgeText: '↑ 15%',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: '3 partners',
            icon: Icons.cancel_outlined,
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
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText,
                    style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                  radius: 14,
                  backgroundColor: iconBg,
                  child: Icon(icon, size: 16, color: iconColor)),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style:
              const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Search & Filter Bar[cite: 13]
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
                  hintText: 'Search by partner name, mobile, payout ID...',
                  hintStyle:
                  TextStyle(fontSize: 11, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded,
                      size: 17, color: AppColors.iconSecondary),
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
              value: _selectedMonth,
              items: _monthOptions,
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedMonth = v!),
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
              value: _selectedMethod,
              items: _methodOptions,
              onChanged: (v) => setState(() => _selectedMethod = v!),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded,
                size: 15, color: AppColors.primary),
            label: const Text('Filters',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset',
                style: TextStyle(
                    fontSize: 11.5,
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
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded,
              size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
          items: items
              .map((i) => DropdownMenuItem(
              value: i,
              child: Text(i, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // 3. Partner Payouts Data Table[cite: 13]
  Widget _buildPayoutsDataTable() {
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
              children: [
                const Text(
                  'Partner Payouts (48)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Exporting partner payouts to Excel...')),
                    );
                  },
                  icon: const Icon(Icons.download_rounded,
                      size: 14, color: AppColors.primary),
                  label: const Text('Export',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
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
                headingRowColor:
                WidgetStateProperty.all(const Color(0xFFF8FAFC)),
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
                            _selectedRows.addAll(
                                List.generate(_payouts.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Partner Details', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Total Leads', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Approved Leads', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Commission', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Payout Amount', style: _headerStyle)),
                  const DataColumn(label: Text('Month', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(
                      label: Text('Payment Date', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(_payouts.length, (index) {
                  final item = _payouts[index];
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
                              _selectAll =
                                  _selectedRows.length == _payouts.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}',
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: const Color(0xFF0F3E38)
                                  .withValues(alpha: 0.1),
                              child: Text(
                                (item['name'] as String)[0],
                                style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F3E38)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'] as String,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary)),
                                Text(
                                    '${item['code']} • ${item['phone']}',
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text('${item['totalLeads']}',
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary))),
                      DataCell(Text('${item['approvedLeads']}',
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A36A)))),
                      DataCell(Text(item['commission'] as String,
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary))),
                      DataCell(Text(item['payoutAmount'] as String,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F3E38)))),
                      DataCell(Text(item['month'] as String,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: item['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: item['statusCol'] as Color,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(item['paymentDate'] as String,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textSecondary))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined,
                                  size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'View Payout Details',
                              onPressed: () => _openPayoutDetailsModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.receipt_long_rounded,
                                  size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Download Invoice',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Invoice for ${item['payoutId']} downloaded.')),
                                );
                              },
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

  // 4. Pagination Footer[cite: 13]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 48 partners',
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
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                  items: [10, 25, 50]
                      .map((n) =>
                      DropdownMenuItem(value: n, child: Text('$n per page')))
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
            _buildPageButton('>'),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(String text,
      {bool isSelected = false, bool isEnabled = true}) {
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
          border: Border.all(
              color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
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