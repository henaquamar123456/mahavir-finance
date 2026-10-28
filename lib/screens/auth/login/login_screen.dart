
import 'package:flutter/material.dart';
import 'package:mahavir_finance/screens/partner_section/dasboard/partner_dashboard_screen.dart';
import 'package:mahavir_finance/widgets/auth_header.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/asset_constants.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../customer-section/home/customer_home_screen.dart';
import '../provider/auth_form_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFormProvider(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthFormProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and heading
                  AuthHeader(
                    title: 'Welcome Back!',
                    subtitle: 'Login to continue to Mahavir Finance',
                    logo: Image.asset(
                      AssetsConstants.mahavirLogo,
                      height: 76,
                      width: 76,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Mobile / Email tabs
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _LoginTab(
                            title: 'Mobile Number',
                            selected: provider.isMobileLogin,
                            onTap: () =>
                                provider.changeLoginMethod(true),
                          ),
                        ),
                        Expanded(
                          child: _LoginTab(
                            title: 'Email Address',
                            selected: !provider.isMobileLogin,
                            onTap: () =>
                                provider.changeLoginMethod(false),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Mobile / Email label
                  Text(
                    provider.isMobileLogin
                        ? 'Mobile Number'
                        : 'Email Address',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // Mobile number field
                  if (provider.isMobileLogin)
                    TextFormField(
                      controller: provider.mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: provider.validateMobile,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: _inputDecoration(
                        hint: 'Enter mobile number',
                        prefix: Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 10,
                          ),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              '+91',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ).copyWith(counterText: ''),
                    )
                  else
                  // Email field
                    TextFormField(
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: provider.validateEmail,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: _inputDecoration(
                        hint: 'Enter email address',
                        prefix: const Icon(Icons.email_outlined),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Password label
                  Text(
                    'Password',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // Password field
                  TextFormField(
                    controller: provider.passwordController,
                    obscureText: !provider.isPasswordVisible,
                    validator: provider.validatePassword,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      hint: 'Enter your password',
                      prefix: const Icon(Icons.lock_outline),
                      suffix: IconButton(
                        onPressed: provider.togglePasswordVisibility,
                        icon: Icon(
                          provider.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.iconSecondary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.forgotPassword,
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Login button
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        foregroundColor: AppColors.textOnPrimary,
                        disabledBackgroundColor:
                        AppColors.buttonDisabled,
                        disabledForegroundColor:
                        AppColors.textSecondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                          : Text(
                        'Login',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // OR divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColors.divider),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: AppTextStyles.labelSmall.copyWith(
                            letterSpacing: 1,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.divider),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Google and Apple buttons
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onTap: () => _showComingSoon(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onTap: () => _showComingSoon(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Register link
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.register,
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Partner registration
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerDashboardScreen()));
                      },
                      child: Text(
                        'Register as a Partner',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable input decoration
  static InputDecoration _inputDecoration({
    required String hint,
    Widget? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
        fontSize: 14,
      ),
      prefixIcon: prefix,
      prefixIconColor: AppColors.iconSecondary,
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
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
          width: 1.5,
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
          width: 1.5,
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Social login integration is pending.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _LoginTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LoginTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? AppColors.textOnPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 25,
        color: AppColors.iconPrimary,
      ),
      label: Text(
        label,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(color: AppColors.border),
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
