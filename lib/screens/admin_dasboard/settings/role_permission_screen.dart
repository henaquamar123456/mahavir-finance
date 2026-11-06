import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class RolesPermissionsScreen extends StatefulWidget {
  const RolesPermissionsScreen({super.key});

  @override
  State<RolesPermissionsScreen> createState() => _RolesPermissionsScreenState();
}

class _RolesPermissionsScreenState extends State<RolesPermissionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: Users, 1: Roles, 2: Permissions
  String _selectedRoleFilter = 'All Roles';
  String _selectedStatusFilter = 'All Status';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _roleOptions = [
    'All Roles',
    'Super Admin',
    'Loan Manager',
    'Finance Manager',
    'Content Manager',
    'Support Manager',
    'Viewer',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Active',
    'Inactive',
  ];

  // PDF Page 20 ke Admin Users ka data[cite: 20]
  final List<Map<String, dynamic>> _adminUsers = [
    {
      'id': 1,
      'name': 'Rohit Kumar',
      'email': 'rohit@mahavirfinance.com',
      'role': 'Super Admin',
      'roleBg': const Color(0xFFE6F7F2),
      'roleCol': const Color(0xFF0F3E38),
      'status': 'Active',
      'lastLogin': '25 Oct 2024\n11:30 AM',
    },
    {
      'id': 2,
      'name': 'Neha Gupta',
      'email': 'neha@mahavirfinance.com',
      'role': 'Content Manager',
      'roleBg': const Color(0xFFEFF6FF),
      'roleCol': const Color(0xFF0284C7),
      'status': 'Active',
      'lastLogin': '25 Oct 2024\n10:15 AM',
    },
    {
      'id': 3,
      'name': 'Amit Yadav',
      'email': 'amit@mahavirfinance.com',
      'role': 'Support Manager',
      'roleBg': const Color(0xFFFEF3C7),
      'roleCol': const Color(0xFFD97706),
      'status': 'Active',
      'lastLogin': '24 Oct 2024\n06:20 PM',
    },
    {
      'id': 4,
      'name': 'Priya Sharma',
      'email': 'priya@mahavirfinance.com',
      'role': 'Finance Manager',
      'roleBg': const Color(0xFFF3E8FF),
      'roleCol': const Color(0xFF7C3AED),
      'status': 'Active',
      'lastLogin': '24 Oct 2024\n03:40 PM',
    },
    {
      'id': 5,
      'name': 'Vikram Singh',
      'email': 'vikram@mahavirfinance.com',
      'role': 'Loan Manager',
      'roleBg': const Color(0xFFDCFCE7),
      'roleCol': const Color(0xFF16A36A),
      'status': 'Inactive',
      'lastLogin': '20 Oct 2024\n09:15 AM',
    },
  ];

  // PDF Page 20 Role Permissions Matrix data[cite: 20]
  final List<Map<String, dynamic>> _permissionMatrix = [
    {
      'module': 'Dashboard',
      'superAdmin': true,
      'loanManager': true,
      'financeManager': true,
      'contentManager': true,
      'supportManager': true,
      'viewer': true,
    },
    {
      'module': 'Customers',
      'superAdmin': true,
      'loanManager': true,
      'financeManager': false,
      'contentManager': false,
      'supportManager': true,
      'viewer': true,
    },
    {
      'module': 'Partners',
      'superAdmin': true,
      'loanManager': true,
      'financeManager': true,
      'contentManager': false,
      'supportManager': false,
      'viewer': true,
    },
    {
      'module': 'Loan Management',
      'superAdmin': true,
      'loanManager': true,
      'financeManager': false,
      'contentManager': false,
      'supportManager': false,
      'viewer': false,
    },
    {
      'module': 'Financials',
      'superAdmin': true,
      'loanManager': false,
      'financeManager': true,
      'contentManager': false,
      'supportManager': false,
      'viewer': false,
    },
    {
      'module': 'Reports & Analytics',
      'superAdmin': true,
      'loanManager': true,
      'financeManager': true,
      'contentManager': false,
      'supportManager': false,
      'viewer': true,
    },
    {
      'module': 'CMS / Content',
      'superAdmin': true,
      'loanManager': false,
      'financeManager': false,
      'contentManager': true,
      'supportManager': false,
      'viewer': false,
    },
    {
      'module': 'Blog Management',
      'superAdmin': true,
      'loanManager': false,
      'financeManager': false,
      'contentManager': true,
      'supportManager': false,
      'viewer': false,
    },
    {
      'module': 'Support & Queries',
      'superAdmin': true,
      'loanManager': false,
      'financeManager': false,
      'contentManager': false,
      'supportManager': true,
      'viewer': false,
    },
    {
      'module': 'Settings',
      'superAdmin': true,
      'loanManager': false,
      'financeManager': false,
      'contentManager': false,
      'supportManager': false,
      'viewer': false,
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
      _selectedRoleFilter = 'All Roles';
      _selectedStatusFilter = 'All Status';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 20 Add New User Modal[cite: 20]
  void _openAddUserModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String role = 'Loan Manager';
    String status = 'Active';

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
                  'Add New Admin User',
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
              width: 460,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Full Name *', 'e.g. Vikram Singh'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                        decoration: _inputDecoration('Official Email *', 'user@mahavirfinance.com'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: role,
                        items: _roleOptions
                            .where((r) => r != 'All Roles')
                            .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (val) => setModalState(() => role = val!),
                        decoration: _inputDecoration('Assigned Role *', ''),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: true,
                        validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                        decoration: _inputDecoration('Temporary Password *', '••••••••'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Status: ', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Active',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => status = v!),
                              ),
                              const Text('Active', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Inactive',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => status = v!),
                              ),
                              const Text('Inactive', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
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
                        content: Text('Admin user created successfully!'),
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
                child: const Text('Create User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  // PDF Page 20 Create/Edit Role with granular permissions checkboxes[cite: 20]
  void _openCreateEditRoleModal() {
    final formKey = GlobalKey<FormState>();
    final roleNameCtrl = TextEditingController(text: 'Loan Manager');
    final descCtrl = TextEditingController(
      text: 'Can manage loan products, leads and approvals',
    );

    final Map<String, List<Map<String, dynamic>>> granularPermissions = {
      'Dashboard': [
        {'name': 'View Dashboard', 'val': true},
        {'name': 'View Reports', 'val': true},
      ],
      'Customers': [
        {'name': 'View Customers', 'val': true},
        {'name': 'Add/Edit Customers', 'val': true},
        {'name': 'Delete Customers', 'val': false},
      ],
      'Partners': [
        {'name': 'View Partners', 'val': true},
        {'name': 'Add/Edit Partners', 'val': true},
        {'name': 'Delete Partners', 'val': false},
      ],
      'Loan Management': [
        {'name': 'View Loan Leads', 'val': true},
        {'name': 'Add/Edit Leads', 'val': true},
        {'name': 'Delete Leads', 'val': false},
      ],
    };

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
                  'Create/Edit Role',
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
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: roleNameCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Role Name *', 'e.g. Loan Manager'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: _inputDecoration(
                          'Description',
                          'Can manage loan products, leads and approvals (56/200)',
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Module Permissions *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),

                      // Granular Checkboxes grouped by Module[cite: 20]
                      ...granularPermissions.entries.map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 14,
                                runSpacing: 4,
                                children: entry.value.map((perm) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Checkbox(
                                          value: perm['val'] as bool,
                                          activeColor: const Color(0xFF0F3E38),
                                          onChanged: (v) {
                                            setModalState(() {
                                              perm['val'] = v ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        perm['name'] as String,
                                        style: const TextStyle(fontSize: 10.5, color: AppColors.primary),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }),
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
                        content: Text('Role permissions saved successfully!'),
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
                child: const Text('Save Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              // Header title and Add User button[cite: 20]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total Users, Total Roles, Active Users, Inactive Users)[cite: 20]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Navigation Tabs (Users | Roles | Permissions)[cite: 20]
              _buildTabsRow(),
              const SizedBox(height: 14),

              // 3. Search & Filter Bar[cite: 20]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 4. Two-Column Workspace (Admin Users Table vs Role Permissions Matrix)[cite: 20]
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 1080;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Admin Users Table[cite: 20]
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAdminUsersDataTable(),
                              const SizedBox(height: 14),
                              _buildPaginationFooter(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Column: Role Permissions Matrix[cite: 20]
                        Expanded(
                          flex: 5,
                          child: _buildRolePermissionsMatrixCard(),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _buildAdminUsersDataTable(),
                      const SizedBox(height: 14),
                      _buildPaginationFooter(),
                      const SizedBox(height: 16),
                      _buildRolePermissionsMatrixCard(),
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

  // Header Title Row[cite: 20]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Roles & Permissions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage admin users, roles and access control for Mahavir Finance.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _openAddUserModal,
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Add New User',
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

  // 1. Four Metric Badges[cite: 20]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Users',
            value: '12',
            badgeText: 'System users',
            badgeBg: const Color(0xFFE0F2FE),
            badgeColor: const Color(0xFF0284C7),
            subtitle: 'All admin users',
            icon: Icons.manage_accounts_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Total Roles',
            value: '6',
            badgeText: 'Configured',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'System roles',
            icon: Icons.shield_outlined,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Active Users',
            value: '10',
            badgeText: 'Online',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Currently active',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFE6F7F2),
            iconColor: const Color(0xFF0F3E38),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Inactive Users',
            value: '2',
            badgeText: 'Disabled',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: 'Deactivated accounts',
            icon: Icons.person_off_outlined,
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
              Text(title, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
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

  // 2. Navigation Tabs Row[cite: 20]
  Widget _buildTabsRow() {
    final tabs = ['Users (12)', 'Roles (6)', 'Permissions Matrix'];

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = _selectedTab == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => setState(() => _selectedTab = index),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // 3. Search & Filter Bar[cite: 20]
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
            flex: 4,
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
                  hintText: 'Search users by name, email or role...',
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
              value: _selectedRoleFilter,
              items: _roleOptions,
              onChanged: (v) => setState(() => _selectedRoleFilter = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedStatusFilter,
              items: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatusFilter = v!),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, size: 15, color: AppColors.primary),
            label: const Text('Filters', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // 4. Left: Admin Users Data Table[cite: 20]
  Widget _buildAdminUsersDataTable() {
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
                  'Admin Users (12)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                Text(
                  'Active First ▾',
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
                            _selectedRows.addAll(List.generate(_adminUsers.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('Name', style: _headerStyle)),
                  const DataColumn(label: Text('Email', style: _headerStyle)),
                  const DataColumn(label: Text('Role', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Last Login', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(_adminUsers.length, (index) {
                  final item = _adminUsers[index];
                  final isSelected = _selectedRows.contains(index);
                  final isActive = item['status'] == 'Active';

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
                              _selectAll = _selectedRows.length == _adminUsers.length;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                              child: Text(
                                (item['name'] as String)[0],
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
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
                        Text(
                          item['email'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(color: item['roleBg'] as Color, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            item['role'] as String,
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item['roleCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: isActive ? const Color(0xFF16A36A) : const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['lastLogin'] as String,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.2),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit User',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.lock_reset_rounded, size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'Reset Password',
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

  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Showing 1 to 5 of 12 users', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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

  // 4. Right: Role Permissions Matrix Card[cite: 20]
  Widget _buildRolePermissionsMatrixCard() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Role Permissions Matrix',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  Text(
                    'Overview of module access for each role',
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _openCreateEditRoleModal,
                icon: const Icon(Icons.tune_rounded, size: 14, color: Color(0xFF0F3E38)),
                label: const Text(
                  'Edit Role',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                headingRowHeight: 40,
                dataRowMinHeight: 38,
                dataRowMaxHeight: 42,
                horizontalMargin: 10,
                columnSpacing: 14,
                columns: const [
                  DataColumn(label: Text('Module', style: _headerStyle)),
                  DataColumn(label: Text('Super Admin', style: _headerStyle)),
                  DataColumn(label: Text('Loan Mgr', style: _headerStyle)),
                  DataColumn(label: Text('Finance Mgr', style: _headerStyle)),
                  DataColumn(label: Text('Content Mgr', style: _headerStyle)),
                  DataColumn(label: Text('Support Mgr', style: _headerStyle)),
                  DataColumn(label: Text('Viewer', style: _headerStyle)),
                ],
                rows: _permissionMatrix.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          item['module'] as String,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ),
                      DataCell(_buildCheckCell(item['superAdmin'] == true)),
                      DataCell(_buildCheckCell(item['loanManager'] == true)),
                      DataCell(_buildCheckCell(item['financeManager'] == true)),
                      DataCell(_buildCheckCell(item['contentManager'] == true)),
                      DataCell(_buildCheckCell(item['supportManager'] == true)),
                      DataCell(_buildCheckCell(item['viewer'] == true)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckCell(bool hasAccess) {
    if (hasAccess) {
      return const Center(
        child: Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF16A36A)),
      );
    }
    return const Center(
      child: Icon(Icons.remove_rounded, size: 16, color: AppColors.textHint),
    );
  }
}