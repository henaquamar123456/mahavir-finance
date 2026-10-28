import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';

class EditPartnerProfileScreen extends StatefulWidget {
  const EditPartnerProfileScreen({super.key});

  @override
  State<EditPartnerProfileScreen> createState() => _EditPartnerProfileScreenState();
}

class _EditPartnerProfileScreenState extends State<EditPartnerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Information Controllers
  final _fullNameController = TextEditingController(text: 'Rohan Kumar');
  final _mobileController = TextEditingController(text: '9876543210');
  final _dobController = TextEditingController(text: '12 Jan 1995');
  final _emailController = TextEditingController(text: 'rohan.kumar@gmail.com');
  final _altMobileController = TextEditingController(text: '9123456789');
  String _selectedGender = 'Male';
  final _currentAddressController = TextEditingController(
    text: 'B-203, Sector 62, Noida, Uttar Pradesh - 201309',
  );

  // Business Information Controllers
  final _businessNameController = TextEditingController(text: 'RK Associates');
  String _selectedBusinessType = 'DSA Agent';
  final _gstController = TextEditingController(text: '27ABCDE1234F1Z5');
  final _experienceController = TextEditingController(text: '3 Years');
  final _areaOfOperationController = TextEditingController(text: 'Noida, Delhi, Ghaziabad');
  final _businessAddressController = TextEditingController(
    text: 'Office No. 12, Sector 62\nNoida, Uttar Pradesh - 201309',
  );

  // Bank Details Controllers
  final _accountHolderController = TextEditingController(text: 'Rohan Kumar');
  final _bankNameController = TextEditingController(text: 'HDFC Bank');
  final _accountNumberController = TextEditingController(text: '501023456789');
  final _ifscController = TextEditingController(text: 'HDFC0001234');
  final _upiIdController = TextEditingController(text: 'rohan123@okhdfcbank');
  String _selectedPayoutFrequency = 'Monthly';

  bool _isSaving = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _businessTypeOptions = [
    'DSA Agent',
    'Financial Consultant',
    'Chartered Accountant',
    'Real Estate Broker',
    'Connector',
  ];
  final List<String> _payoutFrequencyOptions = ['Weekly', 'Bi-Weekly', 'Monthly'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _altMobileController.dispose();
    _currentAddressController.dispose();
    _businessNameController.dispose();
    _gstController.dispose();
    _experienceController.dispose();
    _areaOfOperationController.dispose();
    _businessAddressController.dispose();
    _accountHolderController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile information updated successfully!'),
        backgroundColor: Color(0xFF0F3E38),
      ),
    );
    Navigator.pop(context);
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
                // Header Title
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Update your personal and business information.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // 1. Change Profile Photo Card
                _buildChangePhotoCard(),
                const SizedBox(height: 16),

                // 2. Personal Information Section
                _buildSectionHeader('Personal Information'),
                const SizedBox(height: 10),
                _buildPersonalInfoFields(),
                const SizedBox(height: 18),

                // 3. Business Information Section
                _buildSectionHeader('Business Information'),
                const SizedBox(height: 10),
                _buildBusinessInfoFields(),
                const SizedBox(height: 18),

                // 4. Bank Details Section
                _buildSectionHeader('Bank Details'),
                const SizedBox(height: 10),
                _buildBankDetailsFields(),
                const SizedBox(height: 24),

                // Update Profile CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleUpdateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3E38),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Text(
                      'Update Profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Change Profile Photo Card
  Widget _buildChangePhotoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
                child: const Icon(Icons.person, size: 34, color: Color(0xFF0F3E38)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A36A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'JPG, PNG (Max 2 MB)',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Remove',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3E38),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Upload Photo',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    );
  }

  // 2. Personal Information Fields
  Widget _buildPersonalInfoFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _fullNameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _inputDecoration(label: 'Full Name *', hint: 'Enter full name'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) => (v == null || v.trim().length != 10) ? '10 digits' : null,
                decoration: _inputDecoration(
                  label: 'Mobile Number *',
                  hint: '9876543210',
                  prefixText: '+91 ',
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
                controller: _dobController,
                decoration: _inputDecoration(label: 'Date of Birth', hint: '12 Jan 1995'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
                decoration: _inputDecoration(label: 'Email Address *', hint: 'email@example.com'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _altMobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: _inputDecoration(
                  label: 'Alternate Number',
                  hint: '9123456789',
                  prefixText: '+91 ',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _inputDecoration(label: 'Gender', hint: 'Select'),
                items: _genderOptions
                    .map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedGender = val);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _currentAddressController,
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: _inputDecoration(label: 'Current Address *', hint: 'Enter current residential address'),
        ),
      ],
    );
  }

  // 3. Business Information Fields
  Widget _buildBusinessInfoFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _businessNameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _inputDecoration(label: 'Business Name *', hint: 'Enter business name'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedBusinessType,
                decoration: _inputDecoration(label: 'Business Type', hint: 'Select type'),
                items: _businessTypeOptions
                    .map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBusinessType = val);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _gstController,
                textCapitalization: TextCapitalization.characters,
                decoration: _inputDecoration(label: 'GST Number', hint: '27ABCDE1234F1Z5'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _experienceController,
                decoration: _inputDecoration(label: 'Years of Experience', hint: 'e.g. 3 Years'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _areaOfOperationController,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: _inputDecoration(label: 'Area of Operation *', hint: 'Noida, Delhi, Ghaziabad'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _businessAddressController,
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: _inputDecoration(label: 'Business Address *', hint: 'Enter complete office address'),
        ),
      ],
    );
  }

  // 4. Bank Details Fields
  Widget _buildBankDetailsFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _accountHolderController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _inputDecoration(label: 'Account Holder Name *', hint: 'Rohan Kumar'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _bankNameController,
                decoration: _inputDecoration(label: 'Bank Name', hint: 'HDFC Bank'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _inputDecoration(label: 'Account Number *', hint: '5010 2345 6789'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _ifscController,
                textCapitalization: TextCapitalization.characters,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                decoration: _inputDecoration(label: 'IFSC Code *', hint: 'HDFC0001234'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _upiIdController,
                decoration: _inputDecoration(label: 'UPI ID', hint: 'rohan123@okhdfcbank'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedPayoutFrequency,
                decoration: _inputDecoration(label: 'Payout Frequency', hint: 'Select'),
                items: _payoutFrequencyOptions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPayoutFrequency = val);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 11, color: AppColors.textHint),
      prefixText: prefixText,
      prefixStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
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
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }
}