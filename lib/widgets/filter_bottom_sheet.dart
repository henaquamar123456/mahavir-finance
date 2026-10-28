import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme/app_dimensions.dart';
import '../../constants/theme/app_text_styles.dart';
import '../../utils/currency_formatter.dart';
import '../screens/customer-section/loans/loans_provider.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  static const List<Map<String, dynamic>> loanTypes = [
    {'title': 'Personal Loan', 'icon': Icons.person_outline_rounded},
    {'title': 'Business Loan', 'icon': Icons.business_center_outlined},
    {'title': 'Car Loan', 'icon': Icons.directions_car_outlined},
    {'title': 'Credit Card Loan', 'icon': Icons.credit_card_outlined},
    {'title': 'Education Loan', 'icon': Icons.school_outlined},
    {'title': 'Gold Loan', 'icon': Icons.monetization_on_outlined},
    {'title': 'Home Loan', 'icon': Icons.home_outlined},
    {'title': 'Loan Against Property', 'icon': Icons.apartment_outlined},
  ];

  static const List<String> tenures = [
    'All',
    '1-3 Years',
    '3-5 Years',
    '5+ Years',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoansProvider>();

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
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header: Title & Close Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Loans',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
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

          // Scrollable Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Loan Type Section
                  Text(
                    'Loan Type',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loanTypes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.7,
                    ),
                    itemBuilder: (context, index) {
                      final item = loanTypes[index];
                      final title = item['title'] as String;
                      final icon = item['icon'] as IconData;
                      final isSelected = provider.selectedTypes.contains(title);

                      return InkWell(
                        onTap: () => provider.toggleLoanType(title),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondary.withValues(alpha: 0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                size: 20,
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.iconSecondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.secondary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 2. Loan Amount Range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Loan Amount',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${CurrencyFormatter.formatWhole(provider.amountRange.start)}  —  ${CurrencyFormatter.formatWhole(provider.amountRange.end)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RangeSlider(
                    values: provider.amountRange,
                    min: 50000,
                    max: 50000000,
                    divisions: 100,
                    activeColor: AppColors.secondary,
                    inactiveColor: AppColors.border,
                    onChanged: (values) => provider.setAmountRange(values),
                  ),

                  const SizedBox(height: 20),

                  // 3. Interest Rate Range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Interest Rate (Approx.)',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${provider.interestRange.start.toInt()}%  —  ${provider.interestRange.end.toInt()}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RangeSlider(
                    values: provider.interestRange,
                    min: 5,
                    max: 24,
                    divisions: 19,
                    activeColor: AppColors.secondary,
                    inactiveColor: AppColors.border,
                    onChanged: (values) => provider.setInterestRange(values),
                  ),

                  const SizedBox(height: 20),

                  // 4. Tenure Chips
                  Text(
                    'Tenure',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: tenures.map((tenure) {
                      final isSelected = provider.selectedTenure == tenure;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tenure),
                          selected: isSelected,
                          onSelected: (_) => provider.setSelectedTenure(tenure),
                          selectedColor: AppColors.secondary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.border,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      provider.clearFilters();
                    },
                    child: Text(
                      'Clear All',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.applyFilterSheet();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Apply Filter (${provider.filteredLoans.length})',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
}