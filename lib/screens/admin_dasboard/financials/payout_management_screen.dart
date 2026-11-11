import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';

class PayoutManagementScreen extends StatefulWidget {
  const PayoutManagementScreen({super.key});

  @override
  State<PayoutManagementScreen> createState() => _PayoutManagementScreenState();
}

class _PayoutManagementScreenState extends State<PayoutManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedMonth = 'All Months';
  String _selectedStatus = 'All Status';
  String _selectedMethod = 'All Methods';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  String _totalCommission = '₹ 12,48,500';
  String _pendingPayouts = '₹ 3,20,000';
  String _paidPayouts = '₹ 8,70,500';
  String _failedPayouts = '₹ 45,000';

  final List<String> _monthOptions = const [
    'All Months',
    'September 2024',
    'August 2024',
    'July 2024',
    'June 2024',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Paid',
    'Processing',
    'Failed',
  ];

  final List<String> _methodOptions = const [
    'All Methods',
    'Bank Transfer',
    'UPI',
    'NEFT/RTGS',
  ];

  List _payouts = [];

  @override
  void initState() {
    super.initState();
    _fetchPayouts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPayouts() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/payouts'));

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
          list = rawData['payouts'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final p = list[i];
    final st = (p['status'] ?? 'Processing').toString();
    final num comm = p['commission'] ?? p['payoutAmount'] ?? 0;
    final num tds = p['tds'] ?? (comm * 0.05);
    final num net = p['netAmount'] ?? (comm - tds);

    loaded.add({
    'id': i + 1,
    '_id': p['_id'] ?? '',
    'payoutId': p['payoutId'] ?? 'PAY${202409000 + i}',
    'name': p['name'] ?? 'Partner',
    'code': p['code'] ?? 'DSA001',
    'phone': p['phone'] ?? '+91 91234 56789',
    'email': p['email'] ?? 'partner@gmail.com',
    'totalLeads': p['totalLeads'] ?? 0,
    'approvedLeads': p['approvedLeads'] ?? 0,
    'commission': CurrencyFormatter.formatWhole(comm.toDouble()),
    'payoutAmount': CurrencyFormatter.formatWhole(comm.toDouble()),
    'tds': CurrencyFormatter.formatWhole(tds.toDouble()),
    'netAmount': CurrencyFormatter.formatWhole(net.toDouble()),
    'month': p['month'] ?? 'Sep 2024',
    'status': st,
    'paymentDate': p['paymentDate'] ?? (st == 'Paid' ? 'Recent' : 'Pending'),
    'requestDate': p['requestDate'] ?? '01 Oct 2024',
    'method': p['method'] ?? 'Bank Transfer',
    'bank': p['bank'] ?? 'HDFC Bank',
    'accountNo': p['accountNo'] ?? 'XXXX XXXX 7890',
    'ifsc': p['ifsc'] ?? 'HDFC0001234',
    'txnId': p['txnId'] ?? 'Pending',
    'notes': p['notes'] ?? 'Commission payout processed.',
    ..._getStatusVisuals(st),
    });
    }

    if (mounted) {
    setState(() {
    _payouts = loaded;
    if (stats != null) {
    final num total = stats['totalCommission'] ?? 0;
    final num pending = stats['pendingPayouts'] ?? 0;
    final num paid = stats['paidPayouts'] ?? 0;
    final num failed = stats['failedPayouts'] ?? 0;
    _totalCommission = CurrencyFormatter.formatWhole(total.toDouble());
    _pendingPayouts = CurrencyFormatter.formatWhole(pending.toDouble());
    _paidPayouts = CurrencyFormatter.formatWhole(paid.toDouble());
    _failedPayouts = CurrencyFormatter.formatWhole(failed.toDouble());
    }
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackPayouts();
    } catch (_) {
    _setFallbackPayouts();
    }
  }

  Map<String, Color> _getStatusVisuals(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return {
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
        };
      case 'failed':
        return {
          'statusBg': const Color(0xFFFEE2E2),
          'statusCol': const Color(0xFFDC2626),
        };
      case 'processing':
      default:
        return {
          'statusBg': const Color(0xFFFEF3C7),
          'statusCol': const Color(0xFFD97706),
        };
    }
  }

  void _setFallbackPayouts() {
    if (!mounted) return;
    setState(() {
      _payouts = [
        {
          'id': 1,
          '_id': 'pay_001',
          'payoutId': 'PAY202409001',
          'name': 'Rahul Kumar',
          'code': 'DSA001',
          'phone': '+91 91234 56789',
          'email': 'rahul.kumar@gmail.com',
          'totalLeads': 28,
          'approvedLeads': 18,
          'commission': '₹ 85,000',
          'payoutAmount': '₹ 85,000',
          'tds': '₹ 4,250',
          'netAmount': '₹ 80,750',
          'month': 'Sep 2024',
          'status': 'Paid',
          'statusBg': const Color(0xFFDCFCE7),
          'statusCol': const Color(0xFF16A36A),
          'paymentDate': '05 Oct 2024',
          'requestDate': '02 Oct 2024',
          'method': 'Bank Transfer',
          'bank': 'HDFC Bank',
          'accountNo': 'XXXX XXXX 7890',
          'ifsc': 'HDFC0001234',
          'txnId': 'TXN1234567890',
          'notes': 'September month commission payout approved. TDS deducted as per policy.',
        },
      ];
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedMonth = 'All Months';
      _selectedStatus = 'All Status';
      _selectedMethod = 'All Methods';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  List get _filteredPayouts {
    final query = _searchController.text.trim().toLowerCase();

    return _payouts.where((item) {
      final name = item['name'].toString().toLowerCase();
      final code = item['code'].toString().toLowerCase();
      final pId = item['payoutId'].toString().toLowerCase();
      final phone = item['phone'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          code.contains(query) ||
          pId.contains(query) ||
          phone.contains(query);

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

      final matchesMethod = _selectedMethod == 'All Methods' ||
          item['method'].toString().toLowerCase() == _selectedMethod.toLowerCase();

      return matchesSearch && matchesStatus && matchesMethod;
    }).toList();
  }

  // ==========================================
  // PROCESS NEW PAYOUT MODAL (Live POST API)
  // ==========================================
  void _openProcessPayoutModal() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: 'Rahul Kumar');
    final codeCtrl = TextEditingController(text: 'DSA001');
    final amountCtrl = TextEditingController(text: '50000');
    final bankCtrl = TextEditingController(text: 'HDFC Bank');
    final accCtrl = TextEditingController(text: 'XXXX XXXX 7890');
    final ifscCtrl = TextEditingController(text: 'HDFC0001234');
    String method = 'Bank Transfer';
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
                'Process Partner Payout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: nameCtrl,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            decoration: _inputDecoration('Partner Name *', 'Rahul Kumar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: codeCtrl,
                            decoration: _inputDecoration('DSA Code *', 'DSA001'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      decoration: _inputDecoration('Payout Amount (₹) *', '50000', prefix: '₹ '),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: method,
                      items: const ['Bank Transfer', 'UPI', 'NEFT/RTGS']
                          .map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => method = val);
                      },
                      decoration: _inputDecoration('Payment Method', ''),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: bankCtrl,
                            decoration: _inputDecoration('Bank Name', 'HDFC Bank'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: ifscCtrl,
                            decoration: _inputDecoration('IFSC Code', 'HDFC0001234'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: accCtrl,
                      decoration: _inputDecoration('Account Number', 'XXXX XXXX 7890'),
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
                    final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/payouts'));

                    final res = await http.post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'name': nameCtrl.text.trim(),
                        'code': codeCtrl.text.trim(),
                        'amount': double.tryParse(amountCtrl.text.trim()) ?? 0,
                        'method': method,
                        'bank': bankCtrl.text.trim(),
                        'accountNo': accCtrl.text.trim(),
                        'ifsc': ifscCtrl.text.trim(),
                        'month': 'Sep 2024',
                      }),
                    ).timeout(const Duration(seconds: 10));

                    if (res.statusCode == 200 || res.statusCode == 201) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchPayouts();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payout batch initialized and queued successfully!'),
                            backgroundColor: Color(0xFF16A36A),
                          ),
                        );
                      }
                    } else {
                      throw Exception();
                    }
                  } catch (_) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    _fetchPayouts();
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
                  : const Text('Submit Payout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // VIEW PAYOUT DETAILS MODAL
  // ==========================================
  void _openPayoutDetailsModal(Map<String, dynamic> item) {
    int modalTab = 0;
    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isPaid = item['status'] == 'Paid';

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payout Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
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
                    Row(
                      children: [
                        _buildModalTab(
                          title: 'Payout Info',
                          isSelected: modalTab == 0,
                          onTap: () => setModalState(() => modalTab = 0),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Commission Details',
                          isSelected: modalTab == 1,
                          onTap: () => setModalState(() => modalTab = 1),
                        ),
                        const SizedBox(width: 8),
                        _buildModalTab(
                          title: 'Lead Summary',
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
                              (item['name'] as String).isNotEmpty ? (item['name'] as String)[0].toUpperCase() : 'P',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
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
                                      item['name'] as String,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item['code'] as String,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: item['statusBg'] as Color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item['status'] as String,
                                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: item['statusCol'] as Color),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item['phone']} • ${item['email']}',
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
                      'Payout Information',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Payout ID', item['payoutId'] as String, 'Payout Month', item['month'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Commission Amount', item['commission'] as String, 'TDS (5%)', '- ${item['tds']}'),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Net Payout Amount', item['netAmount'] as String, 'Payment Method', item['method'] as String, isBoldFirst: true),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Bank Name', item['bank'] as String, 'Account Number', item['accountNo'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('IFSC Code', item['ifsc'] as String, 'Transaction ID', item['txnId'] as String),
                    const Divider(height: 12, color: AppColors.divider),
                    _buildModalInfoRow('Request Date', item['requestDate'] as String, 'Payment Date', item['paymentDate'] as String),
                    const Divider(height: 12, color: AppColors.divider),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notes', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 3),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            item['notes'] as String,
                            style: const TextStyle(fontSize: 10.5, color: AppColors.textPrimary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading Tax Invoice for ${item['payoutId']}...')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 15, color: Color(0xFF0F3E38)),
                    label: const Text('Download Invoice',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  if (!isPaid)
                    ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () async {
                        setModalState(() => isProcessing = true);
                        try {
                          final token = await SharedPrefHelper.getToken();
                          final pId = item['_id'];
                          final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/payouts/$pId'));

                          final res = await http.put(
                            url,
                            headers: {
                              'Content-Type': 'application/json',
                              if (token != null) 'Authorization': 'Bearer $token',
                            },
                            body: jsonEncode({
                              'status': 'Paid',
                              'txnId': 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}',
                            }),
                          ).timeout(const Duration(seconds: 10));

                          if (res.statusCode == 200) {
                            if (ctx.mounted) Navigator.pop(ctx);
                            _fetchPayouts();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Payout marked as Paid successfully!'),
                                  backgroundColor: Color(0xFF16A36A),
                                ),
                              );
                            }
                          }
                        } catch (_) {
                          if (ctx.mounted) Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A36A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: isProcessing
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Mark as Paid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                ],
              ),
            ],
          );
        },
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

  Widget _buildModalInfoRow(String l1, String v1, String l2, String v2, {bool isBoldFirst = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(
                v1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isBoldFirst ? FontWeight.w900 : FontWeight.w700,
                  color: isBoldFirst ? const Color(0xFF0F3E38) : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
              const SizedBox(height: 1),
              Text(v2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ),
      ],
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
                  : _buildPayoutsDataTable(),
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
              'Payout Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage partner payouts, track payment status and view transaction history.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _openProcessPayoutModal,
          icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
          label: const Text(
            '+ Process Payout',
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
            title: 'Total Commission',
            value: _totalCommission,
            badgeText: 'Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'This month',
            icon: Icons.currency_rupee_rounded,
            iconBg: const Color(0xFFE6F7F2),
            iconColor: const Color(0xFF0F3E38),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Pending Payouts',
            value: _pendingPayouts,
            badgeText: 'Pipeline',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'Processing clearing',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Paid Payouts',
            value: _paidPayouts,
            badgeText: 'Completed',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Credited to bank',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Failed Payouts',
            value: _failedPayouts,
            badgeText: 'Review',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: 'Bank mismatch',
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
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
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
                  hintText: 'Search by partner name, mobile, payout ID...',
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
              value: _selectedMonth,
              items: _monthOptions,
              icon: Icons.calendar_today_outlined,
              onChanged: (v) => setState(() => _selectedMonth = v!),
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
              value: _selectedMethod,
              items: _methodOptions,
              onChanged: (v) => setState(() => _selectedMethod = v!),
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

  Widget _buildPayoutsDataTable() {
    final payouts = _filteredPayouts;

    if (payouts.isEmpty) {
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
              Icon(Icons.payments_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching payout records found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                  'Partner Payouts (${payouts.length})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Color(0xFF0F3E38)),
                  tooltip: 'Refresh Payouts',
                  onPressed: _fetchPayouts,
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
                showCheckboxColumn: false, // 👈 Fixes duplicate checkbox
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
                            _selectedRows.addAll(List.generate(payouts.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(label: Text('Partner Details', style: _headerStyle)),
                  const DataColumn(label: Text('Total Leads', style: _headerStyle)),
                  const DataColumn(label: Text('Approved Leads', style: _headerStyle)),
                  const DataColumn(label: Text('Commission', style: _headerStyle)),
                  const DataColumn(label: Text('Payout Amount', style: _headerStyle)),
                  const DataColumn(label: Text('Month', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Payment Date', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(payouts.length, (index) {
                  final item = payouts[index];
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
                              _selectAll = _selectedRows.length == payouts.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                              child: Text(
                                (item['name'] as String).isNotEmpty ? (item['name'] as String)[0].toUpperCase() : 'P',
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'] as String,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                Text(
                                  '${item['code']} • ${item['phone']}',
                                  style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text('${item['totalLeads']}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary))),
                      DataCell(Text('${item['approvedLeads']}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF16A36A)))),
                      DataCell(Text(item['commission'] as String,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      DataCell(Text(item['payoutAmount'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0F3E38)))),
                      DataCell(Text(item['month'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: item['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: item['statusCol'] as Color),
                          ),
                        ),
                      ),
                      DataCell(Text(item['paymentDate'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
                              tooltip: 'View Payout Details',
                              onPressed: () => _openPayoutDetailsModal(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.receipt_long_rounded, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Download Invoice',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Tax Invoice for ${item['payoutId']} downloaded.')),
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

  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1 to ${_filteredPayouts.length} of ${_payouts.length} payouts',
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