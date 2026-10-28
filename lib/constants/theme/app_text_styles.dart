
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display styles
  static final TextStyle displayLarge = GoogleFonts.kanit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static final TextStyle displayMedium = GoogleFonts.kanit(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  // Heading styles
  static final TextStyle headingLarge = GoogleFonts.kanit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static final TextStyle headingMedium = GoogleFonts.kanit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static final TextStyle headingSmall = GoogleFonts.kanit(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // Body styles
  static final TextStyle bodyLarge = GoogleFonts.kanit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.kanit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Label styles
  static final TextStyle labelLarge = GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static final TextStyle labelMedium = GoogleFonts.kanit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static final TextStyle labelSmall = GoogleFonts.kanit(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Financial amount styles
  static final TextStyle amountLarge = GoogleFonts.kanit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
  );

  static final TextStyle amountMedium = GoogleFonts.kanit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.2,
  );

  static final TextStyle amountSmall = GoogleFonts.kanit(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  // Status styles
  static final TextStyle success = GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
  );

  static final TextStyle warning = GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.warning,
  );

  static final TextStyle error = GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  // Button styles
  static final TextStyle button = GoogleFonts.kanit(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Link style
  static final TextStyle link = GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
    decoration: TextDecoration.underline,
  );
}
