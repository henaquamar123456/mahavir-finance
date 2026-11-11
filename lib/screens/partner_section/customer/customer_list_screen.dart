import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';
import '../leads/add_new_lead_screen.dart';
import 'customer_details_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  bool _isLoading = true;
  List _customers = [];

  int _totalCount = 0;
  int _pendingCount = 0;
  int _approvedCount = 0;
  int _rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoading = true);

    try {
      final userData = await SharedPrefHelper.getUserData();
      final token = await SharedPrefHelper.getToken();

      String dsaCode = userData['dsaCode'] ?? '';
      if (dsaCode.isEmpty) {
        final phone = userData['phone'] ?? '1234';
        dsaCode = 'MFP${phone.length >= 4 ? phone.substring(phone.length - 4) : phone}';
      }

      if (token == null) {
        _setFallbackData();
        return;
      }

      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loans/dsa/$dsaCode'));
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> loans = data['data'] ?? [];

        int pending = 0;
        int approved = 0;
        int rejected = 0;
        final List fetchedList = [];
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');

    for (var item in loans) {
    final statusStr = (item['status'] ?? 'Pending').toString();
    final amount = double.tryParse(item['loanAmount'].toString()) ?? 0.0;
    final loanType = (item['loanType'] ?? 'Personal Loan').toString();

    if (statusStr.toLowerCase() == 'approved' || statusStr.toLowerCase() == 'disbursed') {
    approved++;
    } else if (statusStr.toLowerCase() == 'rejected') {
    rejected++;
    } else {
    pending++;
    }

    String name = 'Customer';
    String phone = '';
    String email = '';
    String city = item['city'] ?? 'India';
    bool verified = false;

    if (item['customer'] is Map) {
    name = item['customer']['name'] ?? 'Customer';
    phone = item['customer']['phone'] ?? '';
    email = item['customer']['email'] ?? '';
    verified = item['customer']['status'] == 'Active';
    }

    DateTime createdDate = DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now();

    fetchedList.add({
    'name': name,
    'verified': verified,
    'phone': phone.isNotEmpty ? phone : 'N/A',
    'email': email.isNotEmpty ? email : 'N/A',
    'city': city.isNotEmpty ? city : 'India',
    'loanType': loanType,
    'amount': amount,
    'date': dateFormat.format(createdDate),
    'status': statusStr,
    'icon': _getCategoryIcon(loanType),
    'color': _getCategoryColor(loanType),
    });
    }

    if (mounted) {
    setState(() {
    _customers = fetchedList;
    _totalCount = fetchedList.length;
    _pendingCount = pending;
    _approvedCount = approved;
    _rejectedCount = rejected;
    _isLoading = false;
    });
    }
    } else {
    _setFallbackData();
    }
    } catch (_) {
    _setFallbackData();
    }
  }

  void _setFallbackData() {
    if (!mounted) return;
    setState(() {
      _customers = [
        {
          'name': 'Amit Shah',
          'verified': true,
          'phone': '+91 98765 43210',
          'email': 'amit.shah@gmail.com',
          'city': 'Ahmedabad, Gujarat',
          'loanType': 'Car Loan',
          'amount': 800000.0,
          'date': '12 Sep 2024',
          'status': 'Pending',
          'icon': Icons.directions_car_rounded,
          'color': const Color(0xFF0284C7),
        },
        {
          'name': 'Priya Sharma',
          'verified': true,
          'phone': '+91 87654 32109',
          'email': 'priya@gmail.com',
          'city': 'Surat, Gujarat',
          'loanType': 'Home Loan',
          'amount': 2500000.0,
          'date': '11 Sep 2024',
          'status': 'Approved',
          'icon': Icons.home_rounded,
          'color': const Color(0xFF16A36A),
        },
      ];
      _totalCount = _customers.length;
      _pendingCount = 1;
      _approvedCount = 1;
      _rejectedCount = 0;
      _isLoading = false;
    });
  }

  IconData _getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home loan':
        return Icons.home_rounded;
      case 'car loan':
        return Icons.directions_car_rounded;
      case 'business loan':
        return Icons.business_center_rounded;
      case 'education loan':
        return Icons.school_rounded;
      case 'gold loan':
        return Icons.savings_rounded;
      case 'loan against property':
        return Icons.domain_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'home loan':
        return const Color(0xFF0284C7);
      case 'business loan':
        return const Color(0xFF7C3AED);
      case 'car loan':
        return const Color(0xFFD97706);
      case 'gold loan':
        return const Color(0xFF16A36A);
      default:
        return AppColors.secondary;
    }
  }

  List get _filteredCustomers {
    return _customers.where((c) {
      final status = (c['status'] ?? '').toString();
      if (_selectedFilter == 'Pending' && status != 'Pending' && status != 'Under Review') {
        return false;
      } else if (_selectedFilter == 'Approved' && status != 'Approved' && status != 'Disbursed') {
        return false;
      } else if (_selectedFilter == 'Rejected' && status != 'Rejected') {
        return false;
      }

      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchName = (c['name'] as String).toLowerCase().contains(query);
        final matchPhone = (c['phone'] as String).toLowerCase().contains(query);
        final matchEmail = (c['email'] as String).toLowerCase().contains(query);
        final matchCity = (c['city'] as String).toLowerCase().contains(query);
        final matchLoan = (c['loanType'] as String).toLowerCase().contains(query);
        if (!matchName && !matchPhone && !matchEmail && !matchCity && !matchLoan) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredCustomers;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer List',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Manage all your referred customers in one place.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),

                  _buildMetricBadgesStrip(),
                  const SizedBox(height: 12),

                  _buildFilterChipsRow(),
                  const SizedBox(height: 12),

                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search by name, mobile, email or loan type...',
                        hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.iconSecondary),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16, color: AppColors.iconSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
                  : RefreshIndicator(
                color: AppColors.secondary,
                onRefresh: _fetchCustomers,
                child: list.isEmpty
                    ? Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_rounded,
                          size: 48,
                          color: AppColors.iconSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No customers found for selected criteria',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _buildCustomerItemCard(context, item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final res = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
            );
            if (res == true) {
              _fetchCustomers();
            }
          },
          backgroundColor: const Color(0xFF0F3E38),
          elevation: 4,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
          label: const Text(
            'Add New Customer',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBadgesStrip() {
    final metrics = [
      {
        'val': '$_totalCount',
        'label': 'Total',
        'key': 'All',
        'icon': Icons.groups_rounded,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFEFF6FF),
      },
      {
        'val': '$_pendingCount',
        'label': 'Pending',
        'key': 'Pending',
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7),
      },
      {
        'val': '$_approvedCount',
        'label': 'Approved',
        'key': 'Approved',
        'icon': Icons.check_circle_rounded,
        'color': AppColors.secondary,
        'bg': const Color(0xFFDCFCE7),
      },
      {
        'val': '$_rejectedCount',
        'label': 'Rejected',
        'key': 'Rejected',
        'icon': Icons.cancel_rounded,
        'color': const Color(0xFFDC2626),
        'bg': const Color(0xFFFEE2E2),
      },
    ];

    return Row(
      children: metrics.map((m) {
        final Color col = m['color'] as Color;
        final Color bg = m['bg'] as Color;
        final String filterKey = m['key'] as String;
        final bool isSelected = _selectedFilter == filterKey;

        return Expanded(
          child: InkWell(
            onTap: () => setState(() => _selectedFilter = filterKey),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? bg.withValues(alpha: 0.6) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? col : AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                    child: Icon(m['icon'] as IconData, size: 13, color: col),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          m['val'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: col,
                          ),
                        ),
                        Text(
                          m['label'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 8,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = [
      {'label': 'All ($_totalCount)', 'key': 'All'},
      {'label': 'Pending ($_pendingCount)', 'key': 'Pending'},
      {'label': 'Approved ($_approvedCount)', 'key': 'Approved'},
      {'label': 'Rejected ($_rejectedCount)', 'key': 'Rejected'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedFilter = f['key']!),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F3E38) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? const Color(0xFF0F3E38) : AppColors.border),
                ),
                child: Text(
                  f['label']!,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomerItemCard(BuildContext context, Map<String, dynamic> item) {
    final Color col = item['color'] as Color;
    final String status = item['status'] as String;
    final bool verified = item['verified'] as bool;

    Color statusBg;
    Color statusCol;

    switch (status.toLowerCase()) {
      case 'approved':
      case 'disbursed':
        statusBg = const Color(0xFFDCFCE7);
        statusCol = const Color(0xFF16A36A);
        break;
      case 'rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusCol = const Color(0xFFDC2626);
        break;
      case 'under review':
        statusBg = const Color(0xFFE0F2FE);
        statusCol = const Color(0xFF0284C7);
        break;
      default:
        statusBg = const Color(0xFFFEF3C7);
        statusCol = const Color(0xFFD97706);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomerDetailsScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: col.withValues(alpha: 0.12),
                  child: Icon(Icons.person, color: col, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item['name'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ),
                          if (verified) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Verified', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Color(0xFF16A36A))),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 11, color: AppColors.iconSecondary),
                          const SizedBox(width: 3),
                          Text(item['phone'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 11, color: AppColors.iconSecondary),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              item['email'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 11, color: AppColors.iconSecondary),
                          const SizedBox(width: 3),
                          Text(item['city'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item['icon'] as IconData, size: 13, color: col),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item['loanType'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.formatWhole(item['amount'] as double),
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: col),
                      ),
                      const SizedBox(height: 1),
                      Text(item['date'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: statusCol),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.iconSecondary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}