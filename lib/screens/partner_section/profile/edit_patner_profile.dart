import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../core/servicess/shared_pref_helper.dart';

class EditPartnerProfileScreen extends StatefulWidget {
  const EditPartnerProfileScreen({super.key});

  @override
  State<EditPartnerProfileScreen> createState() => _EditPartnerProfileScreenState();
}

class _EditPartnerProfileScreenState extends State<EditPartnerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Information Controllers
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController(text: '12 Jan 1995');
  final _emailController = TextEditingController();
  final _altMobileController = TextEditingController();
  String _selectedGender = 'Male';
  final _currentAddressController = TextEditingController();

  // Business Information Controllers
  final _businessNameController = TextEditingController(text: 'RK Associates');
  String _selectedBusinessType = 'DSA Agent';
  final _gstController = TextEditingController();
  final _experienceController = TextEditingController(text: '3 Years');
  final _areaOfOperationController = TextEditingController(text: 'Gujarat, India');
  final _businessAddressController = TextEditingController();

  // Bank Details Controllers
  final _accountHolderController = TextEditingController();
  final _bankNameController = TextEditingController(text: 'HDFC Bank');
  final _accountNumberController = TextEditingController(text: '501023456789');
  final _ifscController = TextEditingController(text: 'HDFC0001234');
  final _upiIdController = TextEditingController(text: 'partner@okhdfcbank');
  String _selectedPayoutFrequency = 'Monthly';

  bool _isSaving = false;
  bool _isLoadingInitial = true;

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
  void initState() {
    super.initState();
    _loadInitialUserData();
  }

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

  Future<void> _loadInitialUserData() async {
    try {
      final userData = await SharedPrefHelper.getUserData();
      if (mounted) {
        setState(() {
          _fullNameController.text = userData['name'] ?? '';
          _mobileController.text = userData['phone'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _currentAddressController.text = userData['city'] ?? '';
          _businessAddressController.text = userData['city'] ?? '';
          _accountHolderController.text = userData['name'] ?? '';
          _isLoadingInitial = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingInitial = false);
    }
  }

  Future<void> _handleUpdateProfile() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedName = _fullNameController.text.trim();
    final updatedEmail = _emailController.text.trim().toLowerCase();
    final updatedCity = _currentAddressController.text.trim();

    try {
      final token = await SharedPrefHelper.getToken();

      if (token != null) {
        final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/auth/update-details'));
        await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'name': updatedName,
            'email': updatedEmail,
            'city': updatedCity,
          }),
        ).timeout(const Duration(seconds: 12));
      }

      // Update Local Session Cache
      final currentData = await SharedPrefHelper.getUserData();
      currentData['name'] = updatedName;
      currentData['email'] = updatedEmail;
      currentData['city'] = updatedCity;
      // await SharedPrefHelper.saveUserData(currentData);

      // Purani line:
// await SharedPrefHelper.saveUserData(currentData);

// Nayi line:
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(currentData));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile information updated successfully!'),
          backgroundColor: Color(0xFF16A36A),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
      ),
      body: SafeArea(
        child: _isLoadingInitial
            ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  'Update your personal, business and payout details.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // 1. Profile Avatar Card
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

                // Update CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleUpdateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3E38),
                      disabledBackgroundColor: AppColors.buttonDisabled,
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
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
            child: const Icon(Icons.person, size: 30, color: Color(0xFF0F3E38)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Avatar',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                SizedBox(height: 2),
                Text('Assigned Channel Partner Profile', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                readOnly: true, // Phone is primary login identifier
                decoration: _inputDecoration(
                  label: 'Registered Phone',
                  hint: 'Mobile Number',
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
                decoration: _inputDecoration(label: 'Email Address *', hint: 'email@example.com'),
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
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: _inputDecoration(label: 'City / Address *', hint: 'Enter city or region'),
        ),
      ],
    );
  }

  Widget _buildBusinessInfoFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _businessNameController,
                decoration: _inputDecoration(label: 'Agency / Business Name', hint: 'Enter agency name'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedBusinessType,
                decoration: _inputDecoration(label: 'Partner Role', hint: 'Select role'),
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
        TextFormField(
          controller: _areaOfOperationController,
          decoration: _inputDecoration(label: 'Area of Operation', hint: 'e.g. Ahmedabad, Surat'),
        ),
      ],
    );
  }

  Widget _buildBankDetailsFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _accountHolderController,
                decoration: _inputDecoration(label: 'Beneficiary Name', hint: 'Account Holder Name'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _bankNameController,
                decoration: _inputDecoration(label: 'Bank Name', hint: 'e.g. HDFC Bank'),
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
                decoration: _inputDecoration(label: 'Account Number', hint: 'Bank Account No'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _ifscController,
                textCapitalization: TextCapitalization.characters,
                decoration: _inputDecoration(label: 'IFSC Code', hint: 'HDFC0001234'),
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
                decoration: _inputDecoration(label: 'UPI ID for Payout', hint: 'partner@upi'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedPayoutFrequency,
                decoration: _inputDecoration(label: 'Payout Cycle', hint: 'Select'),
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