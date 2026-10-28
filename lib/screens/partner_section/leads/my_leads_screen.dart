import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../p_models/partner_model_screen.dart';
import 'add_new_lead_screen.dart';
import 'lead_details_screen.dart';

class MyLeadsScreen extends StatefulWidget {
  const MyLeadsScreen({super.key});

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<PartnerLeadModel> _allLeads = [
    ...PartnerLeadModel.sampleLeads,
    const PartnerLeadModel(
      id: '#LD20240908',
      customerName: 'Neha Verma',
      customerId: 'CUST00128',
      phone: '+91 99887 76655',
      email: 'neha@gmail.com',
      city: 'Ahmedabad, Gujarat',
      loanCategory: 'Education Loan',
      amount: 700000,
      tenure: '7 Years',
      date: '08 Sep 2024',
      time: '12:20 PM',
      status: PartnerLeadStatus.pending,
      icon: Icons.school_rounded,
      iconColor: Color(0xFFD97706),
    ),
    const PartnerLeadModel(
      id: '#LD20240906',
      customerName: 'Vikram Singh',
      customerId: 'CUST00129',
      phone: '+91 90011 22334',
      email: 'vikram@gmail.com',
      city: 'Surendranagar, Gujarat',
      loanCategory: 'Gold Loan',
      amount: 300000,
      tenure: '2 Years',
      date: '06 Sep 2024',
      time: '03:10 PM',
      status: PartnerLeadStatus.approved,
      icon: Icons.savings_rounded,
      iconColor: Color(0xFF16A36A),
      isExistingCustomer: true,
    ),
    const PartnerLeadModel(
      id: '#LD20240905',
      customerName: 'Anjali Gupta',
      customerId: 'CUST00130',
      phone: '+91 78901 23456',
      email: 'anjali@gmail.com',
      city: 'Bhavnagar, Gujarat',
      loanCategory: 'Loan Against Property',
      amount: 2000000,
      tenure: '10 Years',
      date: '05 Sep 2024',
      time: '05:40 PM',
      status: PartnerLeadStatus.rejected,
      icon: Icons.domain_rounded,
      iconColor: Color(0xFFDC2626),
    ),
  ];

  List<PartnerLeadModel> get _filteredLeads {
    return _allLeads.where((lead) {
      if (_selectedFilter == 'Pending' &&
          lead.status != PartnerLeadStatus.pending &&
          lead.status != PartnerLeadStatus.underReview) {
        return false;
      } else if (_selectedFilter == 'Approved' && lead.status != PartnerLeadStatus.approved) {
        return false;
      } else if (_selectedFilter == 'Rejected' && lead.status != PartnerLeadStatus.rejected) {
        return false;
      }

      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchName = lead.customerName.toLowerCase().contains(query);
        final matchPhone = lead.phone.toLowerCase().contains(query);
        final matchLoan = lead.loanCategory.toLowerCase().contains(query);
        if (!matchName && !matchPhone && !matchLoan) return false;
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
    final leads = _filteredLeads;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        child: Column(
          children: [
            // Top Sticky Controls
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Add New Lead CTA (Crash Fixed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Leads',
                              style: AppTextStyles.headingLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Manage all your referred customers and track their status.',
                              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
                          );
                        },
                        icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                        label: const Text(
                          'Add New Lead',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3E38),
                          elevation: 0,
                          minimumSize: Size.zero, // Global theme infinite width override
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 4 Compact Metric Badges Strip
                  _buildMetricBadgesStrip(),
                  const SizedBox(height: 12),

                  // Filter Chips
                  _buildFilterChipsRow(),
                  const SizedBox(height: 12),

                  // Search Bar + Filter Button
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
                              hintText: 'Search by name, mobile or loan type...',
                              hintStyle: TextStyle(fontSize: 12, color: AppColors.textHint),
                              prefixIcon: Icon(Icons.search_rounded, size: 20, color: AppColors.iconSecondary),
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
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),

            // Scrollable Leads List
            Expanded(
              child: leads.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: AppColors.iconSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    const Text(
                      'No leads found for selected criteria',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: leads.length,
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  return _buildLeadItemCard(context, lead);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBadgesStrip() {
    final metrics = [
      {'val': '48', 'label': 'Total Leads', 'icon': Icons.groups_rounded, 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFEFF6FF)},
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // 6 se 4 kiya
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
                const SizedBox(width: 4),
                // Expanded wrap karne se text kabhi overflow nahi karega
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        m['val'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
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

  Widget _buildLeadItemCard(BuildContext context, PartnerLeadModel lead) {
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
              MaterialPageRoute(builder: (_) => LeadDetailsScreen(lead: lead)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: lead.iconColor.withValues(alpha: 0.12),
                  child: Icon(Icons.person, color: lead.iconColor, size: 24),
                ),
                const SizedBox(width: 12),

                // Name, Phone, Email
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 12, color: AppColors.iconSecondary),
                          const SizedBox(width: 4),
                          Text(lead.phone, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 12, color: AppColors.iconSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              lead.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Loan Type, Amount & Date
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(lead.icon, size: 13, color: lead.iconColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              lead.loanCategory,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.formatWhole(lead.amount),
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: lead.iconColor),
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 10, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(lead.date, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge & Trailing Chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: lead.status.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        lead.status.label,
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: lead.status.textColor),
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