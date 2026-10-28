import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/asset_constants.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../auth/login/login_screen.dart';
import '../../providers/onboding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static final List<Map<String, String>> pages = [
    {
      'title1': 'Build Your',
      'title2': 'Financial Future',
      'description':
      'Get the right loan solutions to achieve your dreams and secure your future.',
      'image': 'assets/images/illustrations/house2.png',
    },
    {
      'title1': 'Wide Range',
      'title2': 'of Loan Solutions',
      'description':
      'Explore personal, home, business and other loan options designed for your needs.',
      'image': 'assets/images/illustrations/smartphone.png',
    },
    {
      'title1': 'Easy & Secure',
      'title2': 'Application Process',
      'description':
      'Apply for your loan through a simple, transparent and secure process.',
      'image': 'assets/images/illustrations/Loan.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  void _getStarted(BuildContext context) {
    Navigator.of(context).pushReplacement(
      // MaterialPageRoute(
      //   builder: (_) => const LoginScreen(),
      // ),
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        final currentPage = provider.currentPage;
        // Syntax error fixed here
        final isLastPage = currentPage == OnboardingScreen.pages.length - 1;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: provider.pageController,
                    itemCount: OnboardingScreen.pages.length,
                    onPageChanged: provider.onPageChanged,
                    itemBuilder: (context, index) {
                      final page = OnboardingScreen.pages[index];

                      return _OnboardingPage(
                        title1: page['title1']!,
                        title2: page['title2']!,
                        description: page['description']!,
                        image: page['image']!,
                        index: index,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    OnboardingScreen.pages.length,
                        (index) {
                      final isActive = currentPage == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 24 : 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.secondary : AppColors.border,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      if (currentPage > 0)
                        TextButton(
                          onPressed: provider.previousPage,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 68),
                      const Spacer(),
                      if (isLastPage)
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _getStarted(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonPrimary,
                                foregroundColor: AppColors.textOnPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ),
                                  const SizedBox(width:2),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: AppColors.textOnPrimary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: provider.nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonSecondary,
                              foregroundColor: AppColors.textOnPrimary,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.textOnPrimary,
                              size: 26,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title1;
  final String title2;
  final String description;
  final String image;
  final int index;

  const _OnboardingPage({
    required this.title1,
    required this.title2,
    required this.description,
    required this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final titleStyle = AppTextStyles.displayMedium.copyWith(
      fontSize: screenWidth < 360 ? 27 : 30,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.15,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.025),
          if (index == 0)
            Image.asset(
              'assets/images/logo/splass logo.png',
              height: screenHeight * 0.12,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AssetsConstants.mahavirLogo,
                  height: screenHeight * 0.12,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.account_balance_rounded,
                      size: 54,
                      color: AppColors.primary,
                    );
                  },
                );
              },
            )
          else
            SizedBox(height: screenHeight * 0.12),
          const SizedBox(height: 18),
          Text(
            title1,
            textAlign: TextAlign.center,
            style: titleStyle.copyWith(color: AppColors.textPrimary),
          ),
          Text(
            title2,
            textAlign: TextAlign.center,
            style: titleStyle.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 15,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Container(
                width: 230,
                height: 230,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      blurRadius: 28,
                      spreadRadius: 4,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AssetsConstants.splashIllustration,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return const Icon(
                            Icons.account_balance_rounded,
                            size: 80,
                            color: AppColors.iconSecondary,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}