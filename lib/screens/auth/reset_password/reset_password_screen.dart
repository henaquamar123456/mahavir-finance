
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/asset_constants.dart';
import '../../../constants/theme/app_text_styles.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  bool get _hasMinLength =>
      _passwordController.text.length >= 8;

  bool get _hasUpperAndLower =>
      RegExp(r'[A-Z]').hasMatch(_passwordController.text) &&
          RegExp(r'[a-z]').hasMatch(_passwordController.text);

  bool get _hasNumber =>
      RegExp(r'[0-9]').hasMatch(_passwordController.text);

  bool get _hasSpecialCharacter =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\];]')
          .hasMatch(_passwordController.text);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required bool visible,
    required VoidCallback onVisibilityTap,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
        fontSize: 13,
      ),
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: AppColors.primary,
        size: 20,
      ),
      suffixIcon: IconButton(
        onPressed: onVisibilityTap,
        icon: Icon(
          visible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.primary,
          size: 19,
        ),
      ),
      filled: true,
      fillColor: AppColors.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Connect your reset-password API here.
      // Send the reset token / OTP and the new password
      // according to your backend API requirements.

      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Form validated. Connect your reset-password API.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _requirementRow({
    required String text,
    required bool satisfied,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            satisfied ? Icons.check_circle : Icons.circle,
            size: satisfied ? 11 : 5,
            color: satisfied
                ? AppColors.secondary
                : AppColors.textSecondary,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _BottomWaves(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        5,
                        20,
                        48,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                          children: [
                            // Back arrow
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () =>
                                    Navigator.maybePop(context),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),

                            const SizedBox(height: 2),

                            // Mahavir Finance logo
                            Center(
                              child: Image.asset(
                                AssetsConstants.mahavirLogo,
                                height: 88,
                                width: 175,
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Screen title
                            Text(
                              'Reset Password',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headingLarge.copyWith(
                                color: AppColors.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 5),

                            // Description
                            Text(
                              'Enter your new password below to\n'
                                  'reset your account password.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),

                            const SizedBox(height: 9),

                            // Lock illustration
                            const Center(
                              child: _ResetPasswordIllustration(),
                            ),

                            const SizedBox(height: 9),

                            // New password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter new password';
                                }
                                if (value.length < 8) {
                                  return 'Use at least 8 characters';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Include an uppercase letter';
                                }
                                if (!RegExp(r'[a-z]').hasMatch(value)) {
                                  return 'Include a lowercase letter';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'Include a number';
                                }
                                if (!RegExp(
                                  r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\];]',
                                ).hasMatch(value)) {
                                  return 'Include a special character';
                                }
                                return null;
                              },
                              decoration: _fieldDecoration(
                                hint: 'New Password',
                                visible: _passwordVisible,
                                onVisibilityTap: () {
                                  setState(() {
                                    _passwordVisible =
                                    !_passwordVisible;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 7),

                            // Confirm password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_confirmPasswordVisible,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
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
                              decoration: _fieldDecoration(
                                hint: 'Confirm Password',
                                visible: _confirmPasswordVisible,
                                onVisibilityTap: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 11),

                            // Password requirements card
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                13,
                                11,
                                12,
                                8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF4FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.verified_user,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        'Password Requirements:',
                                        style: AppTextStyles.labelLarge
                                            .copyWith(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 29,
                                    ),
                                    child: Column(
                                      children: [
                                        _requirementRow(
                                          text: 'At least 8 characters',
                                          satisfied: _hasMinLength,
                                        ),
                                        _requirementRow(
                                          text:
                                          'Include uppercase and lowercase letters',
                                          satisfied: _hasUpperAndLower,
                                        ),
                                        _requirementRow(
                                          text: 'Include at least one number',
                                          satisfied: _hasNumber,
                                        ),
                                        _requirementRow(
                                          text:
                                          'Include at least one special character (e.g. @ # \$)',
                                          satisfied:
                                          _hasSpecialCharacter,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Reset password button
                            SizedBox(
                              height: 45,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.secondary,
                                      Color(0xFF00875A),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _resetPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    disabledBackgroundColor:
                                    Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor:
                                    AppColors.textOnPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 21,
                                    width: 21,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Reset Password',
                                        style: AppTextStyles.button
                                            .copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 19,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Lock illustration
class _ResetPasswordIllustration extends StatelessWidget {
  const _ResetPasswordIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      width: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 108,
            width: 164,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFDDF7EC),
                  Color(0xFFF2FBF7),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Lock shackle
          Positioned(
            top: 15,
            left: 72,
            child: Container(
              height: 37,
              width: 47,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.secondary,
                  width: 9,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
            ),
          ),

          // Lock body
          Positioned(
            top: 43,
            left: 58,
            child: Container(
              height: 48,
              width: 73,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.secondary,
                    Color(0xFF00875A),
                  ],
                ),
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.17),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),

          // Circular reset symbol
          Positioned(
            right: 37,
            bottom: 24,
            child: Container(
              height: 39,
              width: 39,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.sync,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Decorative rays
          Positioned(
            right: 20,
            top: 37,
            child: Transform.rotate(
              angle: 0.55,
              child: Container(
                height: 4,
                width: 12,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 53,
            child: Container(
              height: 4,
              width: 10,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            right: 22,
            top: 67,
            child: Transform.rotate(
              angle: -0.55,
              child: Container(
                height: 4,
                width: 12,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom decorative waves
class _BottomWaves extends StatelessWidget {
  const _BottomWaves();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: CustomPaint(
          painter: _BottomWavesPainter(),
        ),
      ),
    );
  }
}

class _BottomWavesPainter extends CustomPainter {
  const _BottomWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final lightGreen = Paint()
      ..color = const Color(0xFFDDF7EC)
      ..style = PaintingStyle.fill;

    final green = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final navy = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final lightPath = Path()
      ..moveTo(0, size.height * 0.30)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.05,
        size.width * 0.43,
        size.height * 0.85,
        size.width * 0.68,
        size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.10,
        size.width * 0.93,
        size.height * 0.15,
        size.width,
        0,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final greenPath = Path()
      ..moveTo(0, size.height * 0.53)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.30,
        size.width * 0.40,
        size.height * 1.20,
        size.width * 0.66,
        size.height * 0.55,
      )
      ..cubicTo(
        size.width * 0.80,
        size.height * 0.20,
        size.width * 0.92,
        size.height * 0.28,
        size.width,
        size.height * 0.10,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final navyPath = Path()
      ..moveTo(0, size.height * 0.76)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.44,
        size.width * 0.38,
        size.height * 1.30,
        size.width * 0.62,
        size.height * 0.83,
      )
      ..cubicTo(
        size.width * 0.79,
        size.height * 0.48,
        size.width * 0.90,
        size.height * 0.55,
        size.width,
        size.height * 0.37,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(lightPath, lightGreen);
    canvas.drawPath(greenPath, green);
    canvas.drawPath(navyPath, navy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
