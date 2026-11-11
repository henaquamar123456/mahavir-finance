import 'package:flutter/foundation.dart'; // kIsWeb ke liye zaroori hai

abstract class MFUrls {
  // Base Domain Switcher (Auto Detects Web vs Emulator)
  static String mfBaseUrl(String endPoint) {
    if (kIsWeb) {
      // Chrome / Web Browser ke liye:
      return "http://localhost:5000/$endPoint";
    } else {
      // Android Emulator ke liye:
      return "http://10.0.2.2:5000/$endPoint";
      // Physical Mobile Device ke liye (Local Wi-Fi IP):
      // return "http://192.168.1.X:5000/$endPoint";
    }
  }

  // Modular Base Helpers
  static String authUrl(String endPoint) => mfBaseUrl("api/v1/auth/$endPoint");
  static String loanUrl(String endPoint) => mfBaseUrl("api/v1/loans/$endPoint");

  // ==========================================
  // 1. AUTHENTICATION MODULE
  // ==========================================
  static String get signup => authUrl("signup");
  static String get login => authUrl("login");
  static String get getMe => authUrl("me");
  static String get forgotPassword => authUrl("forgot-password");
  static String resetPassword(String token) => authUrl("reset-password/$token");

  // ==========================================
  // 2. LOAN & EMI MODULE
  // ==========================================
  static String get applyLoan => loanUrl("apply");
  static String get myLoans => loanUrl("my-loans");
  static String get adminAllLoans => loanUrl("admin/all-loans");
  static String get adminDashboardStats => loanUrl("admin/dashboard-stats");

  // Dynamic Parameter Routes
  static String uploadDocuments(String loanId) => loanUrl("$loanId/documents");
  static String payEmi(String loanId) => loanUrl("$loanId/pay-emi");
  static String loanSummary(String loanId) => loanUrl("$loanId/summary");
  static String adminUpdateLoanStatus(String loanId) =>
      loanUrl("admin/$loanId/status");
  static String dsaLoans(String dsaCode) => loanUrl("dsa/$dsaCode");

  // ==========================================
  // 3. UTILITY MODULE
  // ==========================================
  static String get healthCheck => mfBaseUrl("health");
}