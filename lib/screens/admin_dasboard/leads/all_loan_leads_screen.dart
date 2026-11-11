import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';
import 'lead_details_admin_screen.dart';

class AllLoanLeadsScreen extends StatefulWidget {
  const AllLoanLeadsScreen({super.key});

  @override
  State<AllLoanLeadsScreen> createState() => _AllLoanLeadsScreenState();
}

class _AllLoanLeadsScreenState extends State<AllLoanLeadsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedLoanType = 'All Loan Types';
  String _selectedStatus = 'All Status';
  String _selectedPartner = 'All Partners';
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
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Pending',
    'Under Review',
    'Approved',
    'Rejected',
    'Disbursed',
  ];

  final List<String> _employmentTypes = const [
    'Salaried',
    'Self-Employed',
    'Business Owner',
    'Professional',
  ];

  List<String> _partnerOptions = [
    'All Partners',
    'Rahul Kumar (DSA001)',
    'Amit Yadav (DSA002)',
    'Pooja Sharma (DSA004)',
    'Vikas Singh (DSA005)',
    'Deepak Verma (DSA006)',
    'Neha Gupta (DSA008)',
  ];

  final List<String> _dateOptions = const [
    'All Time',
    'Today',
    'This Week',
    'This Month',
    'Last 3 Months',
  ];

  List _leads = [];

  @override
  void initState() {
    super.initState();
    _fetchLeads();
    _fetchPartnerOptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPartnerOptions() async {
    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/partners'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dynamic rawData = body['data'];
        List<dynamic> partnersList = [];

        if (rawData is Map) {
          partnersList = rawData['partners'] ?? [];
        } else if (rawData is List) {
          partnersList = rawData;
        }

        if (partnersList.isNotEmpty) {
          final List<String> loadedPartners = ['All Partners'];
          for (var p in partnersList) {
            final name = p['name'] ?? 'Partner';
            final code = p['code'] ?? p['dsaCode'] ?? 'DSA001';
            loadedPartners.add('$name ($code)');
          }
          if (mounted) {
            setState(() => _partnerOptions = loadedPartners);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchLeads() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loans'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> rawList = body['data'] ?? [];

        if (rawList.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < rawList.length; i++) {
    final item = rawList[i];
    final customer = item['customer'] is Map ? item['customer'] : {};
    final partner = item['partner'] is Map ? item['partner'] : {};

    final num rawAmt = item['loanAmount'] ?? item['amount'] ?? 0;
    final String st = (item['status'] ?? 'Pending').toString();

    loaded.add({
    'id': i + 1,
    '_id': item['_id'] ?? '',
    'leadId': item['leadId'] ??
    (item['_id'] != null
    ? 'LD${item['_id'].toString().substring(18).toUpperCase()}'
        : 'LD${1000 + i}'),
    'name': customer['name'] ?? item['customerName'] ?? item['name'] ?? 'Customer',
    'phone': customer['phone'] ?? item['phone'] ?? '+91 9876543210',
    'email': customer['email'] ?? item['email'] ?? 'customer@email.com',
    'loanType': item['loanType'] ?? 'Personal Loan',
    'amount': rawAmt > 0
    ? CurrencyFormatter.formatWhole(rawAmt.toDouble())
        : '₹ 5,00,000',
    'rawAmount': rawAmt,
    'employmentType': item['employmentType'] ?? 'Salaried',
    'monthlyIncome': item['monthlyIncome'] ?? 50000,
    'partner': partner['name'] ?? item['partnerName'] ?? 'Direct Referral',
    'partnerCode': partner['dsaCode'] ?? item['partnerCode'] ?? 'DSA001',
    'status': st,
    'submittedOn': item['createdAt'] != null
    ? '${item['createdAt'].toString().substring(0, 10)}\nRecent'
        : 'Recent',
    ..._getStatusVisuals(st),
    });
    }

    if (mounted) {
    setState(() {
    _leads = loaded;
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackLeads();
    } catch (_) {
    _setFallbackLeads();
    }
  }

  Map<String, Color> _getStatusVisuals(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'disbursed':
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
      case 'submitted':
      case 'pending':
      default:
        return {
          'statusBg': const Color(0xFFFEF3C7),
          'statusCol': const Color(0xFFD97706),
        };
    }
  }

  void _setFallbackLeads() {
    if (!mounted) return;
    setState(() {
      _leads = [
        {
          'id': 1,
          '_id': 'lead_001',
          'leadId': 'LD0001',
          'name': 'Amit Shah',
          'phone': '+91 9876543210',
          'email': 'amit.shah@gmail.com',
          'loanType': 'Home Loan',
          'amount': '₹ 25,00,000',
          'rawAmount': 2500000,
          'employmentType': 'Salaried',
          'monthlyIncome': 85000,
          'partner': 'Rahul Kumar',
          'partnerCode': 'DSA001',
          'status': 'Approved',
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
          'submittedOn': '12 Sep 2024\n10:30 AM',
        },
        {
          'id': 2,
          '_id': 'lead_002',
          'leadId': 'LD0002',
          'name': 'Priya Verma',
          'phone': '+91 91234 56789',
          'email': 'priya.verma@gmail.com',
          'loanType': 'Car Loan',
          'amount': '₹ 8,00,000',
          'rawAmount': 800000,
          'employmentType': 'Self-Employed',
          'monthlyIncome': 65000,
          'partner': 'Pooja Sharma',
          'partnerCode': 'DSA004',
          'status': 'Under Review',
          'statusBg': const Color(0xFFE0F2FE),
          'statusCol': const Color(0xFF0284C7),
          'submittedOn': '11 Sep 2024\n02:15 PM',
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
      _selectedPartner = 'All Partners';
      _selectedDateRange = 'All Time';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  List get _filteredLeads {
    final query = _searchController.text.trim().toLowerCase();

    return _leads.where((item) {
      final matchesSearch = query.isEmpty ||
          item['name'].toString().toLowerCase().contains(query) ||
          item['phone'].toString().toLowerCase().contains(query) ||
          item['email'].toString().toLowerCase().contains(query) ||
          item['leadId'].toString().toLowerCase().contains(query);

      final matchesType = _selectedLoanType == 'All Loan Types' ||
          item['loanType'].toString().toLowerCase() ==
              _selectedLoanType.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() ==
              _selectedStatus.toLowerCase();

      final matchesPartner = _selectedPartner == 'All Partners' ||
          item['partner']
              .toString()
              .toLowerCase()
              .contains(_selectedPartner.split(' ')[0].toLowerCase());

      return matchesSearch && matchesType && matchesStatus && matchesPartner;
    }).toList();
  }

  // ============================================================
  // ADD NEW LEAD MODAL (With Monthly Income & Employment Type)
  // ============================================================
  void _openAddLeadModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '1000000');
    final incomeCtrl = TextEditingController(text: '50000');

    String loanType = 'Personal Loan';
    String employmentType = 'Salaried';
    String partner = _partnerOptions.length > 1
        ? _partnerOptions[1]
        : 'Direct Referral';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add New Loan Lead',
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
            width: 480,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _inputDecoration('Customer Name *', 'Amit Shah'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.phone,
                            validator: (v) =>
                            (v == null || v.trim().length != 10)
                                ? '10 digits'
                                : null,
                            decoration: _inputDecoration(
                                'Mobile Number *', '9876543210',
                                prefix: '+91 '),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                                'Email Address', 'customer@gmail.com'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: loanType,
                            items: _loanTypes
                                .where((t) => t != 'All Loan Types')
                                .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t,
                                  style: const TextStyle(fontSize: 12)),
                            ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => loanType = val);
                            },
                            decoration: _inputDecoration('Loan Type *', ''),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: employmentType,
                            items: _employmentTypes
                                .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e,
                                  style: const TextStyle(fontSize: 12)),
                            ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() => employmentType = val);
                              }
                            },
                            decoration:
                            _inputDecoration('Employment Type *', ''),
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
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                            decoration: _inputDecoration(
                                'Requested Loan Amount (₹) *', '1000000'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: incomeCtrl,
                            keyboardType: TextInputType.number,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                            decoration: _inputDecoration(
                                'Monthly Income (₹) *', '50000'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _partnerOptions.contains(partner)
                          ? partner
                          : _partnerOptions.firstWhere(
                              (p) => p != 'All Partners',
                          orElse: () => 'Direct Referral'),
                      items: _partnerOptions
                          .where((p) => p != 'All Partners')
                          .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p,
                            style: const TextStyle(fontSize: 12)),
                      ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => partner = val);
                      },
                      decoration: _inputDecoration('Select Partner (DSA)', ''),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                if (formKey.currentState!.validate()) {
                  setDialogState(() => isSubmitting = true);
                  try {
                    final token = await SharedPrefHelper.getToken();
                    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loans'));

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
                        'loanType': loanType,
                        'amount': double.tryParse(amountCtrl.text
                            .trim()
                            .replaceAll(',', '')) ??
                            500000,
                        'monthlyIncome': double.tryParse(incomeCtrl.text
                            .trim()
                            .replaceAll(',', '')) ??
                            50000,
                        'employmentType': employmentType,
                        'partnerName': partner.split(' (')[0].trim(),
                        'status': 'Pending',
                      }),
                    ).timeout(const Duration(seconds: 12));

                    if (res.statusCode == 200 || res.statusCode == 201) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchLeads();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Loan lead added to pipeline successfully!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    } else {
                      final err = jsonDecode(res.body)['message'] ??
                          'Error creating lead';
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(err),
                            backgroundColor: const Color(0xFFDC2626),
                          ),
                        );
                      }
                      setDialogState(() => isSubmitting = false);
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchLeads();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: isSubmitting
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Text('Submit Lead',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EDIT LEAD MODAL
  // ==========================================
  void _openEditLeadModal(Map<String, dynamic> lead) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController(
        text: (lead['rawAmount'] != null && lead['rawAmount'] > 0)
            ? lead['rawAmount'].toString()
            : lead['amount'].toString().replaceAll(RegExp(r'[^0-9]'), ''));

    String loanType = lead['loanType'] ?? 'Personal Loan';
    if (!_loanTypes.contains(loanType) || loanType == 'All Loan Types') {
      loanType = 'Personal Loan';
    }

    String status = lead['status'] ?? 'Pending';
    if (!_statusOptions.contains(status) || status == 'All Status') {
      status = 'Pending';
    }

    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Lead (${lead['leadId']})',
                style: const TextStyle(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer: ${lead['name']}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                  Text(
                    'Partner: ${lead['partner']}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: status,
                    items: _statusOptions
                        .where((s) => s != 'All Status')
                        .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s, style: const TextStyle(fontSize: 12)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => status = val);
                    },
                    decoration: _inputDecoration('Application Status', ''),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: loanType,
                    items: _loanTypes
                        .where((t) => t != 'All Loan Types')
                        .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t, style: const TextStyle(fontSize: 12)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => loanType = val);
                    },
                    decoration: _inputDecoration('Loan Type', ''),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration:
                    _inputDecoration('Loan Amount (₹)', '2500000'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                if (formKey.currentState!.validate()) {
                  setDialogState(() => isSubmitting = true);
                  final leadId = lead['_id'];

                  try {
                    final token = await SharedPrefHelper.getToken();
                    final url =
                    Uri.parse(MFUrls.mfBaseUrl('api/v1/loans/$leadId'));

                    final res = await http.put(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'status': status,
                        'loanType': loanType,
                        'amount': double.tryParse(amountCtrl.text.trim()) ?? 0,
                      }),
                    ).timeout(const Duration(seconds: 10));

                    if (res.statusCode == 200 || res.statusCode == 201) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchLeads();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lead updated successfully!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    } else {
                      throw Exception();
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    setState(() {
                      lead['status'] = status;
                      lead['loanType'] = loanType;
                      lead['amount'] = '₹ ${amountCtrl.text.trim()}';
                      final visuals = _getStatusVisuals(status);
                      lead['statusBg'] = visuals['statusBg'];
                      lead['statusCol'] = visuals['statusCol'];
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lead updated in current view!'),
                          backgroundColor: Color(0xFF16A36A),
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: isSubmitting
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Text('Save Changes',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      hintText: hint,
      prefixText: prefix,
      prefixStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
                  child: CircularProgressIndicator(
                      color: AppColors.secondary),
                ),
              )
                  : _buildLoanLeadsDataTable(),
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
              'All Loan Leads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View and manage all loan inquiries from customers and partner (DSA) referrals.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _openAddLeadModal,
              icon:
              const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Add New Lead',
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3E38),
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded,
                  color: AppColors.primary, size: 22),
              tooltip: 'Refresh Leads',
              onPressed: _fetchLeads,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    final total = _leads.length;
    final pending = _leads
        .where((l) => l['status'] == 'Pending' || l['status'] == 'Submitted')
        .length;
    final underReview =
        _leads.where((l) => l['status'] == 'Under Review').length;
    final approved = _leads
        .where((l) => l['status'] == 'Approved' || l['status'] == 'Disbursed')
        .length;
    final rejected = _leads.where((l) => l['status'] == 'Rejected').length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Leads',
            value: total.toString(),
            badgeText: 'Active',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Pipeline Total',
            icon: Icons.assignment_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending',
            value: pending.toString(),
            badgeText: 'New',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Awaiting Action',
            icon: Icons.send_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
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
            subtitle: 'Credit Team',
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
            badgeText: 'Done',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Ready to Disburse',
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
            badgeText: 'Closed',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: 'Declined Leads',
            icon: Icons.cancel_outlined,
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
              style: const TextStyle(fontSize: 9.5, color: AppColors.textHint)),
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
                  hintText: 'Search by name, mobile, email, lead ID...',
                  hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
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
              value: _selectedPartner,
              items: _partnerOptions,
              onChanged: (v) => setState(() => _selectedPartner = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedDateRange,
              items: _dateOptions,
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedDateRange = v!),
            ),
          ),
          const SizedBox(width: 8),
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
              value: i, child: Text(i, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLoanLeadsDataTable() {
    final leads = _filteredLeads;

    if (leads.isEmpty) {
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
              Icon(Icons.folder_off_outlined,
                  size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching loan leads found',
                  style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            showCheckboxColumn: false,
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
                            List.generate(leads.length, (i) => i));
                      } else {
                        _selectedRows.clear();
                      }
                    });
                  },
                ),
              ),
              const DataColumn(label: Text('#', style: _headerStyle)),
              const DataColumn(label: Text('Lead ID', style: _headerStyle)),
              const DataColumn(
                  label: Text('Customer Details', style: _headerStyle)),
              const DataColumn(label: Text('Loan Type', style: _headerStyle)),
              const DataColumn(
                  label: Text('Requested Amount', style: _headerStyle)),
              const DataColumn(
                  label: Text('Partner (DSA)', style: _headerStyle)),
              const DataColumn(label: Text('Status', style: _headerStyle)),
              const DataColumn(
                  label: Text('Submitted On', style: _headerStyle)),
              const DataColumn(label: Text('Actions', style: _headerStyle)),
            ],
            rows: List.generate(leads.length, (index) {
              final item = leads[index];
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
                          _selectAll =
                              _selectedRows.length == leads.length;
                        });
                      },
                    ),
                  ),
                  DataCell(Text('${item['id']}',
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textSecondary))),
                  DataCell(
                    Text(
                      item['leadId'] as String,
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F3E38)),
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary),
                        ),
                        Text(
                          '${item['phone']} • ${item['email']}',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(item['loanType'] as String,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textPrimary))),
                  DataCell(Text(item['amount'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary))),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['partner'] as String,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        Text(item['partnerCode'] as String,
                            style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F3E38))),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: item['statusBg'] as Color,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: item['statusCol'] as Color),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item['submittedOn'] as String,
                      style: const TextStyle(
                          fontSize: 10.5,
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
                              size: 18, color: Color(0xFF0284C7)),
                          tooltip: 'Review Lead',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LeadDetailsAdminScreen(leadData: item),
                              ),
                            );
                            _fetchLeads();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 16, color: Color(0xFF0F3E38)),
                          tooltip: 'Edit Lead Status',
                          onPressed: () => _openEditLeadModal(item),
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

  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing ${_filteredLeads.length} of ${_leads.length} leads',
          style:
          const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
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
                      .map((n) => DropdownMenuItem(
                      value: n, child: Text('$n per page')))
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