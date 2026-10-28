import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedTopic = 'General Inquiry';
  final List<String> _topics = [
    'General Inquiry',
    'Loan Application Status',
    'Financial Consulting',
    'EMI & Repayment Query',
    'Document Verification',
    'Feedback & Grievance',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Message Sent!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you for reaching out. Our support team will get in touch with you within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _nameController.clear();
                    _mobileController.clear();
                    _emailController.clear();
                    _messageController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Okay', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
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
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get in Touch',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Have questions or need assistance? Reach out to our dedicated financial advisory team.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Direct Contact Cards Grid
              _buildContactChannelsGrid(),
              const SizedBox(height: 20),

              // 2. Working Hours & Branch Location Card
              _buildOfficeDetailsCard(),
              const SizedBox(height: 20),

              // 3. Send Us a Message Form Card
              _buildMessageFormCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactChannelsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildChannelCard(
            icon: Icons.phone_in_talk_outlined,
            title: 'Call Us',
            subtitle: '+91 1800 258 9900',
            actionText: 'Toll-Free',
            iconColor: const Color(0xFF0284C7),
            bgColor: const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildChannelCard(
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'care@mahavir.com',
            actionText: '24/7 Support',
            iconColor: AppColors.secondary,
            bgColor: const Color(0xFFDCFCE7),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            actionText,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_outlined, color: Color(0xFFD97706), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Corporate Office',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Sector 62, Electronic City, Noida, UP 201309',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 18, color: AppColors.secondary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Mon - Sat: 9:30 AM - 6:30 PM (Sunday Closed)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send Us a Message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fill out the form below and we will respond as soon as possible.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),

            _buildLabel('Full Name*'),
            _buildInputField(
              controller: _nameController,
              hint: 'Enter your full name',
              validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 12),

            _buildLabel('Mobile Number*'),
            _buildInputField(
              controller: _mobileController,
              hint: 'Enter 10-digit number',
              prefixText: '+91  ',
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().length != 10 ? 'Enter valid 10-digit number' : null,
            ),
            const SizedBox(height: 12),

            _buildLabel('Email Address*'),
            _buildInputField(
              controller: _emailController,
              hint: 'Enter email address',
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 12),

            _buildLabel('Inquiry Topic*'),
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
                  value: _selectedTopic,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                  items: _topics.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(t, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedTopic = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildLabel('Message*'),
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextFormField(
                controller: _messageController,
                maxLines: 4,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please describe your inquiry' : null,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Describe your query or requirement...',
                  hintStyle: TextStyle(fontSize: 12, color: AppColors.textHint),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send Message',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send_rounded, size: 16, color: Colors.white),
                  ],
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
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textHint),
        prefixText: prefixText,
        prefixStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: Colors.white,
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
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
        ),
      ),
    );
  }
}