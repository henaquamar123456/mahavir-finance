import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EnquireNowBottomSheet extends StatefulWidget {
  final String initialService;

  const EnquireNowBottomSheet({
    super.key,
    required this.initialService,
  });

  static void show(BuildContext context, {required String initialService}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnquireNowBottomSheet(initialService: initialService),
    );
  }

  @override
  State<EnquireNowBottomSheet> createState() => _EnquireNowBottomSheetState();
}

class _EnquireNowBottomSheetState extends State<EnquireNowBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _messageController;
  late String _selectedService;

  final List<String> _services = [
    'Financial Consulting',
    'Investment Planning',
    'Financial Guidance',
    'Loan Advisory',
    'Tax Planning',
    'Retirement Planning',
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = _services.contains(widget.initialService)
        ? widget.initialService
        : _services.first;
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header Row with Expanded wrapper to fix the 26px overflow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enquire Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Fill in your details and our financial expert will get back to you.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Full Name*'),
                    _buildInputField(
                      controller: _nameController,
                      hint: 'Enter your full name',
                      validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('Mobile Number*'),
                    _buildInputField(
                      controller: _mobileController,
                      hint: 'Enter 10-digit mobile number',
                      keyboardType: TextInputType.phone,
                      prefixText: '+91  ',
                      validator: (val) =>
                      val == null || val.trim().length != 10
                          ? 'Enter a valid 10-digit number'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('Email Address*'),
                    _buildInputField(
                      controller: _emailController,
                      hint: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                      val == null || !val.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildLabel('Select Service*'),
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
                          value: _selectedService,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primary,
                          ),
                          items: _services.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedService = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Message (Optional)'),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _messageController,
                          builder: (_, value, __) {
                            return Text(
                              '${value.text.length}/300',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: TextField(
                        controller: _messageController,
                        maxLength: 300,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Tell us about your requirements...',
                          hintStyle: TextStyle(fontSize: 12, color: AppColors.textHint),
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 16, color: AppColors.secondary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your information is secure with us. We never share your details.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enquiry submitted successfully! Our expert will connect soon.'),
                                backgroundColor: AppColors.secondary,
                              ),
                            );
                          }
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
                              'Submit Enquiry',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
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
      style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textHint),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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