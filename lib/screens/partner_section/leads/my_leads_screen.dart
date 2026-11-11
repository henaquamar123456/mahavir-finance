import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
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

  bool _isLoading = true;
  String? _errorMessage;
  List<PartnerLeadModel> _allLeads = [];

  // Metrics
  int _totalCount = 0;
  int _pendingCount = 0;
  int _approvedCount = 0;
  int _rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Real API Integration: Fetch DSA Leads
  Future<void> _fetchLeads() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userData = await SharedPrefHelper.getUserData();
      final token = await SharedPrefHelper.getToken();

      // Partner DSA Code extract
      String dsaCode = userData['dsaCode'] ?? '';
      if (dsaCode.isEmpty) {
        final phone = userData['phone'] ?? '1234';
        dsaCode = 'MFP${phone.length >= 4 ? phone.substring(phone.length - 4) : phone}';
      }

      if (token == null) {
        _loadFallbackData();
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
        List<PartnerLeadModel> fetched = [];

        final dateFormat = DateFormat('dd MMM yyyy');
        final timeFormat = DateFormat('hh:mm a');

        for (var item in loans) {
          final statusStr = (item['status'] ?? 'Pending').toString();
          final amount = double.tryParse(item['loanAmount'].toString()) ?? 0.0;

          // Status Counting
          if (statusStr.toLowerCase() == 'approved' || statusStr.toLowerCase() == 'disbursed') {
            approved++;
          } else if (statusStr.toLowerCase() == 'rejected') {
            rejected++;
          } else {
            pending++;
          }

          // Customer details extract
          String custName = 'Customer';
          String custPhone = '';
          String custEmail = '';
          String custCity = item['city'] ?? 'India';

          if (item['customer'] is Map) {
            custName = item['customer']['name'] ?? 'Customer';
            custPhone = item['customer']['phone'] ?? '';
            custEmail = item['customer']['email'] ?? '';
          }

          DateTime createdDate = DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now();
          final loanType = (item['loanType'] ?? 'Personal Loan').toString();

          PartnerLeadStatus leadStatus;
          if (statusStr.toLowerCase() == 'approved' || statusStr.toLowerCase() == 'disbursed') {
            leadStatus = PartnerLeadStatus.approved;
          } else if (statusStr.toLowerCase() == 'rejected') {
            leadStatus = PartnerLeadStatus.rejected;
          } else if (statusStr.toLowerCase() == 'under review') {
            leadStatus = PartnerLeadStatus.underReview;
          } else {
            leadStatus = PartnerLeadStatus.pending;
          }

          fetched.add(
            PartnerLeadModel(
              id: item['_id']?.toString() ?? '',
              customerName: custName,
              customerId: item['customer'] is Map ? (item['customer']['_id']?.toString() ?? '') : '',
              phone: custPhone,
              email: custEmail,
              city: custCity,
              loanCategory: loanType,
              amount: amount,
              tenure: '${item['tenureMonths'] ?? 12} Months',
              date: dateFormat.format(createdDate),
              time: timeFormat.format(createdDate),
              status: leadStatus,
              icon: _getCategoryIcon(loanType),
              iconColor: _getCategoryColor(loanType),
              isExistingCustomer: item['isExistingCustomer'] ?? false,
            ),
          );
        }

        if (mounted) {
          setState(() {
            _allLeads = fetched;
            _totalCount = fetched.length;
            _pendingCount = pending;
            _approvedCount = approved;
            _rejectedCount = rejected;
            _isLoading = false;
          });
        }
      } else {
        _loadFallbackData();
      }
    } catch (e) {
      _loadFallbackData();
    }
  }

  void _loadFallbackData() {
    if (!mounted) return;
    setState(() {
      _allLeads = PartnerLeadModel.sampleLeads;
      _totalCount = PartnerLeadModel.sampleLeads.length;
      _pendingCount = 2;
      _approvedCount = 1;
      _rejectedCount = 1;
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
      case 'education loan':
        return const Color(0xFF0284C7);
      case 'gold loan':
        return const Color(0xFF16A36A);
      default:
        return AppColors.secondary;
    }
  }

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
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddNewLeadScreen()),
                          );
                          if (result == true) {
                            _fetchLeads();
                          }
                        },
                        icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                        label: const Text(
                          'Add New Lead',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3E38),
                          elevation: 0,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 4 Compact Dynamic Metric Badges Strip
                  _buildMetricBadgesStrip(),
                  const SizedBox(height: 12),

                  // Filter Chips
                  _buildFilterChipsRow(),
                  const SizedBox(height: 12),

                  // Search Bar
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
                        hintText: 'Search by name, mobile or loan type...',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.iconSecondary),
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

            // Scrollable Leads List with Pull-to-Refresh
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              )
                  : RefreshIndicator(
                color: AppColors.secondary,
                onRefresh: _fetchLeads,
                child: leads.isEmpty
                    ? Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.iconSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No leads found for selected criteria',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: leads.length,
                  itemBuilder: (context, index) {
                    final lead = leads[index];
                    return _buildLeadItemCard(context, lead);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBadgesStrip() {
    final metrics = [
      {
        'val': '$_totalCount',
        'label': 'Total Leads',
        'key': 'All',
        'icon': Icons.groups_rounded,
        'color': const Color(0xFF0284C7),
        'bg': const Color(0xFFEFF6FF)
      },
      {
        'val': '$_pendingCount',
        'label': 'Pending',
        'key': 'Pending',
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7)
      },
      {
        'val': '$_approvedCount',
        'label': 'Approved',
        'key': 'Approved',
        'icon': Icons.check_circle_rounded,
        'color': AppColors.secondary,
        'bg': const Color(0xFFDCFCE7)
      },
      {
        'val': '$_rejectedCount',
        'label': 'Rejected',
        'key': 'Rejected',
        'icon': Icons.cancel_rounded,
        'color': const Color(0xFFDC2626),
        'bg': const Color(0xFFFEE2E2)
      },
    ];

    return Row(
      children: metrics.map((m) {
        final Color col = m['color'] as Color;
        final Color bg = m['bg'] as Color;
        final String filterKey = m['key'] as String;
        final isSelected = _selectedFilter == filterKey;

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
                      if (lead.email.isNotEmpty) ...[
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