import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../utils/date_formatter.dart';
import 'profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late DateTime _selectedDob;
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileProvider>();
    _nameController = TextEditingController(text: p.fullName);
    _cityController = TextEditingController(text: p.city);
    _selectedDob = p.dob;
    _selectedGender = p.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

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
          'Edit Profile',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Profile Picture with change badge
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border, width: 2),
                                  image: const DecorationImage(
                                    image: AssetImage(AssetsConstants.profilePlaceholder),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Tap to change photo',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Personal Information Fields
                    _buildLabel('Full Name*'),
                    _buildInputField(controller: _nameController, hint: 'Enter your full name'),
                    const SizedBox(height: 14),

                    // Verified Email Box (With Change Button)
                    _buildLabel('Email Address*'),
                    _buildVerifiedField(
                      value: provider.email,
                      onTapChange: () => _showChangeEmailModal(context, provider),
                    ),
                    const SizedBox(height: 14),

                    // Verified Mobile Number (With Change Button)
                    _buildLabel('Mobile Number*'),
                    _buildVerifiedField(
                      value: '+91 ${provider.mobileNumber}',
                      onTapChange: () => _showChangeMobileModal(context, provider),
                    ),
                    const SizedBox(height: 14),

                    // Date of Birth
                    _buildLabel('Date of Birth*'),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDob,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _selectedDob = picked);
                        }
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormatter.formatDate(_selectedDob),
                              style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                            ),
                            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.iconSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Gender Selector
                    _buildLabel('Gender*'),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                          items: ['Male', 'Female', 'Other'].map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text(g, style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedGender = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // City
                    _buildLabel('City*'),
                    _buildInputField(controller: _cityController, hint: 'e.g. Noida, Uttar Pradesh'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Save Changes Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    provider.updateBasicDetails(
                      name: _nameController.text.trim(),
                      dob: _selectedDob,
                      gender: _selectedGender,
                      city: _cityController.text.trim(),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String hint}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textHint),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildVerifiedField({required String value, required VoidCallback onTapChange}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, size: 16, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ],
          ),
          InkWell(
            onTap: onTapChange,
            child: const Text(
              'Change',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  // PDF Page 22: Change Email Bottom Sheet with OTP
  void _showChangeEmailModal(BuildContext context, ProfileProvider provider) {
    final emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _OtpVerificationSheet(
        title: 'Update Email Address',
        subtitle: "We'll send a verification code to your new email.",
        fieldHint: 'Enter new email address',
        controller: emailController,
        onVerified: () {
          if (emailController.text.contains('@')) {
            provider.updateEmail(emailController.text.trim());
          }
        },
      ),
    );
  }

  // PDF Page 22: Change Mobile Bottom Sheet with OTP
  void _showChangeMobileModal(BuildContext context, ProfileProvider provider) {
    final mobileController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _OtpVerificationSheet(
        title: 'Update Mobile Number',
        subtitle: "We'll send a verification code to your new mobile number.",
        fieldHint: 'Enter 10-digit mobile number',
        controller: mobileController,
        prefixText: '+91  ',
        isPhone: true,
        onVerified: () {
          if (mobileController.text.length == 10) {
            provider.updateMobile(mobileController.text.trim());
          }
        },
      ),
    );
  }
}

// Reusable 6-Digit OTP Verification Sheet
class _OtpVerificationSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String fieldHint;
  final TextEditingController controller;
  final String? prefixText;
  final bool isPhone;
  final VoidCallback onVerified;

  const _OtpVerificationSheet({
    required this.title,
    required this.subtitle,
    required this.fieldHint,
    required this.controller,
    this.prefixText,
    this.isPhone = false,
    required this.onVerified,
  });

  @override
  State<_OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<_OtpVerificationSheet> {
  bool _otpSent = false;
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            widget.subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          if (!_otpSent) ...[
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  if (widget.prefixText != null)
                    Text(
                      widget.prefixText!,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: widget.fieldHint,
                        hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textHint),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => setState(() => _otpSent = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Send OTP', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ] else ...[
            const Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 44,
                  height: 48,
                  child: TextField(
                    controller: _otpControllers[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.secondary, width: 2),
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) FocusScope.of(context).nextFocus();
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onVerified();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification successful & updated!'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify & Update', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}