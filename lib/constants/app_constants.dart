
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Mahavir Finance';
  static const String appTagline = 'Your Financial Partner';

  // App Configuration
  static const int maxNameLength = 100;
  static const int maxMessageLength = 500;
  static const int otpLength = 6;

  // Pagination
  static const int defaultPageSize = 10;
  static const int initialPage = 1;

  // UI Dimensions
  static const double screenPadding = 16.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double inputRadius = 12.0;
  static const double iconSize = 24.0;
  static const double buttonHeight = 52.0;
  static const double appBarHeight = 60.0;

  // Animation Durations (milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Validation
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int mobileNumberLength = 10;

  // Asset Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath =
      'assets/images/placeholder.png';

  // Storage Keys
  static const String isLoggedInKey = 'is_logged_in';
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String selectedRoleKey = 'selected_role';

  // Network Configuration
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;

  // Messages
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String noInternetMessage =
      'Please check your internet connection.';
  static const String noDataFound = 'No data found.';
  static const String loadingMessage = 'Please wait...';
}
