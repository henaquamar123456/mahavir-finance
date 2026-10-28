import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../utils/currency_formatter.dart';
import '../../../widgets/emi_donut_chart.dart';
import 'emi_calculator_provider.dart';

class PaymentBreakdownScreen extends StatelessWidget {
  const PaymentBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmiCalculatorProvider>();
    final result = provider.result;

    if (result == null) {
      return const Scaffold(body: Center(child: Text('No data found')));
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
          'Payment Breakdown',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Breakdown',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'See how your EMI is split between principal and interest over the tenure.',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 20),

              // 1. Donut Chart + Legend Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    // Donut Chart
                    EmiDonutChart(
                      principalPercentage: result.principalPercentage,
                      interestPercentage: result.interestPercentage,
                      totalPayable: result.totalPayable,
                    ),

                    const SizedBox(width: 16),

                    // Legend Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                            color: AppColors.secondary,
                            title: 'Principal Amount',
                            amount: CurrencyFormatter.formatWhole(result.loanAmount),
                            percentage: '${result.principalPercentage.toStringAsFixed(1)}%',
                          ),
                          const SizedBox(height: 16),
                          _buildLegendItem(
                            color: AppColors.primary,
                            title: 'Total Interest',
                            amount: CurrencyFormatter.formatWhole(result.totalInterest),
                            percentage: '${result.interestPercentage.toStringAsFixed(1)}%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Year-wise Breakdown Header
              const Text(
                'Year-wise Breakdown (Approx.)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Year-wise Breakdown Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      color: const Color(0xFFF1F5F9),
                      child: const Row(
                        children: [
                          SizedBox(width: 36, child: Text('Year', style: _headerStyle)),
                          Expanded(child: Text('Principal (₹)', textAlign: TextAlign.right, style: _headerStyle)),
                          Expanded(child: Text('Interest (₹)', textAlign: TextAlign.right, style: _headerStyle)),
                          Expanded(child: Text('Outstanding (₹)', textAlign: TextAlign.right, style: _headerStyle)),
                        ],
                      ),
                    ),

                    // Table Rows
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: result.yearlyBreakdown.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
                      itemBuilder: (context, index) {
                        final item = result.yearlyBreakdown[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 36,
                                child: Text(
                                  '${item.year}',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  CurrencyFormatter.formatWhole(item.principalPaid).replaceAll('₹', ''),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  CurrencyFormatter.formatWhole(item.interestPaid).replaceAll('₹', ''),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.outstandingBalance == 0
                                      ? '0'
                                      : CurrencyFormatter.formatWhole(item.outstandingBalance).replaceAll('₹', ''),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4. Information Banner (Blue note)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This is an estimated EMI calculation for your reference only. Final loan amount, interest rate, tenure and other terms will be as per the lender\'s policy and verification.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF1E40AF),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String title,
    required String amount,
    required String percentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($percentage)',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );
}