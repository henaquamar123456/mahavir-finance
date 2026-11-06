import 'package:flutter/material.dart';
import 'package:mahavir_finance/screens/admin_dasboard/patners/patners_details_screen.dart';

import '../../../../constants/app_colors.dart';

class PartnerManagementScreen extends StatefulWidget {
  const PartnerManagementScreen({super.key});

  @override
  State<PartnerManagementScreen> createState() => _PartnerManagementScreenState();
}

class _PartnerManagementScreenState extends State<PartnerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All Status';
  String _selectedLocation = 'All Locations';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _statusOptions = [
    'All Status',
    'Active',
    'Pending',
    'Inactive',
  ];

  final List<String> _locationOptions = [
    'All Locations',
    'Noida',
    'Delhi',
    'Ghaziabad',
    'Greater Noida',
    'Gurugram',
    'Faridabad',
  ];

  final List<String> _dateOptions = [
    'All Time',
    'Today',
    'This Month',
    'Last 3 Months',
    'This Year',
  ];

  // PDF Page 4 ke 10 DSA Partners ka data[cite: 4]
  final List<Map<String, dynamic>> _partners = [
    {
      'id': 1,
      'code': 'DSA001',
      'name': 'Rahul Kumar',
      'phone': '+91 98765 43210',
      'email': 'rahul.kumar@gmail.com',
      'location': 'Noida',
      'totalLeads': 48,
      'approved': 32,
      'commission': '₹ 2,40,000',
      'status': 'Active',
      'joinDate': '12 Jan 2024\n10:30 AM',
    },
    {
      'id': 2,
      'code': 'DSA002',
      'name': 'Amit Yadav',
      'phone': '+91 91234 56789',
      'email': 'amit.yadav@gmail.com',
      'location': 'Delhi',
      'totalLeads': 36,
      'approved': 25,
      'commission': '₹ 1,85,000',
      'status': 'Active',
      'joinDate': '08 Feb 2024\n02:15 PM',
    },
    {
      'id': 3,
      'code': 'DSA003',
      'name': 'Sunil Sharma',
      'phone': '+91 99887 66554',
      'email': 'sunil.sharma@gmail.com',
      'location': 'Ghaziabad',
      'totalLeads': 32,
      'approved': 20,
      'commission': '₹ 1,60,000',
      'status': 'Active',
      'joinDate': '15 Mar 2024\n11:20 AM',
    },
    {
      'id': 4,
      'code': 'DSA004',
      'name': 'Pooja Singh',
      'phone': '+91 98711 22334',
      'email': 'pooja.singh@gmail.com',
      'location': 'Noida',
      'totalLeads': 28,
      'approved': 18,
      'commission': '₹ 1,25,000',
      'status': 'Active',
      'joinDate': '21 Mar 2024\n04:45 PM',
    },
    {
      'id': 5,
      'code': 'DSA005',
      'name': 'Vikash Singh',
      'phone': '+91 87654 32109',
      'email': 'vikash.singh@gmail.com',
      'location': 'Greater Noida',
      'totalLeads': 24,
      'approved': 15,
      'commission': '₹ 1,10,000',
      'status': 'Active',
      'joinDate': '05 Apr 2024\n12:10 PM',
    },
    {
      'id': 6,
      'code': 'DSA006',
      'name': 'Deepak Verma',
      'phone': '+91 96543 21098',
      'email': 'deepak.verma@gmail.com',
      'location': 'Gurugram',
      'totalLeads': 18,
      'approved': 10,
      'commission': '₹ 75,000',
      'status': 'Pending',
      'joinDate': '20 Aug 2024\n09:30 AM',
    },
    {
      'id': 7,
      'code': 'DSA007',
      'name': 'Rohan Gupta',
      'phone': '+91 98765 01987',
      'email': 'rohan.gupta@gmail.com',
      'location': 'Noida',
      'totalLeads': 14,
      'approved': 8,
      'commission': '₹ 60,000',
      'status': 'Active',
      'joinDate': '01 Sep 2024\n06:20 PM',
    },
    {
      'id': 8,
      'code': 'DSA008',
      'name': 'Neha Patel',
      'phone': '+91 91230 44556',
      'email': 'neha.patel@gmail.com',
      'location': 'Delhi',
      'totalLeads': 12,
      'approved': 7,
      'commission': '₹ 52,000',
      'status': 'Inactive',
      'joinDate': '10 Sep 2024\n03:50 PM',
    },
    {
      'id': 9,
      'code': 'DSA009',
      'name': 'Suresh Mehta',
      'phone': '+91 99876 54321',
      'email': 'suresh.mehta@gmail.com',
      'location': 'Ghaziabad',
      'totalLeads': 10,
      'approved': 6,
      'commission': '₹ 45,000',
      'status': 'Active',
      'joinDate': '12 Sep 2024\n11:10 AM',
    },
    {
      'id': 10,
      'code': 'DSA010',
      'name': 'Karan Malhotra',
      'phone': '+91 94123 67890',
      'email': 'karan.malhotra@gmail.com',
      'location': 'Faridabad',
      'totalLeads': 8,
      'approved': 4,
      'commission': '₹ 30,000',
      'status': 'Pending',
      'joinDate': '15 Sep 2024\n01:40 PM',
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
      _selectedStatus = 'All Status';
      _selectedLocation = 'All Locations';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  void _openAddPartnerModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final agencyCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add New Partner (DSA)',
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
                    decoration: _inputDecoration('Partner Full Name *', 'Rahul Kumar'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length != 10) ? '10 digits' : null,
                    decoration: _inputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Email Address', 'partner@gmail.com'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: agencyCtrl,
                    decoration: _inputDecoration('Agency / Business Name', 'RK Associates'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cityCtrl,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration: _inputDecoration('City / Location *', 'Noida, Uttar Pradesh'),
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
                    content: Text('Partner registered and verification initiated!'),
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
            child: const Text('Register Partner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
              // Header Section[cite: 4]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total, Active, Pending, Inactive)[cite: 4]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 4]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Partner (DSA) Data Table[cite: 4]
              _buildPartnerDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 4]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 4]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Partner (DSA) Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View, search and manage all registered DSA partners.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _openAddPartnerModal,
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Add New Partner',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F3E38),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // 1. Four Metric Badges[cite: 4]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Partners',
            value: '86',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '+6 this month',
            icon: Icons.people_outline_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Active Partners',
            value: '72',
            badgeText: '↑ 15%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '83.7% of total',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Verification',
            value: '8',
            badgeText: '↓ 20%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: '9.3% of total',
            icon: Icons.access_time_rounded,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Inactive Partners',
            value: '6',
            badgeText: '↓ 14%',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: '7% of total',
            icon: Icons.cancel_outlined,
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

  // 2. Search & Filter Bar[cite: 4]
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

          // Partner Status Filter
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedStatus,
              items: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),

          // Area / Location Filter
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedLocation,
              items: _locationOptions,
              onChanged: (v) => setState(() => _selectedLocation = v!),
            ),
          ),
          const SizedBox(width: 10),

          // Join Date Filter
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

          // Filters and Reset Buttons
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, size: 15, color: AppColors.primary),
            label: const Text('Filters', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 8),
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

  // 3. Partner (DSA) Data Table[cite: 4]
  Widget _buildPartnerDataTable() {
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
                        _selectedRows.addAll(List.generate(_partners.length, (i) => i));
                      } else {
                        _selectedRows.clear();
                      }
                    });
                  },
                ),
              ),
              const DataColumn(label: Text('#', style: _headerStyle)),
              const DataColumn(label: Text('Partner Details', style: _headerStyle)),
              const DataColumn(label: Text('Contact Information', style: _headerStyle)),
              const DataColumn(label: Text('Location', style: _headerStyle)),
              const DataColumn(label: Text('Total Leads', style: _headerStyle)),
              const DataColumn(label: Text('Approved', style: _headerStyle)),
              const DataColumn(label: Text('Commission', style: _headerStyle)),
              const DataColumn(label: Text('Status', style: _headerStyle)),
              const DataColumn(label: Text('Join Date', style: _headerStyle)),
              const DataColumn(label: Text('Actions', style: _headerStyle)),
            ],
            rows: List.generate(_partners.length, (index) {
              final item = _partners[index];
              final isSelected = _selectedRows.contains(index);

              Color statusBg = const Color(0xFFDCFCE7);
              Color statusCol = const Color(0xFF16A36A);
              if (item['status'] == 'Pending') {
                statusBg = const Color(0xFFFEF3C7);
                statusCol = const Color(0xFFD97706);
              } else if (item['status'] == 'Inactive') {
                statusBg = const Color(0xFFFEE2E2);
                statusCol = const Color(0xFFDC2626);
              }

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
                          _selectAll = _selectedRows.length == _partners.length;
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                            Text(
                              item['code'] as String,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                            ),
                          ],
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
                  DataCell(Text(item['location'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
                  DataCell(Text('${item['totalLeads']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                  DataCell(Text('${item['approved']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A36A)))),
                  DataCell(Text(item['commission'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusCol),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item['joinDate'] as String,
                      style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.2),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // View Action -> Navigates to Page 5 (Partner Details)
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
                          tooltip: 'View Partner Details',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PartnerDetailsAdminScreen(partnerData: item),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                          tooltip: 'Edit Partner',
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

  // 4. Pagination Footer[cite: 4]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 86 partners',
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
                  items: [10, 25, 50]
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
            _buildPageButton('9'),
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