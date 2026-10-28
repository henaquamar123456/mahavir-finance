import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
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

  final List<Map<String, dynamic>> _customers = [
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
    {
      'name': 'Rohan Mehta',
      'verified': false,
      'phone': '+91 76543 21098',
      'email': 'rohan@gmail.com',
      'city': 'Vadodara, Gujarat',
      'loanType': 'Personal Loan',
      'amount': 500000.0,
      'date': '10 Sep 2024',
      'status': 'Rejected',
      'icon': Icons.person_rounded,
      'color': const Color(0xFF7C3AED),
    },
    {
      'name': 'Suresh Patel',
      'verified': true,
      'phone': '+91 91234 56789',
      'email': 'suresh@gmail.com',
      'city': 'Rajkot, Gujarat',
      'loanType': 'Business Loan',
      'amount': 1500000.0,
      'date': '09 Sep 2024',
      'status': 'Under Review',
      'icon': Icons.business_center_rounded,
      'color': const Color(0xFFD97706),
    },
    {
      'name': 'Neha Verma',
      'verified': false,
      'phone': '+91 99887 76655',
      'email': 'neha@gmail.com',
      'city': 'Ahmedabad, Gujarat',
      'loanType': 'Education Loan',
      'amount': 700000.0,
      'date': '08 Sep 2024',
      'status': 'Pending',
      'icon': Icons.school_rounded,
      'color': const Color(0xFFD97706),
    },
    {
      'name': 'Vikram Singh',
      'verified': true,
      'phone': '+91 90011 22334',
      'email': 'vikram@gmail.com',
      'city': 'Surendranagar, Gujarat',
      'loanType': 'Gold Loan',
      'amount': 300000.0,
      'date': '06 Sep 2024',
      'status': 'Approved',
      'icon': Icons.savings_rounded,
      'color': const Color(0xFF16A36A),
    },
    {
      'name': 'Anjali Gupta',
      'verified': false,
      'phone': '+91 78901 23456',
      'email': 'anjali@gmail.com',
      'city': 'Bhavnagar, Gujarat',
      'loanType': 'Loan Against Property',
      'amount': 2000000.0,
      'date': '05 Sep 2024',
      'status': 'Rejected',
      'icon': Icons.domain_rounded,
      'color': const Color(0xFFDC2626),
    },
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    return _customers.where((c) {
      if (_selectedFilter == 'Pending' && c['status'] != 'Pending' && c['status'] != 'Under Review') {
        return false;
      } else if (_selectedFilter == 'Approved' && c['status'] != 'Approved') {
        return false;
      } else if (_selectedFilter == 'Rejected' && c['status'] != 'Rejected') {
        return false;
      }

      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchName = (c['name'] as String).toLowerCase().contains(query);
        final matchPhone = (c['phone'] as String).toLowerCase().contains(query);
        final matchEmail = (c['email'] as String).toLowerCase().contains(query);
        final matchCity = (c['city'] as String).toLowerCase().contains(query);
        if (!matchName && !matchPhone && !matchEmail && !matchCity) return false;
      }

      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

                  // 4 Top Status Badges
                  _buildMetricBadgesStrip(),
                  const SizedBox(height: 12),

                  // Filter Chips
                  _buildFilterChipsRow(),
                  const SizedBox(height: 12),

                  // Search + Filter Input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                            decoration: const InputDecoration(
                              hintText: 'Search by name, mobile, email or loan type...',
                              hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textHint),
                              prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.iconSecondary),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list_rounded, size: 18, color: AppColors.primary),
                          label: const Text(
                            'Filter',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),

            // Customers List
            Expanded(
              child: list.isEmpty
                  ? const Center(
                child: Text('No customers found', style: TextStyle(color: AppColors.textSecondary)),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return _buildCustomerItemCard(context, item);
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Bottom "+ Add New Customer" Pill Button (PDF Page 7)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
            );
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
      {'val': '48', 'label': 'Total Customers', 'icon': Icons.groups_rounded, 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFEFF6FF)},
      {'val': '18', 'label': 'Pending', 'icon': Icons.access_time_rounded, 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7)},
      {'val': '22', 'label': 'Approved', 'icon': Icons.check_circle_rounded, 'color': AppColors.secondary, 'bg': const Color(0xFFDCFCE7)},
      {'val': '8', 'label': 'Rejected', 'icon': Icons.cancel_rounded, 'color': const Color(0xFFDC2626), 'bg': const Color(0xFFFEE2E2)},
    ];

    return Row(
      children: metrics.map((m) {
        final Color col = m['color'] as Color;
        final Color bg = m['bg'] as Color;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Icon(m['icon'] as IconData, size: 13, color: col),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['val'] as String, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    Text(m['label'] as String, style: const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = [
      {'label': 'All (48)', 'key': 'All'},
      {'label': 'Pending (18)', 'key': 'Pending'},
      {'label': 'Approved (22)', 'key': 'Approved'},
      {'label': 'Rejected (8)', 'key': 'Rejected'},
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

    switch (status) {
      case 'Approved':
        statusBg = const Color(0xFFDCFCE7);
        statusCol = const Color(0xFF16A36A);
        break;
      case 'Rejected':
        statusBg = const Color(0xFFFEE2E2);
        statusCol = const Color(0xFFDC2626);
        break;
      case 'Under Review':
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
                builder: (_) => CustomerDetailsScreen(),
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