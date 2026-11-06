import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class SupportQueriesScreen extends StatefulWidget {
  const SupportQueriesScreen({super.key});

  @override
  State<SupportQueriesScreen> createState() => _SupportQueriesScreenState();
}

class _SupportQueriesScreenState extends State<SupportQueriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  String _selectedUserType = 'All Users';
  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All Status';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};

  final List<String> _userTypes = [
    'All Users',
    'Customer',
    'Partner',
  ];

  final List<String> _categoryOptions = [
    'All Categories',
    'Technical',
    'Payout',
    'Account',
    'Loan Inquiry',
    'General',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  // PDF Page 19 ke 10 support ticket records[cite: 19]
  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 1,
      'ticketId': 'MF-001',
      'user': 'Rohit Kumar',
      'userType': 'Customer',
      'email': 'rohit@gmail.com',
      'phone': '+91 9876543210',
      'subject': 'Loan application not submitting',
      'message':
      'I am facing an issue while submitting my loan application. It shows an error on the final step.',
      'category': 'Technical',
      'priority': 'High',
      'status': 'Open',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'assignedTo': 'Neha Gupta',
      'createdOn': '15 Oct 2024\n10:30 AM',
      'replies': [
        {
          'sender': 'Rohit Kumar',
          'role': 'Customer',
          'time': '15 Oct 2024, 10:30 AM',
          'text':
          'I am facing an issue while submitting my loan application. It shows an error on the final step.',
          'isCustomer': true,
        },
        {
          'sender': 'Neha Gupta',
          'role': 'Support Agent',
          'time': '15 Oct 2024, 11:15 AM',
          'text':
          'Hi Rohit, This issue is now fixed. Please try again and let us know if you still face any problem.',
          'isCustomer': false,
        },
      ],
    },
    {
      'id': 2,
      'ticketId': 'MF-002',
      'user': 'Pooja Verma',
      'userType': 'Partner',
      'email': 'pooja@gmail.com',
      'phone': '+91 9123456789',
      'subject': 'Commission not reflected',
      'message': 'My September commission for Lead #LD0002 is missing.',
      'category': 'Payout',
      'priority': 'High',
      'status': 'Open',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'assignedTo': 'Priya Sharma',
      'createdOn': '14 Oct 2024\n04:15 PM',
      'replies': [],
    },
    {
      'id': 3,
      'ticketId': 'MF-003',
      'user': 'Amit Yadav',
      'userType': 'Customer',
      'email': 'amit@gmail.com',
      'phone': '+91 9988766554',
      'subject': 'Document upload issue',
      'message': 'Salary slip PDF fails to upload on step 3.',
      'category': 'Technical',
      'priority': 'Medium',
      'status': 'In Progress',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'assignedTo': 'Neha Gupta',
      'createdOn': '14 Oct 2024\n11:20 AM',
      'replies': [],
    },
    {
      'id': 4,
      'ticketId': 'MF-004',
      'user': 'Neha Gupta',
      'userType': 'Customer',
      'email': 'neha.g@gmail.com',
      'phone': '+91 9871122334',
      'subject': 'Loan status update',
      'message': 'Need update on my personal loan application LD0004.',
      'category': 'Loan Inquiry',
      'priority': 'Low',
      'status': 'Resolved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'assignedTo': 'Vikram Yadav',
      'createdOn': '13 Oct 2024\n02:45 PM',
      'replies': [],
    },
    {
      'id': 5,
      'ticketId': 'MF-005',
      'user': 'Vikram Singh',
      'userType': 'Partner',
      'email': 'vikram.s@gmail.com',
      'phone': '+91 8765432109',
      'subject': 'Lead status not updated',
      'message': 'Customer verified but lead still shows under review.',
      'category': 'Loan Inquiry',
      'priority': 'Medium',
      'status': 'In Progress',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'assignedTo': 'Rahul Kumar',
      'createdOn': '12 Oct 2024\n05:20 PM',
      'replies': [],
    },
    {
      'id': 6,
      'ticketId': 'MF-006',
      'user': 'Suresh Patel',
      'userType': 'Customer',
      'email': 'suresh.p@gmail.com',
      'phone': '+91 9654321098',
      'subject': 'Login issue',
      'message': 'OTP is not arriving on my registered mobile number.',
      'category': 'Account',
      'priority': 'Medium',
      'status': 'Resolved',
      'statusBg': const Color(0xFFDCFCE7),
      'statusCol': const Color(0xFF16A36A),
      'assignedTo': 'Neha Gupta',
      'createdOn': '12 Oct 2024\n09:30 AM',
      'replies': [],
    },
    {
      'id': 7,
      'ticketId': 'MF-007',
      'user': 'Anjali Sharma',
      'userType': 'Partner',
      'email': 'anjali.s@gmail.com',
      'phone': '+91 9876501987',
      'subject': 'Payout query',
      'message': 'TDS certificate required for financial year 2024-25.',
      'category': 'Payout',
      'priority': 'High',
      'status': 'Open',
      'statusBg': const Color(0xFFFEF3C7),
      'statusCol': const Color(0xFFD97706),
      'assignedTo': 'Priya Sharma',
      'createdOn': '11 Oct 2024\n03:50 PM',
      'replies': [],
    },
    {
      'id': 8,
      'ticketId': 'MF-008',
      'user': 'Rahul Mehta',
      'userType': 'Customer',
      'email': 'rahul.m@gmail.com',
      'phone': '+91 9123044556',
      'subject': 'Change mobile number',
      'message': 'Requesting phone number update for banking alerts.',
      'category': 'Account',
      'priority': 'Low',
      'status': 'Closed',
      'statusBg': const Color(0xFFF1F5F9),
      'statusCol': const Color(0xFF64748B),
      'assignedTo': 'Amit Yadav',
      'createdOn': '11 Oct 2024\n11:15 AM',
      'replies': [],
    },
    {
      'id': 9,
      'ticketId': 'MF-009',
      'user': 'Sunita Devi',
      'userType': 'Customer',
      'email': 'sunita.d@gmail.com',
      'phone': '+91 9987654321',
      'subject': 'EMI calculator not working',
      'message': 'Calculation shows blank on tenure changes in Android 14.',
      'category': 'Technical',
      'priority': 'Medium',
      'status': 'In Progress',
      'statusBg': const Color(0xFFE0F2FE),
      'statusCol': const Color(0xFF0284C7),
      'assignedTo': 'Neha Gupta',
      'createdOn': '10 Oct 2024\n10:00 AM',
      'replies': [],
    },
    {
      'id': 10,
      'ticketId': 'MF-010',
      'user': 'Arif Khan',
      'userType': 'Partner',
      'email': 'arif.k@gmail.com',
      'phone': '+91 9412367890',
      'subject': 'Need marketing materials',
      'message': 'Requesting physical brochures and banners for offline branch.',
      'category': 'General',
      'priority': 'Low',
      'status': 'Closed',
      'statusBg': const Color(0xFFF1F5F9),
      'statusCol': const Color(0xFF64748B),
      'assignedTo': 'Pooja Sharma',
      'createdOn': '10 Oct 2024\n04:25 PM',
      'replies': [],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedUserType = 'All Users';
      _selectedCategory = 'All Categories';
      _selectedStatus = 'All Status';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 19 ka Ticket Details Modal (Conversation, Internal Notes & Reply)[cite: 19]
  void _openTicketDetailsModal(Map<String, dynamic> ticket) {
    int modalTab = 0;
    final List<Map<String, dynamic>> replies =
    List.from(ticket['replies'] ?? []);

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
                Row(
                  children: [
                    Text(
                      '#${ticket['ticketId']}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F3E38)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: ticket['statusBg'] as Color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ticket['status'] as String,
                        style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: ticket['statusCol'] as Color),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            content: SizedBox(
              width: 540,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket['subject'] as String,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Created on: ${(ticket['createdOn'] as String).replaceAll('\n', ' ')}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),

                    // User Info Card[cite: 19]
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                            const Color(0xFF0F3E38).withValues(alpha: 0.1),
                            child: Text(
                              (ticket['user'] as String)[0],
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F3E38)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      ticket['user'] as String,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0F2FE),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        ticket['userType'] as String,
                                        style: const TextStyle(
                                            fontSize: 8.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0284C7)),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${ticket['phone']}  •  ${ticket['email']}',
                                  style: const TextStyle(
                                      fontSize: 9.5,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Meta Attributes Strip[cite: 19]
                    Row(
                      children: [
                        _buildMetaTag('Category', ticket['category'] as String),
                        const SizedBox(width: 8),
                        _buildMetaTag('Priority', ticket['priority'] as String),
                        const SizedBox(width: 8),
                        _buildMetaTag(
                            'Assigned To', ticket['assignedTo'] as String),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Subtabs: Conversation, Internal Notes (1), Ticket History[cite: 19]
                    Row(
                      children: [
                        _buildModalTab(
                          title: 'Conversation',
                          isSelected: modalTab == 0,
                          onTap: () => setModalState(() => modalTab = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Internal Notes (1)',
                          isSelected: modalTab == 1,
                          onTap: () => setModalState(() => modalTab = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Ticket History',
                          isSelected: modalTab == 2,
                          onTap: () => setModalState(() => modalTab = 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Message Thread[cite: 19]
                    Container(
                      height: 180,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: replies.isEmpty
                          ? Center(
                        child: Text(
                          ticket['message'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary),
                        ),
                      )
                          : ListView.builder(
                        itemCount: replies.length,
                        itemBuilder: (context, i) {
                          final msg = replies[i];
                          final isCust = msg['isCustomer'] == true;

                          return Align(
                            alignment: isCust
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(maxWidth: 360),
                              decoration: BoxDecoration(
                                color: isCust
                                    ? Colors.white
                                    : const Color(0xFF0F3E38),
                                borderRadius: BorderRadius.circular(8),
                                border: isCust
                                    ? Border.all(color: AppColors.border)
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: isCust
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${msg['sender']} (${msg['role']})',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: isCust
                                          ? AppColors.primary
                                          : const Color(0xFF5EEAD4),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    msg['text'] as String,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isCust
                                          ? AppColors.textPrimary
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    msg['time'] as String,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: isCust
                                          ? AppColors.textHint
                                          : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Reply Box[cite: 19]
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _replyController,
                            style: const TextStyle(fontSize: 11),
                            decoration: const InputDecoration(
                              hintText: 'Type your reply...',
                              hintStyle: TextStyle(
                                  fontSize: 11, color: AppColors.textHint),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_replyController.text.trim().isNotEmpty) {
                              setModalState(() {
                                replies.add({
                                  'sender': 'Super Admin',
                                  'role': 'Support Agent',
                                  'time': 'Just now',
                                  'text': _replyController.text.trim(),
                                  'isCustomer': false,
                                });
                                _replyController.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.send_rounded,
                              size: 14, color: Colors.white),
                          label: const Text('Send Reply',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F3E38),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetaTag(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $val',
        style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primary),
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
              // Header title and Create Ticket action[cite: 19]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 5 Metric Cards (Total, Open, In Progress, Resolved, Closed)[cite: 19]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 19]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Support Tickets Data Table[cite: 19]
              _buildTicketsDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 19]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 19]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Support & Queries',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage and resolve customer and partner support tickets efficiently.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create ticket form opened!'),
                backgroundColor: Color(0xFF0F3E38),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Create Ticket',
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

  // 1. Five Metric Cards[cite: 19]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Tickets',
            value: '248',
            badgeText: '↑ 12%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'All time',
            icon: Icons.confirmation_number_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Open Tickets',
            value: '48',
            badgeText: '↑ 8%',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Need attention',
            icon: Icons.error_outline_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'In Progress',
            value: '86',
            badgeText: '↑ 20%',
            badgeBg: const Color(0xFFE0F2FE),
            badgeColor: const Color(0xFF0284C7),
            subtitle: 'Being resolved',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Resolved',
            value: '102',
            badgeText: '↑ 28%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'This month',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Closed',
            value: '12',
            badgeText: '↓ 10%',
            badgeBg: const Color(0xFFF1F5F9),
            badgeColor: const Color(0xFF64748B),
            subtitle: 'Not applicable',
            icon: Icons.task_alt_rounded,
            iconBg: const Color(0xFFF1F5F9),
            iconColor: const Color(0xFF64748B),
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

  // 2. Search & Filter Bar[cite: 19]
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
                  hintText:
                  'Search tickets by ID, subject, customer name, mobile...',
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
              value: _selectedUserType,
              items: _userTypes,
              onChanged: (v) => setState(() => _selectedUserType = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedCategory,
              items: _categoryOptions,
              onChanged: (v) => setState(() => _selectedCategory = v!),
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

  // 3. Support Tickets Data Table[cite: 19]
  Widget _buildTicketsDataTable() {
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
                  'Support Tickets (248)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
                Text(
                  'Latest First ▾',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F3E38)),
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
                                List.generate(_tickets.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('Ticket ID & User', style: _headerStyle)),
                  const DataColumn(label: Text('Subject', style: _headerStyle)),
                  const DataColumn(label: Text('Category', style: _headerStyle)),
                  const DataColumn(label: Text('Priority', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Created On', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(_tickets.length, (index) {
                  final item = _tickets[index];
                  final isSelected = _selectedRows.contains(index);

                  Color priorityCol = const Color(0xFF16A36A);
                  if (item['priority'] == 'High') {
                    priorityCol = const Color(0xFFDC2626);
                  } else if (item['priority'] == 'Medium') {
                    priorityCol = const Color(0xFFD97706);
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
                              _selectAll =
                                  _selectedRows.length == _tickets.length;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            Text(
                              '#${item['ticketId']}',
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F3E38)),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['user'] as String,
                                    style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary)),
                                Text('(${item['userType']})',
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 220,
                          child: Text(
                            item['subject'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary),
                          ),
                        ),
                      ),
                      DataCell(Text(item['category'] as String,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textPrimary))),
                      DataCell(
                        Text(
                          item['priority'] as String,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: priorityCol),
                        ),
                      ),
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
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: item['statusCol'] as Color,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['createdOn'] as String,
                          style: const TextStyle(
                              fontSize: 10,
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
                              tooltip: 'View Ticket',
                              onPressed: () => _openTicketDetailsModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Assign / Edit',
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
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // 4. Pagination Footer[cite: 19]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 248 tickets',
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