import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../dasboard/partner_dashboard_screen.dart';
import 'my_leads_screen.dart';

class AddNewLeadScreen extends StatefulWidget {
  const AddNewLeadScreen({super.key});

  @override
  State<AddNewLeadScreen> createState() => _AddNewLeadScreenState();
}

class _AddNewLeadScreenState extends State<AddNewLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTenure = '1 Year';
  final int _currentStep = 1;
  bool _isLoading = false;

  final List<String> _loanCategories = [
    'Personal Loan',
    'Home Loan',
    'Business Loan',
    'Car Loan',
    'Education Loan',
    'Gold Loan',
    'Loan Against Property',
    'Credit Card Loan',
  ];

  final List<String> _tenureOptions = [
    '1 Year',
    '2 Years',
    '3 Years',
    '5 Years',
    '7 Years',
    '10 Years',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int _parseTenureMonths(String? tenure) {
    switch (tenure) {
      case '1 Year':
        return 12;
      case '2 Years':
        return 24;
      case '3 Years':
        return 36;
      case '5 Years':
        return 60;
      case '7 Years':
        return 84;
      case '10 Years':
        return 120;
      default:
        return 12;
    }
  }

  /// Real API Integration: POST /api/v1/loans/partner/create-lead
  Future<void> _submitLead() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a loan category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication token missing. Please re-login.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      final Map<String, dynamic> requestBody = {
        'customerName': _nameController.text.trim(),
        'customerPhone': _phoneController.text.trim(),
        'customerEmail': _emailController.text.trim().toLowerCase(),
        'loanType': _selectedCategory,
        'loanAmount': double.tryParse(_amountController.text.trim()) ?? 0,
        'tenureMonths': _parseTenureMonths(_selectedTenure),
        'employmentType': 'Salaried',
        'monthlyIncome': 25000,
        'city': _addressController.text.trim(),
        'purpose': _notesController.text.trim(),
      };

      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/loans/partner/create-lead'));
      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 201 && responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Lead submitted successfully!',
            ),
            backgroundColor: const Color(0xFF16A36A),
          ),
        );

        // Success hone par wapas Dashboard par bhejna
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Failed to submit lead. Try again.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection error: Unable to reach server (${e.toString()})'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          AssetsConstants.mahavirLogo,
          height: 30,
          errorBuilder: (_, __, ___) => const Text(
            'MAHAVIR FINANCE',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: 0.5,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
              child: const Icon(Icons.person, size: 20, color: Color(0xFF0F3E38)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 18),
                _buildStepper(),
                const SizedBox(height: 20),

                // Customer Information Section
                _buildSectionTitle(
                  icon: Icons.person_rounded,
                  iconColor: const Color(0xFF16A36A),
                  title: 'Customer Information',
                ),
                const SizedBox(height: 12),
                _buildCustomerInfoFields(),
                const SizedBox(height: 20),

                // Loan Information Section
                _buildSectionTitle(
                  icon: Icons.business_center_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Loan Information',
                ),
                const SizedBox(height: 12),
                _buildLoanInfoFields(),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitLead,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3E38),
                      disabledBackgroundColor: AppColors.buttonDisabled,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Submit Lead',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        backgroundColor: Colors.white,
        elevation: 4,
        indicatorColor: const Color(0xFFDCFCE7),
        onDestinationSelected: (index) {
          if (index == 1) return;

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PartnerDashboardScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MyLeadsScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF16A36A)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF16A36A)),
            label: 'Add Lead',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description, color: Color(0xFF16A36A)),
            label: 'My Leads',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF16A36A)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Lead',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Fill in customer details to register loan lead under your partner code.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.assignment_add,
            color: Color(0xFF0284C7),
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    final steps = [
      {'num': '1', 'title': 'Customer\nDetails'},
      {'num': '2', 'title': 'Loan\nDetails'},
      {'num': '3', 'title': 'Verification\nPending'},
      {'num': '4', 'title': 'Commission\nDisbursal'},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final stepNum = index + 1;
        final isActive = stepNum <= _currentStep;
        final isCurrent = stepNum == _currentStep;

        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isCurrent
                          ? const Color(0xFF16A36A)
                          : isActive
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFE2E8F0),
                      child: Text(
                        steps[index]['num']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isCurrent
                              ? Colors.white
                              : isActive
                              ? const Color(0xFF16A36A)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[index]['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        color: isCurrent ? const Color(0xFF16A36A) : AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Container(
                    width: 14,
                    height: 2,
                    color: stepNum < _currentStep
                        ? const Color(0xFF16A36A)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfoFields() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _fieldDecoration(
                  label: 'Full Name *',
                  hint: 'Enter customer name',
                  icon: Icons.person_outline_rounded,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) => (v == null || v.trim().length != 10) ? '10 digits' : null,
                decoration: _fieldDecoration(
                  label: 'Mobile Number *',
                  hint: 'Enter 10 digit number',
                  icon: Icons.phone_outlined,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration(
                  label: 'Email Address',
                  hint: 'Enter email (optional)',
                  icon: Icons.email_outlined,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(1995),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _dobController.text = '${date.day}/${date.month}/${date.year}';
                    });
                  }
                },
                decoration: _fieldDecoration(
                  label: 'Date of Birth',
                  hint: 'Select date (optional)',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          decoration: _fieldDecoration(
            label: 'Residential City / Address',
            hint: 'Enter city or complete address (optional)',
            icon: Icons.location_on_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildLoanInfoFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: _fieldDecoration(
            label: 'Loan Category *',
            hint: 'Select loan category',
            icon: Icons.format_list_bulleted_rounded,
          ),
          items: _loanCategories
              .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12.5))))
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _fieldDecoration(
                  label: 'Requested Amount *',
                  hint: 'Enter amount',
                  icon: Icons.currency_rupee_rounded,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedTenure,
                decoration: _fieldDecoration(
                  label: 'Loan Tenure',
                  hint: 'Select tenure',
                  icon: Icons.timelapse_rounded,
                ),
                items: _tenureOptions
                    .map(
                      (t) => DropdownMenuItem(
                    value: t,
                    child: Text(
                      t,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedTenure = val);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          decoration: _fieldDecoration(
            label: 'Additional Notes / Remarks',
            hint: 'Enter any additional remarks (optional)',
            icon: Icons.edit_note_rounded,
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 11, color: AppColors.textHint),
      prefixIcon: Icon(icon, size: 18, color: AppColors.iconSecondary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0F3E38), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
    );
  }
}