import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../widgets/inquiry_stepper.dart';
import '../../../c_models/inquiry_model.dart';

class InquiryDetailsScreen extends StatelessWidget {
  final InquiryModel inquiry;

  const InquiryDetailsScreen({
    super.key,
    required this.inquiry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inquiry Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inquiry Details',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Here are the details of your loan inquiry.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),

              // Header Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: inquiry.iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(inquiry.icon, color: inquiry.iconColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inquiry.loanType,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            inquiry.id,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Submitted on ${DateFormatter.formatDate(inquiry.date)}, ${inquiry.formattedTime}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: inquiry.status.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        inquiry.status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: inquiry.status.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Stepper Progress
              InquiryStepper(
                currentStep: inquiry.currentStep,
                dateText: DateFormatter.formatShortDate(inquiry.date),
              ),
              const SizedBox(height: 14),

              // Loan Details
              _buildInfoSection(
                title: 'Loan Details',
                icon: Icons.account_balance_wallet_outlined,
                children: [
                  _buildDetailRow('Loan Type', inquiry.loanType),
                  _buildDetailRow('Loan Amount', CurrencyFormatter.formatWhole(inquiry.amount)),
                  _buildDetailRow('Purpose of Loan', inquiry.purpose),
                  _buildDetailRow('Preferred Tenure', inquiry.tenure),
                  _buildDetailRow('Expected Disbursal', inquiry.expectedDisbursal, isLast: true),
                ],
              ),
              const SizedBox(height: 14),

              // Your Details
              _buildInfoSection(
                title: 'Your Details',
                icon: Icons.person_outline_rounded,
                children: [
                  _buildDetailRow('Full Name', inquiry.applicantName),
                  _buildDetailRow('Mobile Number', inquiry.mobileNumber),
                  _buildDetailRow('Email Address', inquiry.email),
                  _buildDetailRow('Employment Type', inquiry.employmentType),
                  _buildDetailRow('Monthly Income', CurrencyFormatter.formatWhole(inquiry.monthlyIncome)),
                  _buildDetailRow('Company Name', inquiry.companyName),
                  _buildDetailRow('City', inquiry.city, isLast: true),
                ],
              ),
              const SizedBox(height: 14),

              // Notice Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info_rounded, color: Color(0xFF2563EB), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Our team will contact you on your registered mobile number and email address.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1E40AF),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}