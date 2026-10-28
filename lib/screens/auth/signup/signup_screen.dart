
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/asset_constants.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _agreeToTerms = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    String? example,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.iconSecondary,
        size: 22,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.3,
        ),
      ),
      helperText: example,
      helperStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      helperMaxLines: 1,
      isDense: true,
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
    String? example,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLength: maxLength,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: _fieldDecoration(
        hint: hint,
        icon: icon,
        suffix: suffix,
        example: example,
      ).copyWith(counterText: ''),
    );
  }

  Widget _passwordSuffix({
    required bool visible,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        visible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: AppColors.iconSecondary,
        size: 21,
      ),
    );
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            'Please accept Terms & Conditions and Privacy Policy.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Connect Signup API / Firebase Authentication here.
      // Account is not created until the backend confirms success.

      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            'Form validated. Connect your registration API.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top navigation
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                Navigator.maybePop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                              size: 25,
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              'Already have an account? ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Logo
                      Center(
                        child: Image.asset(
                          AssetsConstants.mahavirLogo,
                          height: 105,
                          width: 190,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Heading
                      Text(
                        'Create Your Account',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.primary,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.8,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Join Mahavir Finance and take the first step\n'
                            'towards your financial goals',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Full Name
                      _buildField(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.trim().length < 2) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // Mobile Number
                      _buildField(
                        controller: _mobileController,
                        hint: 'Mobile Number',
                        icon: Icons.call_outlined,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (!RegExp(r'^[6-9]\d{9}$')
                              .hasMatch(value.trim())) {
                            return 'Enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // Email Address
                      _buildField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!RegExp(
                            r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$',
                          ).hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // Password
                      _buildField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: !_passwordVisible,
                        suffix: _passwordSuffix(
                          visible: _passwordVisible,
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // Confirm Password
                      _buildField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: !_confirmPasswordVisible,
                        suffix: _passwordSuffix(
                          visible: _confirmPasswordVisible,
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                              !_confirmPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Terms and Conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 26,
                            height: 26,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: AppColors.secondary,
                              checkColor: AppColors.textOnPrimary,
                              side: const BorderSide(
                                color: AppColors.border,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment:
                              WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'I agree to the ',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Open Terms & Conditions.
                                  },
                                  child: Text(
                                    'Terms & Conditions',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' and ',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Open Privacy Policy.
                                  },
                                  child: Text(
                                    'Privacy Policy',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Create Account button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                          _isLoading ? null : _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary,
                            foregroundColor: AppColors.textOnPrimary,
                            disabledBackgroundColor:
                            AppColors.buttonDisabled,
                            disabledForegroundColor:
                            AppColors.textOnPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create Account',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.arrow_forward,
                                size: 23,
                                color: AppColors.textOnPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // OR divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.divider,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            child: Text(
                              'OR',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.divider,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Register as Partner
                      SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Navigate to Partner Registration.
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.handshake_outlined,
                                size: 25,
                                color: AppColors.iconPrimary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Register as Partner',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
