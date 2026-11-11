import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class NotificationsManagementScreen extends StatefulWidget {
  const NotificationsManagementScreen({super.key});

  @override
  State<NotificationsManagementScreen> createState() =>
      _NotificationsManagementScreenState();
}

class _NotificationsManagementScreenState
    extends State<NotificationsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedAudience = 'All Audiences';
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  int _totalCount = 124;
  int _customersCount = 56;
  int _partnersCount = 48;
  int _teamCount = 20;

  final List<String> _audienceOptions = const [
    'All Audiences',
    'Customers',
    'Partners',
    'Team Members',
    'All',
  ];

  final List<String> _typeOptions = const [
    'All Types',
    'Promotional',
    'Transactional',
    'Informational',
    'Alert',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Sent',
    'Scheduled',
    'Draft',
  ];

  List _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/notifications'));

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
          list = rawData['notifications'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final n = list[i];
    final type = (n['type'] ?? 'Promotional').toString();
    final st = (n['status'] ?? 'Sent').toString();

    loaded.add({
    'id': i + 1,
    '_id': n['_id'] ?? '',
    'title': n['title'] ?? 'Notification',
    'message': n['message'] ?? '',
    'audience': n['audience'] ?? 'Customers',
    'type': type,
    'status': st,
    'sentOn': n['sentOn'] ?? 'Recent',
    'engagement': n['engagement'] ?? '85%',
    'reach': n['reach'] ?? '1,200/1,500',
    ..._getTypeVisuals(type),
    ..._getStatusVisuals(st),
    });
    }

    if (mounted) {
    setState(() {
    _notifications = loaded;
    if (stats != null) {
    _totalCount = stats['totalNotifications'] ?? loaded.length;
    _customersCount = stats['sentToCustomers'] ??
    loaded.where((x) => x['audience'] == 'Customers').length;
    _partnersCount = stats['sentToPartners'] ??
    loaded.where((x) => x['audience'] == 'Partners').length;
    _teamCount = stats['sentToTeamMembers'] ??
    loaded.where((x) => x['audience'] == 'Team Members').length;
    } else {
    _totalCount = loaded.length;
    }
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackNotifications();
    } catch (_) {
    _setFallbackNotifications();
    }
  }

  Map<String, Color> _getTypeVisuals(String type) {
    switch (type.toLowerCase()) {
      case 'transactional':
        return {'typeBg': const Color(0xFFF3E8FF), 'typeCol': const Color(0xFF7C3AED)};
      case 'informational':
        return {'typeBg': const Color(0xFFFEF3C7), 'typeCol': const Color(0xFFD97706)};
      case 'alert':
        return {'typeBg': const Color(0xFFFEE2E2), 'typeCol': const Color(0xFFDC2626)};
      case 'promotional':
      default:
        return {'typeBg': const Color(0xFFEFF6FF), 'typeCol': const Color(0xFF0284C7)};
    }
  }

  Map<String, Color> _getStatusVisuals(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return {'statusBg': const Color(0xFFE0F2FE), 'statusCol': const Color(0xFF0284C7)};
      case 'draft':
        return {'statusBg': const Color(0xFFF1F5F9), 'statusCol': const Color(0xFF64748B)};
      case 'sent':
      default:
        return {'statusBg': const Color(0xFFDCFCE7), 'statusCol': const Color(0xFF16A36A)};
    }
  }

  void _setFallbackNotifications() {
    if (!mounted) return;
    setState(() {
      _notifications = [
        {
          'id': 1,
          '_id': 'notif_001',
          'title': 'New Home Loan Scheme',
          'message': 'Get home loans at just 8.5% p.a. with minimal processing fees.',
          'audience': 'Customers',
          'type': 'Promotional',
          'typeBg': const Color(0xFFEFF6FF),
          'typeCol': const Color(0xFF0284C7),
          'status': 'Sent',
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
          'sentOn': '12 Oct 2024\n10:30 AM',
          'engagement': '85%',
          'reach': '2,450/2,880',
        },
        {
          'id': 2,
          '_id': 'notif_002',
          'title': 'Diwali Special Offer',
          'message': 'Special gift hampers and +0.25% commission bonus for top partners.',
          'audience': 'Partners',
          'type': 'Promotional',
          'typeBg': const Color(0xFFEFF6FF),
          'typeCol': const Color(0xFF0284C7),
          'status': 'Sent',
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
          'sentOn': '10 Oct 2024\n09:15 AM',
          'engagement': '72%',
          'reach': '320/445',
        },
      ];
      _totalCount = _notifications.length;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedAudience = 'All Audiences';
      _selectedType = 'All Types';
      _selectedStatus = 'All Status';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  List get _filteredNotifications {
    final query = _searchController.text.trim().toLowerCase();

    return _notifications.where((item) {
      final title = item['title'].toString().toLowerCase();
      final msg = item['message'].toString().toLowerCase();
      final aud = item['audience'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          title.contains(query) ||
          msg.contains(query) ||
          aud.contains(query);

      final matchesAudience = _selectedAudience == 'All Audiences' ||
          item['audience'].toString().toLowerCase() == _selectedAudience.toLowerCase();

      final matchesType = _selectedType == 'All Types' ||
          item['type'].toString().toLowerCase() == _selectedType.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

      return matchesSearch && matchesAudience && matchesType && matchesStatus;
    }).toList();
  }

  // ==========================================
  // CREATE NOTIFICATION MODAL (Live POST API)
  // ==========================================
  void _openCreateNotificationModal() {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    String audience = 'Customers';
    String notificationType = 'Promotional';
    bool sendNow = true;
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
                  'Create Notification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
                IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Title *', 'Enter notification title'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: msgCtrl,
                        maxLines: 3,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Message *', 'Enter your message here...'),
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: audience,
                        items: const ['Customers', 'Partners', 'Team Members', 'All']
                            .map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => audience = val);
                        },
                        decoration: _inputDecoration('Audience *', ''),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'Notification Type *',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: ['Promotional', 'Informational', 'Transactional', 'Alert'].map((type) {
                          final isSelected = notificationType == type;
                          return InkWell(
                            onTap: () => setModalState(() => notificationType = type),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF0F3E38) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'Schedule *',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: sendNow,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => sendNow = v!),
                              ),
                              const Text('Send Now', style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: sendNow,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) => setModalState(() => sendNow = v!),
                              ),
                              const Text('Schedule for Later', style: TextStyle(fontSize: 11)),
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
                      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/notifications'));
                      final res = await http.post(
                        url,
                        headers: {
                          'Content-Type': 'application/json',
                          if (token != null) 'Authorization': 'Bearer $token',
                        },
                        body: jsonEncode({
                          'title': titleCtrl.text.trim(),
                          'message': msgCtrl.text.trim(),
                          'audience': audience,
                          'type': notificationType,
                          'sendNow': sendNow,
                        }),
                      ).timeout(const Duration(seconds: 10));

                      if (res.statusCode == 200 || res.statusCode == 201) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        _fetchNotifications();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(sendNow
                                  ? 'Notification dispatched to $audience!'
                                  : 'Notification scheduled successfully!'),
                              backgroundColor: const Color(0xFF16A36A),
                            ),
                          );
                        }
                      } else {
                        throw Exception();
                      }
                    } catch (_) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchNotifications();
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
                    : const Text('Send Notification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // VIEW NOTIFICATION DETAILS MODAL
  // ==========================================
  void _openViewNotificationModal(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notification Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
            ),
            IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  item['message'] as String,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Audience', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text(item['audience'] as String, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category Type', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text(item['type'] as String, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Reach & Engagement', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text('${item['reach']} (${item['engagement']})', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF16A36A))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // RESEND NOTIFICATION (Live PUT API)
  // ==========================================
  Future<void> _resendNotification(Map<String, dynamic> item) async {
    try {
      final token = await SharedPrefHelper.getToken();
      final id = item['_id'];
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/notifications/$id/resend'));

      final res = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        _fetchNotifications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Resent notification: ${item['title']}'),
              backgroundColor: const Color(0xFF16A36A),
            ),
          );
        }
      }
    } catch (_) {
      _fetchNotifications();
    }
  }

  // ==========================================
  // DELETE NOTIFICATION (Live DELETE API)
  // ==========================================
  Future<void> _deleteNotification(Map<String, dynamic> item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Delete Notification?',
          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
        ),
        content: Text('Are you sure you want to delete "${item['title']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), elevation: 0),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final token = await SharedPrefHelper.getToken();
        final id = item['_id'];
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/notifications/$id'));

        final res = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          _fetchNotifications();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted notification: ${item['title']}')),
            );
          }
        }
      } catch (_) {
        setState(() => _notifications.removeWhere((n) => n['_id'] == item['_id']));
      }
    }
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
              _buildHeaderSection(),
              const SizedBox(height: 16),
              _buildTopMetricsRow(),
              const SizedBox(height: 16),
              _buildFilterToolbar(),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              )
                  : _buildNotificationsDataTable(),
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
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Send push notifications and announcements to customers, partners or internal team members.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _openCreateNotificationModal,
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Create Notification',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
              tooltip: 'Refresh Notifications',
              onPressed: _fetchNotifications,
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
            title: 'Total Notifications',
            value: '$_totalCount',
            badgeText: '+Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'All time',
            icon: Icons.notifications_active_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Sent to Customers',
            value: '$_customersCount',
            badgeText: 'Active',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'App users',
            icon: Icons.people_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Sent to Partners',
            value: '$_partnersCount',
            badgeText: 'DSA',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Channel partners',
            icon: Icons.handshake_outlined,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Sent to Team Members',
            value: '$_teamCount',
            badgeText: 'Staff',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Internal officers',
            icon: Icons.badge_outlined,
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
                child: Text(badgeText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: badgeColor)),
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
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
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
                  hintText: 'Search notifications by title, message or audience...',
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
              value: _selectedAudience,
              items: _audienceOptions,
              onChanged: (v) => setState(() => _selectedAudience = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedType,
              items: _typeOptions,
              onChanged: (v) => setState(() => _selectedType = v!),
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
              value: _selectedDateRange,
              items: const ['All Time', 'Today', 'This Week', 'This Month'],
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
          value: items.contains(value) ? value : items.first,
          icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
          isExpanded: true,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNotificationsDataTable() {
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
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
              Icon(Icons.notifications_off_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching notifications found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                  'Notifications (${notifications.length})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const Text(
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
                showCheckboxColumn: false, // 👈 Fixes the double checkbox bug!
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                headingRowHeight: 44,
                dataRowMinHeight: 54,
                dataRowMaxHeight: 58,
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
                            _selectedRows.addAll(List.generate(notifications.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(label: Text('Title & Message', style: _headerStyle)),
                  const DataColumn(label: Text('Audience', style: _headerStyle)),
                  const DataColumn(label: Text('Type', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Sent On', style: _headerStyle)),
                  const DataColumn(label: Text('Engagement', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(notifications.length, (index) {
                  final item = notifications[index];
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
                              _selectAll = _selectedRows.length == notifications.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        SizedBox(
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                              Text(
                                item['message'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item['audience'] == 'Customers'
                                  ? Icons.people_outline_rounded
                                  : item['audience'] == 'Partners'
                                  ? Icons.handshake_outlined
                                  : item['audience'] == 'Team Members'
                                  ? Icons.badge_outlined
                                  : Icons.all_inclusive_rounded,
                              size: 14,
                              color: const Color(0xFF0F3E38),
                            ),
                            const SizedBox(width: 5),
                            Text(item['audience'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(color: item['typeBg'] as Color, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            item['type'] as String,
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item['typeCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(color: item['statusBg'] as Color, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item['statusCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['sentOn'] as String,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.2),
                        ),
                      ),
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['engagement'] as String,
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38))),
                            Text(item['reach'] as String, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'View Details',
                              onPressed: () => _openViewNotificationModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.replay_rounded, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Resend',
                              onPressed: () => _resendNotification(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                              tooltip: 'Delete',
                              onPressed: () => _deleteNotification(item),
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
    final filtered = _filteredNotifications;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to ${filtered.length > _rowsPerPage ? _rowsPerPage : filtered.length} of ${filtered.length} notifications',
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
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
                  items: [10, 25, 50].map((n) => DropdownMenuItem(value: n, child: Text('$n per page'))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _rowsPerPage = val);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}