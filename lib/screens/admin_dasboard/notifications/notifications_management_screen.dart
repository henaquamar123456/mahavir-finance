import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

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

  final List<String> _audienceOptions = [
    'All Audiences',
    'Customers',
    'Partners',
    'Team Members',
    'All',
  ];

  final List<String> _typeOptions = [
    'All Types',
    'Promotional',
    'Transactional',
    'Informational',
    'Alert',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Sent',
    'Scheduled',
    'Draft',
  ];

  // PDF Page 16 ke sabhi 10 Notifications ka data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
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
    {
      'id': 3,
      'title': 'Your Loan Application Update',
      'message': 'Your home loan application has been approved by the credit desk.',
      'audience': 'Customers',
      'type': 'Transactional',
      'typeBg': const Color(0xFFF3E8FF),
      'typeCol': const Color(0xFF7C3AED),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '08 Oct 2024\n04:20 PM',
      'engagement': '92%',
      'reach': '1,120/1,220',
    },
    {
      'id': 4,
      'title': 'Commission Credited',
      'message': 'September month commission payout has been processed to your bank.',
      'audience': 'Partners',
      'type': 'Transactional',
      'typeBg': const Color(0xFFF3E8FF),
      'typeCol': const Color(0xFF7C3AED),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '05 Oct 2024\n11:00 AM',
      'engagement': '78%',
      'reach': '295/380',
    },
    {
      'id': 5,
      'title': 'System Maintenance',
      'message': 'Our server services will be temporarily down this Sunday from 2 AM to 4 AM.',
      'audience': 'All',
      'type': 'Alert',
      'typeBg': const Color(0xFFFEE2E2),
      'typeCol': const Color(0xFFDC2626),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '02 Oct 2024\n09:45 PM',
      'engagement': '95%',
      'reach': '4,200/4,420',
    },
    {
      'id': 6,
      'title': 'New Partner Registration',
      'message': 'Complete your CKYC verification to start referring loan leads today.',
      'audience': 'Partners',
      'type': 'Informational',
      'typeBg': const Color(0xFFFEF3C7),
      'typeCol': const Color(0xFFD97706),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '28 Sep 2024\n10:10 AM',
      'engagement': '68%',
      'reach': '212/310',
    },
    {
      'id': 7,
      'title': 'Blog Update: Tax Saving Guide',
      'message': 'Check out our new guide on saving tax on home loans under Section 24b.',
      'audience': 'Customers',
      'type': 'Informational',
      'typeBg': const Color(0xFFFEF3C7),
      'typeCol': const Color(0xFFD97706),
      'status': 'Scheduled',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'sentOn': '15 Oct 2024\n10:00 AM',
      'engagement': '—',
      'reach': 'Scheduled',
    },
    {
      'id': 8,
      'title': 'Lead Assigned for Verification',
      'message': 'A new loan lead has been assigned to your executive pipeline for review.',
      'audience': 'Team Members',
      'type': 'Transactional',
      'typeBg': const Color(0xFFF3E8FF),
      'typeCol': const Color(0xFF7C3AED),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '25 Sep 2024\n02:30 PM',
      'engagement': '98%',
      'reach': '48/49',
    },
    {
      'id': 9,
      'title': 'Q3 Loan Policy Update',
      'message': 'Our loan qualification rules and interest slabs have been updated for Q3.',
      'audience': 'Partners',
      'type': 'Informational',
      'typeBg': const Color(0xFFFEF3C7),
      'typeCol': const Color(0xFFD97706),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '20 Sep 2024\n11:15 AM',
      'engagement': '88%',
      'reach': '176/200',
    },
    {
      'id': 10,
      'title': 'Welcome to Mahavir Finance',
      'message': 'Thank you for joining our financial family. Explore loans with low interest rates.',
      'audience': 'Customers',
      'type': 'Transactional',
      'typeBg': const Color(0xFFF3E8FF),
      'typeCol': const Color(0xFF7C3AED),
      'status': 'Sent',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'sentOn': '18 Sep 2024\n10:00 AM',
      'engagement': '74%',
      'reach': '3,850/5,200',
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
      _selectedAudience = 'All Audiences';
      _selectedType = 'All Types';
      _selectedStatus = 'All Status';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 16 ka Create Notification Form Modal[cite: 16]
  void _openCreateNotificationModal() {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    String audience = 'Customers';
    String notificationType = 'Promotional';
    bool sendNow = true;

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
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field[cite: 16]
                      TextFormField(
                        controller: titleCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Title *', 'Enter notification title'),
                      ),
                      const SizedBox(height: 12),

                      // Message Field[cite: 16]
                      TextFormField(
                        controller: msgCtrl,
                        maxLines: 3,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Message *', 'Enter your message here...'),
                      ),
                      const SizedBox(height: 12),

                      // Audience Dropdown[cite: 16]
                      DropdownButtonFormField<String>(
                        value: audience,
                        items: ['Customers', 'Partners', 'Team Members', 'All']
                            .map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (val) => setModalState(() => audience = val!),
                        decoration: _inputDecoration('Audience *', ''),
                      ),
                      const SizedBox(height: 14),

                      // Notification Type Selection Pills[cite: 16]
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

                      // Media Upload Box (Optional)[cite: 16]
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.cloud_upload_outlined, size: 22, color: Color(0xFF0F3E38)),
                            SizedBox(height: 4),
                            Text(
                              'Media (Optional) - Upload Image',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                            ),
                            Text('PNG, JPG up to 2MB', style: TextStyle(fontSize: 9.5, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Schedule Selection: Send Now vs Schedule for Later[cite: 16]
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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(sendNow
                            ? 'Notification dispatched to $audience!'
                            : 'Notification scheduled successfully!'),
                        backgroundColor: const Color(0xFF0F3E38),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Send Notification',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
              // Header section and Create Notification button[cite: 16]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total, Customers, Partners, Team Members)[cite: 16]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 16]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Notifications Data Table[cite: 16]
              _buildNotificationsDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 16]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 16]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
      ],
    );
  }

  // 1. Four Metric Badges[cite: 16]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Notifications',
            value: '124',
            badgeText: '↑ 18%',
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
            value: '56',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '45.2% of total',
            icon: Icons.people_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Sent to Partners',
            value: '48',
            badgeText: '↑ 25%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '38.7% of total',
            icon: Icons.handshake_outlined,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Sent to Team Members',
            value: '20',
            badgeText: '↑ 8%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '16.1% of total',
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

  // 2. Search & Filter Bar[cite: 16]
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

  // 3. Notifications Data Table[cite: 16]
  Widget _buildNotificationsDataTable() {
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
                  'Notifications (124)',
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
                            _selectedRows.addAll(List.generate(_notifications.length, (i) => i));
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
                rows: List.generate(_notifications.length, (index) {
                  final item = _notifications[index];
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
                              _selectAll = _selectedRows.length == _notifications.length;
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
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.replay_rounded, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Resend',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Resending notification: ${item['title']}...')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                              tooltip: 'Delete',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Deleted notification: ${item['title']}')),
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

  // 4. Pagination Footer[cite: 16]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 124 notifications',
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
                  items: [10, 25, 50].map((n) => DropdownMenuItem(value: n, child: Text('$n per page'))).toList(),
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
            const Text('...', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            _buildPageButton('13'),
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