import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';

class CommissionManagementScreen extends StatefulWidget {
  const CommissionManagementScreen({super.key});

  @override
  State<CommissionManagementScreen> createState() =>
      _CommissionManagementScreenState();
}

class _CommissionManagementScreenState
    extends State<CommissionManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All Categories';
  String _selectedPartnerType = 'All Partner Types';
  String _selectedStatus = 'All Status';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  String _totalCommissionPaid = '₹ 12,48,500';
  String _pendingPayouts = '₹ 3,20,000';
  int _activePartners = 48;
  int _totalRules = 12;

  final List<String> _categoryOptions = const [
    'All Categories',
    'Home Loan',
    'Personal Loan',
    'Car Loan',
    'Education Loan',
    'Business Loan',
    'Gold Loan',
    'Agriculture Loan',
    'Medical Loan',
    'Loan Against Property',
    'Other Loans',
  ];

  final List<String> _partnerTypeOptions = const [
    'All Partner Types',
    'DSA Partner',
    'Sub-DSA',
    'Corporate Partner',
  ];

  final List<String> _statusOptions = const [
    'All Status',
    'Active',
    'Inactive',
  ];

  List _rules = [];

  @override
  void initState() {
    super.initState();
    _fetchRules();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRules() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/commissions'));

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
          list = rawData['rules'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final r = list[i];
    final cat = r['category'] ?? 'Home Loan';
    final hex = r['colorHex'] ?? '';

    loaded.add({
    'id': i + 1,
    '_id': r['_id'] ?? '',
    'category': cat,
    'partnerType': r['partnerType'] ?? 'DSA Partner',
    'type': r['type'] ?? 'Percentage',
    'value': r['value'] ?? '1.50%',
    'minAmount': r['minAmount'] ?? '₹ 5,00,000',
    'maxAmount': r['maxAmount'] ?? '₹ 5,00,00,000',
    'conditions': r['conditions'] ??
    'Min: ${r['minAmount']}\nMax: ${r['maxAmount']}',
    'status': r['status'] ?? 'Active',
    'color': _resolveColor(hex, cat),
    });
    }

    if (mounted) {
    setState(() {
    _rules = loaded;
    if (stats != null) {
    final num paid = stats['totalCommissionPaid'] ?? 0;
    final num pending = stats['pendingPayouts'] ?? 0;
    _totalCommissionPaid = CurrencyFormatter.formatWhole(paid.toDouble());
    _pendingPayouts = CurrencyFormatter.formatWhole(pending.toDouble());
    _activePartners = stats['activePartners'] ?? 48;
    _totalRules = stats['totalRules'] ?? loaded.length;
    } else {
    _totalRules = loaded.length;
    }
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackRules();
    } catch (_) {
    _setFallbackRules();
    }
  }

  Color _resolveColor(String hex, String cat) {
    if (hex.isNotEmpty && hex.startsWith('#') && hex.length == 7) {
      try {
        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }
    final c = cat.toLowerCase();
    if (c.contains('home')) return const Color(0xFF0F3E38);
    if (c.contains('personal')) return const Color(0xFF7C3AED);
    if (c.contains('car')) return const Color(0xFF0284C7);
    if (c.contains('education')) return const Color(0xFFD97706);
    if (c.contains('business')) return const Color(0xFF16A36A);
    if (c.contains('gold')) return const Color(0xFFEAB308);
    if (c.contains('agri')) return const Color(0xFF65A30D);
    if (c.contains('medical')) return const Color(0xFFDC2626);
    return const Color(0xFF64748B);
  }

  void _setFallbackRules() {
    if (!mounted) return;
    setState(() {
      _rules = [
        {
          'id': 1,
          '_id': 'rule_001',
          'category': 'Home Loan',
          'partnerType': 'DSA Partner',
          'type': 'Percentage',
          'value': '1.50%',
          'minAmount': '₹ 5,00,000',
          'maxAmount': '₹ 5,00,00,000',
          'conditions': 'Min: ₹5,00,000\nMax: ₹5,00,00,000',
          'status': 'Active',
          'color': const Color(0xFF0F3E38),
        },
        {
          'id': 2,
          '_id': 'rule_002',
          'category': 'Personal Loan',
          'partnerType': 'DSA Partner',
          'type': 'Percentage',
          'value': '2.00%',
          'minAmount': '₹ 50,000',
          'maxAmount': '₹ 25,00,000',
          'conditions': 'Min: ₹50,000\nMax: ₹25,00,000',
          'status': 'Active',
          'color': const Color(0xFF7C3AED),
        },
        {
          'id': 3,
          '_id': 'rule_003',
          'category': 'Car Loan',
          'partnerType': 'DSA Partner',
          'type': 'Fixed Amount',
          'value': '₹ 7,500',
          'minAmount': '₹ 2,00,000',
          'maxAmount': '₹ 50,00,000',
          'conditions': 'Min: ₹2,00,000\nMax: ₹50,00,000',
          'status': 'Active',
          'color': const Color(0xFF0284C7),
        },
      ];
      _totalRules = _rules.length;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All Categories';
      _selectedPartnerType = 'All Partner Types';
      _selectedStatus = 'All Status';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  List get _filteredRules {
    final query = _searchController.text.trim().toLowerCase();

    return _rules.where((item) {
      final cat = item['category'].toString().toLowerCase();
      final pType = item['partnerType'].toString().toLowerCase();
      final val = item['value'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          cat.contains(query) ||
          pType.contains(query) ||
          val.contains(query);

      final matchesCategory = _selectedCategory == 'All Categories' ||
          item['category'].toString().toLowerCase() ==
              _selectedCategory.toLowerCase();

      final matchesPartnerType = _selectedPartnerType == 'All Partner Types' ||
          item['partnerType'].toString().toLowerCase() ==
              _selectedPartnerType.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() ==
              _selectedStatus.toLowerCase();

      return matchesSearch && matchesCategory && matchesPartnerType && matchesStatus;
    }).toList();
  }

  // ==========================================
  // ADD & EDIT RULE MODAL (Live API)
  // ==========================================
  void _openAddEditRuleModal({Map<String, dynamic>? rule}) {
    final formKey = GlobalKey<FormState>();
    final valueCtrl = TextEditingController(
      text: rule?['value']?.replaceAll('%', '')?.replaceAll('₹', '')?.trim() ?? '1.50',
    );
    final minCtrl = TextEditingController(
      text: rule?['minAmount']?.replaceAll('₹', '')?.trim() ?? '5,00,000',
    );
    final maxCtrl = TextEditingController(
      text: rule?['maxAmount']?.replaceAll('₹', '')?.trim() ?? '5,00,00,000',
    );
    final condCtrl = TextEditingController(text: rule?['conditions'] ?? '');

    String category = rule?['category'] ?? 'Home Loan';
    String partnerType = rule?['partnerType'] ?? 'DSA Partner';
    String commType = rule?['type'] ?? 'Percentage';
    String status = rule?['status'] ?? 'Active';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isPercentage = commType == 'Percentage';

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rule == null ? 'Add Commission Rule' : 'Edit Commission Rule',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
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
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _categoryOptions.contains(category) ? category : 'Home Loan',
                              items: _categoryOptions
                                  .where((c) => c != 'All Categories')
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => category = val);
                              },
                              decoration: _inputDecoration('Loan Category *', ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: partnerType,
                              items: const ['DSA Partner', 'Sub-DSA', 'Corporate Partner']
                                  .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => partnerType = val);
                              },
                              decoration: _inputDecoration('Partner Type *', ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'Commission Type *',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildCommissionTypeOption(
                            label: 'Percentage (%)',
                            isSelected: isPercentage,
                            onTap: () => setModalState(() => commType = 'Percentage'),
                          ),
                          const SizedBox(width: 12),
                          _buildCommissionTypeOption(
                            label: 'Fixed Amount (₹)',
                            isSelected: !isPercentage,
                            onTap: () => setModalState(() => commType = 'Fixed Amount'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: valueCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                          'Commission Value *',
                          isPercentage ? '1.50' : '5,000',
                          suffix: isPercentage ? '%' : null,
                          prefix: !isPercentage ? '₹ ' : null,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: minCtrl,
                              keyboardType: TextInputType.text,
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              decoration: _inputDecoration('Minimum Loan Amount *', '5,00,000', prefix: '₹ '),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: maxCtrl,
                              keyboardType: TextInputType.text,
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              decoration: _inputDecoration('Maximum Loan Amount *', '5,00,00,000', prefix: '₹ '),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: condCtrl,
                        maxLines: 2,
                        decoration: _inputDecoration('Additional Conditions (Optional)', 'e.g. Applicable for salaried customers only'),
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

                    final formattedValue = isPercentage
                        ? '${valueCtrl.text.trim()}%'
                        : '₹ ${valueCtrl.text.trim()}';

                    final payload = {
                      'category': category,
                      'partnerType': partnerType,
                      'type': commType,
                      'value': formattedValue,
                      'minAmount': '₹ ${minCtrl.text.trim().replaceAll('₹', '').trim()}',
                      'maxAmount': '₹ ${maxCtrl.text.trim().replaceAll('₹', '').trim()}',
                      'conditions': condCtrl.text.trim().isNotEmpty
                          ? condCtrl.text.trim()
                          : 'Min: ₹ ${minCtrl.text.trim()}\nMax: ₹ ${maxCtrl.text.trim()}',
                      'status': status,
                    };

                    try {
                      http.Response res;
                      if (rule == null) {
                        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/commissions'));
                        res = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null) 'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      } else {
                        final rId = rule['_id'];
                        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/commissions/$rId'));
                        res = await http.put(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null) 'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      }

                      if (res.statusCode == 200 || res.statusCode == 201) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        _fetchRules();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(rule == null
                                  ? 'New commission rule saved!'
                                  : 'Commission rule updated successfully!'),
                              backgroundColor: const Color(0xFF16A36A),
                            ),
                          );
                        }
                      } else {
                        throw Exception();
                      }
                    } catch (_) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchRules();
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
                    : Text(rule == null ? 'Save Rule' : 'Update Rule', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // DELETE RULE (Live API)
  // ==========================================
  Future<void> _deleteRule(Map<String, dynamic> rule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete ${rule['category']} Rule?', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
        content: const Text(
          'Are you sure you want to remove this commission slab? Partners will no longer receive commissions based on this rule.',
          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
        ),
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
        final rId = rule['_id'];
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/commissions/$rId'));

        final res = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          _fetchRules();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted rule for: ${rule['category']}')),
            );
          }
        }
      } catch (_) {
        setState(() => _rules.removeWhere((r) => r['_id'] == rule['_id']));
      }
    }
  }

  Widget _buildCommissionTypeOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F7F2) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F3E38) : AppColors.border,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 15,
              color: isSelected ? const Color(0xFF0F3E38) : AppColors.iconSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF0F3E38) : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, {String? prefix, String? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
      hintText: hint,
      prefixText: prefix,
      suffixText: suffix,
      prefixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
      suffixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
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
                  : _buildRulesDataTable(),
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
              'Commission Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Set and manage commission rules for partners (DSA) based on loan type, amount and performance.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddEditRuleModal(),
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Add Commission Rule',
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
            title: 'Total Commission Paid',
            value: _totalCommissionPaid,
            badgeText: 'Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: '1.5% DSA volume',
            icon: Icons.payments_outlined,
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
            subtitle: 'Ready to credit',
            icon: Icons.hourglass_top_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Active Partners',
            value: '$_activePartners',
            badgeText: '+Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Earning commission',
            icon: Icons.handshake_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Total Rules',
            value: '$_totalRules',
            badgeText: 'Active',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Configured slabs',
            icon: Icons.rule_folder_outlined,
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
                  hintText: 'Search loan type, partner type, rate...',
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
              value: _selectedCategory,
              items: _categoryOptions,
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedPartnerType,
              items: _partnerTypeOptions,
              onChanged: (v) => setState(() => _selectedPartnerType = v!),
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

  Widget _buildRulesDataTable() {
    final rules = _filteredRules;

    if (rules.isEmpty) {
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
              Icon(Icons.rule_folder_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching commission rules found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                  'Commission Rules (${rules.length})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const Text(
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
                showCheckboxColumn: false, // 👈 Fixes double checkbox bug!
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
                            _selectedRows.addAll(List.generate(rules.length, (i) => i));
                          } else {
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const DataColumn(label: Text('#', style: _headerStyle)),
                  const DataColumn(label: Text('Loan Category', style: _headerStyle)),
                  const DataColumn(label: Text('Partner Type', style: _headerStyle)),
                  const DataColumn(label: Text('Commission Type', style: _headerStyle)),
                  const DataColumn(label: Text('Commission Value', style: _headerStyle)),
                  const DataColumn(label: Text('Conditions', style: _headerStyle)),
                  const DataColumn(label: Text('Status', style: _headerStyle)),
                  const DataColumn(label: Text('Actions', style: _headerStyle)),
                ],
                rows: List.generate(rules.length, (index) {
                  final item = rules[index];
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
                              _selectAll = _selectedRows.length == rules.length;
                            });
                          },
                        ),
                      ),
                      DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: item['color'] as Color),
                            const SizedBox(width: 8),
                            Text(
                              item['category'] as String,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(item['partnerType'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item['type'] == 'Percentage' ? const Color(0xFFE0F2FE) : const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['type'] as String,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: item['type'] == 'Percentage' ? const Color(0xFF0284C7) : const Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['value'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0F3E38)),
                        ),
                      ),
                      DataCell(
                        Text(
                          item['conditions'] as String,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.2),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(6),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
                              tooltip: 'Edit Rule',
                              onPressed: () => _openAddEditRuleModal(rule: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                              tooltip: 'Delete Rule',
                              onPressed: () => _deleteRule(item),
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
          'Showing 1 to ${_filteredRules.length} of ${_rules.length} rules',
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