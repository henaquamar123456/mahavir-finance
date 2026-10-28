import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../utils/currency_formatter.dart';
import 'emi_calculator_provider.dart';
import 'emi_estimate_screen.dart';

class EmiCalculatorScreen extends StatelessWidget {
  const EmiCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmiCalculatorProvider(),
      child: const _EmiCalculatorView(),
    );
  }
}

class _EmiCalculatorView extends StatefulWidget {
  const _EmiCalculatorView();

  @override
  State<_EmiCalculatorView> createState() => _EmiCalculatorViewState();
}

class _EmiCalculatorViewState extends State<_EmiCalculatorView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<EmiCalculatorProvider>();
    _amountController.text = CurrencyFormatter.formatWhole(provider.loanAmount);
    _rateController.text = provider.interestRate.toString();
    _tenureController.text = provider.tenureYears.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmiCalculatorProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMI Calculator',
                          style: AppTextStyles.headingLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Plan your loan with our easy EMI calculator and make better financial decisions.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      size: 40,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Loan Type Dropdown
              _buildSectionLabel('Select Loan Type'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.selectedLoanType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                    items: provider.loanTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.iconSecondary),
                            const SizedBox(width: 10),
                            Text(
                              type,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) provider.setLoanType(val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Loan Amount
              _buildSectionLabel('Loan Amount'),
              _buildInputField(
                controller: _amountController,
                onChanged: (val) {
                  final parsed = CurrencyFormatter.parse(val);
                  if (parsed != null && parsed >= 50000 && parsed <= 5000000) {
                    provider.setLoanAmount(parsed);
                  }
                },
              ),
              SliderTheme(
                data: _customSliderTheme,
                child: Slider(
                  value: provider.loanAmount.clamp(50000, 5000000),
                  min: 50000,
                  max: 5000000,
                  divisions: 99,
                  onChanged: (val) {
                    provider.setLoanAmount(val);
                    _amountController.text = CurrencyFormatter.formatWhole(val);
                  },
                ),
              ),
              _buildRangeLabels('₹ 50,000', '₹ 50,00,000'),

              const SizedBox(height: 16),

              // Annual Interest Rate
              _buildSectionLabel('Annual Interest Rate'),
              _buildInputField(
                controller: _rateController,
                suffixText: '%',
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null && parsed >= 5 && parsed <= 30) {
                    provider.setInterestRate(parsed);
                  }
                },
              ),
              SliderTheme(
                data: _customSliderTheme,
                child: Slider(
                  value: provider.interestRate.clamp(5.0, 30.0),
                  min: 5.0,
                  max: 30.0,
                  divisions: 50,
                  onChanged: (val) {
                    provider.setInterestRate(double.parse(val.toStringAsFixed(1)));
                    _rateController.text = val.toStringAsFixed(1);
                  },
                ),
              ),
              _buildRangeLabels('5%', '30%'),

              const SizedBox(height: 16),

              // Loan Tenure
              _buildSectionLabel('Loan Tenure'),
              _buildInputField(
                controller: _tenureController,
                suffixText: 'Years',
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed >= 1 && parsed <= 30) {
                    provider.setTenureYears(parsed);
                  }
                },
              ),
              SliderTheme(
                data: _customSliderTheme,
                child: Slider(
                  value: provider.tenureYears.toDouble().clamp(1.0, 30.0),
                  min: 1.0,
                  max: 30.0,
                  divisions: 29,
                  onChanged: (val) {
                    provider.setTenureYears(val.toInt());
                    _tenureController.text = val.toInt().toString();
                  },
                ),
              ),
              _buildRangeLabels('6 Months', '30 Years'),

              const SizedBox(height: 24),

              // Calculate EMI Button (Passes provider cleanly to EmiEstimateScreen)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    provider.calculateEmi();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: provider,
                          child: const EmiEstimateScreen(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Calculate EMI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? suffixText,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
          if (suffixText != null)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                suffixText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRangeLabels(String min, String max) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(min, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(max, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  SliderThemeData get _customSliderTheme => SliderThemeData(
    activeTrackColor: AppColors.secondary,
    inactiveTrackColor: AppColors.border,
    thumbColor: Colors.white,
    overlayColor: AppColors.secondary.withValues(alpha: 0.15),
    trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(
      enabledThumbRadius: 9,
      elevation: 2,
    ),
  );
}