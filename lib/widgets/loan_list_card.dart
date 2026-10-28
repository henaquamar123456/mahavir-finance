import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme/app_dimensions.dart';
import '../../constants/theme/app_text_styles.dart';
import '../c_models/loan_product_model.dart';

class LoanListCard extends StatelessWidget {
  final LoanProductModel loan;
  final VoidCallback onTap;

  const LoanListCard({
    super.key,
    required this.loan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Icon, Title, Description, Arrow
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: loan.iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        loan.icon,
                        color: loan.iconColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loan.title,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loan.detailedDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.iconSecondary,
                      size: 22,
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 12),

                // Bottom stats row: Amount | Interest Rate | Tenure
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        label: 'Amount',
                        value: loan.amountDisplay,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildStatItem(
                          label: 'Interest Rate',
                          value: loan.interestRateDisplay,
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        label: 'Tenure',
                        value: loan.tenureDisplay,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}