
import 'package:flutter/material.dart';

class ResponsiveHelper {
  ResponsiveHelper._();

  // Screen breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  /// Returns the screens width.
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Returns the screens height.
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Checks whether the current screens is mobile-sized.
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  /// Checks whether the current screens is tablet-sized.
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint &&
        width < tabletBreakpoint;
  }

  /// Checks whether the current screens is desktop-sized.
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= tabletBreakpoint;
  }

  /// Returns responsive horizontal padding.
  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);

    if (width >= tabletBreakpoint) return 32;
    if (width >= mobileBreakpoint) return 24;
    return 16;
  }

  /// Returns responsive page padding.
  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding(context),
      vertical: isMobile(context) ? 16 : 24,
    );
  }

  /// Returns a responsive font size.
  static double fontSize(
      BuildContext context, {
        required double mobile,
        double? tablet,
        double? desktop,
      }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }

  /// Returns a responsive value for each screens size.
  static double value({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }

  /// Calculates a maximum content width for larger screens.
  static double contentWidth(BuildContext context) {
    final width = screenWidth(context);

    if (width >= tabletBreakpoint) {
      return width * 0.85 > 1200 ? 1200 : width * 0.85;
    }

    return width;
  }

  /// Returns a responsive number of grid columns.
  static int gridColumns(BuildContext context) {
    final width = screenWidth(context);

    if (width >= 1200) return 4;
    if (width >= tabletBreakpoint) return 3;
    if (width >= mobileBreakpoint) return 2;
    return 1;
  }
}
