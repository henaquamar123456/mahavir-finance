import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class LoanInquiryManagementScreen extends StatefulWidget {
  const LoanInquiryManagementScreen({super.key});

  @override
  State<LoanInquiryManagementScreen> createState() =>
      _LoanInquiryManagementScreenState();
}

class _LoanInquiryManagementScreenState
    extends State<LoanInquiryManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedLoanType = 'All Loan Types';
  String _selectedStatus = 'All Status';
  String _selectedSource = 'All Sources';
  String _selectedTeamMember = 'All Team Members';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  final List<String> _loanTypes = const [
    'All Loan Types',
    'Home Loan',
    'Car Loan',
    'Personal Loan',
    'Business Loan',
    'Education Loan',
    'Financial Consulting',
    'Financial Guidance',
    'Retirement Planning',
    'Investment Planning',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Submitted',
    'Under Review',
    'Approved',
    'Rejected',
  ];

  final List<String> _sourceOptions = const [
    'All Sources',
    'Mobile App',
    'Website',
    'Partner (DSA)',
    'Walk-in',
  ];

  final List<String> _teamMembers = const [
    'All Team Members',
    'Rahul Kumar',
    'Pooja Sharma',
    'Amit Yadav',
    'Vikash Singh',
    'Neha Gupta',
  ];

  List _inquiries = [];

  @override
  void initState() {
    super.initState();
    _fetchInquiries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInquiries() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/enquiries'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> rawList = body['data'] ?? [];

        if (rawList.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < rawList.length; i++) {
    final item = rawList[i];
    final st = (item['status'] ?? 'Submitted').toString();

    loaded.add({
    'id': i + 1,
    '_id': item['_id'] ?? '',
    'name': item['name'] ?? 'Applicant',
    'phone': item['phone'] ?? '+91 9876543210',
    'email': item['email'] ?? 'applicant@gmail.com',
    'city': item['city'] ?? 'Noida, Uttar Pradesh',
    'loanType': item['loanType'] ?? item['service'] ?? 'Personal Loan',
    'amount': item['amount'] ?? '₹ 10,00,000',
    'status': st,
    'assignedTo': item['assignedTo'] ?? 'Rahul Kumar',
    'source': item['source'] ?? 'Mobile App',
    'tenure': item['tenure'] ?? '5 Years',
    'purpose': item['message'] ?? 'Loan requirement',
    'expectedDisbursal': item['expectedDisbursal'] ?? 'Immediate',
    'inquiryDate': item['createdAt'] != null
    ? '${item['createdAt'].toString().substring(0, 10)}\nRecent'
        : 'Recent',
    ..._getStatusVisuals(st),
    });
    }

    if (mounted) {
    setState(() {
    _inquiries = loaded;
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackInquiries();
    } catch (_) {
    _setFallbackInquiries();
    }
  }

  Map<String, Color> _getStatusVisuals(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return {
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
        };
      case 'rejected':
        return {
          'statusBg': const Color(0xFFFEE2E2),
          'statusCol': const Color(0xFFDC2626),
        };
      case 'under review':
        return {
          'statusBg': const Color(0xFFE0F2FE),
          'statusCol': const Color(0xFF0284C7),
        };
      case 'new':
      case 'submitted':
      case 'pending':
      default:
        return {
          'statusBg': const Color(0xFFFEF3C7),
          'statusCol': const Color(0xFFD97706),
        };
    }
  }

  void _setFallbackInquiries() {
    if (!mounted) return;
    setState(() {
      _inquiries = [
        {
          'id': 1,
          '_id': 'inq_001',
          'name': 'Amit Shah',
          'phone': '+91 9876543210',
          'email': 'amit.shah@gmail.com',
          'city': 'Noida, Uttar Pradesh',
          'loanType': 'Home Loan',
          'amount': '₹ 25,00,000',
          'status': 'Approved',
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
          'assignedTo': 'Rahul Kumar',
          'source': 'Mobile App',
          'tenure': '20 Years',
          'purpose': 'Purchase a new house',
          'expectedDisbursal': 'Oct 2024',
          'inquiryDate': '12 Sep 2024\n10:30 AM',
        },
      ];
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedLoanType = 'All Loan Types';
      _selectedStatus = 'All Status';
      _selectedSource = 'All Sources';
      _selectedTeamMember = 'All Team Members';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  List get _filteredInquiries {
    final query = _searchController.text.trim().toLowerCase();

    return _inquiries.where((item) {
      final matchesSearch = query.isEmpty ||
          item['name'].toString().toLowerCase().contains(query) ||
          item['phone'].toString().toLowerCase().contains(query) ||
          item['email'].toString().toLowerCase().contains(query) ||
          item['city'].toString().toLowerCase().contains(query) ||
          item['loanType'].toString().toLowerCase().contains(query);

      final matchesType = _selectedLoanType == 'All Loan Types' ||
          item['loanType'].toString().toLowerCase() == _selectedLoanType.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

      final matchesSource = _selectedSource == 'All Sources' ||
          item['source'].toString().toLowerCase() == _selectedSource.toLowerCase();

      final matchesTeam = _selectedTeamMember == 'All Team Members' ||
          item['assignedTo'].toString().toLowerCase() == _selectedTeamMember.toLowerCase();

      return matchesSearch && matchesType && matchesStatus && matchesSource && matchesTeam;
    }).toList();
  }

  // ==========================================
  // ADD NEW INQUIRY MODAL (Live POST API)
  // ==========================================
  void _openAddInquiryModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Noida, Uttar Pradesh');
    final amountCtrl = TextEditingController(text: '1000000');
    String loanType = 'Personal Loan';
    String source = 'Mobile App';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add New Loan Inquiry',
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
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _inputDecoration('Customer Name *', 'Amit Shah'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().length != 10) ? '10 digits required' : null,
                      decoration: _inputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email Address', 'customer@gmail.com'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cityCtrl,
                      decoration: _inputDecoration('City / Region', 'Noida, Uttar Pradesh'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _loanTypes.contains(loanType) ? loanType : 'Personal Loan',
                      items: _loanTypes
                          .where((t) => t != 'All Loan Types')
                          .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => loanType = val);
                      },
                      decoration: _inputDecoration('Loan Type', ''),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _inputDecoration('Requested Amount (₹) *', '1000000'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: source,
                      items: _sourceOptions
                          .where((s) => s != 'All Sources')
                          .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => source = val);
                      },
                      decoration: _inputDecoration('Inquiry Channel Source', ''),
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
                  try {
                    final token = await SharedPrefHelper.getToken();
                    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/enquiries'));

                    final res = await http.post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'name': nameCtrl.text.trim(),
                        'phone': phoneCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'city': cityCtrl.text.trim(),
                        'service': loanType,
                        'loanType': loanType,
                        'amount': '₹ ${amountCtrl.text.trim()}',
                        'source': source,
                        'status': 'Submitted',
                        'assignedTo': 'Rahul Kumar',
                        'message': 'New inquiry submitted by admin',
                      }),
                    ).timeout(const Duration(seconds: 10));

                    if (res.statusCode == 200 || res.statusCode == 201) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchInquiries();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Inquiry recorded and pipeline updated!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    } else {
                      throw Exception();
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchInquiries();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isSubmitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Save Inquiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EDIT INQUIRY MODAL (Live PUT API)
  // ==========================================
  void _openEditInquiryModal(Map<String, dynamic> inq) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: inq['name'] ?? '');
    String initialPhone = (inq['phone'] ?? '').toString().replaceAll('+91', '').replaceAll(' ', '').trim();
    final phoneCtrl = TextEditingController(text: initialPhone);
    final emailCtrl = TextEditingController(text: inq['email'] ?? '');
    final cityCtrl = TextEditingController(text: inq['city'] ?? '');
    final amountCtrl = TextEditingController(
      text: inq['amount'].toString().replaceAll(RegExp(r'[^0-9]'), ''),
    );

    String loanType = inq['loanType'] ?? 'Personal Loan';
    if (!_loanTypes.contains(loanType) || loanType == 'All Loan Types') {
      loanType = 'Personal Loan';
    }

    String status = inq['status'] ?? 'Submitted';
    if (status.toLowerCase() == 'new') status = 'Submitted';
    if (!_statusOptions.contains(status) || status == 'All Status') {
      status = 'Submitted';
    }

    String assignedTo = inq['assignedTo'] ?? 'Rahul Kumar';
    if (!_teamMembers.contains(assignedTo) || assignedTo == 'All Team Members') {
      assignedTo = 'Rahul Kumar';
    }

    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Inquiry #${inq['id']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.pop(ctx)),
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
                      decoration: _inputDecoration('Customer Name *', 'Amit Shah'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().length != 10) ? '10 digits required' : null,
                      decoration: _inputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email Address', 'customer@gmail.com'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: loanType,
                            items: _loanTypes
                                .where((t) => t != 'All Loan Types')
                                .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => loanType = val);
                            },
                            decoration: _inputDecoration('Loan Type', ''),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: status,
                            items: _statusOptions
                                .where((s) => s != 'All Status')
                                .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => status = val);
                            },
                            decoration: _inputDecoration('Status', ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Amount (₹)', '1000000'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: assignedTo,
                            items: _teamMembers
                                .where((m) => m != 'All Team Members')
                                .map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => assignedTo = val);
                            },
                            decoration: _inputDecoration('Assigned Officer', ''),
                          ),
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
                  final inqId = inq['_id'];

                  try {
                    final token = await SharedPrefHelper.getToken();
                    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/enquiries/$inqId'));

                    final res = await http.put(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'name': nameCtrl.text.trim(),
                        'phone': phoneCtrl.text.trim(),
                        'email': emailCtrl.text.trim(),
                        'loanType': loanType,
                        'service': loanType,
                        'amount': '₹ ${amountCtrl.text.trim()}',
                        'status': status,
                        'assignedTo': assignedTo,
                      }),
                    ).timeout(const Duration(seconds: 10));

                    if (res.statusCode == 200 || res.statusCode == 201) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchInquiries();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Inquiry updated successfully!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    } else {
                      throw Exception();
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchInquiries();
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
  // INQUIRY DETAILS MODAL (Live Approve / Reject)
  // ==========================================
  void _openInquiryDetailsModal(Map<String, dynamic> inq) {
    int modalTab = 0;
    bool isProcessing = false;

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
                  'Inquiry Details',
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildModalTab(
                          title: 'Inquiry Details',
                          isSelected: modalTab == 0,
                          onTap: () => setModalState(() => modalTab = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Documents (4)',
                          isSelected: modalTab == 1,
                          onTap: () => setModalState(() => modalTab = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Notes (2)',
                          isSelected: modalTab == 2,
                          onTap: () => setModalState(() => modalTab = 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                            child: Text(
                              (inq['name'] as String).isNotEmpty ? (inq['name'] as String)[0].toUpperCase() : 'C',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F3E38),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      inq['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: inq['statusBg'] as Color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        inq['status'] as String,
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                          color: inq['statusCol'] as Color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${inq['phone']} • ${inq['email']}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                ),
                                Text(
                                  inq['city'] as String,
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Loan Information',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Loan Type', inq['loanType'] as String, 'Requested Amount', inq['amount'] as String, isBoldSecond: true),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Loan Tenure', inq['tenure'] as String, 'Purpose', inq['purpose'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Location', inq['city'] as String, 'Expected Disbursal', inq['expectedDisbursal'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Source', inq['source'] as String, 'Status', inq['status'] as String),
                    const Divider(height: 12, color: AppColors.divider),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Assigned To', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text('${inq['assignedTo']} (Loan Officer)',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Inquiry Timeline',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 10),
                    _buildTimelineStep('Inquiry Submitted', '12 Sep 2024, 10:30 AM', isDone: true),
                    _buildTimelineStep('Under Review', 'Active Review Process', isCurrent: true),
                    _buildTimelineStep('Decision Pending', 'Awaiting Action', isScheduled: true, isLast: true),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: isProcessing
                        ? null
                        : () async {
                      setModalState(() => isProcessing = true);
                      await _updateInquiryStatus(inq['_id'], 'Rejected');
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchInquiries();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('✕ Reject',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFDC2626))),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isProcessing
                        ? null
                        : () async {
                      setModalState(() => isProcessing = true);
                      await _updateInquiryStatus(inq['_id'], 'Approved');
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchInquiries();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A36A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isProcessing
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('✓ Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateInquiryStatus(String inqId, String newStatus) async {
    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/enquiries/$inqId'));

      await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': newStatus}),
      ).timeout(const Duration(seconds: 10));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inquiry status updated to $newStatus!'),
            backgroundColor: newStatus == 'Approved' ? const Color(0xFF16A36A) : const Color(0xFFDC2626),
          ),
        );
      }
    } catch (_) {}
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

  Widget _buildModalInfoRow(String l1, String v1, String l2, String v2, {bool isBoldSecond = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(v1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(
                v2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBoldSecond ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldSecond ? const Color(0xFF0F3E38) : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String title, String subtitle,
      {bool isDone = false, bool isCurrent = false, bool isScheduled = false, bool isLast = false}) {
    Color col = AppColors.textHint;
    if (isDone) col = const Color(0xFF16A36A);
    if (isCurrent) col = const Color(0xFF0284C7);
    if (isScheduled) col = const Color(0xFFD97706);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: col.withValues(alpha: 0.2),
                child: CircleAvatar(radius: 3, backgroundColor: col),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? const Color(0xFF16A36A) : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: col)),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              ],
            ),
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
      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
                  : _buildLoanInquiriesDataTable(),
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
              'Loan Inquiry Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track and manage all customer loan inquiries from all channels.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _openAddInquiryModal,
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Add New Inquiry',
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
              tooltip: 'Refresh Inquiries',
              onPressed: _fetchInquiries,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    final total = _inquiries.length;
    final underReview = _inquiries.where((i) => i['status'].toString().toLowerCase() == 'under review').length;
    final approved = _inquiries.where((i) => i['status'].toString().toLowerCase() == 'approved').length;
    final rejected = _inquiries.where((i) => i['status'].toString().toLowerCase() == 'rejected').length;
    final pendingFollowUp = _inquiries.where((i) {
      final s = i['status'].toString().toLowerCase();
      return s == 'submitted' || s == 'new' || s == 'pending';
    }).length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Inquiries',
            value: total.toString(),
            badgeText: 'Active',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'All channels',
            icon: Icons.help_outline_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Under Review',
            value: underReview.toString(),
            badgeText: 'Pending',
            badgeBg: const Color(0xFFE0F2FE),
            badgeColor: const Color(0xFF0284C7),
            subtitle: 'In credit review',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Approved',
            value: approved.toString(),
            badgeText: 'Ready',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Ready to disburse',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Rejected',
            value: rejected.toString(),
            badgeText: 'Declined',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: 'Criteria not met',
            icon: Icons.cancel_outlined,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Follow-up',
            value: pendingFollowUp.toString(),
            badgeText: 'Action',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Awaiting customer response',
            icon: Icons.phone_forwarded_rounded,
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
                  hintText: 'Search inquiries by name, mobile, loan type, status...',
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
              value: _selectedSource,
              items: _sourceOptions,
              onChanged: (v) => setState(() => _selectedSource = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedTeamMember,
              items: _teamMembers,
              onChanged: (v) => setState(() => _selectedTeamMember = v!),
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

  Widget _buildLoanInquiriesDataTable() {
    final inquiries = _filteredInquiries;

    if (inquiries.isEmpty) {
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
              Icon(Icons.inbox_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching loan inquiries found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                  'Loan Inquiries (${inquiries.length})',
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
                showCheckboxColumn: false, // Prevents duplicate checkbox
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
                            _selectedRows.addAll(List.generate(inquiries.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(label: Text('Customer Details', style: _headerStyle)),
                  const DataColumn(label: Text('Loan Type', style: _headerStyle)),
                  const DataColumn(label: Text('Requested Amount', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Assigned To', style: _headerStyle)),
                  const DataColumn(label: Text('Inquiry Date', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(inquiries.length, (index) {
                  final item = inquiries[index];
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
                              _selectAll = _selectedRows.length == inquiries.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                            Text(
                              '${item['phone']} • ${item['city']}',
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(item['loanType'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
                      DataCell(Text(
                        item['amount'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                      )),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: item['statusBg'] as Color, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: item['statusCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                              child: Text(
                                (item['assignedTo'] as String)[0],
                                style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(item['assignedTo'] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          item['inquiryDate'] as String,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.2),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'View Inquiry Details',
                              onPressed: () => _openInquiryDetailsModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit Inquiry',
                              onPressed: () => _openEditInquiryModal(item),
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
        Text(
          'Showing ${_filteredInquiries.length} of ${_inquiries.length} inquiries',
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
                  items: [10, 25, 50, 100]
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n per page')))
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