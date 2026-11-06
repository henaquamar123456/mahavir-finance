import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import 'customer_details_admin_screen.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedLoanType = 'All Loan Types';
  String _selectedStatus = 'All Status';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  int _currentPage = 1;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _loanTypes = [
    'All Loan Types',
    'Home Loan',
    'Personal Loan',
    'Car Loan',
    'Business Loan',
    'Education Loan',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Active',
    'Inactive',
  ];

  final List<String> _dateOptions = [
    'All Time',
    'Today',
    'This Week',
    'This Month',
    'Last 3 Months',
  ];

  // PDF Page 2 ke sabhi 10 records
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 1,
      'code': 'CUST001234',
      'name': 'Amit Shah',
      'phone': '+91 9876543210',
      'email': 'amit.shah@gmail.com',
      'loanType': 'Home Loan',
      'loanAmount': '₹ 25,00,000',
      'status': 'Active',
      'registeredOn': '12 Sep 2024\n10:30 AM',
    },
    {
      'id': 2,
      'code': 'CUST001235',
      'name': 'Priya Verma',
      'phone': '+91 9123456789',
      'email': 'priya.verma@gmail.com',
      'loanType': 'Car Loan',
      'loanAmount': '₹ 8,00,000',
      'status': 'Active',
      'registeredOn': '11 Sep 2024\n02:15 PM',
    },
    {
      'id': 3,
      'code': 'CUST001236',
      'name': 'Rohan Mehta',
      'phone': '+91 99887 66554',
      'email': 'rohan.mehta@gmail.com',
      'loanType': 'Personal Loan',
      'loanAmount': '₹ 5,00,000',
      'status': 'Active',
      'registeredOn': '10 Sep 2024\n11:20 AM',
    },
    {
      'id': 4,
      'code': 'CUST001237',
      'name': 'Neha Singh',
      'phone': '+91 98711 22334',
      'email': 'neha.singh@gmail.com',
      'loanType': 'Education Loan',
      'loanAmount': '₹ 10,00,000',
      'status': 'Inactive',
      'registeredOn': '09 Sep 2024\n04:45 PM',
    },
    {
      'id': 5,
      'code': 'CUST001238',
      'name': 'Suresh Patel',
      'phone': '+91 87654 32109',
      'email': 'suresh.patel@gmail.com',
      'loanType': 'Business Loan',
      'loanAmount': '₹ 15,00,000',
      'status': 'Active',
      'registeredOn': '09 Sep 2024\n12:10 PM',
    },
    {
      'id': 6,
      'code': 'CUST001239',
      'name': 'Kavita Sharma',
      'phone': '+91 96543 21098',
      'email': 'kavita.sharma@gmail.com',
      'loanType': 'Home Loan',
      'loanAmount': '₹ 30,00,000',
      'status': 'Active',
      'registeredOn': '08 Sep 2024\n09:30 AM',
    },
    {
      'id': 7,
      'code': 'CUST001240',
      'name': 'Vikram Yadav',
      'phone': '+91 98765 01987',
      'email': 'vikram.yadav@gmail.com',
      'loanType': 'Personal Loan',
      'loanAmount': '₹ 4,50,000',
      'status': 'Inactive',
      'registeredOn': '07 Sep 2024\n06:20 PM',
    },
    {
      'id': 8,
      'code': 'CUST001241',
      'name': 'Anjali Sinha',
      'phone': '+91 91230 44556',
      'email': 'anjali.sinha@gmail.com',
      'loanType': 'Car Loan',
      'loanAmount': '₹ 7,50,000',
      'status': 'Active',
      'registeredOn': '06 Sep 2024\n03:50 PM',
    },
    {
      'id': 9,
      'code': 'CUST001242',
      'name': 'Deepak Kumar',
      'phone': '+91 99876 54321',
      'email': 'deepak.kumar@gmail.com',
      'loanType': 'Business Loan',
      'loanAmount': '₹ 20,00,000',
      'status': 'Active',
      'registeredOn': '05 Sep 2024\n11:10 AM',
    },
    {
      'id': 10,
      'code': 'CUST001243',
      'name': 'Ritu Singh',
      'phone': '+91 94123 67890',
      'email': 'ritu.singh@gmail.com',
      'loanType': 'Education Loan',
      'loanAmount': '₹ 6,00,000',
      'status': 'Active',
      'registeredOn': '04 Sep 2024\n01:40 PM',
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
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  void _openAddCustomerModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String loanType = 'Home Loan';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add New Customer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
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
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration: _dialogInputDecoration('Full Name *', 'Amit Shah'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length != 10) ? '10 digits' : null,
                    decoration: _dialogInputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _dialogInputDecoration('Email Address', 'customer@gmail.com'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: loanType,
                    items: ['Home Loan', 'Personal Loan', 'Car Loan', 'Business Loan', 'Education Loan']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (val) => loanType = val!,
                    decoration: _dialogInputDecoration('Interested Loan Type', ''),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _dialogInputDecoration('Requested Amount (₹)', '25,00,000'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Customer registered successfully!'),
                    backgroundColor: Color(0xFF0F3E38),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Create Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  InputDecoration _dialogInputDecoration(String label, String hint, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      hintText: hint,
      prefixText: prefix,
      prefixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              // Header Title and Add Customer Button
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total, Active, Inactive, New)[cite: 2]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Filter & Search Toolbar[cite: 2]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Customer Data Table[cite: 2]
              _buildCustomerDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 2]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 2]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Customer Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View, search and manage all registered customers.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        // Wrap ki jagah seedhe ElevatedButton ya Row(mainAxisSize: MainAxisSize.min) rakhein:
        ElevatedButton.icon(
          onPressed: _openAddCustomerModal,
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Add New Customer',
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F3E38),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // 1. Top 4 Metric Cards[cite: 2]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Customers',
            value: '1,248',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '+132 this month',
            icon: Icons.groups_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Active Customers',
            value: '1,056',
            badgeText: '↑ 10%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '84.6% of total',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Inactive Customers',
            value: '142',
            badgeText: '↓ 5%',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: '11.4% of total',
            icon: Icons.cancel_outlined,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'New Customers',
            value: '132',
            badgeText: '↑ 20%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'This month',
            icon: Icons.person_add_alt_rounded,
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
              Text(title, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: iconBg, child: Icon(icon, size: 16, color: iconColor)),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Filter Toolbar[cite: 2]
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
          // Search Field
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
                  hintText: 'Search by name, mobile, email...',
                  hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded, size: 17, color: AppColors.iconSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Loan Type Filter
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedLoanType,
              items: _loanTypes,
              onChanged: (v) => setState(() => _selectedLoanType = v!),
            ),
          ),
          const SizedBox(width: 10),

          // Status Filter
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedStatus,
              items: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),

          // Date Range Filter
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

          // Reset Button
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
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // 3. Customer Data Table[cite: 2]
  Widget _buildCustomerDataTable() {
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
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            headingRowHeight: 44,
            dataRowMinHeight: 52,
            dataRowMaxHeight: 56,
            horizontalMargin: 14,
            columnSpacing: 24,
            columns: [
              DataColumn(
                label: Checkbox(
                  value: _selectAll,
                  activeColor: const Color(0xFF0F3E38),
                  onChanged: (val) {
                    setState(() {
                      _selectAll = val ?? false;
                      if (_selectAll) {
                        _selectedRows.addAll(List.generate(_customers.length, (i) => i));
                      } else {
                        _selectedRows.clear();
                      }
                    });
                  },
                ),
              ),
              const DataColumn(label: Text('#', style: _headerStyle)),
              const DataColumn(label: Text('Customer Name', style: _headerStyle)),
              const DataColumn(label: Text('Contact Details', style: _headerStyle)),
              const DataColumn(label: Text('Loan Type', style: _headerStyle)),
              const DataColumn(label: Text('Loan Amount', style: _headerStyle)),
              const DataColumn(label: Text('Status', style: _headerStyle)),
              const DataColumn(label: Text('Registered On', style: _headerStyle)),
              const DataColumn(label: Text('Actions', style: _headerStyle)),
            ],
            rows: List.generate(_customers.length, (index) {
              final item = _customers[index];
              final isSelected = _selectedRows.contains(index);
              final isActive = item['status'] == 'Active';

              return DataRow(
                selected: isSelected,
                onSelectChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedRows.add(index);
                    } else {
                      _selectedRows.remove(index);
                    }
                    _selectAll = _selectedRows.length == _customers.length;
                  });
                },
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
                          _selectAll = _selectedRows.length == _customers.length;
                        });
                      },
                    ),
                  ),
                  DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                          child: Text(
                            (item['name'] as String)[0],
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item['name'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['phone'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        Text(item['email'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  DataCell(Text(item['loanType'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
                  DataCell(Text(item['loanAmount'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive ? const Color(0xFF16A36A) : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item['registeredOn'] as String,
                      style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.2),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // View Action -> Navigates to Page 3 (Customer Details)
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
                          tooltip: 'View Details',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerDetailsAdminScreen(customerData: item),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                          tooltip: 'Edit Customer',
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
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // 4. Pagination Footer[cite: 2]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 1,248 customers',
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
            _buildPageButton('125'),
            const SizedBox(width: 4),
            _buildPageButton('>'),
          ],
        ),
      ],
    );
  }

  Widget _buildPageButton(String text, {bool isSelected = false, bool isEnabled = true}) {
    return InkWell(
      onTap: isEnabled ? () {

      } : null,
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