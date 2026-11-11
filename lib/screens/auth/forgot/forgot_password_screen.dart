import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../provider/auth_form_provider.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFormProvider(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  InputDecoration _decoration({
    required String hint,
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
        fontSize: 14,
      ),
      prefixIcon: prefix,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
    );
  }

  Future<void> _handleForgotPassword(
      BuildContext context,
      AuthFormProvider provider,
      ) async {
    FocusScope.of(context).unfocus();

    final bool success = await provider.forgotPassword();

    if (!context.mounted) return;

    if (!success) {
      if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final String target = provider.isMobileLogin
        ? '+91 ${provider.mobileController.text.trim()}'
        : provider.emailController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent successfully. Please verify.'),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          destination: target.isNotEmpty ? target : '+91 98765 43210',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthFormProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 460,
                    minHeight: constraints.maxHeight > 26
                        ? constraints.maxHeight - 26
                        : constraints.maxHeight,
                  ),
                  child: Form(
                    key: provider.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.maybePop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        const Center(
                          child: _ForgotPasswordIllustration(),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.primary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.7,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Enter your registered mobile number or\n"
                              "email address and we'll send you an OTP\n"
                              "to reset your password.",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Mobile / Email selector
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _MethodTab(
                                  title: 'Mobile Number',
                                  selected: provider.isMobileLogin,
                                  onTap: () =>
                                      provider.changeLoginMethod(true),
                                ),
                              ),
                              Expanded(
                                child: _MethodTab(
                                  title: 'Email Address',
                                  selected: !provider.isMobileLogin,
                                  onTap: () =>
                                      provider.changeLoginMethod(false),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        if (provider.isMobileLogin)
                          TextFormField(
                            controller: provider.mobileController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _handleForgotPassword(context, provider),
                            maxLength: 10,
                            validator: provider.validateMobile,
                            onChanged: (_) => provider.clearError(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            decoration: _decoration(
                              hint: 'Enter mobile number',
                              prefix: Padding(
                                padding: const EdgeInsets.only(
                                  left: 13,
                                  right: 10,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '🇮🇳',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 9),
                                    Text(
                                      '+91',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 9),
                                    Container(
                                      height: 27,
                                      width: 1,
                                      color: AppColors.border,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ).copyWith(counterText: ''),
                          )
                        else
                          TextFormField(
                            controller: provider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _handleForgotPassword(context, provider),
                            validator: provider.validateEmail,
                            onChanged: (_) => provider.clearError(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            decoration: _decoration(
                              hint: 'Enter email address',
                              prefix: const Icon(
                                Icons.mail_outline,
                                color: AppColors.iconSecondary,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  Color(0xFF00875A),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: ElevatedButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : () => _handleForgotPassword(
                                context,
                                provider,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: AppColors.textOnPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              child: provider.isLoading
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Send Reset Code',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withValues(
                                  alpha: 0.04,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.successBackground,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.verified_user,
                                  color: AppColors.success,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your information is secure with us',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'We never share your details with anyone',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
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

class _MethodTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.successBackground : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLarge.copyWith(
                  color:
                  selected ? AppColors.secondary : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: selected ? AppColors.secondary : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordIllustration extends StatelessWidget {
  const _ForgotPasswordIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 175,
            width: 215,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFDDF6ED),
                  Color(0xFFF3FBF8),
                  Colors.white,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 27,
            child: Container(
              height: 85,
              width: 126,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF77B2FF),
                    Color(0xFF2875D8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.16),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 63,
            child: ClipPath(
              clipper: _EnvelopeFlapClipper(),
              child: Container(
                height: 60,
                width: 126,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB8DBFF),
                      Color(0xFFE4F1FF),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            child: Container(
              height: 50,
              width: 70,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5FAFF),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                    width: 36,
                    color: const Color(0xFF6CA6EF),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: 52,
                    color: const Color(0xFF9CC6F8),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 4,
                    width: 30,
                    color: const Color(0xFF9CC6F8),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: ClipPath(
              clipper: _EnvelopeFrontClipper(),
              child: Container(
                height: 60,
                width: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF65A4F4),
                      Color(0xFF357FD9),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            right: 48,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            top: 61,
            right: 25,
            child: Transform.rotate(
              angle: 0.65,
              child: Container(
                height: 4,
                width: 15,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Positioned(
            top: 82,
            right: 18,
            child: Container(
              height: 4,
              width: 12,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 26,
            child: Transform.rotate(
              angle: -0.65,
              child: Container(
                height: 4,
                width: 13,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvelopeFlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _EnvelopeFrontClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height * 0.65)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}