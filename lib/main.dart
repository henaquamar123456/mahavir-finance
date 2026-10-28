import 'package:flutter/material.dart';
import 'package:mahavir_finance/screens/auth/provider/auth_form_provider.dart';
import 'package:mahavir_finance/screens/customer-section/calculator/emi_calculator_provider.dart';
import 'package:mahavir_finance/screens/customer-section/loans/loan_inquiry_provider.dart';
import 'package:mahavir_finance/screens/customer-section/loans/loans_provider.dart';
import 'package:mahavir_finance/screens/customer-section/profile/profile_provider.dart';
import 'package:mahavir_finance/splash/splash_provider.dart';
import 'package:provider/provider.dart';
import 'constants/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SplashProvider>(
          create: (_) => SplashProvider(),
        ),
        ChangeNotifierProvider<LoansProvider>(
          create: (_) => LoansProvider(),
        ),
        ChangeNotifierProvider<EmiCalculatorProvider>(
          create: (_) => EmiCalculatorProvider(),
        ),
        ChangeNotifierProvider<AuthFormProvider>(
          create: (_) => AuthFormProvider(),
        ),
        ChangeNotifierProvider<LoanInquiryProvider>(create: (_) => LoanInquiryProvider()),
        ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
      ],
      child: const MahavirFinanceApp(),
    ),
  );
}

class MahavirFinanceApp extends StatelessWidget {
  const MahavirFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mahavir Finance',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

