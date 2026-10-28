import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../screens/customer-section/providers/inquiry_provider.dart';
import '../utils/date_formatter.dart';

class FilterInquiryBottomSheet extends StatelessWidget {
  const FilterInquiryBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterInquiryBottomSheet(),
    );
  }

  static const List<Map<String, dynamic>> loanTypes = [
    {'title': 'Personal Loan', 'icon': Icons.person_outline_rounded},
    {'title': 'Home Loan', 'icon': Icons.home_outlined},
    {'title': 'Car Loan', 'icon': Icons.directions_car_outlined},
    {'title': 'Business Loan', 'icon': Icons.business_center_outlined},
    {'title': 'Education Loan', 'icon': Icons.school_outlined},
    {'title': 'Gold Loan', 'icon': Icons.monetization_on_outlined},
    {'title': 'Loan Against Property', 'icon': Icons.apartment_outlined},
    {'title': 'Credit Card Loan', 'icon': Icons.credit_card_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InquiryProvider>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Inquiries',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'All',
                      'Pending',
                      'Under Review',
                      'Approved',
                      'Rejected',
                    ].map((status) {
                      final isSelected = provider.filterSheetStatus == status;
                      return ChoiceChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (_) => provider.setFilterSheetStatus(status),
                        selectedColor: AppColors.secondary,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.secondary : AppColors.border,
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Loan Type',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  ...loanTypes.map((type) {
                    final title = type['title'] as String;
                    final icon = type['icon'] as IconData;
                    final isSelected = provider.selectedLoanType == title;

                    return InkWell(
                      onTap: () {
                        provider.setSelectedLoanType(isSelected ? null : title);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(icon, size: 20, color: AppColors.iconSecondary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.secondary : AppColors.border,
                                  width: isSelected ? 6 : 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text(
                    'Date Range',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateBox(
                          context: context,
                          label: 'From Date',
                          date: provider.fromDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: provider.fromDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              provider.setDateRange(picked, provider.toDate);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateBox(
                          context: context,
                          label: 'To Date',
                          date: provider.toDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: provider.toDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              provider.setDateRange(provider.fromDate, picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => provider.resetFilters(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size(100, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.applyFilterSheet();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Apply Filter',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBox({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.iconSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(
                    date != null ? DateFormatter.formatShortDate(date) : 'Select date',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: date != null ? AppColors.textPrimary : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}