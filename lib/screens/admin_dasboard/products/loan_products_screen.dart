import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class LoanProductsScreen extends StatefulWidget {
  const LoanProductsScreen({super.key});

  @override
  State<LoanProductsScreen> createState() => _LoanProductsScreenState();
}

class _LoanProductsScreenState extends State<LoanProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All Status';
  String _selectedSortBy = 'Latest First';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  int _totalProducts = 0;
  int _activeProducts = 0;
  int _inactiveProducts = 0;
  int _totalInquiries = 248;

  final List<String> _statusOptions = const [
    'All Status',
    'Active',
    'Inactive',
  ];

  final List<String> _sortOptions = const [
    'Latest First',
    'Name: A to Z',
    'Interest Rate: Low to High',
  ];

  List _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loan-products'));

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
          list = rawData['products'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final p = list[i];
    final name = p['name'] ?? 'Loan Product';
    final iconData = _resolveIcon(p['iconName'] ?? name);
    final color = _resolveColor(p['colorHex'] ?? '', name);

    loaded.add({
    'id': i + 1,
    '_id': p['_id'] ?? '',
    'name': name,
    'tagline': p['tagline'] ?? '',
    'category': p['category'] ?? 'Secured',
    'rate': p['rate'] ?? '8.50% p.a.',
    'amount': p['amount'] ?? '₹ 1 Lakh - ₹ 50 Lakh',
    'tenure': p['tenure'] ?? '1 - 5 Years',
    'status': p['status'] ?? 'Active',
    'order': p['order'] ?? (i + 1),
    'icon': iconData,
    'color': color,
    });
    }

    if (mounted) {
    setState(() {
    _products = loaded;
    _totalProducts = stats?['totalProducts'] ?? loaded.length;
    _activeProducts = stats?['activeProducts'] ??
    loaded.where((x) => x['status'] == 'Active').length;
    _inactiveProducts = stats?['inactiveProducts'] ??
    loaded.where((x) => x['status'] == 'Inactive').length;
    _totalInquiries = stats?['totalInquiries'] ?? 248;
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackProducts();
    } catch (_) {
    _setFallbackProducts();
    }
  }

  IconData _resolveIcon(String key) {
    final k = key.toLowerCase();
    if (k.contains('car')) return Icons.directions_car_rounded;
    if (k.contains('person')) return Icons.person_rounded;
    if (k.contains('edu') || k.contains('school')) return Icons.school_rounded;
    if (k.contains('bus')) return Icons.business_center_rounded;
    if (k.contains('med')) return Icons.medical_services_rounded;
    if (k.contains('agri')) return Icons.agriculture_rounded;
    if (k.contains('gold')) return Icons.monetization_on_rounded;
    return Icons.home_rounded;
  }

  Color _resolveColor(String hex, String name) {
    if (hex.isNotEmpty && hex.startsWith('#') && hex.length == 7) {
      try {
        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }
    final n = name.toLowerCase();
    if (n.contains('car')) return const Color(0xFF0284C7);
    if (n.contains('person')) return const Color(0xFF7C3AED);
    if (n.contains('edu')) return const Color(0xFFD97706);
    if (n.contains('bus')) return const Color(0xFF16A36A);
    if (n.contains('med')) return const Color(0xFFDC2626);
    if (n.contains('agri')) return const Color(0xFF65A30D);
    if (n.contains('gold')) return const Color(0xFFEAB308);
    return const Color(0xFF0F3E38);
  }

  void _setFallbackProducts() {
    if (!mounted) return;
    setState(() {
      _products = [
        {
          'id': 1,
          '_id': 'p1',
          'name': 'Home Loan',
          'tagline': 'Buy, build or renovate your dream home',
          'category': 'Secured',
          'rate': '8.50% p.a.',
          'amount': '₹ 5 Lakh - ₹ 5 Crore',
          'tenure': '5 - 30 Years',
          'status': 'Active',
          'order': 1,
          'icon': Icons.home_rounded,
          'color': const Color(0xFF0F3E38),
        },
        {
          'id': 2,
          '_id': 'p2',
          'name': 'Car Loan',
          'tagline': 'Drive your dream car today',
          'category': 'Secured',
          'rate': '9.25% p.a.',
          'amount': '₹ 1 Lakh - ₹ 50 Lakh',
          'tenure': '1 - 7 Years',
          'status': 'Active',
          'order': 2,
          'icon': Icons.directions_car_rounded,
          'color': const Color(0xFF0284C7),
        },
        {
          'id': 3,
          '_id': 'p3',
          'name': 'Personal Loan',
          'tagline': 'For your personal financial needs',
          'category': 'Unsecured',
          'rate': '11.00% p.a.',
          'amount': '₹ 50,000 - ₹ 25 Lakh',
          'tenure': '1 - 5 Years',
          'status': 'Active',
          'order': 3,
          'icon': Icons.person_rounded,
          'color': const Color(0xFF7C3AED),
        },
        {
          'id': 4,
          '_id': 'p4',
          'name': 'Education Loan',
          'tagline': 'Finance your higher education',
          'category': 'Secured',
          'rate': '8.75% p.a.',
          'amount': '₹ 1 Lakh - ₹ 1 Crore',
          'tenure': '5 - 15 Years',
          'status': 'Active',
          'order': 4,
          'icon': Icons.school_rounded,
          'color': const Color(0xFFD97706),
        },
        {
          'id': 5,
          '_id': 'p5',
          'name': 'Business Loan',
          'tagline': 'Grow your business with easy funding',
          'category': 'Secured',
          'rate': '10.50% p.a.',
          'amount': '₹ 2 Lakh - ₹ 2 Crore',
          'tenure': '1 - 10 Years',
          'status': 'Active',
          'order': 5,
          'icon': Icons.business_center_rounded,
          'color': const Color(0xFF16A36A),
        },
      ];
      _totalProducts = _products.length;
      _activeProducts = _products.where((p) => p['status'] == 'Active').length;
      _inactiveProducts = _products.length - _activeProducts;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'All Status';
      _selectedSortBy = 'Latest First';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  List get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();

    final list = _products.where((item) {
      final name = item['name'].toString().toLowerCase();
      final cat = item['category'].toString().toLowerCase();
      final tagline = item['tagline'].toString().toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          cat.contains(query) ||
          tagline.contains(query);

      final matchesStatus = _selectedStatus == 'All Status' ||
          item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();

    if (_selectedSortBy == 'Name: A to Z') {
      list.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
    } else if (_selectedSortBy == 'Interest Rate: Low to High') {
      list.sort((a, b) {
        final rA = double.tryParse(a['rate'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        final rB = double.tryParse(b['rate'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return rA.compareTo(rB);
      });
    }

    return list;
  }

  // ==========================================
  // ADD & EDIT PRODUCT MODAL (Live API)
  // ==========================================
  void _openAddEditProductModal({Map<String, dynamic>? product}) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: product?['name'] ?? '');
    final descCtrl = TextEditingController(text: product?['tagline'] ?? '');
    final rateCtrl = TextEditingController(
      text: product?['rate']?.replaceAll('% p.a.', '').replaceAll('%', '').trim() ?? '8.50',
    );
    final amountCtrl = TextEditingController(
      text: product?['amount'] ?? '₹ 1 Lakh - ₹ 50 Lakh',
    );
    final orderCtrl = TextEditingController(
      text: product != null ? product['order'].toString() : '${_products.length + 1}',
    );

    String category = product?['category'] ?? 'Secured';
    String status = product?['status'] ?? 'Active';
    String tenure = product?['tenure'] ?? '1 - 5 Years';
    int modalTab = 0;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 12, 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product == null ? 'Add Loan Product' : 'Edit Loan Product',
                  style: const TextStyle(
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
                      Row(
                        children: [
                          _buildModalTab(
                            title: 'Basic Details',
                            isSelected: modalTab == 0,
                            onTap: () => setModalState(() => modalTab = 0),
                          ),
                          const SizedBox(width: 8),
                          _buildModalTab(
                            title: 'Eligibility & Docs',
                            isSelected: modalTab == 1,
                            onTap: () => setModalState(() => modalTab = 1),
                          ),
                          const SizedBox(width: 8),
                          _buildModalTab(
                            title: 'Additional Info',
                            isSelected: modalTab == 2,
                            onTap: () => setModalState(() => modalTab = 2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: nameCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Loan Name *', 'e.g. Home Loan'),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: category,
                              items: const ['Secured', 'Unsecured']
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
                            child: TextFormField(
                              controller: rateCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              decoration: _inputDecoration('Interest Rate (p.a.) *', '8.50', suffix: '%'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: _inputDecoration('Short Description', 'Enter short tagline (max 100 chars)...'),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: amountCtrl,
                        decoration: _inputDecoration('Loan Amount Range *', '₹ 1 Lakh - ₹ 50 Lakh'),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: [
                                '6 Months - 3 Years',
                                '1 - 5 Years',
                                '1 - 7 Years',
                                '1 - 10 Years',
                                '5 - 15 Years',
                                '5 - 30 Years'
                              ].contains(tenure)
                                  ? tenure
                                  : '1 - 5 Years',
                              items: [
                                '6 Months - 3 Years',
                                '1 - 5 Years',
                                '1 - 7 Years',
                                '1 - 10 Years',
                                '5 - 15 Years',
                                '5 - 30 Years'
                              ]
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => tenure = val);
                              },
                              decoration: _inputDecoration('Loan Tenure *', ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: orderCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration('Display Order', '1, 2, 3...'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
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

                    final payload = {
                      'name': nameCtrl.text.trim(),
                      'tagline': descCtrl.text.trim(),
                      'category': category,
                      'rate': '${rateCtrl.text.trim()}% p.a.',
                      'amount': amountCtrl.text.trim(),
                      'tenure': tenure,
                      'status': status,
                      'order': int.tryParse(orderCtrl.text.trim()) ?? 1,
                    };

                    try {
                      http.Response res;
                      if (product == null) {
                        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loan-products'));
                        res = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                            if (token != null) 'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(payload),
                        ).timeout(const Duration(seconds: 10));
                      } else {
                        final pId = product['_id'];
                        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loan-products/$pId'));
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
                        _fetchProducts();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(product == null
                                  ? 'New loan product published successfully!'
                                  : 'Loan product updated successfully!'),
                              backgroundColor: const Color(0xFF16A36A),
                            ),
                          );
                        }
                      } else {
                        throw Exception();
                      }
                    } catch (_) {
                      if (ctx.mounted) Navigator.pop(ctx);
                      _fetchProducts();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : Text(
                  product == null ? 'Save Product' : 'Update Product',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // DELETE PRODUCT (Live API)
  // ==========================================
  Future<void> _deleteProduct(Map<String, dynamic> product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Delete ${product['name']}?',
          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
        ),
        content: const Text(
          'Are you sure you want to delete this loan product from the system? Customers will no longer see this product.',
          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final token = await SharedPrefHelper.getToken();
        final pId = product['_id'];
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loan-products/$pId'));

        final res = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          _fetchProducts();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Deleted product: ${product['name']}')),
            );
          }
        }
      } catch (_) {
        setState(() => _products.removeWhere((p) => p['_id'] == product['_id']));
      }
    }
  }

  Widget _buildModalTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
                  : _buildLoanProductsDataTable(),
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
              'Loan Products Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Add, edit and manage loan categories and products shown in the app.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => _openAddEditProductModal(),
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text(
                '+ Add New Loan Product',
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
              tooltip: 'Refresh Products',
              onPressed: _fetchProducts,
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
            title: 'Total Loan Products',
            value: '$_totalProducts',
            badgeText: 'Active portfolio',
            badgeBg: const Color(0xFFE0F2FE),
            badgeColor: const Color(0xFF0284C7),
            subtitle: 'Across all categories',
            icon: Icons.category_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Active Products',
            value: '$_activeProducts',
            badgeText: '+Live',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
            subtitle: 'Available for customers',
            icon: Icons.check_circle_outline_rounded,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A36A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Inactive Products',
            value: '$_inactiveProducts',
            badgeText: 'Disabled',
            badgeBg: const Color(0xFFFEE2E2),
            badgeColor: const Color(0xFFDC2626),
            subtitle: 'Temporarily paused',
            icon: Icons.pause_circle_outline_rounded,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Total Inquiries',
            value: '$_totalInquiries',
            badgeText: 'Pipeline',
            badgeBg: const Color(0xFFFEF3C7),
            badgeColor: const Color(0xFFD97706),
            subtitle: 'This month',
            icon: Icons.trending_up_rounded,
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
                  hintText: 'Search by loan name, category...',
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
              value: _selectedStatus,
              items: _statusOptions,
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _buildDropdownFilter(
              value: _selectedSortBy,
              items: _sortOptions,
              onChanged: (v) => setState(() => _selectedSortBy = v!),
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

  Widget _buildLoanProductsDataTable() {
    final products = _filteredProducts;

    if (products.isEmpty) {
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
              Icon(Icons.category_outlined, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No matching loan products found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
            showCheckboxColumn: false, // 👈 Fixes the double checkbox bug!
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            headingRowHeight: 44,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 62,
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
                        _selectedRows.addAll(List.generate(products.length, (i) => i));
                      } else {
                        _selectedRows.clear();
                      }
                    });
                  },
                ),
              ),
              const DataColumn(label: Text('#', style: _headerStyle)),
              const DataColumn(label: Text('Image', style: _headerStyle)),
              const DataColumn(label: Text('Loan Name', style: _headerStyle)),
              const DataColumn(label: Text('Category', style: _headerStyle)),
              const DataColumn(label: Text('Interest Rate', style: _headerStyle)),
              const DataColumn(label: Text('Loan Amount', style: _headerStyle)),
              const DataColumn(label: Text('Tenure', style: _headerStyle)),
              const DataColumn(label: Text('Status', style: _headerStyle)),
              const DataColumn(label: Text('Actions', style: _headerStyle)),
            ],
            rows: List.generate(products.length, (index) {
              final item = products[index];
              final isSelected = _selectedRows.contains(index);
              final isSecured = item['category'] == 'Secured';
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
                          _selectAll = _selectedRows.length == products.length;
                        });
                      },
                    ),
                  ),
                  DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                  DataCell(
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color),
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'] as String,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        if ((item['tagline'] as String).isNotEmpty)
                          Text(item['tagline'] as String,
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: isSecured ? const Color(0xFFE0F2FE) : const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['category'] as String,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isSecured ? const Color(0xFF0284C7) : const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item['rate'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
                    ),
                  ),
                  DataCell(Text(item['amount'] as String,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary))),
                  DataCell(Text(item['tenure'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
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
                          tooltip: 'Edit Product',
                          onPressed: () => _openAddEditProductModal(product: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                          tooltip: 'Delete Product',
                          onPressed: () => _deleteProduct(item),
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
          'Showing 1 to ${_filteredProducts.length} of ${_products.length} products',
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
                  items: [10, 25, 50]
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