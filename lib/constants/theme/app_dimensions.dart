
import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Spacing
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // Screen padding
  static const double screenPaddingHorizontal = 16;
  static const double screenPaddingVertical = 16;
  static const double tabletPaddingHorizontal = 24;
  static const double desktopPaddingHorizontal = 32;

  // Border radius
  static const double radiusSmall = 6;
  static const double radiusMedium = 10;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  static const double radiusXXLarge = 20;
  static const double radiusCircular = 100;

  // Icon sizes
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconXLarge = 32;
  static const double iconXXLarge = 48;

  // Button dimensions
  static const double buttonHeightSmall = 36;
  static const double buttonHeight = 48;
  static const double buttonHeightLarge = 56;
  static const double buttonMinWidth = 100;

  // Text field dimensions
  static const double inputHeight = 52;
  static const double inputBorderWidth = 1;
  static const double inputFocusedBorderWidth = 1.5;

  // App bar
  static const double appBarHeight = 56;
  static const double appBarElevation = 0;

  // Bottom navigation
  static const double bottomNavHeight = 72;
  static const double bottomNavIconSize = 24;

  // Cards
  static const double cardRadius = 16;
  static const double cardPadding = 16;
  static const double cardElevation = 0;

  // Avatars
  static const double avatarSmall = 32;
  static const double avatarMedium = 40;
  static const double avatarLarge = 48;
  static const double avatarXLarge = 64;

  // Dividers and borders
  static const double dividerThickness = 1;
  static const double borderWidth = 1;

  // Loading indicators
  static const double loaderSmall = 20;
  static const double loaderMedium = 32;
  static const double loaderLarge = 48;

  // Maximum content width
  static const double maxContentWidth = 1200;

  // Common EdgeInsets
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenPaddingHorizontal,
    vertical: screenPaddingVertical,
  );

  static const EdgeInsets cardContentPadding = EdgeInsets.all(cardPadding);

  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: spacing16,
    vertical: spacing12,
  );

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spacing20,
    vertical: spacing12,
  );

  // Common BorderRadius
  static const BorderRadius smallBorderRadius = BorderRadius.all(
    Radius.circular(radiusSmall),
  );

  static const BorderRadius mediumBorderRadius = BorderRadius.all(
    Radius.circular(radiusMedium),
  );

  static const BorderRadius largeBorderRadius = BorderRadius.all(
    Radius.circular(radiusLarge),
  );

  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(cardRadius),
  );
}
