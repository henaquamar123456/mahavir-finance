import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/date_formatter.dart';
import 'inquiry_success_screen.dart';
import 'loan_inquiry_provider.dart';

class ApplyLoanScreen extends StatefulWidget {
  final String? initialCategory;

  const ApplyLoanScreen({super.key, this.initialCategory});

  @override
  State<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _incomeController;
  late TextEditingController _companyController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final p = context.read<LoanInquiryProvider>();

    // Initial controllers setup without calling notifyListeners
    _nameController = TextEditingController(text: p.fullName);
    _mobileController = TextEditingController(text: p.mobileNumber);
    _emailController = TextEditingController(text: p.email);
    _incomeController =
        TextEditingController(text: p.monthlyIncome.toInt().toString());
    _companyController = TextEditingController(text: p.companyName);
    _cityController = TextEditingController(text: p.city);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _incomeController.dispose();
    _companyController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoanInquiryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () {
            if (provider.currentStep > 0) {
              provider.previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Loan Inquiry',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Stepper Header (1 -> 2 -> 3)
            _buildStepperHeader(provider.currentStep),

            // Form Page Body
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us your requirements and our team will get back to you with the best offers.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (provider.currentStep == 0) _buildStepOne(provider),
                    if (provider.currentStep == 1) _buildStepTwo(provider),
                    if (provider.currentStep == 2) _buildStepThree(provider),
                  ],
                ),
              ),
            ),

            // Bottom Buttons Bar
            _buildBottomActionBar(provider),
          ],
        ),
      ),
    );
  }

  // 1. Stepper Header (Fixed syntax error)
  Widget _buildStepperHeader(int currentStep) {
    final steps = ['Loan Details', 'Personal Details', 'Review & Submit'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final isPassed = currentStep > stepIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: isPassed ? AppColors.secondary : AppColors.border,
              ),
            );
          } else {
            final stepIndex = index ~/ 2;
            final isCompleted = currentStep > stepIndex;
            final isCurrent = currentStep == stepIndex;

            return Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent
                        ? AppColors.secondary
                        : Colors.white,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? AppColors.secondary
                          : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isCurrent
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  steps[stepIndex],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color:
                    isCurrent ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  // STEP 1: Loan Details
  Widget _buildStepOne(LoanInquiryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Loan Information'),
        const SizedBox(height: 12),
        _buildFieldLabel('Select Loan Category*'),
        _buildDropdown(
          value: provider.selectedCategory,
          items: provider.categories,
          onChanged: (val) {
            if (val != null) provider.setCategory(val);
          },
        ),
        const SizedBox(height: 16),
        _buildFieldLabel('Required Loan Amount*'),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            CurrencyFormatter.formatWhole(provider.loanAmount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        SliderTheme(
          data: _sliderTheme,
          child: Slider(
            value: provider.loanAmount.clamp(50000, 5000000),
            min: 50000,
            max: 5000000,
            divisions: 99,
            onChanged: (val) => provider.setLoanAmount(val),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₹ 50,000',
                style:
                TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text('₹ 50,00,000',
                style:
                TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 16),
        _buildFieldLabel('Purpose of Loan*'),
        _buildDropdown(
          value: provider.loanPurpose,
          items: provider.purposes,
          onChanged: (val) {
            if (val != null) provider.setLoanPurpose(val);
          },
        ),
        const SizedBox(height: 16),
        _buildFieldLabel('Preferred Tenure'),
        _buildDropdown(
          value: provider.preferredTenure,
          items: provider.tenures,
          onChanged: (val) {
            if (val != null) provider.setPreferredTenure(val);
          },
        ),
        const SizedBox(height: 20),
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
              Icon(Icons.info_outline_rounded,
                  color: Color(0xFF2563EB), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This is a loan inquiry. Final loan amount, interest rate and tenure will be as per the lender\'s policy and verification.',
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
      ],
    );
  }

  // STEP 2: Personal & Employment Details
  Widget _buildStepTwo(LoanInquiryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Personal Details'),
        const SizedBox(height: 12),
        _buildFieldLabel('Full Name*'),
        _buildTextField(
            controller: _nameController, hint: 'Enter your full name'),
        const SizedBox(height: 14),
        _buildFieldLabel('Mobile Number*'),
        _buildTextField(
          controller: _mobileController,
          hint: 'Enter 10-digit mobile number',
          keyboardType: TextInputType.phone,
          prefixText: '+91  ',
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Email Address*'),
        _buildTextField(
          controller: _emailController,
          hint: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Date of Birth*'),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: provider.dob,
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              provider.updatePersonalDetails(
                name: _nameController.text,
                mobile: _mobileController.text,
                email: _emailController.text,
                dob: picked,
              );
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.formatDate(provider.dob),
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppColors.iconSecondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        _buildSectionTitle('Employment & Income Details'),
        const SizedBox(height: 12),
        _buildFieldLabel('Employment Type*'),
        _buildDropdown(
          value: provider.employmentType,
          items: provider.employmentTypes,
          onChanged: (val) {
            if (val != null) {
              provider.updateEmploymentDetails(
                empType: val,
                income: double.tryParse(_incomeController.text) ?? 50000,
                company: _companyController.text,
                city: _cityController.text,
              );
            }
          },
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Monthly Income (₹)*'),
        _buildTextField(
          controller: _incomeController,
          hint: 'e.g. 50000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Company Name*'),
        _buildTextField(
            controller: _companyController,
            hint: 'Enter company or business name'),
        const SizedBox(height: 14),
        _buildFieldLabel('City*'),
        _buildTextField(
            controller: _cityController, hint: 'e.g. Noida, Uttar Pradesh'),
      ],
    );
  }

  // STEP 3: Review & Submit
  Widget _buildStepThree(LoanInquiryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Review Your Details'),
        const SizedBox(height: 4),
        const Text(
          'Please review your information before submitting',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          title: 'Loan Details',
          onEdit: () => provider.setCurrentStep(0),
          items: [
            {'label': 'Category', 'val': provider.selectedCategory},
            {
              'label': 'Loan Amount',
              'val': CurrencyFormatter.formatWhole(provider.loanAmount)
            },
            {'label': 'Purpose', 'val': provider.loanPurpose},
            {'label': 'Preferred Tenure', 'val': provider.preferredTenure},
          ],
        ),
        const SizedBox(height: 14),
        _buildReviewCard(
          title: 'Personal Details',
          onEdit: () => provider.setCurrentStep(1),
          items: [
            {'label': 'Full Name', 'val': provider.fullName},
            {'label': 'Mobile Number', 'val': '+91 ${provider.mobileNumber}'},
            {'label': 'Email Address', 'val': provider.email},
            {
              'label': 'Date of Birth',
              'val': DateFormatter.formatDate(provider.dob)
            },
          ],
        ),
        const SizedBox(height: 14),
        _buildReviewCard(
          title: 'Employment Details',
          onEdit: () => provider.setCurrentStep(1),
          items: [
            {'label': 'Employment Type', 'val': provider.employmentType},
            {
              'label': 'Monthly Income',
              'val': CurrencyFormatter.formatWhole(provider.monthlyIncome)
            },
            {'label': 'Company Name', 'val': provider.companyName},
            {'label': 'City', 'val': provider.city},
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: provider.agreedToTerms,
                activeColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onChanged: (val) => provider.toggleTermsAgreement(val ?? false),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'I agree to be contacted by Mahavir Finance and its lending partners for loan offers. I confirm that the information provided is correct.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Bottom Buttons: Back & Next/Submit
  Widget _buildBottomActionBar(LoanInquiryProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          if (provider.currentStep > 0) ...[
            OutlinedButton(
              onPressed: () => provider.previousStep(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                minimumSize: const Size(90, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (provider.currentStep == 1) {
                    provider.updatePersonalDetails(
                      name: _nameController.text,
                      mobile: _mobileController.text,
                      email: _emailController.text,
                      dob: provider.dob,
                    );
                    provider.updateEmploymentDetails(
                      empType: provider.employmentType,
                      income: double.tryParse(_incomeController.text) ?? 50000,
                      company: _companyController.text,
                      city: _cityController.text,
                    );
                  }

                  if (provider.currentStep < 2) {
                    provider.nextStep();
                  } else {
                    if (!provider.agreedToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Please accept terms and conditions')),
                      );
                      return;
                    }
                    provider.submitInquiry();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const InquirySuccessScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.currentStep == 2 ? 'Submit Inquiry' : 'Next',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          if (prefixText != null)
            Text(
              prefixText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style:
              const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                const TextStyle(fontSize: 13, color: AppColors.textHint),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required VoidCallback onEdit,
    required List<Map<String, String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary),
              ),
              InkWell(
                onTap: onEdit,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          ...items.map((it) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(it['label']!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  Text(it['val']!,
                      style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  SliderThemeData get _sliderTheme => SliderThemeData(
    activeTrackColor: AppColors.secondary,
    inactiveTrackColor: AppColors.border,
    thumbColor: Colors.white,
    trackHeight: 4,
    thumbShape:
    const RoundSliderThumbShape(enabledThumbRadius: 9, elevation: 2),
  );
}