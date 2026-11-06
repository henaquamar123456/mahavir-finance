import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class LeadAssignmentScreen extends StatefulWidget {
  const LeadAssignmentScreen({super.key});

  @override
  State<LeadAssignmentScreen> createState() => _LeadAssignmentScreenState();
}

class _LeadAssignmentScreenState extends State<LeadAssignmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _memberSearchController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String _selectedLoanType = 'All Loan Types';
  String _selectedStatus = 'All Status';
  String _selectedTeamMember = 'All Team Members';
  String _selectedDateRange = 'All Time';
  String _selectedPriority = 'Medium';
  String _followUpDate = '15 Sep 2024';
  int _selectedLeadIndex = 0;
  int _selectedMemberIndex = 0;
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
    'New',
    'In Progress',
    'Assigned',
  ];

  final List<String> _teamMembersFilter = [
    'All Team Members',
    'Rahul Kumar',
    'Pooja Sharma',
    'Vikram Yadav',
    'Anjali Verma',
    'Neha Gupta',
  ];

  // PDF Page 9 ke 10 leads ka data[cite: 9]
  final List<Map<String, dynamic>> _leads = [
    {
      'id': 1,
      'name': 'Amit Shah',
      'phone': '+91 9876543210',
      'email': 'amit.shah@gmail.com',
      'loanType': 'Home Loan',
      'amount': '₹ 25,00,000',
      'status': 'New',
      'assignedTo': 'Unassigned',
      'submittedOn': '12 Sep 2024\n10:30 AM',
    },
    {
      'id': 2,
      'name': 'Priya Verma',
      'phone': '+91 91234 56789',
      'email': 'priya.verma@gmail.com',
      'loanType': 'Car Loan',
      'amount': '₹ 8,00,000',
      'status': 'In Progress',
      'assignedTo': 'Rohit Sharma',
      'submittedOn': '11 Sep 2024\n02:15 PM',
    },
    {
      'id': 3,
      'name': 'Rohan Mehta',
      'phone': '+91 99887 66554',
      'email': 'rohan.mehta@gmail.com',
      'loanType': 'Personal Loan',
      'amount': '₹ 5,00,000',
      'status': 'New',
      'assignedTo': 'Unassigned',
      'submittedOn': '10 Sep 2024\n11:20 AM',
    },
    {
      'id': 4,
      'name': 'Neha Singh',
      'phone': '+91 98711 22334',
      'email': 'neha.singh@gmail.com',
      'loanType': 'Education Loan',
      'amount': '₹ 10,00,000',
      'status': 'In Progress',
      'assignedTo': 'Anjali Verma',
      'submittedOn': '09 Sep 2024\n04:45 PM',
    },
    {
      'id': 5,
      'name': 'Suresh Patel',
      'phone': '+91 87654 32109',
      'email': 'suresh.patel@gmail.com',
      'loanType': 'Business Loan',
      'amount': '₹ 15,00,000',
      'status': 'New',
      'assignedTo': 'Unassigned',
      'submittedOn': '09 Sep 2024\n12:10 PM',
    },
    {
      'id': 6,
      'name': 'Kavita Sharma',
      'phone': '+91 96543 21098',
      'email': 'kavita.sharma@gmail.com',
      'loanType': 'Home Loan',
      'amount': '₹ 30,00,000',
      'status': 'In Progress',
      'assignedTo': 'Vikram Yadav',
      'submittedOn': '08 Sep 2024\n09:30 AM',
    },
    {
      'id': 7,
      'name': 'Vikram Yadav',
      'phone': '+91 98765 01987',
      'email': 'vikram.yadav@gmail.com',
      'loanType': 'Car Loan',
      'amount': '₹ 4,50,000',
      'status': 'New',
      'assignedTo': 'Unassigned',
      'submittedOn': '07 Sep 2024\n06:20 PM',
    },
    {
      'id': 8,
      'name': 'Anjali Sinha',
      'phone': '+91 91230 44556',
      'email': 'anjali.sinha@gmail.com',
      'loanType': 'Personal Loan',
      'amount': '₹ 7,50,000',
      'status': 'In Progress',
      'assignedTo': 'Pooja Sharma',
      'submittedOn': '06 Sep 2024\n03:50 PM',
    },
    {
      'id': 9,
      'name': 'Deepak Kumar',
      'phone': '+91 99876 54321',
      'email': 'deepak.kumar@gmail.com',
      'loanType': 'Education Loan',
      'amount': '₹ 20,00,000',
      'status': 'New',
      'assignedTo': 'Unassigned',
      'submittedOn': '05 Sep 2024\n11:10 AM',
    },
    {
      'id': 10,
      'name': 'Ritu Singh',
      'phone': '+91 94123 67890',
      'email': 'ritu.singh@gmail.com',
      'loanType': 'Business Loan',
      'amount': '₹ 6,00,000',
      'status': 'In Progress',
      'assignedTo': 'Rahul Kumar',
      'submittedOn': '04 Sep 2024\n01:40 PM',
    },
  ];

  // PDF Page 9 Team Members workload list[cite: 9]
  final List<Map<String, dynamic>> _teamMembers = [
    {
      'name': 'Rahul Kumar',
      'role': 'Loan Officer',
      'activeLeads': 24,
      'conversion': '62%',
    },
    {
      'name': 'Pooja Sharma',
      'role': 'Loan Officer',
      'activeLeads': 18,
      'conversion': '70%',
    },
    {
      'name': 'Vikram Yadav',
      'role': 'Senior Executive',
      'activeLeads': 18,
      'conversion': '68%',
    },
    {
      'name': 'Anjali Verma',
      'role': 'Loan Officer',
      'activeLeads': 26,
      'conversion': '65%',
    },
    {
      'name': 'Neha Gupta',
      'role': 'Relationship Manager',
      'activeLeads': 20,
      'conversion': '68%',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _memberSearchController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedLoanType = 'All Loan Types';
      _selectedStatus = 'All Status';
      _selectedTeamMember = 'All Team Members';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeLead = _leads[_selectedLeadIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Title & Bulk Assign Action[cite: 9]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 2. 4 Metric Cards (Total Unassigned, Assigned Leads, In Progress, Converted)[cite: 9]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 3. Search & Filter Bar[cite: 9]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 4. Main 2-Column Responsive Workspace: Leads Table & Assign Lead Panel[cite: 9]
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 1080;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Leads Table[cite: 9]
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLeadsDataTable(),
                              const SizedBox(height: 14),
                              _buildPaginationFooter(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Column: Assign Lead Panel[cite: 9]
                        SizedBox(
                          width: 380,
                          child: _buildAssignLeadPanel(activeLead),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _buildLeadsDataTable(),
                      const SizedBox(height: 14),
                      _buildPaginationFooter(),
                      const SizedBox(height: 16),
                      _buildAssignLeadPanel(activeLead),
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

  // 1. Header Title & Bulk Assign Action[cite: 9]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Lead Assignment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Assign loan leads to team members for follow-up and processing.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bulk Assign initiated for selected leads!'),
                backgroundColor: Color(0xFF0F3E38),
              ),
            );
          },
          icon: const Icon(Icons.group_add_rounded, size: 16, color: Colors.white),
          label: const Text(
            '+ Bulk Assign',
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

  // 2. 4 Metric Cards[cite: 9]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Unassigned',
            value: '18',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Leads pending assignment',
            icon: Icons.assignment_late_outlined,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Assigned Leads',
            value: '186',
            badgeText: '↑ 15%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Leads assigned to team',
            icon: Icons.assignment_ind_outlined,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'In Progress',
            value: '72',
            badgeText: '↓ 8%',
            badgeBg: const Color(0xFFE0F2FE),
            badgeColor: const Color(0xFF0284C7),
            subtitle: 'Currently being worked',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Converted',
            value: '48',
            badgeText: '↑ 22%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Successfully closed',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFF3E8FF),
            iconColor: const Color(0xFF7C3AED),
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

  // 3. Search & Filter Bar[cite: 9]
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
                  hintText: 'Search leads by name, mobile, loan type, status...',
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
              value: _selectedTeamMember,
              items: _teamMembersFilter,
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

  // 4. Left: Leads Data Table (18 Unassigned)[cite: 9]
  Widget _buildLeadsDataTable() {
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
                  'Leads (18 Unassigned)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                Text(
                  'Unassigned First ▾',
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
                headingRowHeight: 42,
                dataRowMinHeight: 50,
                dataRowMaxHeight: 54,
                horizontalMargin: 12,
                columnSpacing: 18,
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: _selectAll,
                      activeColor: const Color(0xFF0F3E38),
                      onChanged: (val) {
                        setState(() {
                          _selectAll = val ?? false;
                          if (_selectAll) {
                            _selectedRows.addAll(List.generate(_leads.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('Customer Details', style: _headerStyle)),
                  const DataColumn(label: Text('Loan Type', style: _headerStyle)),
                  const DataColumn(label: Text('Amount', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Assigned To', style: _headerStyle)),
                  const DataColumn(label: Text('Submitted On', style: _headerStyle)),
                  const DataColumn(label: Text('Action', style: _headerStyle)),
                ],
                rows: List.generate(_leads.length, (index) {
                  final item = _leads[index];
                  final isSelectedRow = _selectedRows.contains(index);
                  final isCurrentActive = index == _selectedLeadIndex;
                  final isUnassigned = item['assignedTo'] == 'Unassigned';

                  return DataRow(
                    selected: isCurrentActive || isSelectedRow,
                    color: WidgetStateProperty.resolveWith<Color?>((states) {
                      if (isCurrentActive) {
                        return const Color(0xFFE6F7F2).withValues(alpha: 0.6);
                      }
                      return null;
                    }),
                    cells: [
                      DataCell(
                        Checkbox(
                          value: isSelectedRow,
                          activeColor: const Color(0xFF0F3E38),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedRows.add(index);
                              } else {
                                _selectedRows.remove(index);
                              }
                              _selectAll = _selectedRows.length == _leads.length;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () => setState(() => _selectedLeadIndex = index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'] as String,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              Text(item['phone'] as String,
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                      DataCell(Text(item['loanType'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
                      DataCell(Text(item['amount'] as String,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item['status'] == 'New' ? const Color(0xFFFEF3C7) : const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: item['status'] == 'New' ? const Color(0xFFD97706) : const Color(0xFF0284C7),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        isUnassigned
                            ? const Text(
                          'Unassigned',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
                        )
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                              child: Text(
                                (item['assignedTo'] as String)[0],
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(item['assignedTo'] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(item['submittedOn'] as String,
                            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.2)),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () => setState(() => _selectedLeadIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F3E38),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Assign',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
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
    fontSize: 10.5,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Showing 1 to 10 of 18 leads', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Row(
          children: const [
            Text('10 per page ▾', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            SizedBox(width: 8),
            Text('<  1  2  >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
      ],
    );
  }

  // 4. Right: Assign Lead Panel[cite: 9]
  Widget _buildAssignLeadPanel(Map<String, dynamic> activeLead) {
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
            children: const [
              Text(
                'Assign Lead',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              Icon(Icons.close_rounded, size: 18, color: AppColors.iconSecondary),
            ],
          ),
          const SizedBox(height: 10),

          // Active Lead Summary Pill[cite: 9]
          Container(
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
                    Text(
                      activeLead['name'] as String,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    Text(
                      activeLead['amount'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0F3E38)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${activeLead['phone']}  •  ${activeLead['email']}',
                  style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                ),
                Text(
                  '${activeLead['loanType']}  |  Submitted: ${activeLead['submittedOn']!.replaceAll('\n', ' ')}',
                  style: const TextStyle(fontSize: 9.5, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Select Team Member Heading & Search[cite: 9]
          const Text(
            'Select Team Member',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Container(
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _memberSearchController,
              style: const TextStyle(fontSize: 11),
              decoration: const InputDecoration(
                hintText: 'Search team members...',
                hintStyle: TextStyle(fontSize: 10.5, color: AppColors.textHint),
                prefixIcon: Icon(Icons.search_rounded, size: 15, color: AppColors.iconSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Team Member Workload Selection Cards[cite: 9]
          Column(
            children: List.generate(_teamMembers.length, (index) {
              final member = _teamMembers[index];
              final isSelected = index == _selectedMemberIndex;

              return InkWell(
                onTap: () => setState(() => _selectedMemberIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE6F7F2) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0F3E38) : AppColors.border,
                      width: isSelected ? 1.2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                        child: Text(
                          (member['name'] as String)[0],
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['name'] as String,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            Text(
                              member['role'] as String,
                              style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Active Leads: ${member['activeLeads']}',
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          Text('Conversion: ${member['conversion']}',
                              style: const TextStyle(fontSize: 9, color: Color(0xFF16A36A), fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),

          // Assignment Details: Priority & Follow-up Date[cite: 9]
          const Text(
            'Assignment Details',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Priority', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPriority,
                          isExpanded: true,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                          onChanged: (v) => setState(() => _selectedPriority = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Follow-up Date', style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_followUpDate,
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.iconSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Remarks field[cite: 9]
          TextField(
            controller: _remarksController,
            maxLines: 2,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              hintText: 'Add assignment notes (Optional)...',
              hintStyle: const TextStyle(fontSize: 10, color: AppColors.textHint),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons: Cancel and Assign Lead[cite: 9]
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final memberName = _teamMembers[_selectedMemberIndex]['name'];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lead successfully assigned to $memberName!'),
                        backgroundColor: const Color(0xFF0F3E38),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3E38),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Assign Lead', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}