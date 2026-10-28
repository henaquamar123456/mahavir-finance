import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../c_models/loan_product_model.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/app_empty_view.dart';
import '../../../widgets/filter_bottom_sheet.dart';
import '../../../widgets/loan_grid_card.dart';
import '../../../widgets/loan_list_card.dart';
import 'loan_details_screen.dart'; // Import added
import 'loans_provider.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoansProvider(),
      child: Consumer<LoansProvider>(
        builder: (context, provider, _) {
          final loans = provider.filteredLoans;
          final isListView = provider.isListView;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              body: SafeArea(
                top: false,
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: provider.setSearchQuery,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Search loan type...',
                                  hintStyle: TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: AppColors.iconSecondary,
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Filter Button with Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                onTap: () => FilterBottomSheet.show(context),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    color: provider.activeFiltersCount > 0
                                        ? AppColors.secondary.withValues(alpha: 0.12)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: provider.activeFiltersCount > 0
                                          ? AppColors.secondary
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.tune_rounded,
                                    color: provider.activeFiltersCount > 0
                                        ? AppColors.secondary
                                        : AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              if (provider.activeFiltersCount > 0)
                                Positioned(
                                  top: -3,
                                  right: -3,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${provider.activeFiltersCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Category Horizontal Pills (Only in Grid mode)
                      if (!isListView) ...[
                        SizedBox(
                          height: 32,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.categories.length,
                            itemBuilder: (context, index) {
                              final cat = provider.categories[index];
                              final isSelected = provider.selectedCategory == cat;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => provider.setSelectedCategory(cat),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.secondary
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.secondary
                                            : AppColors.border,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Main Body
                      Expanded(
                        child: loans.isEmpty
                            ? Center(
                          child: AppEmptyView(
                            title: 'No Loans Found',
                            message:
                            'Try adjusting your search query or filter parameters.',
                            actionText: 'Reset Filters',
                            onAction: () {
                              _searchController.clear();
                              provider.clearFilters();
                            },
                          ),
                        )
                            : isListView
                            ? ListView.builder(
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: loans.length,
                          itemBuilder: (context, index) {
                            final loan = loans[index];
                            return LoanListCard(
                              loan: loan,
                              onTap: () => _openLoanDetails(loan),
                            );
                          },
                        )
                            : LayoutBuilder(
                          builder: (context, constraints) {
                            const int crossAxisCount = 2;
                            const double spacing = 8;
                            const int fixedRows = 4;

                            final double availableWidth = constraints.maxWidth;
                            final double availableHeight = constraints.maxHeight;

                            final double cardWidth = (availableWidth - spacing) / crossAxisCount;
                            final double cardHeight = (availableHeight - ((fixedRows - 1) * spacing)) / fixedRows;

                            final double dynamicAspectRatio = cardWidth / (cardHeight > 0 ? cardHeight : 1);

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: loans.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                childAspectRatio: dynamicAspectRatio > 0 ? dynamicAspectRatio : 1.2,
                              ),
                              itemBuilder: (context, index) {
                                final loan = loans[index];
                                return LoanGridCard(
                                  loan: loan,
                                  onTap: () => _openLoanDetails(loan),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Navigation implemented
  void _openLoanDetails(LoanProductModel loan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoanDetailsScreen(loan: loan),
      ),
    );
  }
}