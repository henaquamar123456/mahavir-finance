
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LoanProductCard extends StatelessWidget {
  const LoanProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.interestRate,
    this.loanAmount,
    this.onTap,
    this.iconColor = AppColors.secondary,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? interestRate;
  final String? loanAmount;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 27,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.iconSecondary,
                  ),
                ],
              ),
              if (interestRate != null || loanAmount != null) ...[
                const SizedBox(height: 16),
                const Divider(
                  height: 1,
                  color: AppColors.divider,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (loanAmount != null)
                      Expanded(
                        child: _LoanInfo(
                          label: 'Loan Amount',
                          value: loanAmount!,
                        ),
                      ),
                    if (interestRate != null)
                      Expanded(
                        child: _LoanInfo(
                          label: 'Interest Rate',
                          value: interestRate!,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LoanInfo extends StatelessWidget {
  const _LoanInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
