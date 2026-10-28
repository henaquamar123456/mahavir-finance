import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../utils/currency_formatter.dart';
import '../loans/apply_loan_screen.dart';
import '../loans/loan_inquiry_provider.dart';
import 'emi_calculator_provider.dart';
import 'payment_breakdown_screen.dart';

class EmiEstimateScreen extends StatelessWidget {
  const EmiEstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmiCalculatorProvider>();
    final result = provider.result;

    if (result == null) {
      return const Scaffold(
        body: Center(child: Text('No calculation data')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'EMI Estimate',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Greeting Card
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.secondary,
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Here's your\nEMI Estimate",
                          style: AppTextStyles.headingMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            height: 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Based on the details you provided.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Big Monthly EMI Highlight Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly EMI',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatWhole(result.monthlyEmi),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 3. Total Interest & Total Payable 2-Column Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard(
                      icon: Icons.monetization_on_outlined,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFD97706),
                      label: 'Total Interest',
                      value: CurrencyFormatter.formatWhole(result.totalInterest),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconBg: const Color(0xFFDCFCE7),
                      iconColor: AppColors.secondary,
                      label: 'Total Payable',
                      value: CurrencyFormatter.formatWhole(result.totalPayable),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 4. Loan Summary Section Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Loan Summary',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        // View Breakdown Link
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: provider,
                                  child: const PaymentBreakdownScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'View Breakdown >',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 10),

                    _buildSummaryRow(
                      icon: Icons.assignment_outlined,
                      title: 'Loan Amount',
                      value: CurrencyFormatter.formatWhole(result.loanAmount),
                    ),
                    _buildSummaryRow(
                      icon: Icons.percent_rounded,
                      title: 'Annual Interest Rate',
                      value: '${result.interestRate}%',
                    ),
                    _buildSummaryRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Loan Tenure',
                      value:
                      '${result.tenureYears} Years (${result.tenureYears * 12} months)',
                    ),
                    _buildSummaryRow(
                      icon: Icons.receipt_outlined,
                      title: 'Monthly EMI',
                      value: CurrencyFormatter.formatWhole(result.monthlyEmi),
                    ),
                    _buildSummaryRow(
                      icon: Icons.savings_outlined,
                      title: 'Total Interest',
                      value: CurrencyFormatter.formatWhole(result.totalInterest),
                    ),
                    _buildSummaryRow(
                      icon: Icons.account_balance_outlined,
                      title: 'Total Payable Amount',
                      value: CurrencyFormatter.formatWhole(result.totalPayable),
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. Action Buttons: Reset & Apply for Loan
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      provider.reset();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      minimumSize: const Size(105, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final tenureStr =
                              '${result.tenureYears} Years (${result.tenureYears * 12} months)';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) {
                                  final p = LoanInquiryProvider(
                                    initialCategory: provider.selectedLoanType,
                                  );
                                  p.setLoanAmount(result.loanAmount);
                                  p.setPreferredTenure(tenureStr);
                                  return p;
                                },
                                child: ApplyLoanScreen(
                                  initialCategory: provider.selectedLoanType,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Apply for Loan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
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
          Container(
            width: 32,
            height: 32,
            decoration:
            BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label,
              style:
              const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String title,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.iconSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}