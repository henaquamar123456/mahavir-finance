
import 'package:flutter/material.dart';
import '../../screens/customer-section/home/customer_home_screen.dart';
import '../../screens/onboding/screens/onboding/onboding_screen.dart';
import '../../screens/auth/forgot/forgot_password_screen.dart';
import '../../screens/auth/login/login_screen.dart';
import '../../screens/auth/signup/signup_screen.dart';
import '../../splash/splash_screen.dart';
import 'app_routes.dart';


class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );


      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
        );

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );

      case AppRoutes.customerDashboard:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );

      case AppRoutes.partnerDashboard:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Partner Dashboard'),
        );

      case AppRoutes.adminDashboard:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Admin Dashboard'),
        );

      case AppRoutes.profile:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Profile'),
        );

      case AppRoutes.settings:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Settings'),
        );

      default:
        return _buildRoute(
          settings,
          const _PlaceholderScreen(title: 'Page Not Found'),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
      RouteSettings settings,
      Widget screen,
      ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => screen,
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
