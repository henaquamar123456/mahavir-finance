
class AppRoutes {
  AppRoutes._();

  // Initial route
  static const String splash = '/';

  // Authentication
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';

  // Customer
  static const String customerDashboard = '/customer/dashboard';
  static const String loanProducts = '/customer/loan-products';
  static const String loanDetails = '/customer/loan-details';
  static const String applyLoan = '/customer/apply-loan';
  static const String myLoans = '/customer/my-loans';
  static const String loanHistory = '/customer/loan-history';
  static const String emiDetails = '/customer/emi-details';

  // Partner
  static const String partnerDashboard = '/partner/dashboard';
  static const String partnerCustomers = '/partner/customers';
  static const String partnerApplications = '/partner/applications';
  static const String partnerProfile = '/partner/profile';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminLoanApplications = '/admin/loan-applications';
  static const String adminReports = '/admin/reports';

  // Common
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';

}
