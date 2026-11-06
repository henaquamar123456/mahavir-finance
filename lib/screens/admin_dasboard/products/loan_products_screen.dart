import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

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

  final List<String> _statusOptions = [
    'All Status',
    'Active',
    'Inactive',
  ];

  final List<String> _sortOptions = [
    'Latest First',
    'Name: A to Z',
    'Interest Rate: Low to High',
    'Max Amount: High to Low',
  ];

  // PDF Page 10 ke sabhi 8 Loan Products ka data[cite: 10]
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Home Loan',
      'tagline': 'Buy, build or renovate your dream home',
      'category': 'Secured',
      'rate': '8.50% p.a.',
      'amount': '₹ 5 Lakh - ₹ 5 Crore',
      'tenure': '5 - 30 Years',
      'status': 'Active',
      'icon': Icons.home_rounded,
      'color': const Color(0xFF0F3E38),
    },
    {
      'id': 2,
      'name': 'Car Loan',
      'tagline': 'Drive your dream car today',
      'category': 'Secured',
      'rate': '9.25% p.a.',
      'amount': '₹ 1 Lakh - ₹ 50 Lakh',
      'tenure': '1 - 7 Years',
      'status': 'Active',
      'icon': Icons.directions_car_rounded,
      'color': const Color(0xFF0284C7),
    },
    {
      'id': 3,
      'name': 'Personal Loan',
      'tagline': 'For your personal financial needs',
      'category': 'Unsecured',
      'rate': '11.00% p.a.',
      'amount': '₹ 50,000 - ₹ 25 Lakh',
      'tenure': '1 - 5 Years',
      'status': 'Active',
      'icon': Icons.person_rounded,
      'color': const Color(0xFF7C3AED),
    },
    {
      'id': 4,
      'name': 'Education Loan',
      'tagline': 'Finance your higher education',
      'category': 'Secured',
      'rate': '8.75% p.a.',
      'amount': '₹ 1 Lakh - ₹ 1 Crore',
      'tenure': '5 - 15 Years',
      'status': 'Active',
      'icon': Icons.school_rounded,
      'color': const Color(0xFFD97706),
    },
    {
      'id': 5,
      'name': 'Business Loan',
      'tagline': 'Grow your business with easy funding',
      'category': 'Secured',
      'rate': '10.50% p.a.',
      'amount': '₹ 2 Lakh - ₹ 2 Crore',
      'tenure': '1 - 10 Years',
      'status': 'Active',
      'icon': Icons.business_center_rounded,
      'color': const Color(0xFF16A36A),
    },
    {
      'id': 6,
      'name': 'Medical Loan',
      'tagline': 'For medical emergencies',
      'category': 'Unsecured',
      'rate': '11.50% p.a.',
      'amount': '₹ 50,000 - ₹ 20 Lakh',
      'tenure': '1 - 5 Years',
      'status': 'Active',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFFDC2626),
    },
    {
      'id': 7,
      'name': 'Agriculture Loan',
      'tagline': 'Support for farmers and agriculture',
      'category': 'Secured',
      'rate': '9.00% p.a.',
      'amount': '₹ 1 Lakh - ₹ 1 Crore',
      'tenure': '1 - 7 Years',
      'status': 'Active',
      'icon': Icons.agriculture_rounded,
      'color': const Color(0xFF65A30D),
    },
    {
      'id': 8,
      'name': 'Gold Loan',
      'tagline': 'Get funds against your gold',
      'category': 'Secured',
      'rate': '7.50% p.a.',
      'amount': '₹ 20,000 - ₹ 50 Lakh',
      'tenure': '6 Months - 3 Years',
      'status': 'Active',
      'icon': Icons.monetization_on_rounded,
      'color': const Color(0xFFEAB308),
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
      _selectedStatus = 'All Status';
      _selectedSortBy = 'Latest First';
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  // PDF Page 10 ka Add/Edit Loan Product Form Modal[cite: 10]
  void _openAddEditProductModal({Map<String, dynamic>? product}) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: product?['name'] ?? '');
    final descCtrl = TextEditingController(text: product?['tagline'] ?? '');
    final rateCtrl = TextEditingController(
        text: product?['rate']?.replaceAll('% p.a.', '') ?? '');
    final minAmountCtrl = TextEditingController();
    final maxAmountCtrl = TextEditingController();
    final orderCtrl = TextEditingController(text: '1');

    String category = product?['category'] ?? 'Secured';
    String status = product?['status'] ?? 'Active';
    String tenure = product?['tenure'] ?? '1 - 5 Years';
    int modalTab = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            titlePadding: const EdgeInsets.fromLTRB(18, 16, 12, 10),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product == null ? 'Add Loan Product' : 'Edit Loan Product',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary),
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
                      // Form Sub-tabs[cite: 10]
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

                      // Loan Name*[cite: 10]
                      TextFormField(
                        controller: nameCtrl,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration(
                            'Loan Name *', 'Enter loan product name'),
                      ),
                      const SizedBox(height: 12),

                      // Category & Interest Rate[cite: 10]
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: category,
                              items: ['Secured', 'Unsecured']
                                  .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c,
                                      style: const TextStyle(
                                          fontSize: 12))))
                                  .toList(),
                              onChanged: (val) =>
                                  setModalState(() => category = val!),
                              decoration: _inputDecoration('Category *', ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: rateCtrl,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                              decoration: _inputDecoration(
                                  'Interest Rate (p.a.) *', '8.50',
                                  suffix: '%'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Short Description*[cite: 10]
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDecoration('Short Description *',
                            'Enter short description (max 100 chars)...'),
                      ),
                      const SizedBox(height: 12),

                      // Min & Max Loan Amount[cite: 10]
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: minAmountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                  'Min Loan Amount *', '1,00,000',
                                  prefix: '₹ '),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: maxAmountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                  'Max Loan Amount *', '5,00,00,000',
                                  prefix: '₹ '),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Loan Tenure & Display Order[cite: 10]
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: tenure,
                              items: [
                                '6 Months - 3 Years',
                                '1 - 5 Years',
                                '1 - 7 Years',
                                '1 - 10 Years',
                                '5 - 15 Years',
                                '5 - 30 Years'
                              ]
                                  .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t,
                                      style: const TextStyle(
                                          fontSize: 12))))
                                  .toList(),
                              onChanged: (val) =>
                                  setModalState(() => tenure = val!),
                              decoration: _inputDecoration('Loan Tenure *', ''),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: orderCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                  'Display Order', '1, 2, 3...'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status Radio Buttons[cite: 10]
                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Active',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Active',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Inactive',
                                groupValue: status,
                                activeColor: const Color(0xFF0F3E38),
                                onChanged: (v) =>
                                    setModalState(() => status = v!),
                              ),
                              const Text('Inactive',
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Upload Image Placeholder[cite: 10]
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.border,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.cloud_upload_outlined,
                                size: 24, color: Color(0xFF0F3E38)),
                            SizedBox(height: 4),
                            Text(
                              'Click to upload product image',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F3E38)),
                            ),
                            Text('PNG, JPG up to 2MB',
                                style: TextStyle(
                                    fontSize: 9.5, color: AppColors.textHint)),
                          ],
                        ),
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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(product == null
                            ? 'New loan product published!'
                            : 'Loan product updated successfully!'),
                        backgroundColor: const Color(0xFF0F3E38),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3E38),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save Product',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
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

  InputDecoration _inputDecoration(String label, String hint,
      {String? prefix, String? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
      hintText: hint,
      prefixText: prefix,
      suffixText: suffix,
      prefixStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: AppColors.primary),
      suffixStyle: const TextStyle(
          fontWeight: FontWeight.w700, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
          const BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
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
              // Header title and Add Product button[cite: 10]
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // 1. 4 Metric Cards (Total, Active, Inactive, Total Inquiries)[cite: 10]
              _buildTopMetricsRow(),
              const SizedBox(height: 16),

              // 2. Search & Filter Bar[cite: 10]
              _buildFilterToolbar(),
              const SizedBox(height: 16),

              // 3. Loan Products Data Table[cite: 10]
              _buildLoanProductsDataTable(),
              const SizedBox(height: 14),

              // 4. Pagination Footer[cite: 10]
              _buildPaginationFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Title Row[cite: 10]
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
        ElevatedButton.icon(
          onPressed: () => _openAddEditProductModal(),
          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
          label: const Text(
            '+ Add New Loan Product',
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

  // 1. 4 Metric Cards[cite: 10]
  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Total Loan Products',
            value: '8',
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
            value: '7',
            badgeText: '↑ 12%',
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
            value: '1',
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
            value: '248',
            badgeText: '↑ 15%',
            badgeBg: const Color(0xFFDCFCE7),
            badgeColor: const Color(0xFF16A36A),
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: badgeBg, borderRadius: BorderRadius.circular(4)),
                child: Text(badgeText,
                    style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                  radius: 14,
                  backgroundColor: iconBg,
                  child: Icon(icon, size: 16, color: iconColor)),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style:
              const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

  // 2. Search & Filter Bar[cite: 10]
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
                  hintText: 'Search by loan name, category...',
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
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded,
                size: 15, color: AppColors.primary),
            label: const Text('Filters',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
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

  // 3. Loan Products Data Table[cite: 10]
  Widget _buildLoanProductsDataTable() {
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
            headingRowColor:
            WidgetStateProperty.all(const Color(0xFFF8FAFC)),
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
                        _selectedRows
                            .addAll(List.generate(_products.length, (i) => i));
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
              const DataColumn(
                  label: Text('Interest Rate', style: _headerStyle)),
              const DataColumn(
                  label: Text('Loan Amount', style: _headerStyle)),
              const DataColumn(label: Text('Tenure', style: _headerStyle)),
              const DataColumn(label: Text('Status', style: _headerStyle)),
              const DataColumn(label: Text('Actions', style: _headerStyle)),
            ],
            rows: List.generate(_products.length, (index) {
              final item = _products[index];
              final isSelected = _selectedRows.contains(index);
              final isSecured = item['category'] == 'Secured';

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
                              _selectedRows.length == _products.length;
                        });
                      },
                    ),
                  ),
                  DataCell(Text('${item['id']}',
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textSecondary))),
                  DataCell(
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'] as IconData,
                          size: 20, color: item['color'] as Color),
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'] as String,
                            style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                        Text(item['tagline'] as String,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: isSecured
                            ? const Color(0xFFE0F2FE)
                            : const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['category'] as String,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isSecured
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item['rate'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F3E38)),
                    ),
                  ),
                  DataCell(Text(item['amount'] as String,
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary))),
                  DataCell(Text(item['tenure'] as String,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['status'] as String,
                        style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A36A)),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 16, color: Color(0xFF0F3E38)),
                          tooltip: 'Edit Product',
                          onPressed: () =>
                              _openAddEditProductModal(product: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 16, color: Color(0xFFDC2626)),
                          tooltip: 'Delete Product',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Deleted product: ${item['name']}')),
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
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  // 4. Pagination Footer[cite: 10]
  Widget _buildPaginationFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 8 of 8 products',
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
                  items: [10, 25, 50]
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
            _buildPageButton('>', isEnabled: false),
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