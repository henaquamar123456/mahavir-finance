import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
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
  String? _selectedTenure;
  int _currentStep = 1;

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

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a loan category')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proceeding to Step 2: Loan Details...'),
        backgroundColor: Color(0xFF0F3E38),
      ),
    );
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
            onPressed: () {},
          ),
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
                // Title and Top Right Illustration Header
                _buildHeaderSection(),
                const SizedBox(height: 18),

                // 4-Step Stepper Header
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

                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3E38),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6),
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
        selectedIndex: 1, // Add Lead tab active
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
          } else if (index == 3) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (_) => const PartnerProfileScreen()),
            // );
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
                'Fill in the customer details to create a new loan lead.',
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
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.assignment_add,
            color: Color(0xFF0284C7),
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    final steps = [
      {'num': '1', 'title': 'Customer\nDetails'},
      {'num': '2', 'title': 'Loan\nDetails'},
      {'num': '3', 'title': 'Documents\n(Optional)'},
      {'num': '4', 'title': 'Review &\nSubmit'},
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
                    color: stepNum < _currentStep ? const Color(0xFF16A36A) : const Color(0xFFE2E8F0),
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
            label: 'Residential Address',
            hint: 'Enter complete address (optional)',
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
          children: [
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _fieldDecoration(
                  label: 'Requested Loan Amount *',
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
                  icon: Icons.bar_chart_rounded,
                ),
                items: _tenureOptions
                    .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12.5))))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTenure = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          decoration: _fieldDecoration(
            label: 'Additional Notes',
            hint: 'Enter any additional information (optional)',
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