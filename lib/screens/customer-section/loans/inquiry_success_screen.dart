import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahavir_finance/screens/customer-section/loans/what_happens_next_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../utils/date_formatter.dart';
import 'loan_inquiry_provider.dart';

class InquirySuccessScreen extends StatelessWidget {
  const InquirySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoanInquiryProvider>();
    final refId = provider.referenceId ?? 'MF202610200001';
    final submittedOn = provider.submittedAt != null
        ? '${DateFormatter.formatDate(provider.submittedAt)}, ${DateFormatter.formatTime(provider.submittedAt)}'
        : '20 Oct 2026, 09:41 AM';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Big Green Checkmark Icon with soft background
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.secondary,
                    size: 64,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Inquiry Submitted\nSuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you for your interest. Our team will review your details and get back to you soon with the best loan offers.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // Reference Details Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reference ID',
                              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              refId,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.secondary),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: refId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reference ID copied to clipboard')),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 18, color: AppColors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Submitted On', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text(submittedOn, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Inquiry Status', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Under Review',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'You will receive an update on your registered mobile number and email address.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              // Primary: View Inquiry Status
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WhatHappensNextScreen(referenceId: refId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Inquiry Status',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Secondary: Back to Home
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}