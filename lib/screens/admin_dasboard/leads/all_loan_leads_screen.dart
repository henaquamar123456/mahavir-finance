import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import 'lead_details_admin_screen.dart';

class AllLoanLeadsScreen extends StatefulWidget {
  const AllLoanLeadsScreen({super.key});

  @override
  State<AllLoanLeadsScreen> createState() => _AllLoanLeadsScreenState();
}

class _AllLoanLeadsScreenState extends State<AllLoanLeadsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedLoanType = 'All Loan Types';
  String _selectedStatus = 'All Status';
  String _selectedPartner = 'All Partners';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _loanTypes = const [
    'All Loan Types',
    'Home Loan',
    'Car Loan',
    'Personal Loan',
    'Business Loan',
    'Education Loan',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Submitted',
    'Under Review',
    'Approved',
    'Rejected',
  ];

  final List<String> _partnerOptions = const [
    'All Partners',
    'Rahul Kumar (DSA001)',
    'Amit Yadav (DSA002)',
    'Pooja Sharma (DSA004)',
    'Vikas Singh (DSA005)',
    'Deepak Verma (DSA006)',
    'Neha Gupta (DSA008)',
  ];

  final List<String> _dateOptions = const [
    'All Time',
    'Today',
    'This Week',
    'This Month',
    'Last 3 Months',
  ];

  final List<Map<String, dynamic>> _leads = [
    {
      'id': 1,
      'leadId': 'LD0001',
      'name': 'Amit Shah',
      'phone': '+91 9876543210',
      'email': 'amit.shah@gmail.com',
      'loanType': 'Home Loan',
      'amount': '₹ 25,00,000',
      'partner': 'Rahul Kumar',
      'partnerCode': 'DSA001',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'submittedOn': '12 Sep 2024\n10:30 AM',
    },
    {
      'id': 2,
      'leadId': 'LD0002',
      'name': 'Priya Verma',
      'phone': '+91 91234 56789',
      'email': 'priya.verma@gmail.com',
      'loanType': 'Car Loan',
      'amount': '₹ 8,00,000',
      'partner': 'Pooja Sharma',
      'partnerCode': 'DSA004',
      'status': 'Under Review',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'submittedOn': '11 Sep 2024\n02:15 PM',
    },
    {
      'id': 3,
      'leadId': 'LD0003',
      'name': 'Rohan Mehta',
      'phone': '+91 99887 66554',
      'email': 'rohan.mehta@gmail.com',
      'loanType': 'Personal Loan',
      'amount': '₹ 5,00,000',
      'partner': 'Amit Yadav',
      'partnerCode': 'DSA002',
      'status': 'Submitted',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'submittedOn': '10 Sep 2024\n11:20 AM',
    },
    {
      'id': 4,
      'leadId': 'LD0004',
      'name': 'Neha Singh',
      'phone': '+91 98711 22334',
      'email': 'neha.singh@gmail.com',
      'loanType': 'Education Loan',
      'amount': '₹ 10,00,000',
      'partner': 'Vikas Singh',
      'partnerCode': 'DSA005',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'submittedOn': '09 Sep 2024\n04:45 PM',
    },
    {
      'id': 5,
      'leadId': 'LD0005',
      'name': 'Suresh Patel',
      'phone': '+91 87654 32109',
      'email': 'suresh.patel@gmail.com',
      'loanType': 'Business Loan',
      'amount': '₹ 15,00,000',
      'partner': 'Deepak Verma',
      'partnerCode': 'DSA006',
      'status': 'Rejected',
      'statusBg': const Color(0xFFFEE2E2),
      'statusCol': const Color(0xFFDC2626),
      'submittedOn': '09 Sep 2024\n12:10 PM',
    },
    {
      'id': 6,
      'leadId': 'LD0006',
      'name': 'Kavita Sharma',
      'phone': '+91 96543 21098',
      'email': 'kavita.sharma@gmail.com',
      'loanType': 'Home Loan',
      'amount': '₹ 30,00,000',
      'partner': 'Rahul Kumar',
      'partnerCode': 'DSA001',
      'status': 'Under Review',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'submittedOn': '08 Sep 2024\n09:30 AM',
    },
    {
      'id': 7,
      'leadId': 'LD0007',
      'name': 'Vikram Yadav',
      'phone': '+91 98765 01987',
      'email': 'vikram.yadav@gmail.com',
      'loanType': 'Car Loan',
      'amount': '₹ 4,50,000',
      'partner': 'Pooja Sharma',
      'partnerCode': 'DSA004',
      'status': 'Approved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'submittedOn': '07 Sep 2024\n06:20 PM',
    },
    {
      'id': 8,
      'leadId': 'LD0008',
      'name': 'Anjali Sinha',
      'phone': '+91 91230 44556',
      'email': 'anjali.sinha@gmail.com',
      'loanType': 'Personal Loan',
      'amount': '₹ 7,50,000',
      'partner': 'Amit Yadav',
      'partnerCode': 'DSA002',
      'status': 'Submitted',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'submittedOn': '06 Sep 2024\n03:50 PM',
    },
    {
      'id': 9,
      'leadId': 'LD0009',
      'name': 'Deepak Kumar',
      'phone': '+91 99876 54321',
      'email': 'deepak.kumar@gmail.com',
      'loanType': 'Education Loan',
      'amount': '₹ 20,00,000',
      'partner': 'Vikas Singh',
      'partnerCode': 'DSA005',
      'status': 'Under Review',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'submittedOn': '05 Sep 2024\n11:10 AM',
    },
    {
      'id': 10,
      'leadId': 'LD0010',
      'name': 'Ritu Singh',
      'phone': '+91 94123 67890',
      'email': 'ritu.singh@gmail.com',
      'loanType': 'Business Loan',
      'amount': '₹ 6,00,000',
      'partner': 'Neha Gupta',
      'partnerCode': 'DSA008',
      'status': 'Rejected',
      'statusBg': const Color(0xFFFEE2E2),
      'statusCol': const Color(0xFFDC2626),
      'submittedOn': '04 Sep 2024\n01:40 PM',
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
      _selectedPartner = 'All Partners';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  void _openAddLeadModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String loanType = 'Home Loan';
    String partner = 'Rahul Kumar (DSA001)';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add New Loan Lead',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
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
          width: 440,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration: _inputDecoration('Customer Name *', 'Amit Shah'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                    (v == null || v.trim().length != 10) ? '10 digits' : null,
                    decoration: _inputDecoration(
                        'Mobile Number *', '9876543210',
                        prefix: '+91 '),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: loanType,
                    items: const [
                      'Home Loan',
                      'Personal Loan',
                      'Car Loan',
                      'Business Loan',
                      'Education Loan'
                    ]
                        .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t,
                          style: const TextStyle(fontSize: 12)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        loanType = val;
                      }
                    },
                    decoration: _inputDecoration('Loan Type', ''),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration:
                    _inputDecoration('Requested Loan Amount *', '25,00,000'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: partner,
                    items: _partnerOptions
                        .where((p) => p != 'All Partners')
                        .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p,
                          style: const TextStyle(fontSize: 12)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        partner = val;
                      }
                    },
                    decoration: _inputDecoration('Select Partner (DSA)', ''),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Loan lead created and added to pipeline!'),
                    backgroundColor: Color(0xFF0F3E38),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Submit Lead',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      hintText: hint,
      prefixText: prefix,
      prefixStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              _buildHeaderSection(),
              const SizedBox(height: 16),
              _buildTopMetricsRow(),
              const SizedBox(height: 16),
              _buildFilterToolbar(),
              const SizedBox(height: 16),
              _buildLoanLeadsDataTable(),
              const SizedBox(height: 14),
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'All Loan Leads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View and manage all loan inquiries from customers and partner (DSA) referrals.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _openAddLeadModal,
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Add New Lead',
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Exporting loan leads to CSV/Excel...')),
                );
              },
              icon: const Icon(Icons.download_rounded,
                  size: 16, color: AppColors.primary),
              label: const Text(
                'Export',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Leads',
            value: '248',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '+26 this month',
            icon: Icons.assignment_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Submitted',
            value: '86',
            badgeText: '↑ 10%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: '34.7% of total',
            icon: Icons.send_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
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
            subtitle: '25% of total',
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
            subtitle: '29% of total',
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
            subtitle: '11.3% of total',
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                    color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                  radius: 12,
                  backgroundColor: iconBg,
                  child: Icon(icon, size: 14, color: iconColor)),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(subtitle,
              style:
              const TextStyle(fontSize: 9.5, color: AppColors.textHint)),
        ],
      ),
    );
  }

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
                  hintText: 'Search by name, mobile, email, lead ID...',
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
              value: _selectedPartner,
              items: _partnerOptions,
              onChanged: (v) => setState(() => _selectedPartner = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedDateRange,
              items: _dateOptions,
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedDateRange = v!),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _buildLoanLeadsDataTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
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
                            List.generate(_leads.length, (i) => i));
                      } else {
                        _selectedRows.clear();
                      }
                    });
                  },
                ),
              ),
              const DataColumn(label: Text('#', style: _headerStyle)),
              const DataColumn(label: Text('Lead ID', style: _headerStyle)),
              const DataColumn(
                  label: Text('Customer Details', style: _headerStyle)),
              const DataColumn(label: Text('Loan Type', style: _headerStyle)),
              const DataColumn(
                  label: Text('Requested Amount', style: _headerStyle)),
              const DataColumn(
                  label: Text('Partner (DSA)', style: _headerStyle)),
              const DataColumn(label: Text('Status', style: _headerStyle)),
              const DataColumn(
                  label: Text('Submitted On', style: _headerStyle)),
              const DataColumn(label: Text('Actions', style: _headerStyle)),
            ],
            rows: List.generate(_leads.length, (index) {
              final item = _leads[index];
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
                              _selectedRows.length == _leads.length;
                        });
                      },
                    ),
                  ),
                  DataCell(Text('${item['id']}',
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textSecondary))),
                  DataCell(
                    Text(
                      item['leadId'] as String,
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F3E38)),
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'] as String,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                        Text('${item['phone']}  •  ${item['email']}',
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  DataCell(Text(item['loanType'] as String,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textPrimary))),
                  DataCell(Text(item['amount'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary))),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['partner'] as String,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        Text(item['partnerCode'] as String,
                            style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F3E38))),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: item['statusBg'] as Color,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: item['statusCol'] as Color),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item['submittedOn'] as String,
                      style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                          height: 1.2),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined,
                              size: 16, color: Color(0xFF0284C7)),
                          tooltip: 'Review Lead',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LeadDetailsAdminScreen(leadData: item),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 16, color: Color(0xFF0F3E38)),
                          tooltip: 'Edit Lead',
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert_rounded,
                              size: 16, color: AppColors.iconSecondary),
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
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 248 leads',
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
                  items: [10, 25, 50, 100]
                      .map((n) =>
                      DropdownMenuItem(value: n, child: Text('$n per page')))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _rowsPerPage = val);
                    }
                  },
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