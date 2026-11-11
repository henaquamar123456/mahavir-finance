import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

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
  bool _isLoading = false;

  int _totalTickets = 248;
  int _openTickets = 48;
  int _inProgressTickets = 86;
  int _resolvedTickets = 102;
  int _closedTickets = 12;

  final List<String> _userTypes = const [
    'All Users',
    'Customer',
    'Partner',
  ];

  final List<String> _categoryOptions = const [
    'All Categories',
    'Technical',
    'Payout',
    'Account',
    'Loan Inquiry',
    'General',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  final List<String> _supportOfficers = const [
    'Neha Gupta',
    'Priya Sharma',
    'Vikram Yadav',
    'Rahul Kumar',
    'Amit Yadav',
    'Pooja Sharma',
  ];

  List _tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/tickets'));

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
          list = rawData['tickets'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final t = list[i];
    final st = (t['status'] ?? 'Open').toString();

    loaded.add({
    'id': i + 1,
    '_id': t['_id'] ?? '',
    'ticketId': t['ticketId'] ?? 'MF-${(i + 1).toString().padLeft(3, '0')}',
    'user': t['user'] ?? 'User',
    'userType': t['userType'] ?? 'Customer',
    'email': t['email'] ?? 'user@gmail.com',
    'phone': t['phone'] ?? '+91 9876543210',
    'subject': t['subject'] ?? 'Query',
    'message': t['message'] ?? '',
    'category': t['category'] ?? 'General',
    'priority': t['priority'] ?? 'Medium',
    'status': st,
    'assignedTo': t['assignedTo'] ?? 'Neha Gupta',
    'createdOn': t['createdOn'] ?? 'Recent',
    'replies': t['replies'] is List ? List.from(t['replies']) : [],
    ..._getStatusVisuals(st),
    });
    }

    if (mounted) {
    setState(() {
    _tickets = loaded;
    if (stats != null) {
    _totalTickets = stats['totalTickets'] ?? loaded.length;
    _openTickets = stats['openTickets'] ?? loaded.where((x) => x['status'] == 'Open').length;
    _inProgressTickets = stats['inProgressTickets'] ?? loaded.where((x) => x['status'] == 'In Progress').length;
    _resolvedTickets = stats['resolvedTickets'] ?? loaded.where((x) => x['status'] == 'Resolved').length;
    _closedTickets = stats['closedTickets'] ?? loaded.where((x) => x['status'] == 'Closed').length;
    } else {
    _totalTickets = loaded.length;
    }
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackTickets();
    } catch (_) {
    _setFallbackTickets();
    }
  }

  Map<String, Color> _getStatusVisuals(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return {'statusBg': const Color(0xFFDCFCE7), 'statusCol': const Color(0xFF16A36A)};
      case 'in progress':
        return {'statusBg': const Color(0xFFE0F2FE), 'statusCol': const Color(0xFF0284C7)};
      case 'closed':
        return {'statusBg': const Color(0xFFF1F5F9), 'statusCol': const Color(0xFF64748B)};
      case 'open':
      default:
        return {'statusBg': const Color(0xFFFEF3C7), 'statusCol': const Color(0xFFD97706)};
    }
  }

  void _setFallbackTickets() {
    if (!mounted) return;
    setState(() {
      _tickets = [
        {
          'id': 1,
          '_id': 't1',
          'ticketId': 'MF-001',
          'user': 'Rohit Kumar',
          'userType': 'Customer',
          'email': 'rohit@gmail.com',
          'phone': '+91 9876543210',
          'subject': 'Loan application not submitting',
          'message': 'I am facing an issue while submitting my loan application. It shows an error on the final step.',
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
              'text': 'I am facing an issue while submitting my loan application. It shows an error on the final step.',
              'isCustomer': true,
            },
          ],
        },
      ];
      _totalTickets = _tickets.length;
      _isLoading = false;
    });
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

  List get _filteredTickets {
    final query = _searchController.text.trim().toLowerCase();

    return _tickets.where((item) {
      final user = item['user'].toString().toLowerCase();
      final tId = item['ticketId'].toString().toLowerCase();
      final sub = item['subject'].toString().toLowerCase();
      final phone = item['phone'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          user.contains(query) ||
          tId.contains(query) ||
          sub.contains(query) ||
          phone.contains(query);

      final matchesUserType = _selectedUserType == 'All Users' ||
          item['userType'].toString().toLowerCase() == _selectedUserType.toLowerCase();

      final matchesCategory = _selectedCategory == 'All Categories' ||
          item['category'].toString().toLowerCase() == _selectedCategory.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

      return matchesSearch && matchesUserType && matchesCategory && matchesStatus;
    }).toList();
  }

  // ==========================================
  // CREATE TICKET MODAL (Live POST API)
  // ==========================================
  void _openCreateTicketModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    String userType = 'Customer';
    String category = 'Technical';
    String priority = 'High';
    String assignedTo = 'Neha Gupta';
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
              const Text(
                'Create New Support Ticket',
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
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: nameCtrl,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            decoration: _inputDecoration('User / Customer Name *', 'Rohit Kumar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: userType,
                            items: const ['Customer', 'Partner']
                                .map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => userType = val);
                            },
                            decoration: _inputDecoration('User Type *', ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().length != 10) ? '10 digits' : null,
                            decoration: _inputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration('Email Address', 'user@gmail.com'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: category,
                            items: _categoryOptions
                                .where((c) => c != 'All Categories')
                                .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => category = val);
                            },
                            decoration: _inputDecoration('Category *', ''),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: priority,
                            items: const ['High', 'Medium', 'Low']
                                .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => priority = val);
                            },
                            decoration: _inputDecoration('Priority *', ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: subjectCtrl,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _inputDecoration('Subject *', 'Brief issue title'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: messageCtrl,
                      maxLines: 3,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _inputDecoration('Message Description *', 'Describe query or problem in detail...'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: assignedTo,
                      items: _supportOfficers
                          .map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => assignedTo = val);
                      },
                      decoration: _inputDecoration('Assign to Officer', ''),
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
                    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/tickets'));
                    final res = await http.post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'user': nameCtrl.text.trim(),
                        'userType': userType,
                        'phone': phoneCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'subject': subjectCtrl.text.trim(),
                        'message': messageCtrl.text.trim(),
                        'category': category,
                        'priority': priority,
                        'assignedTo': assignedTo,
                      }),
                    ).timeout(const Duration(seconds: 10));

                    if (res.statusCode == 200 || res.statusCode == 201) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchTickets();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support ticket created successfully!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    } else {
                      throw Exception();
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchTickets();
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
                  : const Text('Create Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EDIT TICKET STATUS / ASSIGN MODAL (Live PUT API)
  // ==========================================
  void _openEditTicketModal(Map<String, dynamic> ticket) {
    String status = ticket['status'] ?? 'Open';
    String assignedTo = ticket['assignedTo'] ?? 'Neha Gupta';
    String priority = ticket['priority'] ?? 'Medium';
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
              Text(
                'Update Ticket #${ticket['ticketId']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User: ${ticket['user']} (${ticket['userType']})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Text('Subject: ${ticket['subject']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: status,
                  items: const ['Open', 'In Progress', 'Resolved', 'Closed']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => status = val);
                  },
                  decoration: _inputDecoration('Ticket Status', ''),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _supportOfficers.contains(assignedTo) ? assignedTo : _supportOfficers.first,
                  items: _supportOfficers
                      .map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => assignedTo = val);
                  },
                  decoration: _inputDecoration('Assigned Support Officer', ''),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: const ['High', 'Medium', 'Low']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => priority = val);
                  },
                  decoration: _inputDecoration('Priority Level', ''),
                ),
              ],
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
                setModalState(() => isSubmitting = true);
                try {
                  final token = await SharedPrefHelper.getToken();
                  final tId = ticket['_id'];
                  final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/tickets/$tId'));

                  final res = await http.put(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                      if (token != null) 'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode({
                      'status': status,
                      'assignedTo': assignedTo,
                      'priority': priority,
                    }),
                  ).timeout(const Duration(seconds: 10));

                  if (res.statusCode == 200) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchTickets();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ticket updated successfully!'),
                          backgroundColor: Color(0xFF16A36A),
                        ),
                      );
                    }
                  }
                } catch (_) {
                  if (ctx.mounted) Navigator.pop(ctx);
                  _fetchTickets();
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
  // VIEW CONVERSATION & REPLY (Live POST Reply API)
  // ==========================================
  void _openTicketDetailsModal(Map<String, dynamic> ticket) {
    int modalTab = 0;
    final List replies = List.from(ticket['replies'] ?? []);
    bool isSendingReply = false;

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
    Row(
    children: [
    Text(
    '#${ticket['ticketId']}',
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F3E38)),
    ),
    const SizedBox(width: 8),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
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
    IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
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
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.primary),
    ),
    const SizedBox(height: 2),
    Text(
    'Created on: ${(ticket['createdOn'] as String).replaceAll('\n', ' ')}',
    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
    ),
    const SizedBox(height: 10),

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
    backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
    child: Text(
    (ticket['user'] as String).isNotEmpty ? (ticket['user'] as String)[0].toUpperCase() : 'U',
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
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
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
    ),
    const SizedBox(width: 6),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
    color: const Color(0xFFE0F2FE),
    borderRadius: BorderRadius.circular(3),
    ),
    child: Text(
    ticket['userType'] as String,
    style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Color(0xFF0284C7)),
    ),
    ),
    ],
    ),
    Text(
    '${ticket['phone']} • ${ticket['email']}',
    style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 10),

    Row(
    children: [
    _buildMetaTag('Category', ticket['category'] as String),
    const SizedBox(width: 8),
    _buildMetaTag('Priority', ticket['priority'] as String),
    const SizedBox(width: 8),
    _buildMetaTag('Assigned', ticket['assignedTo'] as String),
    ],
    ),
    const SizedBox(height: 12),

    Row(
    children: [
    _buildModalTab(
    title: 'Conversation',
    isSelected: modalTab == 0,
    onTap: () => setModalState(() => modalTab = 0),
    ),
    const SizedBox(width: 8),
    _buildModalTab(
    title: 'Internal Notes',
    isSelected: modalTab == 1,
    onTap: () => setModalState(() => modalTab = 1),
    ),
    ],
    ),
    const SizedBox(height: 12),

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
    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
    ),
    )
        : ListView.builder(
    itemCount: replies.length,
    itemBuilder: (context, i) {
    final msg = replies[i];
    final isCust = msg['isCustomer'] == true;

    return Align(
    alignment: isCust ? Alignment.centerLeft : Alignment.centerRight,
    child: Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(8),
    constraints: const BoxConstraints(maxWidth: 360),
    decoration: BoxDecoration(
    color: isCust ? Colors.white : const Color(0xFF0F3E38),
    borderRadius: BorderRadius.circular(8),
    border: isCust ? Border.all(color: AppColors.border) : null,
    ),
    child: Column(
    crossAxisAlignment: isCust ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    children: [
    Text(
    '${msg['sender']} (${msg['role']})',
    style: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: isCust ? AppColors.primary : const Color(0xFF5EEAD4),
    ),
    ),
    const SizedBox(height: 2),
    Text(
    msg['text'] as String,
    style: TextStyle(
    fontSize: 10.5,
    color: isCust ? AppColors.textPrimary : Colors.white,
    ),
    ),
    const SizedBox(height: 2),
    Text(
    msg['time'] as String,
    style: TextStyle(
    fontSize: 8,
    color: isCust ? AppColors.textHint : Colors.white70,
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

    Row(
    children: [
    Expanded(
    child: TextField(
    controller: _replyController,
    style: const TextStyle(fontSize: 11),
    decoration: const InputDecoration(
    hintText: 'Type your official reply...',
    hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.border),
    ),
    ),
    ),
    ),
    const SizedBox(width: 8),
    ElevatedButton.icon(
    onPressed: isSendingReply
    ? null
        : () async {
    final replyText = _replyController.text.trim();
    if (replyText.isNotEmpty) {
    setModalState(() => isSendingReply = true);
    try {
    final token = await SharedPrefHelper.getToken();
    final tId = ticket['_id'];
    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/tickets/$tId/reply'));

    final res = await http.post(
    url,
    headers: {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
    'text': replyText,
    'sender': 'Super Admin',
    'role': 'Support Desk',
    }),
    );

    if (res.statusCode == 200) {
    setModalState(() {
    replies.add({
    'sender': 'Super Admin',
    'role': 'Support Desk',
    'time': 'Just now',
    'text': replyText,
    'isCustomer': false,
    });
    ticket['status'] = 'In Progress';
    ticket['statusBg'] = const Color(0xFFE0F2FE);
    ticket['statusCol'] = const Color(0xFF0284C7);
    _replyController.clear();
    isSendingReply = false;
    });
    _fetchTickets();
    }
    } catch (_) {
    setModalState(() => isSendingReply = false);
    }
    }
    },
    icon: isSendingReply
    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : const Icon(Icons.send_rounded, size: 14, color: Colors.white),
    label: const Text('Send Reply', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF0F3E38),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  // ==========================================
  // DELETE TICKET (Live DELETE API)
  // ==========================================
  Future<void> _deleteTicket(Map<String, dynamic> ticket) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete Ticket #${ticket['ticketId']}?', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
        content: const Text('Are you sure you want to permanently delete this support ticket from the system?'),
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
        final tId = ticket['_id'];
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/tickets/$tId'));

        final res = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          _fetchTickets();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted ticket: #${ticket['ticketId']}')),
            );
          }
        }
      } catch (_) {
        setState(() => _tickets.removeWhere((t) => t['_id'] == ticket['_id']));
      }
    }
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
        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
    );
  }

  Widget _buildModalTab({required String title, required bool isSelected, required VoidCallback onTap}) {
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

  InputDecoration _inputDecoration(String label, String hint, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
      hintText: hint,
      prefixText: prefix,
      prefixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
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
              _buildFilterToolbar(),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              )
                  : _buildTicketsDataTable(),
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
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _openCreateTicketModal,
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Create Ticket',
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
              tooltip: 'Refresh Tickets',
              onPressed: _fetchTickets,
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
            title: 'Total Tickets',
            value: '$_totalTickets',
            badgeText: '+Live',
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
            value: '$_openTickets',
            badgeText: 'Action',
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
            value: '$_inProgressTickets',
            badgeText: 'Reviewing',
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
            value: '$_resolvedTickets',
            badgeText: 'Done',
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
            value: '$_closedTickets',
            badgeText: 'Closed',
            badgeBg: const Color(0xFFF1F5F9),
            badgeColor: const Color(0xFF64748B),
            subtitle: 'Completed issues',
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
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Search tickets by ID, subject, customer name, mobile...',
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

  Widget _buildTicketsDataTable() {
    final tickets = _filteredTickets;

    if (tickets.isEmpty) {
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
              Icon(Icons.confirmation_number_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching support tickets found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                  'Support Tickets (${tickets.length})',
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
                            _selectedRows.addAll(List.generate(tickets.length, (i) => i));
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
                rows: List.generate(tickets.length, (index) {
                  final item = tickets[index];
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
                              _selectAll = _selectedRows.length == tickets.length;
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
                              tooltip: 'View Ticket & Conversation',
                              onPressed: () => _openTicketDetailsModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Assign / Update Status',
                              onPressed: () => _openEditTicketModal(item),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded,
                                  size: 16, color: AppColors.iconSecondary),
                              onSelected: (val) {
                                if (val == 'delete') {
                                  _deleteTicket(item);
                                }
                              },
                              itemBuilder: (ctx) => [
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                                      SizedBox(width: 8),
                                      Text('Delete Ticket', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
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
    final filtered = _filteredTickets;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to ${filtered.length > _rowsPerPage ? _rowsPerPage : filtered.length} of ${filtered.length} tickets',
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
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                  items: [10, 25, 50, 100]
                      .map((n) =>
                      DropdownMenuItem(value: n, child: Text('$n per page')))
                      .toList(),
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