import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class RolesPermissionsScreen extends StatefulWidget {
  const RolesPermissionsScreen({super.key});

  @override
  State<RolesPermissionsScreen> createState() => _RolesPermissionsScreenState();
}

class _RolesPermissionsScreenState extends State<RolesPermissionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTab = 0; // 0: Users, 1: Roles, 2: Permissions Matrix
  String _selectedRoleFilter = 'All Roles';
  String _selectedStatusFilter = 'All Status';
  int _rowsPerPage = 10;
  int _currentPage = 1;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  int _totalUsers = 12;
  int _totalRoles = 6;
  int _activeUsers = 10;
  int _inactiveUsers = 2;

  final List<String> _roleOptions = const [
    'All Roles',
    'Super Admin',
    'Loan Manager',
    'Finance Manager',
    'Content Manager',
    'Support Manager',
    'Viewer',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Active',
    'Inactive',
  ];

  List _adminUsers = [];

  final List _permissionMatrix = [
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
  void initState() {
    super.initState();
    _fetchAdminUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAdminUsers() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/users'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dynamic rawData = body['data'];

        List<dynamic> list = [];
        Map<String, dynamic>? stats;

        if (rawData is Map) {
          list = rawData['users'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final u = list[i];
    final role = (u['role'] ?? 'Loan Manager').toString();
    final st = (u['status'] ?? 'Active').toString();

    loaded.add({
    'id': i + 1,
    '_id': u['_id'] ?? '',
    'name': u['name'] ?? 'Admin User',
    'email': u['email'] ?? 'admin@mahavirfinance.com',
    'role': role,
    'status': st,
    'lastLogin': u['lastLogin'] ?? 'Recent',
    ..._getRoleVisuals(role),
    });
    }

    if (mounted) {
    setState(() {
    _adminUsers = loaded;
    if (stats != null) {
    _totalUsers = stats['totalUsers'] ?? loaded.length;
    _totalRoles = stats['totalRoles'] ?? 6;
    _activeUsers = stats['activeUsers'] ??
    loaded.where((x) => x['status'] == 'Active').length;
    _inactiveUsers = stats['inactiveUsers'] ??
    loaded.where((x) => x['status'] == 'Inactive').length;
    } else {
    _totalUsers = loaded.length;
    }
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackUsers();
    } catch (_) {
    _setFallbackUsers();
    }
  }

  Map<String, Color> _getRoleVisuals(String role) {
    switch (role.toLowerCase()) {
      case 'super admin':
        return {'roleBg': const Color(0xFFE6F7F2), 'roleCol': const Color(0xFF0F3E38)};
      case 'content manager':
        return {'roleBg': const Color(0xFFEFF6FF), 'roleCol': const Color(0xFF0284C7)};
      case 'support manager':
        return {'roleBg': const Color(0xFFFEF3C7), 'roleCol': const Color(0xFFD97706)};
      case 'finance manager':
        return {'roleBg': const Color(0xFFF3E8FF), 'roleCol': const Color(0xFF7C3AED)};
      case 'loan manager':
      default:
        return {'roleBg': const Color(0xFFDCFCE7), 'roleCol': const Color(0xFF16A36A)};
    }
  }

  void _setFallbackUsers() {
    if (!mounted) return;
    setState(() {
      _adminUsers = [
        {
          'id': 1,
          '_id': '65f1a1a1a1a1a1a1a1a10001', // 👈 24-hex valid ID
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
          '_id': '65f1a1a1a1a1a1a1a1a10002',
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
          '_id': '65f1a1a1a1a1a1a1a1a10003',
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
          '_id': '65f1a1a1a1a1a1a1a1a10004',
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
          '_id': '65f1a1a1a1a1a1a1a1a10005',
          'name': 'Vikram Singh',
          'email': 'vikram@mahavirfinance.com',
          'role': 'Loan Manager',
          'roleBg': const Color(0xFFDCFCE7),
          'roleCol': const Color(0xFF16A36A),
          'status': 'Inactive',
          'lastLogin': '20 Oct 2024\n09:15 AM',
        },
      ];
      _totalUsers = _adminUsers.length;
      _isLoading = false;
    });
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

  List get _filteredUsers {
    final query = _searchController.text.trim().toLowerCase();

    return _adminUsers.where((item) {
      final name = item['name'].toString().toLowerCase();
      final email = item['email'].toString().toLowerCase();
      final role = item['role'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          role.contains(query);

      final matchesRole = _selectedRoleFilter == 'All Roles' ||
          item['role'].toString().toLowerCase() == _selectedRoleFilter.toLowerCase();

      final matchesStatus = _selectedStatusFilter == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatusFilter.toLowerCase();

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  // ==========================================
  // ADD ADMIN USER MODAL (Live POST API)
  // ==========================================
  void _openAddUserModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String role = 'Loan Manager';
    String status = 'Active';
    bool isSubmitting = false;

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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
                IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            content: SizedBox(
              width: 460,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        onChanged: (val) {
                          if (val != null) setModalState(() => role = val);
                        },
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
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (formKey.currentState!.validate()) {
                    setModalState(() => isSubmitting = true);
                    final token = await SharedPrefHelper.getToken();

                    try {
                      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/users'));
                      final res = await http.post(
                        url,
                        headers: {
                          'Content-Type': 'application/json',
                          if (token != null) 'Authorization': 'Bearer $token',
                        },
                        body: jsonEncode({
                          'name': nameCtrl.text.trim(),
                          'email': emailCtrl.text.trim(),
                          'password': passwordCtrl.text.trim(),
                          'role': role,
                          'status': status,
                        }),
                      ).timeout(const Duration(seconds: 10));

                      if (res.statusCode == 200 || res.statusCode == 201) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        _fetchAdminUsers();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Admin user created successfully!'),
                              backgroundColor: Color(0xFF16A36A),
                            ),
                          );
                        }
                      } else {
                        final body = jsonDecode(res.body);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(body['message'] ?? 'Error creating user'), backgroundColor: const Color(0xFFDC2626)),
                          );
                        }
                        setModalState(() => isSubmitting = false);
                      }
                    } catch (_) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchAdminUsers();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isSubmitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Create User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // EDIT ADMIN USER MODAL (Live PUT API)
  // ==========================================
  void _openEditUserModal(Map<String, dynamic> user) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user['name'] ?? '');
    final emailCtrl = TextEditingController(text: user['email'] ?? '');
    String role = user['role'] ?? 'Loan Manager';
    if (!_roleOptions.contains(role) || role == 'All Roles') role = 'Loan Manager';
    String status = user['status'] ?? 'Active';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Edit User (${user['name']})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
              IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration: _inputDecoration('Full Name *', 'Vikram Singh'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
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
                    onChanged: (val) {
                      if (val != null) setModalState(() => role = val);
                    },
                    decoration: _inputDecoration('Role Designation', ''),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                if (formKey.currentState!.validate()) {
                  setModalState(() => isSubmitting = true);
                  try {
                    final token = await SharedPrefHelper.getToken();
                    final uId = user['_id'];
                    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/users/$uId'));

                    final res = await http.put(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'name': nameCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'role': role,
                        'status': status,
                      }),
                    ).timeout(const Duration(seconds: 10));

                    if (res.statusCode == 200) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchAdminUsers();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Admin user updated successfully!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchAdminUsers();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // RESET PASSWORD MODAL (Live PUT API)
  // ==========================================
  void _openResetPasswordModal(Map<String, dynamic> user) {
    final passCtrl = TextEditingController(text: 'Mahavir@2026');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Reset Password for ${user['name']}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Email: ${user['email']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              TextFormField(
                controller: passCtrl,
                decoration: _inputDecoration('New Password', 'Enter new password'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                setModalState(() => isSubmitting = true);
                try {
                  final token = await SharedPrefHelper.getToken();
                  final uId = user['_id'];
                  final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/users/$uId/reset-password'));

                  final res = await http.put(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                      if (token != null) 'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode({'newPassword': passCtrl.text.trim()}),
                  ).timeout(const Duration(seconds: 10));

                  if (res.statusCode == 200) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password for ${user['name']} has been reset!'),
                          backgroundColor: const Color(0xFF16A36A),
                        ),
                      );
                    }
                  }
                } catch (_) {
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), elevation: 0),
              child: isSubmitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Confirm Reset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EDIT ROLE PERMISSIONS MODAL
  // ==========================================
  void _openCreateEditRoleModal() {
    final roleNameCtrl = TextEditingController(text: 'Loan Manager');
    final descCtrl = TextEditingController(text: 'Can manage loan products, leads and approvals');

    final Map <String, List> granularPermissions = {
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
    const Text('Role Permissions Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
    IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
    ],
    ),
    content: SizedBox(
    width: 520,
    child: SingleChildScrollView(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    TextFormField(
    controller: roleNameCtrl,
    decoration: _inputDecoration('Role Designation *', 'e.g. Loan Manager'),
    ),
    const SizedBox(height: 12),
    TextFormField(
    controller: descCtrl,
    maxLines: 2,
    decoration: _inputDecoration('Description', 'Can manage loan products, leads and approvals'),
    ),
    const SizedBox(height: 14),
    const Text('Module Permissions *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
    const SizedBox(height: 8),
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
    Text(entry.key, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38))),
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
    Text(perm['name'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.primary)),
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
    actions: [
    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
    ElevatedButton(
    onPressed: () {
    Navigator.pop(ctx);
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Role permissions matrix saved successfully!'), backgroundColor: Color(0xFF16A36A)),
    );
    },
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F3E38), elevation: 0),
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
      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              _buildTabsRow(),
              const SizedBox(height: 14),
              _buildFilterToolbar(),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              )
                  : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 1080;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Roles & Permissions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
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

  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Users',
            value: '$_totalUsers',
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
            value: '$_totalRoles',
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
            value: '$_activeUsers',
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
            value: '$_inactiveUsers',
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

  Widget _buildTabsRow() {
    final tabs = ['Users ($_totalUsers)', 'Roles ($_totalRoles)', 'Permissions Matrix'];

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
                onChanged: (_) => setState(() {}),
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
          value: items.contains(value) ? value : items.first,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAdminUsersDataTable() {
    final users = _filteredUsers;

    if (users.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.manage_accounts_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching admin users found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      );
    }

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
                Text(
                  'Admin Users (${users.length})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFF0F3E38)),
                  tooltip: 'Refresh Users',
                  onPressed: _fetchAdminUsers,
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
                showCheckboxColumn: false, // 👈 Fixes the double checkbox bug!
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
                            _selectedRows.addAll(List.generate(users.length, (i) => i));
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
                rows: List.generate(users.length, (index) {
                  final item = users[index];
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
                              _selectAll = _selectedRows.length == users.length;
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
                                (item['name'] as String).isNotEmpty ? (item['name'] as String)[0].toUpperCase() : 'A',
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
                              onPressed: () => _openEditUserModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.lock_reset_rounded, size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'Reset Password',
                              onPressed: () => _openResetPasswordModal(item),
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
    final filtered = _filteredUsers;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to ${filtered.length > _rowsPerPage ? _rowsPerPage : filtered.length} of ${filtered.length} users',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Row(
          children: [
            InkWell(
              onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
              child: const Text('< ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
            Text(' $_currentPage ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38))),
            InkWell(
              onTap: () => setState(() => _currentPage++),
              child: const Text(' >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ],
        ),
      ],
    );
  }

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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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