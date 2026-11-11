import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/asset_constants.dart';
import '../../../constants/theme/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/auth_header.dart';

import '../../admin_dasboard/admin_sell_screen.dart';
import '../../customer-section/home/customer_home_screen.dart';
import '../../partner_section/dasboard/partner_dashboard_screen.dart';
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

  Future<void> _handleLogin(
      BuildContext context,
      AuthFormProvider provider, {
        required bool isDesktop,
      }) async {
    if (provider.isLoading) return;

    if (isDesktop) {
      provider.setSelectedRole('admin');
    }

    final role = await provider.login();

    if (!context.mounted) return;

    if (role == null) {
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

    switch (role.toLowerCase()) {
      case 'customer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
        break;

      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminShellScreen(),
          ),
        );
        break;

      case 'partner':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PartnerDashboardScreen(),
          ),
        );
        break;

      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthFormProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 960;

            if (isDesktop) {
              return Row(
                children: [
                  const Expanded(
                    flex: 5,
                    child: _WebBrandingSide(),
                  ),
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 36,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildForm(
                              context,
                              provider,
                              isDesktop: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: _buildForm(
                    context,
                    provider,
                    isDesktop: false,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context,
      AuthFormProvider provider, {
        required bool isDesktop,
      }) {
    return Form(
      key: provider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthHeader(
            title: isDesktop ? 'Admin Console' : 'Welcome Back!',
            subtitle: isDesktop
                ? 'Sign in to Mahavir Finance Admin Portal'
                : 'Login to continue to Mahavir Finance',
            logo: Image.asset(
              AssetsConstants.mahavirLogo,
              height: 76,
              width: 76,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 24),

          // Role Selector Tab: Keval Mobile par dikhega, Web pe nahi
          if (!isDesktop) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _RoleTab(
                      icon: Icons.person_rounded,
                      title: 'Customer',
                      selected: provider.selectedRole == 'customer',
                      onTap: () => provider.setSelectedRole('customer'),
                    ),
                  ),
                  Expanded(
                    child: _RoleTab(
                      icon: Icons.handshake_rounded,
                      title: 'Partner (DSA)',
                      selected: provider.selectedRole == 'partner',
                      onTap: () => provider.setSelectedRole('partner'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Mobile / Email Switcher Tab
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _LoginTab(
                    title: 'Mobile Number',
                    selected: provider.isMobileLogin,
                    onTap: () => provider.changeLoginMethod(true),
                  ),
                ),
                Expanded(
                  child: _LoginTab(
                    title: 'Email Address',
                    selected: !provider.isMobileLogin,
                    onTap: () => provider.changeLoginMethod(false),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            provider.isMobileLogin ? 'Mobile Number' : 'Email Address',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          if (provider.isMobileLogin)
            TextFormField(
              controller: provider.mobileController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLength: 10,
              validator: provider.validateMobile,
              onChanged: (_) => provider.clearError(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: _inputDecoration(
                hint: 'Enter mobile number',
                prefix: const Padding(
                  padding: EdgeInsets.only(
                    left: 14,
                    right: 10,
                  ),
                  child: Center(
                    widthFactor: 1,
                    child: Text('+91'),
                  ),
                ),
              ).copyWith(counterText: ''),
            )
          else
            TextFormField(
              controller: provider.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: provider.validateEmail,
              onChanged: (_) => provider.clearError(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: _inputDecoration(
                hint: 'Enter email address',
                prefix: const Icon(Icons.email_outlined),
              ),
            ),

          const SizedBox(height: 18),

          Text(
            'Password',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: provider.passwordController,
            obscureText: !provider.isPasswordVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(
              context,
              provider,
              isDesktop: isDesktop,
            ),
            validator: provider.validatePassword,
            onChanged: (_) => provider.clearError(),
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

          const SizedBox(height: 10),

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

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => _handleLogin(
                context,
                provider,
                isDesktop: isDesktop,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                foregroundColor: AppColors.textOnPrimary,
                disabledBackgroundColor: AppColors.buttonDisabled,
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
                isDesktop
                    ? 'Login to Admin Portal'
                    : (provider.selectedRole == 'partner'
                    ? 'Login as Partner'
                    : 'Login as Customer'),
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          if (!isDesktop) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.divider)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'OR CONTINUE WITH',
                    style: AppTextStyles.labelSmall.copyWith(
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.divider)),
              ],
            ),
            const SizedBox(height: 18),
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
            const SizedBox(height: 22),
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
          ] else ...[
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Authorized administrator access only.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

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
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.border),
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
          'Social login integration is in progress.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _WebBrandingSide extends StatelessWidget {
  const _WebBrandingSide();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              AssetsConstants.mahavirLogo,
              height: 56,
              width: 56,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Admin Management\nConsole',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Monitor loan disbursals, manage partner commissions, and oversee KYC verification workflows.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _featureItem(Icons.admin_panel_settings_rounded, 'Full Administrative Control'),
          const SizedBox(height: 16),
          _featureItem(Icons.analytics_rounded, 'Real-time Disbursal & Financial Analytics'),
          const SizedBox(height: 16),
          _featureItem(Icons.security_rounded, 'Audit Logging & Secure Access'),
        ],
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _RoleTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _RoleTab({
    required this.icon,
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
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
      color: selected ? AppColors.secondary : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
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
        size: 24,
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
        side: const BorderSide(color: AppColors.border),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}